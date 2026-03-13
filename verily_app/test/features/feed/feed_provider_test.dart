// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/map/providers/location_providers.dart';
import 'package:verily_client/verily_client.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// Records calls to [listActive] / [listNearby] and returns configurable
/// responses.
class _FakeActionEndpoint extends Fake implements EndpointAction {
  int listActiveCallCount = 0;
  int listNearbyCallCount = 0;
  List<Action>? responseActions;
  List<Action>? nearbyResponseActions;
  Exception? errorToThrow;
  Exception? nearbyErrorToThrow;

  /// Captures the last lat/lng/radius passed to [listNearby].
  double? lastLat;
  double? lastLng;
  double? lastRadius;

  @override
  Future<List<Action>> listActive() async {
    listActiveCallCount++;
    if (errorToThrow != null) throw errorToThrow!;
    return responseActions ?? _defaultActions;
  }

  @override
  Future<List<Action>> listNearby(
    double lat,
    double lng,
    double radiusMeters,
  ) async {
    listNearbyCallCount++;
    lastLat = lat;
    lastLng = lng;
    lastRadius = radiusMeters;
    if (nearbyErrorToThrow != null) throw nearbyErrorToThrow!;
    return nearbyResponseActions ?? _defaultActions;
  }
}

class _FakeClient extends Fake implements Client {
  _FakeClient(this._actionEndpoint);

  final _FakeActionEndpoint _actionEndpoint;

  @override
  EndpointAction get action => _actionEndpoint;
}

/// A helper that creates a [Position] for testing.
Position _testPosition({double lat = 40.7128, double lng = -74.006}) {
  return Position(
    latitude: lat,
    longitude: lng,
    timestamp: DateTime(2026, 3, 9),
    accuracy: 10,
    altitude: 0,
    altitudeAccuracy: 0,
    heading: 0,
    headingAccuracy: 0,
    speed: 0,
    speedAccuracy: 0,
  );
}

/// Default test actions with mixed types for filter testing.
final _defaultActions = <Action>[
  Action(
    id: 1,
    title: 'Quick push-ups',
    description: 'Do push-ups at the park',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Full body visible',
    tags: 'fitness,outdoor',
    createdAt: DateTime(2026, 3),
    updatedAt: DateTime(2026, 3),
  ),
  Action(
    id: 2,
    title: 'Morning meditation streak',
    description: 'Meditate every morning for 7 days',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    actionType: 'habit',
    status: 'active',
    verificationCriteria: 'Show seated posture',
    habitDurationDays: 7,
    habitFrequencyPerWeek: 7,
    habitTotalRequired: 7,
    tags: 'wellness,meditation',
    createdAt: DateTime(2026, 3, 2),
    updatedAt: DateTime(2026, 3, 2),
  ),
  Action(
    id: 3,
    title: 'Visit 3 coffee shops',
    description: 'Visit and review three coffee shops',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    actionType: 'sequential',
    status: 'active',
    verificationCriteria: 'Show storefront',
    totalSteps: 3,
    stepOrdering: 'unordered',
    tags: 'food,adventure',
    createdAt: DateTime(2026, 3, 3),
    updatedAt: DateTime(2026, 3, 3),
  ),
  Action(
    id: 4,
    title: 'Clean the beach',
    description: 'Pick up litter at the beach',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Before and after visible',
    tags: 'environment,community',
    createdAt: DateTime(2026, 3, 4),
    updatedAt: DateTime(2026, 3, 4),
  ),
];

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('FeedFilterNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial filter is FeedFilter.nearby', () {
      final filter = container.read(feedFilterProvider);
      expect(filter, equals(FeedFilter.nearby));
    });

    test('select changes the filter', () {
      container.read(feedFilterProvider.notifier).select(FeedFilter.quick);
      expect(container.read(feedFilterProvider), equals(FeedFilter.quick));
    });

    test('select to all filter', () {
      container.read(feedFilterProvider.notifier).select(FeedFilter.all);
      expect(container.read(feedFilterProvider), equals(FeedFilter.all));
    });

    test('select to highReward filter', () {
      container.read(feedFilterProvider.notifier).select(FeedFilter.highReward);
      expect(container.read(feedFilterProvider), equals(FeedFilter.highReward));
    });

    test('can change filter multiple times', () {
      final notifier = container.read(feedFilterProvider.notifier)
        ..select(FeedFilter.quick);
      expect(container.read(feedFilterProvider), equals(FeedFilter.quick));

      notifier.select(FeedFilter.highReward);
      expect(container.read(feedFilterProvider), equals(FeedFilter.highReward));

      notifier.select(FeedFilter.nearby);
      expect(container.read(feedFilterProvider), equals(FeedFilter.nearby));
    });

    test('FeedFilter enum has correct labels', () {
      expect(FeedFilter.nearby.label, equals('Nearby'));
      expect(FeedFilter.quick.label, equals('Quick'));
      expect(FeedFilter.highReward.label, equals('High Reward'));
      expect(FeedFilter.all.label, equals('All'));
    });
  });

  group('feedActions', () {
    late _FakeActionEndpoint fakeEndpoint;
    late _FakeClient fakeClient;
    late ProviderContainer container;

    /// Creates a container with location stream override.
    ///
    /// When [locationStream] is provided, that stream is used directly.
    /// Otherwise a default error stream is used (GPS unavailable).
    ProviderContainer createContainer({Stream<Position>? locationStream}) {
      final stream =
          locationStream ??
          Stream<Position>.error(Exception('Location unavailable'));

      return ProviderContainer(
        overrides: [
          serverpodClientProvider.overrideWithValue(fakeClient),
          userLocationProvider.overrideWith((_) => stream),
        ],
      );
    }

    /// Creates a container where the GPS position becomes available via stream.
    ///
    /// Uses a broadcast [StreamController] so Riverpod's auto-dispose can
    /// re-subscribe without "Stream already listened to" errors. Emits the
    /// position via [Future.microtask] so it arrives after subscription.
    ///
    /// **Important:** Callers must keep a persistent listener alive via
    /// `container.listen(feedActionsProvider, (_, __) {})` to prevent
    /// Riverpod from auto-disposing the provider chain between reads.
    ProviderContainer createContainerWithPosition(Position position) {
      final controller = StreamController<Position>.broadcast();
      final c = ProviderContainer(
        overrides: [
          serverpodClientProvider.overrideWithValue(fakeClient),
          userLocationProvider.overrideWith((_) {
            // Emit position after a microtask to ensure the listener is set
            // up before the event is delivered.
            Future.microtask(() => controller.add(position));
            return controller.stream;
          }),
        ],
      );
      // Keep the provider chain alive to prevent auto-dispose.
      return c..listen(feedActionsProvider, (_, __) {});
    }

    setUp(() {
      fakeEndpoint = _FakeActionEndpoint();
      fakeClient = _FakeClient(fakeEndpoint);

      // Default container with no GPS — nearby falls back to listActive.
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'nearby filter with GPS calls listNearby with device coordinates',
      () async {
        final position = _testPosition(lat: 51.5074, lng: -0.1278);
        final localContainer = createContainerWithPosition(position);
        addTearDown(localContainer.dispose);

        fakeEndpoint.nearbyResponseActions = [_defaultActions.first];

        // First read may resolve via the loading branch (listActive) because
        // the stream hasn't been processed yet. Reading the future and then
        // pumping lets Riverpod see the stream value and rebuild.
        await localContainer.read(feedActionsProvider.future);
        // Pump multiple microtask cycles so the stream event propagates
        // through Riverpod's dependency graph and triggers a rebuild.
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(Duration.zero);
        }
        // After rebuild with GPS data, feedActions should call listNearby.
        final actions = await localContainer.read(feedActionsProvider.future);

        expect(fakeEndpoint.listNearbyCallCount, greaterThanOrEqualTo(1));
        expect(fakeEndpoint.lastLat, equals(51.5074));
        expect(fakeEndpoint.lastLng, equals(-0.1278));
        expect(fakeEndpoint.lastRadius, equals(kNearbyRadiusMeters));
        expect(actions, hasLength(1));
      },
    );

    test(
      'nearby filter falls back to listActive when GPS unavailable',
      () async {
        // Container created with default error stream (no GPS).
        final actions = await container.read(feedActionsProvider.future);

        // Should call listActive (not listNearby) because GPS errored.
        expect(fakeEndpoint.listActiveCallCount, greaterThanOrEqualTo(1));
        expect(fakeEndpoint.listNearbyCallCount, equals(0));
        expect(actions, hasLength(4));
      },
    );

    test(
      'nearby filter falls back to listActive when listNearby throws',
      () async {
        final localContainer = createContainerWithPosition(_testPosition());
        addTearDown(localContainer.dispose);
        fakeEndpoint.nearbyErrorToThrow = Exception('No spatial data');

        // First read + pump to let GPS propagate.
        await localContainer.read(feedActionsProvider.future);
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(Duration.zero);
        }
        final actions = await localContainer.read(feedActionsProvider.future);

        // listNearby was attempted, then fell back to listActive.
        expect(fakeEndpoint.listNearbyCallCount, greaterThanOrEqualTo(1));
        expect(fakeEndpoint.listActiveCallCount, greaterThanOrEqualTo(1));
        expect(actions, hasLength(4));
      },
    );

    test(
      'nearby filter returns nearby actions when GPS is available',
      () async {
        final localContainer = createContainerWithPosition(_testPosition());
        addTearDown(localContainer.dispose);

        final nearbyOnly = [_defaultActions[0], _defaultActions[2]];
        fakeEndpoint.nearbyResponseActions = nearbyOnly;

        // First read + pump to let GPS propagate.
        await localContainer.read(feedActionsProvider.future);
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(Duration.zero);
        }
        final actions = await localContainer.read(feedActionsProvider.future);

        expect(actions, hasLength(2));
        expect(actions.map((a) => a.id), containsAll([1, 3]));
      },
    );

    test('quick filter returns only one_off actions', () async {
      container.read(feedFilterProvider.notifier).select(FeedFilter.quick);

      final actions = await container.read(feedActionsProvider.future);

      expect(actions, hasLength(2));
      for (final action in actions) {
        expect(action.actionType, equals('one_off'));
      }
      expect(actions.map((a) => a.id), containsAll([1, 4]));
    });

    test(
      'highReward filter returns all actions (no reward sorting yet)',
      () async {
        container
            .read(feedFilterProvider.notifier)
            .select(FeedFilter.highReward);

        final actions = await container.read(feedActionsProvider.future);

        expect(actions, hasLength(4));
      },
    );

    test('all filter returns all actions', () async {
      container.read(feedFilterProvider.notifier).select(FeedFilter.all);

      final actions = await container.read(feedActionsProvider.future);

      expect(actions, hasLength(4));
    });

    test('returns mock data when server throws an exception', () async {
      container.read(feedFilterProvider.notifier).select(FeedFilter.all);
      fakeEndpoint.errorToThrow = Exception('Connection refused');

      final actions = await container.read(feedActionsProvider.future);

      // Should return mock/fallback data, not throw
      expect(actions, isNotEmpty);
    });

    test('returns server data when available', () async {
      container.read(feedFilterProvider.notifier).select(FeedFilter.all);
      fakeEndpoint.responseActions = [
        Action(
          id: 99,
          title: 'Server Action',
          description: 'From server',
          creatorId: UuidValue.fromString(
            '00000000-0000-0000-0000-000000000099',
          ),
          actionType: 'one_off',
          status: 'active',
          verificationCriteria: 'Check',
          createdAt: DateTime(2026, 3, 9),
          updatedAt: DateTime(2026, 3, 9),
        ),
      ];

      final actions = await container.read(feedActionsProvider.future);

      expect(actions, hasLength(1));
      expect(actions.first.id, equals(99));
      expect(actions.first.title, equals('Server Action'));
    });

    test('empty server response returns empty list', () async {
      container.read(feedFilterProvider.notifier).select(FeedFilter.all);
      fakeEndpoint.responseActions = [];

      final actions = await container.read(feedActionsProvider.future);

      expect(actions, isEmpty);
    });

    test('quick filter on empty server returns empty list', () async {
      fakeEndpoint.responseActions = [];
      container.read(feedFilterProvider.notifier).select(FeedFilter.quick);

      final actions = await container.read(feedActionsProvider.future);

      expect(actions, isEmpty);
    });

    test('quick filter excludes habit and sequential types', () async {
      fakeEndpoint.responseActions = [
        Action(
          id: 10,
          title: 'Habit Action',
          description: 'A habit',
          creatorId: UuidValue.fromString(
            '00000000-0000-0000-0000-000000000001',
          ),
          actionType: 'habit',
          status: 'active',
          verificationCriteria: 'Check',
          createdAt: DateTime(2026, 3, 9),
          updatedAt: DateTime(2026, 3, 9),
        ),
        Action(
          id: 11,
          title: 'Sequential Action',
          description: 'A sequential',
          creatorId: UuidValue.fromString(
            '00000000-0000-0000-0000-000000000001',
          ),
          actionType: 'sequential',
          status: 'active',
          verificationCriteria: 'Check',
          createdAt: DateTime(2026, 3, 9),
          updatedAt: DateTime(2026, 3, 9),
        ),
      ];
      container.read(feedFilterProvider.notifier).select(FeedFilter.quick);

      final actions = await container.read(feedActionsProvider.future);

      expect(actions, isEmpty);
    });

    test('kNearbyRadiusMeters is 10 km', () {
      expect(kNearbyRadiusMeters, equals(10000.0));
    });

    test('nearby filter with empty listNearby result returns empty', () async {
      final localContainer = createContainerWithPosition(_testPosition());
      addTearDown(localContainer.dispose);
      fakeEndpoint.nearbyResponseActions = [];

      // First read + pump to let GPS propagate.
      await localContainer.read(feedActionsProvider.future);
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      final actions = await localContainer.read(feedActionsProvider.future);

      expect(fakeEndpoint.listNearbyCallCount, greaterThanOrEqualTo(1));
      expect(actions, isEmpty);
    });
  });
}
