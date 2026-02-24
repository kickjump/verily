import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';

/// Business logic for managing rewards, user reward grants, and leaderboard
/// computation.
///
/// All methods are static and accept a [Session] as the first parameter.
class RewardService {
  RewardService._();

  static final _log = VLogger('RewardService');

  // ---------------------------------------------------------------------------
  // Reward CRUD
  // ---------------------------------------------------------------------------

  /// Creates a reward definition linked to an action.
  static Future<Reward> createReward(
    Session session, {
    required String rewardType,
    required String name,
    required int actionId,
    String? description,
    String? iconUrl,
    int? pointValue,
  }) async {
    // Verify the action exists.
    final action = await Action.db.findById(session, actionId);
    if (action == null) {
      throw NotFoundException('Action with id $actionId not found');
    }

    final reward = Reward(
      rewardType: rewardType,
      name: name,
      description: description,
      iconUrl: iconUrl,
      pointValue: pointValue,
      actionId: actionId,
    );

    final inserted = await Reward.db.insertRow(session, reward);
    _log.info('Created reward "${inserted.name}" (id=${inserted.id})');
    return inserted;
  }

  /// Finds a reward by its primary key [id].
  ///
  /// Throws [NotFoundException] if not found.
  static Future<Reward> findRewardById(Session session, int id) async {
    final reward = await Reward.db.findById(session, id);
    if (reward == null) {
      throw NotFoundException('Reward with id $id not found');
    }
    return reward;
  }

  /// Returns all rewards for a given action.
  static Future<List<Reward>> findRewardsByAction(
    Session session, {
    required int actionId,
  }) async {
    return Reward.db.find(session, where: (t) => t.actionId.equals(actionId));
  }

  /// Deletes a reward by id.
  static Future<void> deleteReward(Session session, int id) async {
    final reward = await findRewardById(session, id);
    await Reward.db.deleteRow(session, reward);
    _log.info('Deleted reward id=$id');
  }

  // ---------------------------------------------------------------------------
  // User Reward grants
  // ---------------------------------------------------------------------------

  /// Grants a reward to a user, typically after successful verification.
  ///
  /// Returns the created [UserReward] record.
  static Future<UserReward> grantReward(
    Session session, {
    required UuidValue userId,
    required int rewardId,
    int? submissionId,
  }) async {
    // Verify the reward exists.
    await findRewardById(session, rewardId);

    // Check for duplicate grant of the same reward+submission combination.
    if (submissionId != null) {
      final existing = await UserReward.db.find(
        session,
        where: (t) =>
            t.userId.equals(userId) &
            t.rewardId.equals(rewardId) &
            t.submissionId.equals(submissionId),
        limit: 1,
      );
      if (existing.isNotEmpty) {
        _log.info(
          'Reward $rewardId already granted to user $userId for '
          'submission $submissionId',
        );
        return existing.first;
      }
    }

    final userReward = UserReward(
      userId: userId,
      rewardId: rewardId,
      submissionId: submissionId,
      earnedAt: DateTime.now().toUtc(),
    );

    final inserted = await UserReward.db.insertRow(session, userReward);
    _log.info('Granted reward $rewardId to user $userId');
    return inserted;
  }

  /// Grants all rewards associated with an action to a user.
  ///
  /// This is called when a user successfully completes an action (or all
  /// steps of a sequential action).
  static Future<List<UserReward>> grantActionRewards(
    Session session, {
    required UuidValue userId,
    required int actionId,
    int? submissionId,
  }) async {
    final rewards = await findRewardsByAction(session, actionId: actionId);
    final grants = <UserReward>[];

    for (final reward in rewards) {
      final grant = await grantReward(
        session,
        userId: userId,
        rewardId: reward.id!,
        submissionId: submissionId,
      );
      grants.add(grant);
    }

    return grants;
  }

  /// Returns all rewards earned by a specific user.
  static Future<List<UserReward>> findUserRewards(
    Session session, {
    required UuidValue userId,
    int limit = 100,
    int offset = 0,
  }) async {
    return UserReward.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.earnedAt,
      orderDescending: true,
    );
  }

  /// Checks whether a user has earned a specific reward.
  static Future<bool> hasReward(
    Session session, {
    required UuidValue userId,
    required int rewardId,
  }) async {
    final count = await UserReward.db.count(
      session,
      where: (t) => t.userId.equals(userId) & t.rewardId.equals(rewardId),
    );
    return count > 0;
  }

  // ---------------------------------------------------------------------------
  // Leaderboard
  // ---------------------------------------------------------------------------

  /// Computes the leaderboard ranked by total reward points.
  ///
  /// Returns a list of [LeaderboardEntry] objects sorted by points descending.
  static Future<List<LeaderboardEntry>> getLeaderboard(
    Session session, {
    int limit = 50,
  }) async {
    // TODO: For production, replace with a raw SQL query that JOINs
    // user_reward with reward and GROUP BY userId, SUM(pointValue),
    // for much better performance:
    //
    // SELECT ur.user_id, SUM(r.point_value) as total_points,
    //        COUNT(ur.id) as reward_count
    // FROM user_reward ur
    // JOIN reward r ON ur.reward_id = r.id
    // GROUP BY ur.user_id
    // ORDER BY total_points DESC
    // LIMIT $limit;

    final allUserRewards = await UserReward.db.find(session);
    final allRewards = await Reward.db.find(session);

    // Build a map of reward id to point value.
    final rewardPoints = <int, int>{};
    for (final reward in allRewards) {
      rewardPoints[reward.id!] = reward.pointValue ?? 0;
    }

    // Accumulate points per user.
    final userPoints = <UuidValue, int>{};
    final userRewardCount = <UuidValue, int>{};
    for (final ur in allUserRewards) {
      final points = rewardPoints[ur.rewardId] ?? 0;
      userPoints[ur.userId] = (userPoints[ur.userId] ?? 0) + points;
      userRewardCount[ur.userId] = (userRewardCount[ur.userId] ?? 0) + 1;
    }

    // Sort by total points descending.
    final sorted = userPoints.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final entries = <LeaderboardEntry>[];
    var rank = 1;
    for (final entry in sorted.take(limit)) {
      entries.add(
        LeaderboardEntry(
          rank: rank,
          userId: entry.key,
          totalPoints: entry.value,
          rewardCount: userRewardCount[entry.key] ?? 0,
        ),
      );
      rank++;
    }

    return entries;
  }

  /// Returns the total points and reward count for a single user.
  static Future<LeaderboardEntry?> getUserStats(
    Session session, {
    required UuidValue userId,
  }) async {
    final userRewards = await findUserRewards(session, userId: userId);
    if (userRewards.isEmpty) return null;

    final rewards = await Reward.db.find(session);
    final rewardPoints = <int, int>{};
    for (final reward in rewards) {
      rewardPoints[reward.id!] = reward.pointValue ?? 0;
    }

    var totalPoints = 0;
    for (final ur in userRewards) {
      totalPoints += rewardPoints[ur.rewardId] ?? 0;
    }

    return LeaderboardEntry(
      rank: 0, // Rank not computed for single-user lookup.
      userId: userId,
      totalPoints: totalPoints,
      rewardCount: userRewards.length,
    );
  }
}

/// A single entry on the leaderboard.
class LeaderboardEntry {
  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.totalPoints,
    required this.rewardCount,
  });

  final int rank;
  final UuidValue userId;
  final int totalPoints;
  final int rewardCount;
}
