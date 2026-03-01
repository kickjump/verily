import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/analytics/posthog_analytics.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'submission_provider.g.dart';

/// Fetches a single submission by its database [id].
@riverpod
Future<ActionSubmission> fetchSubmission(Ref ref, int id) async {
  final client = ref.watch(serverpodClientProvider);
  return client.submission.get(id);
}

/// Fetches the verification result for a [submissionId].
///
/// Returns `null` while the verification is still in progress.
@riverpod
Future<VerificationResult?> verificationResult(
  Ref ref,
  int submissionId,
) async {
  final client = ref.watch(serverpodClientProvider);
  return client.verification.getBySubmission(submissionId);
}

/// Polls the verification result for [submissionId] until it resolves.
///
/// The provider auto-refreshes every 3 seconds while the submission status
/// is still `pending` or `processing`.
@riverpod
Stream<VerificationResult?> verificationPoll(Ref ref, int submissionId) async* {
  final client = ref.watch(serverpodClientProvider);

  while (true) {
    try {
      final result = await client.verification.getBySubmission(submissionId);
      yield result;

      // Stop polling once we have a result.
      if (result != null) return;
    } on Exception catch (e) {
      debugPrint('Verification poll error: $e');
      yield null;
    }

    await Future<void>.delayed(const Duration(seconds: 3));
  }
}

/// Manages the submission creation lifecycle.
@riverpod
class SubmissionNotifier extends _$SubmissionNotifier {
  @override
  AsyncValue<ActionSubmission?> build() => const AsyncData(null);

  /// Creates a new submission for the given [actionId].
  ///
  /// [videoUrl] is the URL of the uploaded video.
  /// [durationSeconds], [latitude], [longitude], and [deviceMetadata]
  /// capture recording context.
  Future<ActionSubmission?> submit({
    required int actionId,
    required String videoUrl,
    double? durationSeconds,
    double? latitude,
    double? longitude,
    String? deviceMetadata,
    int? stepNumber,
  }) async {
    state = const AsyncLoading();
    try {
      final client = ref.read(serverpodClientProvider);
      final submission = ActionSubmission(
        actionId: actionId,
        videoUrl: videoUrl,
        videoDurationSeconds: durationSeconds,
        latitude: latitude,
        longitude: longitude,
        deviceMetadata: deviceMetadata,
        stepNumber: stepNumber,
        status: 'pending',
        // Server overrides performerId from the authenticated session.
        // ignore: experimental_member_use
        performerId: UuidValue.fromString(
          '00000000-0000-0000-0000-000000000000',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final created = await client.submission.create(submission);
      state = AsyncData(created);

      unawaited(
        ref
            .read(posthogInstanceProvider)
            ?.trackVerificationSubmitted(
              actionId: actionId,
              actionType: 'submission',
            ),
      );

      return created;
    } on Exception catch (e, st) {
      debugPrint('Failed to create submission: $e');
      state = AsyncError(e, st);
      return null;
    }
  }

  /// Resets state for a new submission attempt.
  void reset() {
    state = const AsyncData(null);
  }
}
