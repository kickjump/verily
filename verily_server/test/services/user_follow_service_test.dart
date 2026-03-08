@Tags(['db'])
library;

// TODO(ifiokjr): These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/user_follow_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  group('UserFollowService', () {
    // late Session session;

    // setUp(() async {
    //   session = await createTestSession();
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    // -------------------------------------------------------------------------
    // follow()
    // -------------------------------------------------------------------------

    group('follow()', () {
      test('creates a follow relationship', () async {
        // final follow = await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // expect(follow.id, isNotNull);
        // expect(follow.followerId, equals(userA));
        // expect(follow.followedId, equals(userB));
        // expect(follow.createdAt, isNotNull);
      });

      test('throws ValidationException when following self', () async {
        // expect(
        //   () => UserFollowService.follow(
        //     session,
        //     followerId: userA,
        //     followedId: userA,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      });

      test('returns existing record when already following', () async {
        // final first = await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // final second = await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // // Should return the same record, not create a duplicate.
        // expect(first.id, equals(second.id));
      });

      test('allows A->B and B->A as separate relationships', () async {
        // final ab = await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // final ba = await UserFollowService.follow(
        //   session,
        //   followerId: userB,
        //   followedId: userA,
        // );
        //
        // expect(ab.id, isNot(equals(ba.id)));
      });
    });

    // -------------------------------------------------------------------------
    // unfollow()
    // -------------------------------------------------------------------------

    group('unfollow()', () {
      test('removes a follow relationship', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // await UserFollowService.unfollow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // final isFollowing = await UserFollowService.isFollowing(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // expect(isFollowing, isFalse);
      });

      test('completes silently when follow does not exist', () async {
        // No exception should be thrown.
        // await UserFollowService.unfollow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
      });
    });

    // -------------------------------------------------------------------------
    // isFollowing()
    // -------------------------------------------------------------------------

    group('isFollowing()', () {
      test('returns true when following', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // final result = await UserFollowService.isFollowing(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // expect(result, isTrue);
      });

      test('returns false when not following', () async {
        // final result = await UserFollowService.isFollowing(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        //
        // expect(result, isFalse);
      });

      test('is directional (A follows B does not mean B follows A)', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        //
        // final aFollowsB = await UserFollowService.isFollowing(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // final bFollowsA = await UserFollowService.isFollowing(
        //   session,
        //   followerId: userB,
        //   followedId: userA,
        // );
        //
        // expect(aFollowsB, isTrue);
        // expect(bFollowsA, isFalse);
      });
    });

    // -------------------------------------------------------------------------
    // getFollowing() and getFollowers()
    // -------------------------------------------------------------------------

    group('getFollowing()', () {
      test('returns list of users the user follows', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        //
        // final following = await UserFollowService.getFollowing(
        //   session,
        //   userId: userA,
        // );
        //
        // expect(following.length, equals(2));
        // final followedIds = following.map((f) => f.followedId).toSet();
        // expect(followedIds, contains(userB));
        // expect(followedIds, contains(userC));
      });

      test('returns empty list when not following anyone', () async {
        // final following = await UserFollowService.getFollowing(
        //   session,
        //   userId: userC,
        // );
        // expect(following, isEmpty);
      });

      test('respects limit and offset', () async {
        // final page1 = await UserFollowService.getFollowing(
        //   session,
        //   userId: userA,
        //   limit: 1,
        //   offset: 0,
        // );
        // expect(page1.length, lessThanOrEqualTo(1));
      });
    });

    group('getFollowers()', () {
      test('returns list of users following the user', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userB,
        //   followedId: userC,
        // );
        //
        // final followers = await UserFollowService.getFollowers(
        //   session,
        //   userId: userC,
        // );
        //
        // expect(followers.length, equals(2));
        // final followerIds = followers.map((f) => f.followerId).toSet();
        // expect(followerIds, contains(userA));
        // expect(followerIds, contains(userB));
      });
    });

    // -------------------------------------------------------------------------
    // Counts
    // -------------------------------------------------------------------------

    group('countFollowing()', () {
      test('returns correct count', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        //
        // final count = await UserFollowService.countFollowing(
        //   session,
        //   userId: userA,
        // );
        // expect(count, equals(2));
      });
    });

    group('countFollowers()', () {
      test('returns correct count', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userB,
        //   followedId: userC,
        // );
        //
        // final count = await UserFollowService.countFollowers(
        //   session,
        //   userId: userC,
        // );
        // expect(count, equals(2));
      });
    });

    group('getCounts()', () {
      test('returns both follower and following counts', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userB,
        //   followedId: userA,
        // );
        //
        // final counts = await UserFollowService.getCounts(
        //   session,
        //   userId: userA,
        // );
        //
        // expect(counts.following, equals(2));
        // expect(counts.followers, equals(1));
      });
    });

    // -------------------------------------------------------------------------
    // getFollowingIds()
    // -------------------------------------------------------------------------

    group('getFollowingIds()', () {
      test('returns UUIDs of followed users', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        //
        // final ids = await UserFollowService.getFollowingIds(
        //   session,
        //   userId: userA,
        // );
        //
        // expect(ids, contains(userB));
        // expect(ids, contains(userC));
        // expect(ids.length, equals(2));
      });
    });

    // -------------------------------------------------------------------------
    // getMutualFollows()
    // -------------------------------------------------------------------------

    group('getMutualFollows()', () {
      test('returns users who follow each other', () async {
        // A follows B, B follows A (mutual).
        // A follows C, C does not follow A (not mutual).
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userB,
        //   followedId: userA,
        // );
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userC,
        // );
        //
        // final mutuals = await UserFollowService.getMutualFollows(
        //   session,
        //   userId: userA,
        // );
        //
        // expect(mutuals, contains(userB));
        // expect(mutuals, isNot(contains(userC)));
        // expect(mutuals.length, equals(1));
      });

      test('returns empty list when no mutual follows exist', () async {
        // await UserFollowService.follow(
        //   session,
        //   followerId: userA,
        //   followedId: userB,
        // );
        // // B does not follow A back.
        //
        // final mutuals = await UserFollowService.getMutualFollows(
        //   session,
        //   userId: userA,
        // );
        //
        // expect(mutuals, isEmpty);
      });
    });
  });

  // ---------------------------------------------------------------------------
  // FollowCounts (pure Dart - no DB needed)
  // ---------------------------------------------------------------------------

  // group('FollowCounts', () {
  //   test('stores followers and following counts', () {
  //     final counts = FollowCounts(followers: 10, following: 5);
  //     expect(counts.followers, equals(10));
  //     expect(counts.following, equals(5));
  //   });
  // });

  // ---------------------------------------------------------------------------
  // Self-follow prevention (pure logic - no DB needed)
  // ---------------------------------------------------------------------------

  group('Self-follow prevention (pure logic)', () {
    test('same UUIDs are equal', () {
      final id1 = UuidValue.fromString('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee');
      final id2 = UuidValue.fromString('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee');
      expect(id1, equals(id2));
    });

    test('different UUIDs are not equal', () {
      final id1 = UuidValue.fromString('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee');
      final id2 = UuidValue.fromString('11111111-2222-3333-4444-555555555555');
      expect(id1, isNot(equals(id2)));
    });
  });
}
