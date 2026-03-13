// UuidValue is required by Serverpod's generated Action model.
// ignore_for_file: experimental_member_use

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/map/providers/location_providers.dart';
import 'package:verily_client/verily_client.dart';

part 'feed_provider.g.dart';

/// Default search radius in meters for the Nearby filter (10 km).
const kNearbyRadiusMeters = 10000.0;

/// The active filter for the action feed.
enum FeedFilter {
  nearby('Nearby'),
  quick('Quick'),
  highReward('High Reward'),
  all('All');

  const FeedFilter(this.label);
  final String label;
}

/// Provides the current feed filter selection.
@riverpod
class FeedFilterNotifier extends _$FeedFilterNotifier {
  @override
  FeedFilter build() => FeedFilter.nearby;

  // Riverpod notifiers expose methods, not setters.
  // ignore: use_setters_to_change_properties
  void select(FeedFilter filter) => state = filter;
}

/// Fetches actions from the server based on the active filter.
///
/// Returns a list of [Action] objects. In development mode with no server
/// running, returns mock data to keep the UI functional.
///
/// When the filter is [FeedFilter.nearby], the provider awaits the device's
/// GPS position via [userLocationProvider] and calls the server-side
/// `listNearby()` endpoint to return only actions within
/// [kNearbyRadiusMeters]. If the device location is unavailable (permission
/// denied, timeout, etc.), it gracefully falls back to `listActive()` so
/// the user always sees content.
@riverpod
Future<List<Action>> feedActions(Ref ref) async {
  final filter = ref.watch(feedFilterProvider);
  final client = ref.watch(serverpodClientProvider);

  try {
    switch (filter) {
      case FeedFilter.nearby:
        return await _fetchNearbyActions(ref, client);
      case FeedFilter.quick:
        // Filter for one-off actions (quick to complete).
        final actions = await client.action.listActive();
        return actions.where((a) => a.actionType == 'one_off').toList();
      case FeedFilter.highReward:
        // Deferred: sort by reward pool amount requires joining RewardPool
        // data. For now, returns all active actions unsorted.
        return await client.action.listActive();
      case FeedFilter.all:
        return await client.action.listActive();
    }
  } on Exception catch (e) {
    debugPrint('Failed to fetch actions from server: $e');
    // Return mock data when server is unavailable.
    return _mockActions;
  }
}

/// Attempts to fetch nearby actions using the device GPS.
///
/// 1. Awaits [userLocationProvider] with a timeout so the UI isn't blocked
///    if GPS is slow.
/// 2. Calls `client.action.listNearby()` with the resolved coordinates.
/// 3. Falls back to `client.action.listActive()` if GPS or the endpoint
///    is unavailable.
Future<List<Action>> _fetchNearbyActions(Ref ref, Client client) async {
  try {
    final position = await ref
        .watch(userLocationProvider.future)
        .timeout(const Duration(seconds: 5));

    try {
      return await client.action.listNearby(
        position.latitude,
        position.longitude,
        kNearbyRadiusMeters,
      );
    } on Exception catch (e) {
      // listNearby failed (e.g. server has no spatial data yet).
      // Fall back to listActive so the user still sees actions.
      debugPrint('listNearby failed, falling back to listActive: $e');
      return client.action.listActive();
    }
  } on Exception catch (e) {
    // GPS unavailable (permission denied, timeout, etc.).
    debugPrint('GPS unavailable, falling back to listActive: $e');
    return client.action.listActive();
  }
}

/// Mock actions for development when server is unavailable.
final _mockActions = <Action>[
  Action(
    id: 1,
    title: 'Record 20 push-ups at a local park', // l10n-ignore mock seed data
    description:
        'Head to any local park and record yourself doing 20 push-ups. '
        'Make sure your full body is visible and the park environment is '
        'clearly in frame.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Show your full body in frame while doing all reps. '
        'Capture ambient park audio from start to finish. '
        'Pan camera to a park sign before ending recording.',
    tags: 'fitness,outdoor,exercise',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Action(
    id: 2,
    title:
        'Capture a 30s cleanup clip on your street', // l10n-ignore mock seed data
    description:
        'Record yourself picking up litter on your street for at least '
        '30 seconds. Show the before and after state.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Record litter before and after cleanup. '
        'Keep gloves and collection bag visible in video. '
        'Show street name sign in the first 10 seconds.',
    tags: 'environment,community,cleanup',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Action(
    id: 3,
    title: 'Film a 1 minute kindness action', // l10n-ignore mock seed data
    description:
        'Record yourself performing a random act of kindness in your '
        'community. This could be helping someone carry groceries, '
        'giving a compliment, or any positive interaction.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Clearly show the positive interaction in one take. '
        'Capture consent-friendly angle with no private details. '
        'Show the community center sign before wrapping up.',
    tags: 'community,social,kindness',
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  Action(
    id: 4,
    title: 'Morning meditation - 7 day streak', // l10n-ignore mock seed data
    description:
        'Meditate for at least 5 minutes every morning for 7 days in a row. '
        'Record a short clip at the beginning and end of each session.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    actionType: 'habit',
    status: 'active',
    habitDurationDays: 7,
    habitFrequencyPerWeek: 7,
    habitTotalRequired: 7,
    verificationCriteria:
        'Record yourself in a seated meditation posture. '
        'Show a timer or clock at the start and end. '
        'Capture at least 30 seconds of the meditation session.',
    tags: 'wellness,meditation,habit',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Action(
    id: 5,
    title:
        'Visit 3 local coffee shops and review', // l10n-ignore mock seed data
    description:
        'Visit three different local coffee shops in your area. At each one, '
        'order a drink, film a short review, and show the storefront.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    actionType: 'sequential',
    status: 'active',
    totalSteps: 3,
    stepOrdering: 'unordered',
    verificationCriteria:
        'Show the storefront and shop name clearly. '
        'Film yourself ordering and tasting the drink. '
        'Give a brief verbal review of the experience.',
    tags: 'food,social,adventure,review',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
