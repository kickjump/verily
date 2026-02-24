import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';

/// Business logic for user profile management.
///
/// Profiles are automatically created the first time a user logs in via the
/// [getOrCreate] method. All methods are static and accept a [Session] as the
/// first parameter.
class UserProfileService {
  UserProfileService._();

  static final _log = VLogger('UserProfileService');

  /// Retrieves an existing profile for the given [authUserId], or creates a
  /// new one with sensible defaults if none exists.
  ///
  /// This is the primary entry point called during login/session
  /// initialization.
  static Future<UserProfile> getOrCreate(
    Session session, {
    required UuidValue authUserId,
    String? email,
  }) async {
    final existing = await findByAuthUserId(session, authUserId);
    if (existing != null) return existing;

    // Generate a unique username from the email or a random string.
    final baseUsername = _usernameFromEmail(email) ?? _randomUsername();
    final username = await _ensureUniqueUsername(session, baseUsername);

    final now = DateTime.now().toUtc();
    final profile = UserProfile(
      authUserId: authUserId,
      username: username,
      displayName: username,
      isPublic: true,
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await UserProfile.db.insertRow(session, profile);
    _log.info(
      'Auto-created profile for user $authUserId (username: $username)',
    );
    return inserted;
  }

  /// Finds a profile by the authentication provider user id.
  static Future<UserProfile?> findByAuthUserId(
    Session session,
    UuidValue authUserId,
  ) async {
    final results = await UserProfile.db.find(
      session,
      where: (t) => t.authUserId.equals(authUserId),
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  /// Finds a profile by its primary key [id].
  ///
  /// Throws [NotFoundException] if not found.
  static Future<UserProfile> findById(Session session, int id) async {
    final profile = await UserProfile.db.findById(session, id);
    if (profile == null) {
      throw NotFoundException('UserProfile with id $id not found');
    }
    return profile;
  }

  /// Finds a profile by its unique username.
  static Future<UserProfile?> findByUsername(
    Session session,
    String username,
  ) async {
    final results = await UserProfile.db.find(
      session,
      where: (t) => t.username.equals(username.toLowerCase()),
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  /// Updates the profile for the calling user.
  ///
  /// The [authUserId] must match the profile's owner. Only non-null fields
  /// are updated.
  static Future<UserProfile> update(
    Session session, {
    required UuidValue authUserId,
    String? username,
    String? displayName,
    String? bio,
    String? avatarUrl,
    bool? isPublic,
    String? socialLinks,
  }) async {
    final profile = await findByAuthUserId(session, authUserId);
    if (profile == null) {
      throw NotFoundException('Profile not found for user $authUserId');
    }

    if (username != null && username != profile.username) {
      final normalized = username.toLowerCase();
      _validateUsername(normalized);

      final existing = await findByUsername(session, normalized);
      if (existing != null) {
        throw ValidationException('Username "$normalized" is already taken');
      }
      profile.username = normalized;
    }

    if (displayName != null) profile.displayName = displayName;
    if (bio != null) profile.bio = bio;
    if (avatarUrl != null) profile.avatarUrl = avatarUrl;
    if (isPublic != null) profile.isPublic = isPublic;
    if (socialLinks != null) profile.socialLinks = socialLinks;
    profile.updatedAt = DateTime.now().toUtc();

    return UserProfile.db.updateRow(session, profile);
  }

  /// Searches public profiles by username or display name.
  static Future<List<UserProfile>> search(
    Session session, {
    required String query,
    int limit = 20,
  }) async {
    final lowerQuery = query.toLowerCase();
    return UserProfile.db.find(
      session,
      where: (t) =>
          t.isPublic.equals(true) &
          (t.username.like('%$lowerQuery%') |
              t.displayName.like('%$lowerQuery%')),
      limit: limit,
      orderBy: (t) => t.username,
    );
  }

  /// Checks whether a username is available.
  static Future<bool> isUsernameAvailable(
    Session session,
    String username,
  ) async {
    final normalized = username.toLowerCase();
    final existing = await findByUsername(session, normalized);
    return existing == null;
  }

  /// Returns the total number of registered profiles.
  static Future<int> count(Session session) async {
    return UserProfile.db.count(session);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Extracts a username candidate from an email address.
  ///
  /// Returns `null` if the email is null or cannot produce a valid username.
  static String? _usernameFromEmail(String? email) {
    if (email == null || !email.contains('@')) return null;
    final local = email.split('@').first.toLowerCase();
    // Strip non-alphanumeric characters except underscores.
    final cleaned = local.replaceAll(RegExp('[^a-z0-9_]'), '');
    return cleaned.length >= 3 ? cleaned : null;
  }

  /// Generates a random username of the form `user_XXXXXX`.
  static String _randomUsername() {
    final random = Random();
    final suffix = List.generate(
      6,
      (_) => random.nextInt(36).toRadixString(36),
    ).join();
    return 'user_$suffix';
  }

  /// Appends a numeric suffix if the base username is already taken.
  static Future<String> _ensureUniqueUsername(
    Session session,
    String base,
  ) async {
    var candidate = base;
    var attempt = 0;

    while (true) {
      final existing = await findByUsername(session, candidate);
      if (existing == null) return candidate;
      attempt++;
      candidate = '${base}_$attempt';
    }
  }

  /// Validates a username against basic rules.
  static void _validateUsername(String username) {
    if (username.length < 3) {
      throw ValidationException('Username must be at least 3 characters');
    }
    if (username.length > 30) {
      throw ValidationException('Username must be at most 30 characters');
    }
    if (!RegExp(r'^[a-z0-9_]+$').hasMatch(username)) {
      throw ValidationException(
        'Username may only contain lowercase letters, digits, and underscores',
      );
    }
  }
}
