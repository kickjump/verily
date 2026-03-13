import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/actions/providers/create_action_provider.dart';
import 'package:verily_client/verily_client.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// Records the [Action] passed to [create] so tests can assert on it.
class _FakeActionEndpoint extends Fake implements EndpointAction {
  Action? lastCreatedAction;
  Action? responseAction;
  Exception? errorToThrow;

  @override
  Future<Action> create(Action action) async {
    if (errorToThrow != null) throw errorToThrow!;
    lastCreatedAction = action;
    return responseAction ??
        Action(
          id: 42,
          title: action.title,
          description: action.description,
          // Serverpod-generated model uses experimental UUID API.
          // ignore: experimental_member_use
          creatorId: UuidValue.fromString(
            '11111111-1111-1111-1111-111111111111',
          ),
          actionType: action.actionType,
          status: action.status,
          verificationCriteria: action.verificationCriteria,
          totalSteps: action.totalSteps,
          stepOrdering: action.stepOrdering,
          habitDurationDays: action.habitDurationDays,
          habitFrequencyPerWeek: action.habitFrequencyPerWeek,
          habitTotalRequired: action.habitTotalRequired,
          maxPerformers: action.maxPerformers,
          locationRadius: action.locationRadius,
          tags: action.tags,
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
  group('CreateAction', () {
    late _FakeActionEndpoint fakeActionEndpoint;
    late _FakeClient fakeClient;
    late ProviderContainer container;

    setUp(() {
      fakeActionEndpoint = _FakeActionEndpoint();
      fakeClient = _FakeClient(fakeActionEndpoint);

      container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is AsyncData(null)', () {
      final state = container.read(createActionProvider);
      expect(state, isA<AsyncData<Action?>>());
      expect(state.value, isNull);
    });

    test('reset returns state to AsyncData(null)', () {
      container.read(createActionProvider.notifier).reset();
      final state = container.read(createActionProvider);
      expect(state, isA<AsyncData<Action?>>());
      expect(state.value, isNull);
    });

    test('submit sends correct data to server', () async {
      final result = await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Plant a Tree',
            description: 'Plant a sapling in your neighborhood',
            actionType: 'one_off',
            verificationCriteria: 'Must show digging, planting, watering',
            category: 'Environment',
            tags: ['green', 'community'],
            maxPerformers: 10,
            locationName: 'Central Park',
            locationLat: 40.785091,
            locationLng: -73.968285,
            locationRadius: 200,
            stepOrdering: 'ordered',
            totalSteps: 3,
            habitDurationDays: 7,
            habitFrequencyPerWeek: 3,
            habitTotalRequired: 21,
          );

      expect(result, isNotNull);
      expect(result!.id, equals(42));

      // Verify the Action sent to the server has the correct fields.
      final sent = fakeActionEndpoint.lastCreatedAction!;
      expect(sent.title, equals('Plant a Tree'));
      expect(sent.description, equals('Plant a sapling in your neighborhood'));
      expect(sent.actionType, equals('one_off'));
      expect(
        sent.verificationCriteria,
        equals('Must show digging, planting, watering'),
      );
      expect(sent.status, equals('active'));
      expect(sent.maxPerformers, equals(10));
      expect(sent.locationRadius, equals(200.0));
      expect(sent.stepOrdering, equals('ordered'));
      expect(sent.totalSteps, equals(3));
      expect(sent.habitDurationDays, equals(7));
      expect(sent.habitFrequencyPerWeek, equals(3));
      expect(sent.habitTotalRequired, equals(21));
      expect(sent.tags, equals('green,community'));
    });

    test('submit sends placeholder creatorId (server overrides it)', () async {
      await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Do Push-Ups',
            description: 'Do 50 push-ups at the park',
            actionType: 'one_off',
            verificationCriteria: 'Show full body reps',
          );

      final sent = fakeActionEndpoint.lastCreatedAction!;
      expect(
        sent.creatorId.toString(),
        equals('00000000-0000-0000-0000-000000000000'),
      );
    });

    test('submit defaults totalSteps to 1 when not provided', () async {
      await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Quick Task',
            description: 'A simple one-step task',
            actionType: 'one_off',
            verificationCriteria: 'Visible completion',
          );

      final sent = fakeActionEndpoint.lastCreatedAction!;
      expect(sent.totalSteps, equals(1));
    });

    test('submit with null tags does not send tags', () async {
      await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'No Tags Task',
            description: 'A task without tags',
            actionType: 'one_off',
            verificationCriteria: 'Complete it',
          );

      final sent = fakeActionEndpoint.lastCreatedAction!;
      expect(sent.tags, isNull);
    });

    test('submit updates state to AsyncData with created action', () async {
      await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Verified Task',
            description: 'Something to do',
            actionType: 'one_off',
            verificationCriteria: 'Check it',
          );

      final state = container.read(createActionProvider);
      expect(state, isA<AsyncData<Action?>>());
      expect(state.value, isNotNull);
      expect(state.value!.id, equals(42));
      expect(state.value!.title, equals('Verified Task'));
    });

    test('submit returns null and sets error state on failure', () async {
      fakeActionEndpoint.errorToThrow = Exception('Network error');

      final result = await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Failing Task',
            description: 'This will fail',
            actionType: 'one_off',
            verificationCriteria: 'Unreachable',
          );

      expect(result, isNull);
      final state = container.read(createActionProvider);
      expect(state, isA<AsyncError<Action?>>());
    });

    test('submit with empty tags list sends null tags', () async {
      await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Empty Tags',
            description: 'Task with empty tags list',
            actionType: 'sequential',
            verificationCriteria: 'Verify it',
            tags: [],
          );

      final sent = fakeActionEndpoint.lastCreatedAction!;
      // Empty list is converted to null to avoid sending empty string to server.
      expect(sent.tags, isNull);
    });

    test('submit passes isAiGenerated flag for analytics', () async {
      // This test ensures the isAiGenerated parameter is accepted without
      // error. We can't easily verify the posthog call without a mock, but
      // we verify the parameter doesn't break the flow.
      final result = await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'AI Task',
            description: 'Generated by AI',
            actionType: 'one_off',
            verificationCriteria: 'AI criteria',
            isAiGenerated: true,
          );

      expect(result, isNotNull);
    });

    test('multiple submits can be called sequentially', () async {
      final result1 = await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'First Task',
            description: 'First description',
            actionType: 'one_off',
            verificationCriteria: 'First criteria',
          );

      final result2 = await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Second Task',
            description: 'Second description',
            actionType: 'habit',
            verificationCriteria: 'Second criteria',
          );

      expect(result1, isNotNull);
      expect(result2, isNotNull);

      // The last submitted action should be in state.
      final state = container.read(createActionProvider);
      expect(state.value!.title, equals('Second Task'));
    });

    test('reset after submit clears the created action', () async {
      await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Will be cleared',
            description: 'Temporary',
            actionType: 'one_off',
            verificationCriteria: 'Check',
          );

      expect(container.read(createActionProvider).value, isNotNull);

      container.read(createActionProvider.notifier).reset();

      expect(container.read(createActionProvider).value, isNull);
    });

    test('reset after error clears error state', () async {
      fakeActionEndpoint.errorToThrow = Exception('fail');

      await container
          .read(createActionProvider.notifier)
          .submit(
            title: 'Error Task',
            description: 'Will error',
            actionType: 'one_off',
            verificationCriteria: 'Check',
          );

      expect(container.read(createActionProvider), isA<AsyncError<Action?>>());

      container.read(createActionProvider.notifier).reset();

      final state = container.read(createActionProvider);
      expect(state, isA<AsyncData<Action?>>());
      expect(state.value, isNull);
    });
  });
}
