import 'package:serverpod/serverpod.dart';

import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/user_profile_service.dart';

/// Endpoint for managing user profiles.
///
/// All methods require authentication. Each authenticated user has a single
/// profile containing display information and social links.
class UserProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new user profile for the authenticated user.
  Future<UserProfile> create(Session session, UserProfile profile) async {
    final authId = _authenticatedUserId(session);
    await UserProfileService.getOrCreate(session, authUserId: authId);
    return UserProfileService.update(
      session,
      authUserId: authId,
      username: profile.username,
      displayName: profile.displayName,
      bio: profile.bio,
      avatarUrl: profile.avatarUrl,
      isPublic: profile.isPublic,
      socialLinks: profile.socialLinks,
    );
  }

  /// Retrieves the authenticated user's profile.
  Future<UserProfile> get(Session session) async {
    final authId = _authenticatedUserId(session);
    return UserProfileService.getOrCreate(session, authUserId: authId);
  }

  /// Retrieves a user profile by username.
  Future<UserProfile?> getByUsername(Session session, String username) async {
    return UserProfileService.findByUsername(session, username);
  }

  /// Updates the authenticated user's profile.
  Future<UserProfile> update(Session session, UserProfile profile) async {
    final authId = _authenticatedUserId(session);
    return UserProfileService.update(
      session,
      authUserId: authId,
      username: profile.username,
      displayName: profile.displayName,
      bio: profile.bio,
      avatarUrl: profile.avatarUrl,
      isPublic: profile.isPublic,
      socialLinks: profile.socialLinks,
    );
  }

  /// Searches for user profiles by a query string.
  Future<List<UserProfile>> search(Session session, String query) async {
    return UserProfileService.search(session, query: query);
  }
}

UuidValue _authenticatedUserId(Session session) {
  return UuidValue.fromString(session.authenticated!.userIdentifier);
}
