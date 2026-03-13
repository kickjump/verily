import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/analytics/posthog_analytics.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'action_detail_provider.g.dart';

/// Fetches a single action by its ID from the server.
@riverpod
Future<Action> actionDetail(Ref ref, int actionId) async {
  final client = ref.watch(serverpodClientProvider);
  final action = await client.action.get(actionId);

  unawaited(
    ref.read(posthogInstanceProvider)?.trackActionViewed(actionId: actionId),
  );

  return action;
}

/// Fetches the location associated with an action's location ID.
///
/// Returns `null` if the action has no location requirement.
/// This is used by the video review screen to perform on-device geo-fence
/// pre-validation before submission.
@riverpod
Future<Location?> actionLocation(Ref ref, int actionId) async {
  final action = await ref.watch(actionDetailProvider(actionId).future);
  final locationId = action.locationId;
  if (locationId == null) return null;

  final client = ref.watch(serverpodClientProvider);
  return client.location.get(locationId);
}
