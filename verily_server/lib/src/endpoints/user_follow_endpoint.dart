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
    final authId = session.authenticated!.userId;
    return UserFollowService.follow(session, authId, userId);
  }

  /// Unfollows another user.
  Future<void> unfollow(Session session, UuidValue userId) async {
    final authId = session.authenticated!.userId;
    return UserFollowService.unfollow(session, authId, userId);
  }

  /// Lists all followers of a user.
  Future<List<UserFollow>> listFollowers(
    Session session,
    UuidValue userId,
  ) async {
    return UserFollowService.listFollowers(session, userId);
  }

  /// Lists all users that a user is following.
  Future<List<UserFollow>> listFollowing(
    Session session,
    UuidValue userId,
  ) async {
    return UserFollowService.listFollowing(session, userId);
  }

  /// Checks whether the authenticated user is following a given user.
  Future<bool> isFollowing(Session session, UuidValue userId) async {
    final authId = session.authenticated!.userId;
    return UserFollowService.isFollowing(session, authId, userId);
  }
}
