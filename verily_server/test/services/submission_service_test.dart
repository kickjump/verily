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
// import 'package:verily_server/src/services/action_step_service.dart';
// import 'package:verily_server/src/services/submission_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Shared test data
  // ---------------------------------------------------------------------------

  final testCreatorId =
      UuidValue.fromString('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee');
  final performerId =
      UuidValue.fromString('11111111-2222-3333-4444-555555555555');
  const testVideoUrl = 'https://storage.example.com/video.mp4';

  group('SubmissionService', () {
    // late Session session;
    // late Action oneOffAction;
    // late Action sequentialAction;

    // setUp(() async {
    //   session = await createTestSession();
    //
    //   oneOffAction = await ActionService.create(
    //     session,
    //     title: 'Test One-Off',
    //     description: 'Test description',
    //     creatorId: testCreatorId,
    //     actionType: ActionType.oneOff.value,
    //     verificationCriteria: 'Show the action on video',
    //   );
    //
    //   sequentialAction = await ActionService.create(
    //     session,
    //     title: 'Test Sequential',
    //     description: 'Test sequential description',
    //     creatorId: testCreatorId,
    //     actionType: ActionType.sequential.value,
    //     verificationCriteria: 'Complete each step',
    //     totalSteps: 3,
    //   );
    //
    //   // Create steps for the sequential action.
    //   for (var i = 1; i <= 3; i++) {
    //     await ActionStepService.create(
    //       session,
    //       actionId: sequentialAction.id!,
    //       stepNumber: i,
    //       title: 'Step $i',
    //       verificationCriteria: 'Complete step $i',
    //     );
    //   }
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    // -------------------------------------------------------------------------
    // create()
    // -------------------------------------------------------------------------

    group('create()', () {
      test('creates a submission for a one-off action', () async {
        // final submission = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // expect(submission.id, isNotNull);
        // expect(submission.actionId, equals(oneOffAction.id));
        // expect(submission.performerId, equals(performerId));
        // expect(submission.videoUrl, equals(testVideoUrl));
        // expect(submission.status, equals(VerificationStatus.pending.value));
        // expect(submission.createdAt, isNotNull);
        // expect(submission.updatedAt, isNotNull);
      }, skip: 'Requires serverpod_test database session');

      test('creates a submission with optional metadata', () async {
        // final submission = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        //   videoDurationSeconds: 30.5,
        //   deviceMetadata: '{"platform": "ios", "version": "17.0"}',
        //   latitude: 51.5074,
        //   longitude: -0.1278,
        // );
        //
        // expect(submission.videoDurationSeconds, equals(30.5));
        // expect(submission.deviceMetadata, contains('ios'));
        // expect(submission.latitude, closeTo(51.5074, 0.001));
        // expect(submission.longitude, closeTo(-0.1278, 0.001));
      }, skip: 'Requires serverpod_test database session');

      test('throws NotFoundException for non-existent action', () async {
        // expect(
        //   () => SubmissionService.create(
        //     session,
        //     actionId: 99999,
        //     performerId: performerId,
        //     videoUrl: testVideoUrl,
        //   ),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');

      test('throws ValidationException for inactive action', () async {
        // // Archive the action first.
        // await ActionService.archive(
        //   session,
        //   id: oneOffAction.id!,
        //   callerId: testCreatorId,
        // );
        //
        // expect(
        //   () => SubmissionService.create(
        //     session,
        //     actionId: oneOffAction.id!,
        //     performerId: performerId,
        //     videoUrl: testVideoUrl,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');

      test(
        'throws ValidationException when stepNumber missing for sequential',
        () async {
          // expect(
          //   () => SubmissionService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     performerId: performerId,
          //     videoUrl: testVideoUrl,
          //     // stepNumber intentionally omitted
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test('creates submission for step 1 of sequential action', () async {
        // final submission = await SubmissionService.create(
        //   session,
        //   actionId: sequentialAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        //   stepNumber: 1,
        // );
        //
        // expect(submission.stepNumber, equals(1));
        // expect(submission.status, equals(VerificationStatus.pending.value));
      }, skip: 'Requires serverpod_test database session');

      test(
        'throws NotFoundException for non-existent step number',
        () async {
          // expect(
          //   () => SubmissionService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     performerId: performerId,
          //     videoUrl: testVideoUrl,
          //     stepNumber: 99, // does not exist
          //   ),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException when prior steps are not completed',
        () async {
          // Trying to submit step 2 without completing step 1.
          // expect(
          //   () => SubmissionService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     performerId: performerId,
          //     videoUrl: testVideoUrl,
          //     stepNumber: 2,
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'allows step 2 after step 1 is passed',
        () async {
          // // Submit and pass step 1.
          // final step1 = await SubmissionService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   performerId: performerId,
          //   videoUrl: testVideoUrl,
          //   stepNumber: 1,
          // );
          // await SubmissionService.markPassed(session, id: step1.id!);
          //
          // // Now step 2 should be allowed.
          // final step2 = await SubmissionService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   performerId: performerId,
          //   videoUrl: testVideoUrl,
          //   stepNumber: 2,
          // );
          // expect(step2.stepNumber, equals(2));
        },
        skip: 'Requires serverpod_test database session',
      );

      test('throws ValidationException when max performers reached', () async {
        // Create action with maxPerformers=1.
        // final limitedAction = await ActionService.create(
        //   session,
        //   title: 'Limited',
        //   description: 'desc',
        //   creatorId: testCreatorId,
        //   actionType: ActionType.oneOff.value,
        //   verificationCriteria: 'criteria',
        //   maxPerformers: 1,
        // );
        //
        // // First performer submits.
        // await SubmissionService.create(
        //   session,
        //   actionId: limitedAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // // Second performer should be blocked.
        // final secondPerformer = UuidValue.fromString(
        //   '22222222-3333-4444-5555-666666666666',
        // );
        // expect(
        //   () => SubmissionService.create(
        //     session,
        //     actionId: limitedAction.id!,
        //     performerId: secondPerformer,
        //     videoUrl: testVideoUrl,
        //   ),
        //   throwsA(isA<ValidationException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // findById()
    // -------------------------------------------------------------------------

    group('findById()', () {
      test('returns existing submission', () async {
        // final created = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final found = await SubmissionService.findById(session, created.id!);
        // expect(found.id, equals(created.id));
      }, skip: 'Requires serverpod_test database session');

      test('throws NotFoundException for non-existent id', () async {
        // expect(
        //   () => SubmissionService.findById(session, 99999),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // Status transitions
    // -------------------------------------------------------------------------

    group('status transitions', () {
      test('updateStatus changes status to valid value', () async {
        // final created = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final updated = await SubmissionService.updateStatus(
        //   session,
        //   id: created.id!,
        //   status: VerificationStatus.processing.value,
        // );
        //
        // expect(updated.status, equals('processing'));
      }, skip: 'Requires serverpod_test database session');

      test('updateStatus throws for invalid status value', () async {
        // final created = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // expect(
        //   () => SubmissionService.updateStatus(
        //     session,
        //     id: created.id!,
        //     status: 'invalid_status',
        //   ),
        //   throwsA(isA<ArgumentError>()),
        // );
      }, skip: 'Requires serverpod_test database session');

      test('markProcessing sets status to processing', () async {
        // final created = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final updated = await SubmissionService.markProcessing(
        //   session,
        //   id: created.id!,
        // );
        //
        // expect(updated.status, equals(VerificationStatus.processing.value));
      }, skip: 'Requires serverpod_test database session');

      test('markPassed sets status to passed', () async {
        // final created = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final updated = await SubmissionService.markPassed(
        //   session,
        //   id: created.id!,
        // );
        //
        // expect(updated.status, equals(VerificationStatus.passed.value));
      }, skip: 'Requires serverpod_test database session');

      test('markFailed sets status to failed', () async {
        // final created = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final updated = await SubmissionService.markFailed(
        //   session,
        //   id: created.id!,
        // );
        //
        // expect(updated.status, equals(VerificationStatus.failed.value));
      }, skip: 'Requires serverpod_test database session');

      test('markError sets status to error', () async {
        // final created = await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final updated = await SubmissionService.markError(
        //   session,
        //   id: created.id!,
        // );
        //
        // expect(updated.status, equals(VerificationStatus.error.value));
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // findByAction() and findByPerformer()
    // -------------------------------------------------------------------------

    group('findByAction()', () {
      test('returns submissions for a specific action', () async {
        // await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final results = await SubmissionService.findByAction(
        //   session,
        //   actionId: oneOffAction.id!,
        // );
        //
        // expect(results, isNotEmpty);
        // for (final s in results) {
        //   expect(s.actionId, equals(oneOffAction.id));
        // }
      }, skip: 'Requires serverpod_test database session');

      test('filters by status', () async {
        // final results = await SubmissionService.findByAction(
        //   session,
        //   actionId: oneOffAction.id!,
        //   status: VerificationStatus.pending.value,
        // );
        //
        // for (final s in results) {
        //   expect(s.status, equals('pending'));
        // }
      }, skip: 'Requires serverpod_test database session');
    });

    group('findByPerformer()', () {
      test('returns submissions for a specific performer', () async {
        // await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final results = await SubmissionService.findByPerformer(
        //   session,
        //   performerId: performerId,
        // );
        //
        // expect(results, isNotEmpty);
        // for (final s in results) {
        //   expect(s.performerId, equals(performerId));
        // }
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // countPending() and fetchPendingBatch()
    // -------------------------------------------------------------------------

    group('countPending()', () {
      test('returns count of pending submissions', () async {
        // await SubmissionService.create(
        //   session,
        //   actionId: oneOffAction.id!,
        //   performerId: performerId,
        //   videoUrl: testVideoUrl,
        // );
        //
        // final count = await SubmissionService.countPending(session);
        // expect(count, greaterThanOrEqualTo(1));
      }, skip: 'Requires serverpod_test database session');
    });

    group('fetchPendingBatch()', () {
      test('returns batch of pending submissions', () async {
        // final batch = await SubmissionService.fetchPendingBatch(
        //   session,
        //   batchSize: 5,
        // );
        //
        // expect(batch.length, lessThanOrEqualTo(5));
        // for (final s in batch) {
        //   expect(s.status, equals(VerificationStatus.pending.value));
        // }
      }, skip: 'Requires serverpod_test database session');

      test('returns submissions ordered by createdAt ascending', () async {
        // final batch = await SubmissionService.fetchPendingBatch(session);
        //
        // for (var i = 1; i < batch.length; i++) {
        //   expect(
        //     batch[i].createdAt.isAfter(batch[i - 1].createdAt) ||
        //         batch[i].createdAt.isAtSameMomentAs(batch[i - 1].createdAt),
        //     isTrue,
        //   );
        // }
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // hasCompletedAllSteps()
    // -------------------------------------------------------------------------

    group('hasCompletedAllSteps()', () {
      test('returns false when no steps are completed', () async {
        // final result = await SubmissionService.hasCompletedAllSteps(
        //   session,
        //   actionId: sequentialAction.id!,
        //   performerId: performerId,
        // );
        //
        // expect(result, isFalse);
      }, skip: 'Requires serverpod_test database session');

      test('returns false when only some steps are completed', () async {
        // // Complete step 1 and 2 only (action has 3 steps).
        // for (var i = 1; i <= 2; i++) {
        //   final sub = await SubmissionService.create(
        //     session,
        //     actionId: sequentialAction.id!,
        //     performerId: performerId,
        //     videoUrl: testVideoUrl,
        //     stepNumber: i,
        //   );
        //   await SubmissionService.markPassed(session, id: sub.id!);
        // }
        //
        // final result = await SubmissionService.hasCompletedAllSteps(
        //   session,
        //   actionId: sequentialAction.id!,
        //   performerId: performerId,
        // );
        //
        // expect(result, isFalse);
      }, skip: 'Requires serverpod_test database session');

      test('returns true when all steps are completed', () async {
        // for (var i = 1; i <= 3; i++) {
        //   final sub = await SubmissionService.create(
        //     session,
        //     actionId: sequentialAction.id!,
        //     performerId: performerId,
        //     videoUrl: testVideoUrl,
        //     stepNumber: i,
        //   );
        //   await SubmissionService.markPassed(session, id: sub.id!);
        // }
        //
        // final result = await SubmissionService.hasCompletedAllSteps(
        //   session,
        //   actionId: sequentialAction.id!,
        //   performerId: performerId,
        // );
        //
        // expect(result, isTrue);
      }, skip: 'Requires serverpod_test database session');

      test('returns false for non-existent action', () async {
        // final result = await SubmissionService.hasCompletedAllSteps(
        //   session,
        //   actionId: 99999,
        //   performerId: performerId,
        // );
        //
        // expect(result, isFalse);
      }, skip: 'Requires serverpod_test database session');
    });
  });

  // ---------------------------------------------------------------------------
  // Synchronous validation tests (can run without database)
  // ---------------------------------------------------------------------------

  group('VerificationStatus validation (no DB needed)', () {
    test('fromValue parses all valid statuses', () {
      expect(
        VerificationStatus.fromValue('pending'),
        equals(VerificationStatus.pending),
      );
      expect(
        VerificationStatus.fromValue('processing'),
        equals(VerificationStatus.processing),
      );
      expect(
        VerificationStatus.fromValue('passed'),
        equals(VerificationStatus.passed),
      );
      expect(
        VerificationStatus.fromValue('failed'),
        equals(VerificationStatus.failed),
      );
      expect(
        VerificationStatus.fromValue('error'),
        equals(VerificationStatus.error),
      );
    });

    test('fromValue throws for unknown status', () {
      expect(
        () => VerificationStatus.fromValue('unknown'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('VerificationStatus enum has correct values', () {
      expect(VerificationStatus.pending.value, equals('pending'));
      expect(VerificationStatus.processing.value, equals('processing'));
      expect(VerificationStatus.passed.value, equals('passed'));
      expect(VerificationStatus.failed.value, equals('failed'));
      expect(VerificationStatus.error.value, equals('error'));
    });

    test('VerificationStatus enum has correct display names', () {
      expect(VerificationStatus.pending.displayName, equals('Pending'));
      expect(VerificationStatus.processing.displayName, equals('Processing'));
      expect(VerificationStatus.passed.displayName, equals('Passed'));
      expect(VerificationStatus.failed.displayName, equals('Failed'));
      expect(VerificationStatus.error.displayName, equals('Error'));
    });
  });
}
