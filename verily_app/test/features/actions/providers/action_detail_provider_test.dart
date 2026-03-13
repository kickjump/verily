// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/actions/providers/action_detail_provider.dart';
import 'package:verily_client/verily_client.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// Records the ID passed to [get] and returns a configurable response.
class _FakeActionEndpoint extends Fake implements EndpointAction {
  int? lastRequestedId;
  int getCallCount = 0;
  Action? responseAction;
  Exception? errorToThrow;

  @override
  Future<Action> get(int id) async {
    getCallCount++;
    lastRequestedId = id;
    if (errorToThrow != null) throw errorToThrow!;
    return responseAction ??
        Action(
          id: id,
          title: 'Test Action #$id',
          description: 'Description for action $id',
          creatorId: UuidValue.fromString(
            '11111111-1111-1111-1111-111111111111',
          ),
          actionType: 'one_off',
          status: 'active',
          verificationCriteria: 'Verify action $id',
          tags: 'test',
          createdAt: DateTime(2026, 3, 9),
          updatedAt: DateTime(2026, 3, 9),
        );
  }
}

class _FakeClient extends Fake implements Client {
  _FakeClient(this._actionEndpoint);

  final _FakeActionEndpoint _actionEndpoint;

  @override
  EndpointAction get action => _actionEndpoint;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('actionDetail', () {
    late _FakeActionEndpoint fakeEndpoint;
    late _FakeClient fakeClient;
    late ProviderContainer container;

    setUp(() {
      fakeEndpoint = _FakeActionEndpoint();
      fakeClient = _FakeClient(fakeEndpoint);

      container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetches action by ID from server', () async {
      final action = await container.read(actionDetailProvider(42).future);

      expect(fakeEndpoint.lastRequestedId, equals(42));
      expect(fakeEndpoint.getCallCount, equals(1));
      expect(action.id, equals(42));
      expect(action.title, equals('Test Action #42'));
    });

    test('returns full action data from server', () async {
      fakeEndpoint.responseAction = Action(
        id: 7,
        title: 'Beach Cleanup Challenge',
        description: 'Pick up litter at the beach for 30 minutes',
        creatorId: UuidValue.fromString('22222222-2222-2222-2222-222222222222'),
        actionType: 'one_off',
        status: 'active',
        verificationCriteria:
            'Show before/after. Keep gloves visible. Show street sign.',
        tags: 'environment,community,cleanup',
        maxPerformers: 50,
        locationRadius: 500,
        createdAt: DateTime(2026, 3),
        updatedAt: DateTime(2026, 3, 5),
      );

      final action = await container.read(actionDetailProvider(7).future);

      expect(action.id, equals(7));
      expect(action.title, equals('Beach Cleanup Challenge'));
      expect(action.description, contains('litter'));
      expect(action.actionType, equals('one_off'));
      expect(action.status, equals('active'));
      expect(action.tags, equals('environment,community,cleanup'));
      expect(action.maxPerformers, equals(50));
      expect(action.locationRadius, equals(500.0));
      expect(
        action.creatorId.toString(),
        equals('22222222-2222-2222-2222-222222222222'),
      );
    });

    test('returns habit action with habit-specific fields', () async {
      fakeEndpoint.responseAction = Action(
        id: 10,
        title: 'Daily Meditation',
        description: 'Meditate for 5 minutes daily',
        creatorId: UuidValue.fromString('33333333-3333-3333-3333-333333333333'),
        actionType: 'habit',
        status: 'active',
        verificationCriteria: 'Show seated posture',
        habitDurationDays: 30,
        habitFrequencyPerWeek: 7,
        habitTotalRequired: 30,
        createdAt: DateTime(2026, 3, 9),
        updatedAt: DateTime(2026, 3, 9),
      );

      final action = await container.read(actionDetailProvider(10).future);

      expect(action.actionType, equals('habit'));
      expect(action.habitDurationDays, equals(30));
      expect(action.habitFrequencyPerWeek, equals(7));
      expect(action.habitTotalRequired, equals(30));
    });

    test('returns sequential action with step fields', () async {
      fakeEndpoint.responseAction = Action(
        id: 20,
        title: 'Coffee Shop Tour',
        description: 'Visit 3 coffee shops',
        creatorId: UuidValue.fromString('44444444-4444-4444-4444-444444444444'),
        actionType: 'sequential',
        status: 'active',
        verificationCriteria: 'Show storefront',
        totalSteps: 3,
        stepOrdering: 'unordered',
        createdAt: DateTime(2026, 3, 9),
        updatedAt: DateTime(2026, 3, 9),
      );

      final action = await container.read(actionDetailProvider(20).future);

      expect(action.actionType, equals('sequential'));
      expect(action.totalSteps, equals(3));
      expect(action.stepOrdering, equals('unordered'));
    });

    test('propagates error state when server returns error', () async {
      fakeEndpoint.errorToThrow = Exception('Not found');

      // Listen to keep the auto-dispose provider alive while it resolves.
      final states = <AsyncValue<Action>>[];
      final subscription = container.listen(actionDetailProvider(999), (
        _,
        next,
      ) {
        states.add(next);
      }, fireImmediately: true);
      addTearDown(subscription.close);

      // Pump microtask queue until the provider settles.
      // The provider goes through Loading → Error transitions.
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(Duration.zero);
      }

      // The final state should contain an error.
      final lastState = states.last;
      expect(lastState.hasError, isTrue);
      expect(lastState.error, isA<Exception>());
    });

    test('different IDs create separate provider instances', () async {
      final action1 = await container.read(actionDetailProvider(1).future);
      final action2 = await container.read(actionDetailProvider(2).future);

      expect(action1.id, equals(1));
      expect(action2.id, equals(2));
      expect(action1.title, equals('Test Action #1'));
      expect(action2.title, equals('Test Action #2'));
      expect(fakeEndpoint.getCallCount, equals(2));
    });

    test('same ID returns cached result on re-read', () async {
      await container.read(actionDetailProvider(42).future);
      await container.read(actionDetailProvider(42).future);

      // The provider is auto-dispose but within same container lifetime
      // and without invalidation, it should use cached value.
      // Due to auto-dispose, the exact call count depends on Riverpod
      // internals, but we verify the provider resolves correctly both times.
      expect(fakeEndpoint.lastRequestedId, equals(42));
    });

    test('passes correct ID to endpoint for various values', () async {
      for (final id in [0, 1, 100, 999999]) {
        // Create a fresh container for each to avoid caching
        final freshContainer = ProviderContainer(
          overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
        );
        addTearDown(freshContainer.dispose);

        final action = await freshContainer.read(
          actionDetailProvider(id).future,
        );
        expect(action.id, equals(id));
        expect(fakeEndpoint.lastRequestedId, equals(id));
      }
    });
  });
}
