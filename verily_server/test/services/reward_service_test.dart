// TODO: These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`

import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/action_service.dart';
// import 'package:verily_server/src/services/reward_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Shared test data
  // ---------------------------------------------------------------------------

  final testCreatorId =
      UuidValue.fromString('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee');
  final userId1 =
      UuidValue.fromString('11111111-2222-3333-4444-555555555555');
  final userId2 =
      UuidValue.fromString('22222222-3333-4444-5555-666666666666');

  group('RewardService', () {
    // late Session session;
    // late Action testAction;

    // setUp(() async {
    //   session = await createTestSession();
    //
    //   testAction = await ActionService.create(
    //     session,
    //     title: 'Reward Test Action',
    //     description: 'desc',
    //     creatorId: testCreatorId,
    //     actionType: ActionType.oneOff.value,
    //     verificationCriteria: 'criteria',
    //   );
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    // -------------------------------------------------------------------------
    // Reward CRUD
    // -------------------------------------------------------------------------

    group('createReward()', () {
      test('creates a reward linked to an action', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Test Badge',
        //   actionId: testAction.id!,
        //   description: 'A test badge reward',
        //   pointValue: 100,
        // );
        //
        // expect(reward.id, isNotNull);
        // expect(reward.rewardType, equals('badge'));
        // expect(reward.name, equals('Test Badge'));
        // expect(reward.description, equals('A test badge reward'));
        // expect(reward.pointValue, equals(100));
        // expect(reward.actionId, equals(testAction.id));
      }, skip: 'Requires serverpod_test database session');

      test('creates a reward with minimal fields', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'points',
        //   name: 'Minimal Reward',
        //   actionId: testAction.id!,
        // );
        //
        // expect(reward.description, isNull);
        // expect(reward.iconUrl, isNull);
        // expect(reward.pointValue, isNull);
      }, skip: 'Requires serverpod_test database session');

      test('throws NotFoundException for non-existent action', () async {
        // expect(
        //   () => RewardService.createReward(
        //     session,
        //     rewardType: 'badge',
        //     name: 'Orphan Reward',
        //     actionId: 99999,
        //   ),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    group('findRewardById()', () {
      test('returns reward by primary key', () async {
        // final created = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Find Me',
        //   actionId: testAction.id!,
        // );
        //
        // final found = await RewardService.findRewardById(
        //   session,
        //   created.id!,
        // );
        // expect(found.name, equals('Find Me'));
      }, skip: 'Requires serverpod_test database session');

      test('throws NotFoundException for non-existent id', () async {
        // expect(
        //   () => RewardService.findRewardById(session, 99999),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    group('findRewardsByAction()', () {
      test('returns all rewards for an action', () async {
        // await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Badge 1',
        //   actionId: testAction.id!,
        //   pointValue: 100,
        // );
        // await RewardService.createReward(
        //   session,
        //   rewardType: 'points',
        //   name: 'Points 1',
        //   actionId: testAction.id!,
        //   pointValue: 50,
        // );
        //
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: testAction.id!,
        // );
        //
        // expect(rewards.length, equals(2));
      }, skip: 'Requires serverpod_test database session');

      test('returns empty list for action with no rewards', () async {
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: testAction.id!,
        // );
        // expect(rewards, isEmpty);
      }, skip: 'Requires serverpod_test database session');
    });

    group('deleteReward()', () {
      test('deletes a reward by id', () async {
        // final created = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Delete Me',
        //   actionId: testAction.id!,
        // );
        //
        // await RewardService.deleteReward(session, created.id!);
        //
        // expect(
        //   () => RewardService.findRewardById(session, created.id!),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // User Reward grants
    // -------------------------------------------------------------------------

    group('grantReward()', () {
      test('grants a reward to a user', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Grant Test',
        //   actionId: testAction.id!,
        //   pointValue: 100,
        // );
        //
        // final userReward = await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        // );
        //
        // expect(userReward.id, isNotNull);
        // expect(userReward.userId, equals(userId1));
        // expect(userReward.rewardId, equals(reward.id));
        // expect(userReward.earnedAt, isNotNull);
      }, skip: 'Requires serverpod_test database session');

      test('is idempotent for same reward+submission combination', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Idempotent Test',
        //   actionId: testAction.id!,
        //   pointValue: 100,
        // );
        //
        // final grant1 = await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        //   submissionId: 1,
        // );
        //
        // final grant2 = await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        //   submissionId: 1,
        // );
        //
        // // Should return the same record.
        // expect(grant1.id, equals(grant2.id));
      }, skip: 'Requires serverpod_test database session');

      test('allows duplicate grants without submissionId', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'No Submission Check',
        //   actionId: testAction.id!,
        // );
        //
        // final grant1 = await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        //   // No submissionId - no dedup check
        // );
        //
        // final grant2 = await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        // );
        //
        // // Both should succeed as separate grants.
        // expect(grant1.id, isNot(equals(grant2.id)));
      }, skip: 'Requires serverpod_test database session');
    });

    group('grantActionRewards()', () {
      test('grants all rewards for an action to a user', () async {
        // await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Badge',
        //   actionId: testAction.id!,
        //   pointValue: 100,
        // );
        // await RewardService.createReward(
        //   session,
        //   rewardType: 'points',
        //   name: 'Points',
        //   actionId: testAction.id!,
        //   pointValue: 50,
        // );
        //
        // final grants = await RewardService.grantActionRewards(
        //   session,
        //   userId: userId1,
        //   actionId: testAction.id!,
        //   submissionId: 1,
        // );
        //
        // expect(grants.length, equals(2));
      }, skip: 'Requires serverpod_test database session');

      test('returns empty list when action has no rewards', () async {
        // final grants = await RewardService.grantActionRewards(
        //   session,
        //   userId: userId1,
        //   actionId: testAction.id!,
        // );
        //
        // expect(grants, isEmpty);
      }, skip: 'Requires serverpod_test database session');
    });

    group('findUserRewards()', () {
      test('returns all rewards earned by a user', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'User Reward',
        //   actionId: testAction.id!,
        // );
        // await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        // );
        //
        // final rewards = await RewardService.findUserRewards(
        //   session,
        //   userId: userId1,
        // );
        //
        // expect(rewards, isNotEmpty);
        // for (final r in rewards) {
        //   expect(r.userId, equals(userId1));
        // }
      }, skip: 'Requires serverpod_test database session');
    });

    group('hasReward()', () {
      test('returns true when user has the reward', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Has Test',
        //   actionId: testAction.id!,
        // );
        // await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        // );
        //
        // final has = await RewardService.hasReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        // );
        //
        // expect(has, isTrue);
      }, skip: 'Requires serverpod_test database session');

      test('returns false when user does not have the reward', () async {
        // final has = await RewardService.hasReward(
        //   session,
        //   userId: userId1,
        //   rewardId: 99999,
        // );
        //
        // expect(has, isFalse);
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // Leaderboard
    // -------------------------------------------------------------------------

    group('getLeaderboard()', () {
      test('returns entries sorted by total points descending', () async {
        // // Create rewards and grant to two users with different point totals.
        // final reward100 = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: '100 Points',
        //   actionId: testAction.id!,
        //   pointValue: 100,
        // );
        // final reward200 = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: '200 Points',
        //   actionId: testAction.id!,
        //   pointValue: 200,
        // );
        //
        // // userId1 gets 300 total.
        // await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward100.id!,
        // );
        // await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward200.id!,
        // );
        //
        // // userId2 gets 100 total.
        // await RewardService.grantReward(
        //   session,
        //   userId: userId2,
        //   rewardId: reward100.id!,
        // );
        //
        // final leaderboard = await RewardService.getLeaderboard(session);
        //
        // expect(leaderboard.length, greaterThanOrEqualTo(2));
        // // First entry should be userId1 with 300 points.
        // expect(leaderboard[0].userId, equals(userId1));
        // expect(leaderboard[0].totalPoints, equals(300));
        // expect(leaderboard[0].rank, equals(1));
        // // Second entry should be userId2 with 100 points.
        // expect(leaderboard[1].userId, equals(userId2));
        // expect(leaderboard[1].totalPoints, equals(100));
        // expect(leaderboard[1].rank, equals(2));
      }, skip: 'Requires serverpod_test database session');

      test('respects limit parameter', () async {
        // final leaderboard = await RewardService.getLeaderboard(
        //   session,
        //   limit: 1,
        // );
        // expect(leaderboard.length, lessThanOrEqualTo(1));
      }, skip: 'Requires serverpod_test database session');

      test('includes correct reward counts', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Count Test',
        //   actionId: testAction.id!,
        //   pointValue: 50,
        // );
        // await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        // );
        //
        // final leaderboard = await RewardService.getLeaderboard(session);
        // final entry = leaderboard.firstWhere((e) => e.userId == userId1);
        //
        // expect(entry.rewardCount, greaterThanOrEqualTo(1));
      }, skip: 'Requires serverpod_test database session');
    });

    group('getUserStats()', () {
      test('returns stats for a user with rewards', () async {
        // final reward = await RewardService.createReward(
        //   session,
        //   rewardType: 'badge',
        //   name: 'Stats Test',
        //   actionId: testAction.id!,
        //   pointValue: 100,
        // );
        // await RewardService.grantReward(
        //   session,
        //   userId: userId1,
        //   rewardId: reward.id!,
        // );
        //
        // final stats = await RewardService.getUserStats(
        //   session,
        //   userId: userId1,
        // );
        //
        // expect(stats, isNotNull);
        // expect(stats!.userId, equals(userId1));
        // expect(stats.totalPoints, equals(100));
        // expect(stats.rewardCount, equals(1));
        // expect(stats.rank, equals(0)); // Rank not computed for single-user lookup
      }, skip: 'Requires serverpod_test database session');

      test('returns null for user with no rewards', () async {
        // final stats = await RewardService.getUserStats(
        //   session,
        //   userId: userId1,
        // );
        //
        // expect(stats, isNull);
      }, skip: 'Requires serverpod_test database session');
    });
  });

  // ---------------------------------------------------------------------------
  // LeaderboardEntry (pure Dart - no DB needed)
  // ---------------------------------------------------------------------------

  // group('LeaderboardEntry', () {
  //   test('stores rank, userId, totalPoints, and rewardCount', () {
  //     final entry = LeaderboardEntry(
  //       rank: 1,
  //       userId: UuidValue.fromString('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'),
  //       totalPoints: 500,
  //       rewardCount: 3,
  //     );
  //
  //     expect(entry.rank, equals(1));
  //     expect(entry.totalPoints, equals(500));
  //     expect(entry.rewardCount, equals(3));
  //   });
  // });
}
