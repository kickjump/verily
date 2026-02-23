import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/reward_service.dart';

/// Endpoint for managing rewards and leaderboards.
///
/// All methods require authentication. Rewards are earned by users
/// upon successful verification of action submissions.
class RewardEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Lists all rewards associated with a given action.
  Future<List<Reward>> listByAction(Session session, int actionId) async {
    return RewardService.listByAction(session, actionId);
  }

  /// Lists all rewards earned by the authenticated user.
  Future<List<UserReward>> listByUser(Session session) async {
    final authId = session.authenticated!.userId;
    return RewardService.listByUser(session, authId);
  }

  /// Retrieves the leaderboard of users ranked by total reward points.
  Future<List<UserReward>> getLeaderboard(Session session) async {
    return RewardService.getLeaderboard(session);
  }
}
