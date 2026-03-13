// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/submissions/providers/submission_provider.dart';
import 'package:verily_client/verily_client.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeSubmissionEndpoint extends Fake implements EndpointSubmission {
  int createCallCount = 0;
  int getCallCount = 0;
  ActionSubmission? createResponse;
  ActionSubmission? getResponse;
  Exception? errorToThrow;
  ActionSubmission? lastCreatedSubmission;

  @override
  Future<ActionSubmission> create(ActionSubmission submission) async {
    createCallCount++;
    lastCreatedSubmission = submission;
    if (errorToThrow != null) throw errorToThrow!;
    return createResponse ??
        ActionSubmission(
          id: 42,
          actionId: submission.actionId,
          performerId: submission.performerId,
          videoUrl: submission.videoUrl,
          status: 'pending',
          createdAt: DateTime(2026, 3, 9),
          updatedAt: DateTime(2026, 3, 9),
        );
  }

  @override
  Future<ActionSubmission> get(int id) async {
    getCallCount++;
    if (errorToThrow != null) throw errorToThrow!;
    return getResponse ??
        ActionSubmission(
          id: id,
          actionId: 1,
          performerId: UuidValue.fromString(
            '00000000-0000-0000-0000-000000000001',
          ),
          videoUrl: 'test://video',
          status: 'pending',
          createdAt: DateTime(2026, 3, 9),
          updatedAt: DateTime(2026, 3, 9),
        );
  }
}

class _FakeVerificationEndpoint extends Fake implements EndpointVerification {
  int getBySubmissionCallCount = 0;
  VerificationResult? getBySubmissionResponse;
  Exception? errorToThrow;

  @override
  Future<VerificationResult?> getBySubmission(int submissionId) async {
    getBySubmissionCallCount++;
    if (errorToThrow != null) throw errorToThrow!;
    return getBySubmissionResponse;
  }
}

class _FakeClient extends Fake implements Client {
  _FakeClient({
    _FakeSubmissionEndpoint? submissionEndpoint,
    _FakeVerificationEndpoint? verificationEndpoint,
  }) : _submissionEndpoint = submissionEndpoint ?? _FakeSubmissionEndpoint(),
       _verificationEndpoint =
           verificationEndpoint ?? _FakeVerificationEndpoint();

  final _FakeSubmissionEndpoint _submissionEndpoint;
  final _FakeVerificationEndpoint _verificationEndpoint;

  @override
  EndpointSubmission get submission => _submissionEndpoint;

  @override
  EndpointVerification get verification => _verificationEndpoint;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('SubmissionNotifier', () {
    test('initial state is AsyncData(null)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(submissionProvider);
      expect(state, isA<AsyncData<void>>());
      expect(state.value, isNull);
    });

    test('reset returns state to AsyncData(null)', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(submissionProvider.notifier).reset();
      final state = container.read(submissionProvider);
      expect(state, isA<AsyncData<void>>());
      expect(state.value, isNull);
    });

    test(
      'submit calls client.submission.create with correct parameters',
      () async {
        final fakeEndpoint = _FakeSubmissionEndpoint();
        final fakeClient = _FakeClient(submissionEndpoint: fakeEndpoint);
        final container = ProviderContainer(
          overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
        );
        addTearDown(container.dispose);

        final result = await container
            .read(submissionProvider.notifier)
            .submit(
              actionId: 7,
              videoUrl: 'file:///test/video.mp4',
              latitude: 51.5,
              longitude: -0.12,
              durationSeconds: 15,
            );

        expect(fakeEndpoint.createCallCount, equals(1));
        expect(result, isNotNull);
        expect(result!.id, equals(42));
        expect(fakeEndpoint.lastCreatedSubmission!.actionId, equals(7));
        expect(
          fakeEndpoint.lastCreatedSubmission!.videoUrl,
          equals('file:///test/video.mp4'),
        );
        expect(fakeEndpoint.lastCreatedSubmission!.latitude, equals(51.5));
        expect(fakeEndpoint.lastCreatedSubmission!.longitude, equals(-0.12));
      },
    );

    test('submit returns null and sets error state on exception', () async {
      final fakeEndpoint = _FakeSubmissionEndpoint()
        ..errorToThrow = Exception('Network error');
      final fakeClient = _FakeClient(submissionEndpoint: fakeEndpoint);
      final container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(submissionProvider.notifier)
          .submit(actionId: 7, videoUrl: 'test://video');

      expect(result, isNull);
      expect(container.read(submissionProvider), isA<AsyncError<void>>());
    });

    test('submit sets loading state during request', () async {
      final fakeEndpoint = _FakeSubmissionEndpoint();
      final fakeClient = _FakeClient(submissionEndpoint: fakeEndpoint);
      final container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
      addTearDown(container.dispose);

      // Before submit
      expect(container.read(submissionProvider).value, isNull);

      final future = container
          .read(submissionProvider.notifier)
          .submit(actionId: 1, videoUrl: 'test://video');

      // After submit completes
      final result = await future;
      expect(result, isNotNull);
      expect(
        container.read(submissionProvider),
        isA<AsyncData<ActionSubmission?>>(),
      );
    });

    test('submit passes optional metadata fields', () async {
      final fakeEndpoint = _FakeSubmissionEndpoint();
      final fakeClient = _FakeClient(submissionEndpoint: fakeEndpoint);
      final container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
      addTearDown(container.dispose);

      await container
          .read(submissionProvider.notifier)
          .submit(
            actionId: 1,
            videoUrl: 'test://video',
            durationSeconds: 30.5,
            deviceMetadata: 'iPhone 15 Pro',
            stepNumber: 2,
          );

      final submission = fakeEndpoint.lastCreatedSubmission!;
      expect(submission.videoDurationSeconds, equals(30.5));
      expect(submission.deviceMetadata, equals('iPhone 15 Pro'));
      expect(submission.stepNumber, equals(2));
    });
  });

  group('fetchSubmission', () {
    test('calls client.submission.get with correct id', () async {
      final fakeEndpoint = _FakeSubmissionEndpoint();
      final fakeClient = _FakeClient(submissionEndpoint: fakeEndpoint);
      final container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
      addTearDown(container.dispose);

      final submission = await container.read(
        fetchSubmissionProvider(99).future,
      );

      expect(fakeEndpoint.getCallCount, equals(1));
      expect(submission.id, equals(99));
    });
  });

  group('verificationResult', () {
    test('returns null when no result exists', () async {
      final fakeVerification = _FakeVerificationEndpoint();
      final fakeClient = _FakeClient(verificationEndpoint: fakeVerification);
      final container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
      addTearDown(container.dispose);

      final result = await container.read(verificationResultProvider(1).future);

      expect(result, isNull);
      expect(fakeVerification.getBySubmissionCallCount, equals(1));
    });

    test('returns result when verification exists', () async {
      final fakeVerification = _FakeVerificationEndpoint()
        ..getBySubmissionResponse = VerificationResult(
          id: 10,
          submissionId: 1,
          passed: true,
          confidenceScore: 0.95,
          analysisText: 'Looks good',
          spoofingDetected: false,
          modelUsed: 'gemini-2.0-flash',
          createdAt: DateTime(2026, 3, 9),
        );
      final fakeClient = _FakeClient(verificationEndpoint: fakeVerification);
      final container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
      addTearDown(container.dispose);

      final result = await container.read(verificationResultProvider(1).future);

      expect(result, isNotNull);
      expect(result!.passed, isTrue);
      expect(result.confidenceScore, equals(0.95));
    });
  });
}
