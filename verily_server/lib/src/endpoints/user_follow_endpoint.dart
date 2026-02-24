import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/user_follow_service.dart';

/// Endpoint for managing user follow relationships.
///
/// All methods require authentication. Users can follow and unfollow
/// each other to see activity in their feeds.
class UserFollowEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Follows another user.
  Future<UserFollow> follow(Session session, UuidValue userId) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return UserFollowService.follow(
      session,
      followerId: authId,
      followedId: userId,
    );
  }

  /// Unfollows another user.
  Future<void> unfollow(Session session, UuidValue userId) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return UserFollowService.unfollow(
      session,
      followerId: authId,
      followedId: userId,
    );
  }

  /// Lists all followers of a user.
  Future<List<UserFollow>> listFollowers(
    Session session,
    UuidValue userId,
  ) async {
    return UserFollowService.getFollowers(session, userId: userId);
  }

  /// Lists all users that a user is following.
  Future<List<UserFollow>> listFollowing(
    Session session,
    UuidValue userId,
  ) async {
    return UserFollowService.getFollowing(session, userId: userId);
  }

  /// Checks whether the authenticated user is following a given user.
  Future<bool> isFollowing(Session session, UuidValue userId) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return UserFollowService.isFollowing(
      session,
      followerId: authId,
      followedId: userId,
    );
  }
}
