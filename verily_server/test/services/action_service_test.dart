// TODO(ifiokjr): These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`
//
// Until the test infrastructure is in place, these tests document the expected
// behavior of ActionService and serve as a specification for integration tests.

import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/action_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  group('ActionService', () {
    // late Session session;

    // setUp(() async {
    //   // Obtain a test session from serverpod_test.
    //   // session = await createTestSession();
    // });

    // tearDown(() async {
    //   // Clean up test data.
    //   // await session.close();
    // });

    // -------------------------------------------------------------------------
    // create()
    // -------------------------------------------------------------------------

    group('create()', () {
      test(
        'creates a one-off action with required fields',
        () async {
          // final action = await ActionService.create(
          //   session,
          //   title: 'Test Action',
          //   description: 'A test action description',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'Must show the activity on video',
          // );
          //
          // expect(action.id, isNotNull);
          // expect(action.title, equals('Test Action'));
          // expect(action.description, equals('A test action description'));
          // expect(action.creatorId, equals(testCreatorId));
          // expect(action.actionType, equals('one_off'));
          // expect(action.status, equals('active'));
          // expect(action.verificationCriteria, equals('Must show the activity on video'));
          // expect(action.createdAt, isNotNull);
          // expect(action.updatedAt, isNotNull);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates a sequential action with totalSteps',
        () async {
          // final action = await ActionService.create(
          //   session,
          //   title: 'Sequential Challenge',
          //   description: 'A multi-step challenge',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.sequential.value,
          //   verificationCriteria: 'Complete each step',
          //   totalSteps: 5,
          //   intervalDays: 1,
          // );
          //
          // expect(action.id, isNotNull);
          // expect(action.actionType, equals('sequential'));
          // expect(action.totalSteps, equals(5));
          // expect(action.intervalDays, equals(1));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException for sequential action without totalSteps',
        () async {
          // expect(
          //   () => ActionService.create(
          //     session,
          //     title: 'Bad Sequential',
          //     description: 'Missing totalSteps',
          //     creatorId: testCreatorId,
          //     actionType: ActionType.sequential.value,
          //     verificationCriteria: 'Complete each step',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException for sequential action with totalSteps = 0',
        () async {
          // expect(
          //   () => ActionService.create(
          //     session,
          //     title: 'Bad Sequential',
          //     description: 'Zero totalSteps',
          //     creatorId: testCreatorId,
          //     actionType: ActionType.sequential.value,
          //     verificationCriteria: 'Complete each step',
          //     totalSteps: 0,
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ArgumentError for invalid action type',
        () async {
          // expect(
          //   () => ActionService.create(
          //     session,
          //     title: 'Invalid Type',
          //     description: 'Bad type',
          //     creatorId: testCreatorId,
          //     actionType: 'invalid_type',
          //     verificationCriteria: 'criteria',
          //   ),
          //   throwsA(isA<ArgumentError>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates action with optional fields',
        () async {
          // final action = await ActionService.create(
          //   session,
          //   title: 'Full Action',
          //   description: 'With all fields',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          //   maxPerformers: 10,
          //   locationId: 1,
          //   categoryId: 1,
          //   referenceImages: 'https://example.com/ref.jpg',
          // );
          //
          // expect(action.maxPerformers, equals(10));
          // expect(action.locationId, equals(1));
          // expect(action.categoryId, equals(1));
          // expect(action.referenceImages, equals('https://example.com/ref.jpg'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'sets createdAt and updatedAt to current UTC time',
        () async {
          // final before = DateTime.now().toUtc();
          // final action = await ActionService.create(
          //   session,
          //   title: 'Timestamp Test',
          //   description: 'Check timestamps',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          // final after = DateTime.now().toUtc();
          //
          // expect(action.createdAt.isAfter(before) || action.createdAt.isAtSameMomentAs(before), isTrue);
          // expect(action.createdAt.isBefore(after) || action.createdAt.isAtSameMomentAs(after), isTrue);
          // expect(action.createdAt, equals(action.updatedAt));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findById()
    // -------------------------------------------------------------------------

    group('findById()', () {
      test(
        'returns an existing action',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Find Me',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // final found = await ActionService.findById(session, created.id!);
          // expect(found.id, equals(created.id));
          // expect(found.title, equals('Find Me'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent id',
        () async {
          // expect(
          //   () => ActionService.findById(session, 99999),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // list()
    // -------------------------------------------------------------------------

    group('list()', () {
      test(
        'returns actions with default pagination',
        () async {
          // await ActionService.create(
          //   session,
          //   title: 'Action 1',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          // await ActionService.create(
          //   session,
          //   title: 'Action 2',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // final results = await ActionService.list(session);
          // expect(results.length, greaterThanOrEqualTo(2));
        },
        skip: 'Requires serverpod_test database session',
      );

      test('filters by status', () async {
        // final results = await ActionService.list(session, status: 'active');
        // for (final action in results) {
        //   expect(action.status, equals('active'));
        // }
      }, skip: 'Requires serverpod_test database session');

      test('filters by categoryId', () async {
        // final results = await ActionService.list(session, categoryId: 1);
        // for (final action in results) {
        //   expect(action.categoryId, equals(1));
        // }
      }, skip: 'Requires serverpod_test database session');

      test('filters by creatorId', () async {
        // final results = await ActionService.list(
        //   session,
        //   creatorId: testCreatorId,
        // );
        // for (final action in results) {
        //   expect(action.creatorId, equals(testCreatorId));
        // }
      }, skip: 'Requires serverpod_test database session');

      test(
        'respects limit and offset',
        () async {
          // final page1 = await ActionService.list(session, limit: 1, offset: 0);
          // final page2 = await ActionService.list(session, limit: 1, offset: 1);
          //
          // expect(page1.length, lessThanOrEqualTo(1));
          // expect(page2.length, lessThanOrEqualTo(1));
          // if (page1.isNotEmpty && page2.isNotEmpty) {
          //   expect(page1.first.id, isNot(equals(page2.first.id)));
          // }
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns results ordered by createdAt descending',
        () async {
          // final results = await ActionService.list(session, limit: 10);
          // for (var i = 1; i < results.length; i++) {
          //   expect(
          //     results[i - 1].createdAt.isAfter(results[i].createdAt) ||
          //         results[i - 1].createdAt.isAtSameMomentAs(results[i].createdAt),
          //     isTrue,
          //   );
          // }
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // search()
    // -------------------------------------------------------------------------

    group('search()', () {
      test(
        'finds actions by title substring',
        () async {
          // await ActionService.create(
          //   session,
          //   title: 'Unique Pushup Challenge',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // final results = await ActionService.search(session, query: 'pushup');
          // expect(results.any((a) => a.title.contains('Pushup')), isTrue);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'finds actions by description substring',
        () async {
          // await ActionService.create(
          //   session,
          //   title: 'Something',
          //   description: 'Contains a unique_keyword here',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // final results = await ActionService.search(
          //   session,
          //   query: 'unique_keyword',
          // );
          // expect(results, isNotEmpty);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'search is case-insensitive',
        () async {
          // final results = await ActionService.search(session, query: 'PUSHUP');
          // Expect same results as lowercase query
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns empty list for no matches',
        () async {
          // final results = await ActionService.search(
          //   session,
          //   query: 'zzz_no_match_zzz',
          // );
          // expect(results, isEmpty);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // update()
    // -------------------------------------------------------------------------

    group('update()', () {
      test(
        'updates title when called by owner',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Original Title',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // final updated = await ActionService.update(
          //   session,
          //   id: created.id!,
          //   callerId: testCreatorId,
          //   title: 'Updated Title',
          // );
          //
          // expect(updated.title, equals('Updated Title'));
          // expect(updated.description, equals('desc')); // unchanged
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'updates multiple fields simultaneously',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Multi Update',
          //   description: 'original desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'original',
          // );
          //
          // final updated = await ActionService.update(
          //   session,
          //   id: created.id!,
          //   callerId: testCreatorId,
          //   title: 'New Title',
          //   description: 'New Description',
          //   verificationCriteria: 'New Criteria',
          // );
          //
          // expect(updated.title, equals('New Title'));
          // expect(updated.description, equals('New Description'));
          // expect(updated.verificationCriteria, equals('New Criteria'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ForbiddenException when non-owner tries to update',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Owner Only',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // expect(
          //   () => ActionService.update(
          //     session,
          //     id: created.id!,
          //     callerId: otherUserId,
          //     title: 'Hacked',
          //   ),
          //   throwsA(isA<ForbiddenException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent action',
        () async {
          // expect(
          //   () => ActionService.update(
          //     session,
          //     id: 99999,
          //     callerId: testCreatorId,
          //     title: 'Doesnt Exist',
          //   ),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'updates updatedAt timestamp',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Timestamp Update',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // await Future.delayed(Duration(milliseconds: 10));
          //
          // final updated = await ActionService.update(
          //   session,
          //   id: created.id!,
          //   callerId: testCreatorId,
          //   title: 'Timestamp Check',
          // );
          //
          // expect(updated.updatedAt.isAfter(created.updatedAt), isTrue);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // archive()
    // -------------------------------------------------------------------------

    group('archive()', () {
      test(
        'sets status to archived',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Archive Me',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // final archived = await ActionService.archive(
          //   session,
          //   id: created.id!,
          //   callerId: testCreatorId,
          // );
          //
          // expect(archived.status, equals('archived'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ForbiddenException when non-owner tries to archive',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'No Archive',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // expect(
          //   () => ActionService.archive(
          //     session,
          //     id: created.id!,
          //     callerId: otherUserId,
          //   ),
          //   throwsA(isA<ForbiddenException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // delete()
    // -------------------------------------------------------------------------

    group('delete()', () {
      test(
        'deletes an action by owner',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Delete Me',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // await ActionService.delete(
          //   session,
          //   id: created.id!,
          //   callerId: testCreatorId,
          // );
          //
          // expect(
          //   () => ActionService.findById(session, created.id!),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ForbiddenException when non-owner tries to delete',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Cant Delete',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // expect(
          //   () => ActionService.delete(
          //     session,
          //     id: created.id!,
          //     callerId: otherUserId,
          //   ),
          //   throwsA(isA<ForbiddenException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // countActive()
    // -------------------------------------------------------------------------

    group('countActive()', () {
      test(
        'returns count of active actions',
        () async {
          // final count = await ActionService.countActive(session);
          // expect(count, isA<int>());
          // expect(count, greaterThanOrEqualTo(0));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'does not count archived actions',
        () async {
          // final created = await ActionService.create(
          //   session,
          //   title: 'Will Archive',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          // final countBefore = await ActionService.countActive(session);
          //
          // await ActionService.archive(
          //   session,
          //   id: created.id!,
          //   callerId: testCreatorId,
          // );
          // final countAfter = await ActionService.countActive(session);
          //
          // expect(countAfter, equals(countBefore - 1));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findByCreator()
    // -------------------------------------------------------------------------

    group('findByCreator()', () {
      test(
        'returns only actions by the specified creator',
        () async {
          // await ActionService.create(
          //   session,
          //   title: 'By Creator',
          //   description: 'desc',
          //   creatorId: testCreatorId,
          //   actionType: ActionType.oneOff.value,
          //   verificationCriteria: 'criteria',
          // );
          //
          // final results = await ActionService.findByCreator(
          //   session,
          //   creatorId: testCreatorId,
          // );
          //
          // for (final action in results) {
          //   expect(action.creatorId, equals(testCreatorId));
          // }
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'respects limit and offset parameters',
        () async {
          // final page1 = await ActionService.findByCreator(
          //   session,
          //   creatorId: testCreatorId,
          //   limit: 1,
          //   offset: 0,
          // );
          // expect(page1.length, lessThanOrEqualTo(1));
        },
        skip: 'Requires serverpod_test database session',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Synchronous validation tests (can run without database)
  // ---------------------------------------------------------------------------

  group('ActionType validation (no DB needed)', () {
    test('ActionType.fromValue parses "one_off"', () {
      expect(ActionType.fromValue('one_off'), equals(ActionType.oneOff));
    });

    test('ActionType.fromValue parses "sequential"', () {
      expect(ActionType.fromValue('sequential'), equals(ActionType.sequential));
    });

    test('ActionType.fromValue throws for unknown value', () {
      expect(
        () => ActionType.fromValue('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('ActionType enum has correct values', () {
      expect(ActionType.oneOff.value, equals('one_off'));
      expect(ActionType.sequential.value, equals('sequential'));
    });

    test('ActionType enum has correct display names', () {
      expect(ActionType.oneOff.displayName, equals('One-Off'));
      expect(ActionType.sequential.displayName, equals('Sequential'));
    });
  });
}
