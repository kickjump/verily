import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'creator_actions_provider.g.dart';

/// Fetches actions created by the authenticated user.
@riverpod
Future<List<Action>> creatorActions(Ref ref) async {
  final client = ref.watch(serverpodClientProvider);

  try {
    return await client.action.listByCreator();
  } on Exception catch (error) {
    debugPrint('Failed to fetch creator actions: $error');
    return <Action>[];
  }
}
