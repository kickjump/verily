// TODO: These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`

import 'package:test/test.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/action_service.dart';
// import 'package:verily_server/src/services/submission_service.dart';
// import 'package:verily_server/src/services/verification_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  group('VerificationService', () {
    // late Session session;
    // late ActionSubmission testSubmission;

    // setUp(() async {
    //   session = await createTestSession();
    //
    //   final action = await ActionService.create(
    //     session,
    //     title: 'Verify Test Action',
    //     description: 'desc',
    //     creatorId: testCreatorId,
    //     actionType: ActionType.oneOff.value,
    //     verificationCriteria: 'criteria',
    //   );
    //
    //   testSubmission = await SubmissionService.create(
    //     session,
    //     actionId: action.id!,
    //     performerId: performerId,
    //     videoUrl: 'https://storage.example.com/video.mp4',
    //   );
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    // -------------------------------------------------------------------------
    // Constants
    // -------------------------------------------------------------------------

    group('constants', () {
      test(
        'passingConfidenceThreshold is 0.7',
        () {
          // This can be tested without a database since it's a static constant.
          // expect(VerificationService.passingConfidenceThreshold, equals(0.7));
        },
        skip: 'Requires import of VerificationService',
      );
    });

    // -------------------------------------------------------------------------
    // create()
    // -------------------------------------------------------------------------

    group('create()', () {
      test(
        'creates a passing verification result',
        () async {
          // final result = await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: true,
          //   confidenceScore: 0.95,
          //   analysisText: 'Clear video showing all 10 press-ups with good form.',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(result.id, isNotNull);
          // expect(result.submissionId, equals(testSubmission.id));
          // expect(result.passed, isTrue);
          // expect(result.confidenceScore, equals(0.95));
          // expect(result.analysisText, contains('press-ups'));
          // expect(result.spoofingDetected, isFalse);
          // expect(result.modelUsed, equals('gemini-2.0-flash'));
          // expect(result.createdAt, isNotNull);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates a failing verification result',
        () async {
          // final result = await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: false,
          //   confidenceScore: 0.3,
          //   analysisText: 'Could not verify the required action.',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(result.passed, isFalse);
          // expect(result.confidenceScore, equals(0.3));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'updates submission status to passed when result passes',
        () async {
          // await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: true,
          //   confidenceScore: 0.9,
          //   analysisText: 'Verified',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // final updatedSubmission = await SubmissionService.findById(
          //   session,
          //   testSubmission.id!,
          // );
          // expect(
          //   updatedSubmission.status,
          //   equals(VerificationStatus.passed.value),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'updates submission status to failed when result fails',
        () async {
          // await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: false,
          //   confidenceScore: 0.2,
          //   analysisText: 'Not verified',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // final updatedSubmission = await SubmissionService.findById(
          //   session,
          //   testSubmission.id!,
          // );
          // expect(
          //   updatedSubmission.status,
          //   equals(VerificationStatus.failed.value),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent submission',
        () async {
          // expect(
          //   () => VerificationService.create(
          //     session,
          //     submissionId: 99999,
          //     passed: true,
          //     confidenceScore: 0.9,
          //     analysisText: 'text',
          //     spoofingDetected: false,
          //     modelUsed: 'gemini-2.0-flash',
          //   ),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException when result already exists for submission',
        () async {
          // await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: true,
          //   confidenceScore: 0.9,
          //   analysisText: 'First result',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(
          //   () => VerificationService.create(
          //     session,
          //     submissionId: testSubmission.id!,
          //     passed: false,
          //     confidenceScore: 0.5,
          //     analysisText: 'Duplicate result',
          //     spoofingDetected: false,
          //     modelUsed: 'gemini-2.0-flash',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'stores structuredResult when provided',
        () async {
          // final result = await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: true,
          //   confidenceScore: 0.9,
          //   analysisText: 'text',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          //   structuredResult: '{"passed": true, "details": "full analysis"}',
          // );
          //
          // expect(result.structuredResult, contains('"passed": true'));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // createFromGeminiResponse()
    // -------------------------------------------------------------------------

    group('createFromGeminiResponse()', () {
      test(
        'passes when confidence >= 0.7 and no spoofing',
        () async {
          // final result = await VerificationService.createFromGeminiResponse(
          //   session,
          //   submissionId: testSubmission.id!,
          //   analysisText: 'Good video',
          //   confidenceScore: 0.8,
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(result.passed, isTrue);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'fails when confidence < 0.7',
        () async {
          // final result = await VerificationService.createFromGeminiResponse(
          //   session,
          //   submissionId: testSubmission.id!,
          //   analysisText: 'Low confidence',
          //   confidenceScore: 0.5,
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(result.passed, isFalse);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'fails when spoofing detected even with high confidence',
        () async {
          // final result = await VerificationService.createFromGeminiResponse(
          //   session,
          //   submissionId: testSubmission.id!,
          //   analysisText: 'Spoofing found',
          //   confidenceScore: 0.95,
          //   spoofingDetected: true,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(result.passed, isFalse);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'passes at exactly 0.7 threshold with no spoofing',
        () async {
          // final result = await VerificationService.createFromGeminiResponse(
          //   session,
          //   submissionId: testSubmission.id!,
          //   analysisText: 'Borderline pass',
          //   confidenceScore: 0.7,
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(result.passed, isTrue);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'fails at 0.699 confidence',
        () async {
          // final result = await VerificationService.createFromGeminiResponse(
          //   session,
          //   submissionId: testSubmission.id!,
          //   analysisText: 'Just below threshold',
          //   confidenceScore: 0.699,
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // expect(result.passed, isFalse);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findById() and findBySubmissionId()
    // -------------------------------------------------------------------------

    group('findById()', () {
      test(
        'returns result by primary key',
        () async {
          // final created = await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: true,
          //   confidenceScore: 0.9,
          //   analysisText: 'text',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // final found = await VerificationService.findById(
          //   session,
          //   created.id!,
          // );
          // expect(found.id, equals(created.id));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent id',
        () async {
          // expect(
          //   () => VerificationService.findById(session, 99999),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('findBySubmissionId()', () {
      test(
        'returns result for submission',
        () async {
          // await VerificationService.create(
          //   session,
          //   submissionId: testSubmission.id!,
          //   passed: true,
          //   confidenceScore: 0.9,
          //   analysisText: 'text',
          //   spoofingDetected: false,
          //   modelUsed: 'gemini-2.0-flash',
          // );
          //
          // final found = await VerificationService.findBySubmissionId(
          //   session,
          //   testSubmission.id!,
          // );
          // expect(found, isNotNull);
          // expect(found!.submissionId, equals(testSubmission.id));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns null when no result exists',
        () async {
          // final result = await VerificationService.findBySubmissionId(
          //   session,
          //   testSubmission.id!,
          // );
          // expect(result, isNull);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findSpoofingDetected() and findLowConfidence()
    // -------------------------------------------------------------------------

    group('findSpoofingDetected()', () {
      test(
        'returns results with spoofing detected',
        () async {
          // final results = await VerificationService.findSpoofingDetected(session);
          // for (final r in results) {
          //   expect(r.spoofingDetected, isTrue);
          // }
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    group('findLowConfidence()', () {
      test(
        'returns results below threshold',
        () async {
          // final results = await VerificationService.findLowConfidence(
          //   session,
          //   threshold: 0.5,
          // );
          // for (final r in results) {
          //   expect(r.confidenceScore, lessThan(0.5));
          // }
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // getStats()
    // -------------------------------------------------------------------------

    group('getStats()', () {
      test(
        'returns correct aggregate statistics',
        () async {
          // final stats = await VerificationService.getStats(session);
          //
          // expect(stats.totalCount, isA<int>());
          // expect(stats.passedCount, isA<int>());
          // expect(stats.failedCount, isA<int>());
          // expect(stats.spoofingDetectedCount, isA<int>());
          // expect(stats.totalCount, equals(stats.passedCount + stats.failedCount));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'passRate is 0 when no results exist',
        () async {
          // final stats = await VerificationService.getStats(session);
          // if (stats.totalCount == 0) {
          //   expect(stats.passRate, equals(0.0));
          // }
        },
        skip: 'Requires serverpod_test database session',
      );
    });
  });

  // ---------------------------------------------------------------------------
  // VerificationStats (pure Dart - no DB needed)
  // ---------------------------------------------------------------------------

  // group('VerificationStats', () {
  //   test('passRate calculation with results', () {
  //     final stats = VerificationStats(
  //       totalCount: 10,
  //       passedCount: 7,
  //       failedCount: 3,
  //       spoofingDetectedCount: 1,
  //     );
  //
  //     expect(stats.passRate, closeTo(0.7, 0.001));
  //   });
  //
  //   test('passRate is 0 when totalCount is 0', () {
  //     final stats = VerificationStats(
  //       totalCount: 0,
  //       passedCount: 0,
  //       failedCount: 0,
  //       spoofingDetectedCount: 0,
  //     );
  //
  //     expect(stats.passRate, equals(0.0));
  //   });
  //
  //   test('passRate is 1.0 when all pass', () {
  //     final stats = VerificationStats(
  //       totalCount: 5,
  //       passedCount: 5,
  //       failedCount: 0,
  //       spoofingDetectedCount: 0,
  //     );
  //
  //     expect(stats.passRate, equals(1.0));
  //   });
  // });
}
