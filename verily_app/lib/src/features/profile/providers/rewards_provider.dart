import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'rewards_provider.g.dart';

/// Fetches all rewards earned by the authenticated user.
@riverpod
Future<List<UserReward>> userRewards(Ref ref) async {
  final client = ref.watch(serverpodClientProvider);
  return client.reward.listByUser();
}

/// Fetches the leaderboard of top users by reward points.
@riverpod
Future<List<UserReward>> leaderboard(Ref ref) async {
  final client = ref.watch(serverpodClientProvider);
  return client.reward.getLeaderboard();
}
