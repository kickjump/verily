import 'package:serverpod/serverpod.dart';

import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/reward_service.dart';

/// Endpoint for managing rewards and leaderboards.
///
/// All methods require authentication. Rewards are earned by users
/// upon successful verification of action submissions.
class RewardEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Lists all rewards associated with a given action.
  Future<List<Reward>> listByAction(Session session, int actionId) async {
    return RewardService.findRewardsByAction(session, actionId: actionId);
  }

  /// Lists all rewards earned by the authenticated user.
  Future<List<UserReward>> listByUser(Session session) async {
    final authId = _authenticatedUserId(session);
    return RewardService.findUserRewards(session, userId: authId);
  }

  /// Retrieves the leaderboard of users ranked by total reward points.
  Future<List<UserReward>> getLeaderboard(Session session) async {
    return UserReward.db.find(
      session,
      limit: 100,
      orderBy: (t) => t.earnedAt,
      orderDescending: true,
    );
  }
}

UuidValue _authenticatedUserId(Session session) {
  return UuidValue.fromString(session.authenticated!.userIdentifier);
}
