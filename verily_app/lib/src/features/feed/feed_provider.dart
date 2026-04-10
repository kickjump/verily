// UuidValue is required by Serverpod's generated Action model.
// ignore_for_file: experimental_member_use

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/demo/demo_data.dart';
import 'package:verily_app/src/features/map/providers/location_providers.dart';
import 'package:verily_client/verily_client.dart';

part 'feed_provider.g.dart';

/// Default radius in meters for the "nearby" feed filter (10 km).
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
        // Try GPS-based nearby search, fall back to listActive.
        try {
          final locationAsync = ref.watch(userLocationProvider);
          final position = locationAsync.value;
          if (position != null) {
            try {
              return await client.action.listNearby(
                position.latitude,
                position.longitude,
                kNearbyRadiusMeters,
              );
            } on Exception {
              // listNearby failed, fall back to listActive.
              return await client.action.listActive();
            }
          }
        } on Exception {
          // GPS unavailable — fall through to listActive.
        }
        return await client.action.listActive();
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
    return demoActions;
  }
}

// Demo actions are defined in demo_data.dart and shared across providers.
