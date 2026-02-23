import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';

/// Business logic for user follow/unfollow relationships.
///
/// A follow creates a directed edge from the follower to the followed user.
/// The unique index on `(followerId, followedId)` prevents duplicates at the
/// database level.
///
/// All methods are static and accept a [Session] as the first parameter.
class UserFollowService {
  UserFollowService._();

  static final _log = VLogger('UserFollowService');

  /// Creates a follow relationship.
  ///
  /// The [followerId] starts following [followedId]. A user cannot follow
  /// themselves. If the follow already exists this method returns the existing
  /// record without error.
  static Future<UserFollow> follow(
    Session session, {
    required UuidValue followerId,
    required UuidValue followedId,
  }) async {
    if (followerId == followedId) {
      throw ValidationException('A user cannot follow themselves');
    }

    // Check if already following.
    final existing = await _findExisting(
      session,
      followerId: followerId,
      followedId: followedId,
    );
    if (existing != null) return existing;

    final userFollow = UserFollow(
      followerId: followerId,
      followedId: followedId,
      createdAt: DateTime.now().toUtc(),
    );

    final inserted = await UserFollow.db.insertRow(session, userFollow);
    _log.info('User $followerId followed $followedId');
    return inserted;
  }

  /// Removes a follow relationship.
  ///
  /// If the follow does not exist this method completes silently.
  static Future<void> unfollow(
    Session session, {
    required UuidValue followerId,
    required UuidValue followedId,
  }) async {
    final existing = await _findExisting(
      session,
      followerId: followerId,
      followedId: followedId,
    );
    if (existing == null) return;

    await UserFollow.db.deleteRow(session, existing);
    _log.info('User $followerId unfollowed $followedId');
  }

  /// Returns `true` if [followerId] is following [followedId].
  static Future<bool> isFollowing(
    Session session, {
    required UuidValue followerId,
    required UuidValue followedId,
  }) async {
    final existing = await _findExisting(
      session,
      followerId: followerId,
      followedId: followedId,
    );
    return existing != null;
  }

  /// Returns the list of users that [userId] is following.
  static Future<List<UserFollow>> getFollowing(
    Session session, {
    required UuidValue userId,
    int limit = 50,
    int offset = 0,
  }) async {
    return UserFollow.db.find(
      session,
      where: (t) => t.followerId.equals(userId),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Returns the list of users following [userId].
  static Future<List<UserFollow>> getFollowers(
    Session session, {
    required UuidValue userId,
    int limit = 50,
    int offset = 0,
  }) async {
    return UserFollow.db.find(
      session,
      where: (t) => t.followedId.equals(userId),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Returns the count of users that [userId] is following.
  static Future<int> countFollowing(
    Session session, {
    required UuidValue userId,
  }) async {
    return UserFollow.db.count(
      session,
      where: (t) => t.followerId.equals(userId),
    );
  }

  /// Returns the count of users who follow [userId].
  static Future<int> countFollowers(
    Session session, {
    required UuidValue userId,
  }) async {
    return UserFollow.db.count(
      session,
      where: (t) => t.followedId.equals(userId),
    );
  }

  /// Returns the follower and following counts for a user in a single call.
  static Future<FollowCounts> getCounts(
    Session session, {
    required UuidValue userId,
  }) async {
    final followers = await countFollowers(session, userId: userId);
    final following = await countFollowing(session, userId: userId);
    return FollowCounts(
      followers: followers,
      following: following,
    );
  }

  /// Returns the UUIDs of all users that [userId] follows.
  ///
  /// This is useful for building "following" feeds.
  static Future<List<UuidValue>> getFollowingIds(
    Session session, {
    required UuidValue userId,
  }) async {
    final follows = await UserFollow.db.find(
      session,
      where: (t) => t.followerId.equals(userId),
    );
    return follows.map((f) => f.followedId).toList();
  }

  /// Returns mutual follows (users that both follow each other).
  static Future<List<UuidValue>> getMutualFollows(
    Session session, {
    required UuidValue userId,
  }) async {
    final followingIds = await getFollowingIds(session, userId: userId);
    final mutuals = <UuidValue>[];

    for (final otherId in followingIds) {
      final theyFollowBack = await isFollowing(
        session,
        followerId: otherId,
        followedId: userId,
      );
      if (theyFollowBack) {
        mutuals.add(otherId);
      }
    }

    return mutuals;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Looks up an existing follow record, returning `null` if not found.
  static Future<UserFollow?> _findExisting(
    Session session, {
    required UuidValue followerId,
    required UuidValue followedId,
  }) async {
    final results = await UserFollow.db.find(
      session,
      where: (t) =>
          t.followerId.equals(followerId) & t.followedId.equals(followedId),
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }
}

/// Follower and following counts for a user.
class FollowCounts {
  FollowCounts({
    required this.followers,
    required this.following,
  });

  final int followers;
  final int following;
}
