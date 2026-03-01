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
