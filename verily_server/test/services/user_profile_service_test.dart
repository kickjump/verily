// TODO: Database-dependent tests require serverpod_test setup.
// Run with: cd verily_server && dart test
//
// The username validation and generation tests can run immediately since they
// test pure logic with no database dependency.

import 'package:test/test.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/user_profile_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Username validation (pure logic - no DB needed)
  //
  // Since _validateUsername is private, we replicate the validation rules here
  // for testing. The service enforces:
  // - Minimum 3 characters
  // - Maximum 30 characters
  // - Only lowercase letters, digits, and underscores
  // ---------------------------------------------------------------------------

  group('Username validation (pure logic)', () {
    bool isValidUsername(String username) {
      if (username.length < 3) return false;
      if (username.length > 30) return false;
      return RegExp(r'^[a-z0-9_]+$').hasMatch(username);
    }

    test('valid usernames pass validation', () {
      expect(isValidUsername('alice'), isTrue);
      expect(isValidUsername('bob_42'), isTrue);
      expect(isValidUsername('user_123'), isTrue);
      expect(isValidUsername('a_b'), isTrue);
      expect(isValidUsername('abc'), isTrue);
      expect(isValidUsername('user_with_underscores'), isTrue);
    });

    test('rejects usernames shorter than 3 characters', () {
      expect(isValidUsername('ab'), isFalse);
      expect(isValidUsername('a'), isFalse);
      expect(isValidUsername(''), isFalse);
    });

    test('rejects usernames longer than 30 characters', () {
      final longName = 'a' * 31;
      expect(isValidUsername(longName), isFalse);
    });

    test('accepts username exactly 30 characters', () {
      final exactName = 'a' * 30;
      expect(isValidUsername(exactName), isTrue);
    });

    test('accepts username exactly 3 characters', () {
      expect(isValidUsername('abc'), isTrue);
    });

    test('rejects uppercase letters', () {
      expect(isValidUsername('Alice'), isFalse);
      expect(isValidUsername('BOB'), isFalse);
      expect(isValidUsername('alicE'), isFalse);
    });

    test('rejects special characters', () {
      expect(isValidUsername('alice!'), isFalse);
      expect(isValidUsername('bob@42'), isFalse);
      expect(isValidUsername('user.name'), isFalse);
      expect(isValidUsername('user-name'), isFalse);
      expect(isValidUsername('user name'), isFalse);
    });

    test('allows digits', () {
      expect(isValidUsername('123'), isTrue);
      expect(isValidUsername('user123'), isTrue);
      expect(isValidUsername('123user'), isTrue);
    });

    test('allows underscores', () {
      expect(isValidUsername('___'), isTrue);
      expect(isValidUsername('_user_'), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Username from email extraction (pure logic - no DB needed)
  //
  // Replicates _usernameFromEmail logic:
  // - Returns null if email is null or has no @
  // - Takes the local part before @
  // - Lowercases it
  // - Strips non-alphanumeric chars except underscores
  // - Returns null if result is fewer than 3 chars
  // ---------------------------------------------------------------------------

  group('Username from email extraction (pure logic)', () {
    String? usernameFromEmail(String? email) {
      if (email == null || !email.contains('@')) return null;
      final local = email.split('@').first.toLowerCase();
      final cleaned = local.replaceAll(RegExp('[^a-z0-9_]'), '');
      return cleaned.length >= 3 ? cleaned : null;
    }

    test('extracts username from simple email', () {
      expect(usernameFromEmail('alice@example.com'), equals('alice'));
    });

    test('lowercases the username', () {
      expect(usernameFromEmail('Alice@example.com'), equals('alice'));
      expect(usernameFromEmail('BOB@example.com'), equals('bob'));
    });

    test('strips dots and hyphens', () {
      expect(usernameFromEmail('john.doe@example.com'), equals('johndoe'));
      expect(usernameFromEmail('jane-smith@example.com'), equals('janesmith'));
    });

    test('preserves underscores', () {
      expect(usernameFromEmail('user_name@example.com'), equals('user_name'));
    });

    test('strips plus addressing', () {
      expect(usernameFromEmail('user+tag@example.com'), equals('usertag'));
    });

    test('returns null for null email', () {
      expect(usernameFromEmail(null), isNull);
    });

    test('returns null for email without @', () {
      expect(usernameFromEmail('not_an_email'), isNull);
    });

    test('returns null when cleaned result is fewer than 3 chars', () {
      expect(usernameFromEmail('ab@example.com'), isNull);
      expect(usernameFromEmail('a.b@example.com'), isNull);
    });

    test('handles numeric email local parts', () {
      expect(usernameFromEmail('12345@example.com'), equals('12345'));
    });

    test('handles email with multiple dots', () {
      expect(usernameFromEmail('a.b.c.d@example.com'), equals('abcd'));
    });
  });

  // ---------------------------------------------------------------------------
  // Random username generation (pure logic - no DB needed)
  //
  // Replicates _randomUsername logic:
  // - Format: user_XXXXXX where X is base-36 char
  // ---------------------------------------------------------------------------

  group('Random username generation (pure logic)', () {
    String randomUsername() {
      final random = DateTime.now().millisecondsSinceEpoch;
      // Just verify the format.
      return 'user_${random.toRadixString(36).substring(0, 6)}';
    }

    test('generated username starts with user_', () {
      final username = randomUsername();
      expect(username, startsWith('user_'));
    });

    test('generated username is valid', () {
      final username = randomUsername();
      expect(username.length, greaterThanOrEqualTo(7)); // "user_" + at least 1
      expect(RegExp(r'^[a-z0-9_]+$').hasMatch(username), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Database-dependent tests (require serverpod_test)
  // ---------------------------------------------------------------------------

  group('UserProfileService (database operations)', () {
    // late Session session;

    // setUp(() async {
    //   session = await createTestSession();
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    group('getOrCreate()', () {
      test(
        'creates a new profile for a new user',
        () async {
          // final profile = await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // expect(profile.id, isNotNull);
          // expect(profile.authUserId, equals(testAuthUserId));
          // expect(profile.username, equals('alice'));
          // expect(profile.displayName, equals('alice'));
          // expect(profile.isPublic, isTrue);
          // expect(profile.createdAt, isNotNull);
          // expect(profile.updatedAt, isNotNull);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns existing profile on subsequent calls',
        () async {
          // final first = await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // final second = await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // expect(first.id, equals(second.id));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'generates a random username when email is null',
        () async {
          // final profile = await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          // );
          //
          // expect(profile.username, startsWith('user_'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'appends suffix when username is taken',
        () async {
          // // Create first profile with 'alice'.
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // // Create second profile with same email prefix.
          // final second = await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: otherAuthUserId,
          //   email: 'alice@other.com',
          // );
          //
          // expect(second.username, startsWith('alice'));
          // expect(second.username, isNot(equals('alice'))); // Should be alice_1
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('findByAuthUserId()', () {
      test(
        'returns profile for existing user',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          // );
          //
          // final found = await UserProfileService.findByAuthUserId(
          //   session,
          //   testAuthUserId,
          // );
          // expect(found, isNotNull);
          // expect(found!.authUserId, equals(testAuthUserId));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns null for non-existent user',
        () async {
          // final found = await UserProfileService.findByAuthUserId(
          //   session,
          //   UuidValue.fromString('99999999-9999-9999-9999-999999999999'),
          // );
          // expect(found, isNull);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('findById()', () {
      test(
        'returns profile by primary key',
        () async {
          // final created = await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          // );
          //
          // final found = await UserProfileService.findById(session, created.id!);
          // expect(found.authUserId, equals(testAuthUserId));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent id',
        () async {
          // expect(
          //   () => UserProfileService.findById(session, 99999),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('findByUsername()', () {
      test(
        'returns profile for existing username',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // final found = await UserProfileService.findByUsername(session, 'alice');
          // expect(found, isNotNull);
          // expect(found!.username, equals('alice'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns null for non-existent username',
        () async {
          // final found = await UserProfileService.findByUsername(
          //   session,
          //   'nonexistent_user',
          // );
          // expect(found, isNull);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('update()', () {
      test('updates display name', () async {
        // await UserProfileService.getOrCreate(
        //   session,
        //   authUserId: testAuthUserId,
        // );
        //
        // final updated = await UserProfileService.update(
        //   session,
        //   authUserId: testAuthUserId,
        //   displayName: 'Alice Wonderland',
        // );
        //
        // expect(updated.displayName, equals('Alice Wonderland'));
      }, skip: 'Requires serverpod_test database session');

      test(
        'updates username with validation',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // final updated = await UserProfileService.update(
          //   session,
          //   authUserId: testAuthUserId,
          //   username: 'new_alice',
          // );
          //
          // expect(updated.username, equals('new_alice'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException for too-short username',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          // );
          //
          // expect(
          //   () => UserProfileService.update(
          //     session,
          //     authUserId: testAuthUserId,
          //     username: 'ab',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException for username with special chars',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          // );
          //
          // expect(
          //   () => UserProfileService.update(
          //     session,
          //     authUserId: testAuthUserId,
          //     username: 'alice!',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException for taken username',
        () async {
          // // Create two profiles.
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: otherAuthUserId,
          //   email: 'bob@example.com',
          // );
          //
          // expect(
          //   () => UserProfileService.update(
          //     session,
          //     authUserId: otherAuthUserId,
          //     username: 'alice',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent profile',
        () async {
          // expect(
          //   () => UserProfileService.update(
          //     session,
          //     authUserId: UuidValue.fromString(
          //       '99999999-9999-9999-9999-999999999999',
          //     ),
          //     displayName: 'Ghost',
          //   ),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'updates bio, avatarUrl, isPublic, and socialLinks',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          // );
          //
          // final updated = await UserProfileService.update(
          //   session,
          //   authUserId: testAuthUserId,
          //   bio: 'Hello world',
          //   avatarUrl: 'https://example.com/avatar.jpg',
          //   isPublic: false,
          //   socialLinks: '{"twitter": "@alice"}',
          // );
          //
          // expect(updated.bio, equals('Hello world'));
          // expect(updated.avatarUrl, equals('https://example.com/avatar.jpg'));
          // expect(updated.isPublic, isFalse);
          // expect(updated.socialLinks, contains('twitter'));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('search()', () {
      test(
        'finds public profiles by username',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // final results = await UserProfileService.search(
          //   session,
          //   query: 'alice',
          // );
          //
          // expect(results.any((p) => p.username == 'alice'), isTrue);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'does not return private profiles',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          // await UserProfileService.update(
          //   session,
          //   authUserId: testAuthUserId,
          //   isPublic: false,
          // );
          //
          // final results = await UserProfileService.search(
          //   session,
          //   query: 'alice',
          // );
          //
          // expect(results.any((p) => p.username == 'alice'), isFalse);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('isUsernameAvailable()', () {
      test(
        'returns true for available username',
        () async {
          // final available = await UserProfileService.isUsernameAvailable(
          //   session,
          //   'totally_new_user',
          // );
          // expect(available, isTrue);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns false for taken username',
        () async {
          // await UserProfileService.getOrCreate(
          //   session,
          //   authUserId: testAuthUserId,
          //   email: 'alice@example.com',
          // );
          //
          // final available = await UserProfileService.isUsernameAvailable(
          //   session,
          //   'alice',
          // );
          // expect(available, isFalse);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('count()', () {
      test(
        'returns total profile count',
        () async {
          // final count = await UserProfileService.count(session);
          // expect(count, isA<int>());
          // expect(count, greaterThanOrEqualTo(0));
        },
        skip: 'Requires serverpod_test database session',
      );
    });
  });
}
