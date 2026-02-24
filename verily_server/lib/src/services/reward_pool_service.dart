import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';

/// Business logic for managing reward pools.
///
/// A reward pool is a funded pot of SOL, SPL tokens, or NFTs that is
/// distributed to performers who complete an action and pass verification.
///
/// All methods are static and accept a [Session] as the first parameter.
class RewardPoolService {
  RewardPoolService._();

  static final _log = VLogger('RewardPoolService');

  /// Creates a new reward pool for an action.
  static Future<RewardPool> create(
    Session session, {
    required int actionId,
    required UuidValue creatorId,
    required String rewardType,
    required double totalAmount,
    required double perPersonAmount,
    String? tokenMintAddress,
    int? maxRecipients,
    DateTime? expiresAt,
    double platformFeePercent = 5.0,
  }) async {
    // Validate reward type.
    RewardType.fromValue(rewardType);

    // Verify the action exists.
    final action = await Action.db.findById(session, actionId);
    if (action == null) {
      throw NotFoundException('Action with id $actionId not found');
    }

    // Verify creator owns the action.
    if (action.creatorId != creatorId) {
      throw ForbiddenException(
        'Only the action creator can create reward pools',
      );
    }

    // Validate amounts.
    if (totalAmount <= 0) {
      throw ValidationException('Total amount must be positive');
    }
    if (perPersonAmount <= 0) {
      throw ValidationException('Per-person amount must be positive');
    }
    if (perPersonAmount > totalAmount) {
      throw ValidationException('Per-person amount cannot exceed total amount');
    }
    if (platformFeePercent < 0 || platformFeePercent > 50) {
      throw ValidationException('Platform fee must be between 0% and 50%');
    }

    // SPL token transfers require a mint address.
    if (rewardType == RewardType.splToken.value && tokenMintAddress == null) {
      throw ValidationException(
        'Token mint address is required for SPL token rewards',
      );
    }

    final now = DateTime.now().toUtc();
    final pool = RewardPool(
      actionId: actionId,
      creatorId: creatorId,
      rewardType: rewardType,
      tokenMintAddress: tokenMintAddress,
      totalAmount: totalAmount,
      remainingAmount: totalAmount,
      perPersonAmount: perPersonAmount,
      maxRecipients: maxRecipients,
      expiresAt: expiresAt,
      platformFeePercent: platformFeePercent,
      status: PoolStatus.active.value,
      createdAt: now,
    );

    final inserted = await RewardPool.db.insertRow(session, pool);
    _log.info(
      'Created reward pool (id=${inserted.id}) for action $actionId: '
      '$totalAmount $rewardType',
    );
    return inserted;
  }

  /// Gets a reward pool by id.
  static Future<RewardPool> findById(Session session, int id) async {
    final pool = await RewardPool.db.findById(session, id);
    if (pool == null) {
      throw NotFoundException('Reward pool $id not found');
    }
    return pool;
  }

  /// Lists all reward pools for an action.
  static Future<List<RewardPool>> findByAction(
    Session session, {
    required int actionId,
    String? status,
  }) async {
    var filter = RewardPool.t.actionId.equals(actionId);
    if (status != null) {
      filter = filter & RewardPool.t.status.equals(status);
    }

    return RewardPool.db.find(
      session,
      where: (_) => filter,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Lists all reward pools created by a user.
  static Future<List<RewardPool>> findByCreator(
    Session session, {
    required UuidValue creatorId,
    int limit = 50,
    int offset = 0,
  }) async {
    return RewardPool.db.find(
      session,
      where: (t) => t.creatorId.equals(creatorId),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Cancels a reward pool and marks remaining funds for refund.
  static Future<RewardPool> cancel(
    Session session, {
    required int poolId,
    required UuidValue userId,
  }) async {
    final pool = await findById(session, poolId);

    if (pool.creatorId != userId) {
      throw ForbiddenException('Only the pool creator can cancel it');
    }

    if (pool.status != PoolStatus.active.value) {
      throw ValidationException(
        'Can only cancel active pools (current: ${pool.status})',
      );
    }

    pool.status = PoolStatus.cancelled.value;
    final updated = await RewardPool.db.updateRow(session, pool);

    _log.info(
      'Cancelled reward pool id=$poolId, '
      'remaining: ${pool.remainingAmount} ${pool.rewardType}',
    );

    // TODO: Initiate refund of remainingAmount to creator's wallet

    return updated;
  }

  /// Records a funding transaction for a pool.
  static Future<RewardPool> recordFunding(
    Session session, {
    required int poolId,
    required String txSignature,
  }) async {
    final pool = await findById(session, poolId);
    pool.fundingTxSignature = txSignature;
    final updated = await RewardPool.db.updateRow(session, pool);
    _log.info('Recorded funding tx for pool $poolId: $txSignature');
    return updated;
  }

  /// Lists all distributions for a reward pool.
  static Future<List<RewardDistribution>> getDistributions(
    Session session, {
    required int poolId,
    int limit = 100,
    int offset = 0,
  }) async {
    return RewardDistribution.db.find(
      session,
      where: (t) => t.rewardPoolId.equals(poolId),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Returns the total amount distributed from a pool.
  static Future<double> getTotalDistributed(
    Session session, {
    required int poolId,
  }) async {
    final distributions = await RewardDistribution.db.find(
      session,
      where: (t) =>
          t.rewardPoolId.equals(poolId) &
          t.status.notEquals(DistributionStatus.failed.value),
    );

    return distributions.fold<double>(0, (sum, d) => sum + d.amount);
  }

  /// Checks if an active reward pool exists for an action.
  static Future<bool> hasActivePool(
    Session session, {
    required int actionId,
  }) async {
    final count = await RewardPool.db.count(
      session,
      where: (t) =>
          t.actionId.equals(actionId) &
          t.status.equals(PoolStatus.active.value),
    );
    return count > 0;
  }
}
