import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/reward_pool_service.dart';

/// Endpoint for managing reward pools on actions.
///
/// Reward pools are funded pots of SOL, SPL tokens, or NFTs that are
/// distributed to performers who complete an action.
class RewardPoolEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new reward pool for an action.
  Future<RewardPool> create(
    Session session,
    int actionId,
    String rewardType,
    double totalAmount,
    double perPersonAmount, {
    String? tokenMintAddress,
    int? maxRecipients,
    DateTime? expiresAt,
  }) async {
    final userId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return RewardPoolService.create(
      session,
      actionId: actionId,
      creatorId: userId,
      rewardType: rewardType,
      totalAmount: totalAmount,
      perPersonAmount: perPersonAmount,
      tokenMintAddress: tokenMintAddress,
      maxRecipients: maxRecipients,
      expiresAt: expiresAt,
    );
  }

  /// Gets a reward pool by id.
  Future<RewardPool> get(Session session, int poolId) async {
    return RewardPoolService.findById(session, poolId);
  }

  /// Lists all reward pools for an action.
  Future<List<RewardPool>> listByAction(Session session, int actionId) async {
    return RewardPoolService.findByAction(session, actionId: actionId);
  }

  /// Lists all reward pools created by the authenticated user.
  Future<List<RewardPool>> listByCreator(Session session) async {
    final userId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return RewardPoolService.findByCreator(session, creatorId: userId);
  }

  /// Cancels a reward pool (only the creator can cancel).
  Future<RewardPool> cancel(Session session, int poolId) async {
    final userId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return RewardPoolService.cancel(session, poolId: poolId, userId: userId);
  }

  /// Lists all distributions from a reward pool.
  Future<List<RewardDistribution>> getDistributions(
    Session session,
    int poolId,
  ) async {
    return RewardPoolService.getDistributions(session, poolId: poolId);
  }
}
