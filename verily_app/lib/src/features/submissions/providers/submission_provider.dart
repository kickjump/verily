import 'dart:async';

import 'package:flutter/cupertino.dart' show IconData;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show IconData;
import 'package:flutter/widgets.dart' show IconData;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/analytics/posthog_analytics.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/submissions/services/video_quality_analyzer.dart';
import 'package:verily_app/src/features/submissions/submission_status_screen.dart'
    show SubmissionStatusScreen;
import 'package:verily_client/verily_client.dart';

part 'submission_provider.g.dart';

/// On-device pre-score data computed from local quality checks.
///
/// Shown immediately on the [SubmissionStatusScreen] while the server
/// performs full Gemini AI analysis — providing instant psychological
/// feedback about submission quality.
class PreScoreData {
  const PreScoreData({
    required this.score,
    required this.checkSummaries,
    required this.analysisTimeMs,
  });

  /// Compute a [PreScoreData] from a [VideoQualityReport].
  ///
  /// The score is a weighted average of individual check results:
  /// - Face detection and brightness are weighted higher (core quality).
  /// - Resolution and duration are baseline requirements.
  /// - Sharpness, file size, screen recording detection are supporting.
  factory PreScoreData.fromQualityReport(VideoQualityReport report) {
    if (report.checks.isEmpty) {
      return const PreScoreData(
        score: 0,
        checkSummaries: [],
        analysisTimeMs: 0,
      );
    }

    // Weighted scoring: each check type has a weight reflecting its
    // importance to the server-side Gemini verification.
    const weights = <QualityCheckType, double>{
      QualityCheckType.faceDetection: 0.25,
      QualityCheckType.brightness: 0.20,
      QualityCheckType.resolution: 0.15,
      QualityCheckType.minimumDuration: 0.15,
      QualityCheckType.blurDetection: 0.10,
      QualityCheckType.fileSize: 0.05,
      QualityCheckType.screenRecordingDetection: 0.05,
      QualityCheckType.geoFence: 0.05,
    };

    var weightedSum = 0.0;
    var totalWeight = 0.0;
    final summaries = <PreScoreCheckSummary>[];

    for (final check in report.checks) {
      final weight = weights[check.checkType] ?? 0.05;
      totalWeight += weight;
      if (check.passed) {
        weightedSum += weight;
      }

      summaries.add(
        PreScoreCheckSummary(
          label: check.label,
          passed: check.passed,
          icon: _iconForCheckType(check.checkType),
        ),
      );
    }

    final score = totalWeight > 0 ? weightedSum / totalWeight : 0.0;

    return PreScoreData(
      score: score,
      checkSummaries: summaries,
      analysisTimeMs: report.analysisTimeMs,
    );
  }

  /// Estimated confidence score from on-device checks (0.0–1.0).
  final double score;

  /// Human-readable summaries of each check performed.
  final List<PreScoreCheckSummary> checkSummaries;

  /// How long the on-device analysis took in milliseconds.
  final int analysisTimeMs;

  /// Whether the pre-score suggests the submission is likely to pass.
  bool get looksGood => score >= 0.7;

  /// A human-readable message based on the pre-score.
  String get message {
    if (score >= 0.9) {
      return 'Excellent! Our local checks suggest high confidence — '
          'server AI is now doing full analysis.';
    } else if (score >= 0.7) {
      return 'Looking good! Most local checks passed — '
          'server AI is analyzing for final verification.';
    } else if (score >= 0.5) {
      return 'Some quality concerns detected — '
          'server AI will make the final determination.';
    } else {
      return 'Several quality issues found — '
          'the server AI may have difficulty verifying this submission.';
    }
  }

  static String _iconForCheckType(QualityCheckType type) {
    return switch (type) {
      QualityCheckType.faceDetection => 'face',
      QualityCheckType.brightness => 'brightness',
      QualityCheckType.resolution => 'resolution',
      QualityCheckType.minimumDuration => 'duration',
      QualityCheckType.blurDetection => 'sharpness',
      QualityCheckType.fileSize => 'file_size',
      QualityCheckType.screenRecordingDetection => 'screen_recording',
      QualityCheckType.geoFence => 'location',
    };
  }
}

/// Summary of a single on-device quality check for display in the UI.
class PreScoreCheckSummary {
  const PreScoreCheckSummary({
    required this.label,
    required this.passed,
    required this.icon,
  });

  final String label;
  final bool passed;

  /// Semantic icon identifier (resolved to [IconData] in the UI layer).
  final String icon;
}

/// Global state provider for the pre-score computed on the video review screen.
///
/// Set by VideoReviewScreen before navigating to SubmissionStatusScreen.
/// Read by SubmissionStatusScreen to show immediate feedback.
/// Auto-cleared when the status screen disposes.
@riverpod
class PreScore extends _$PreScore {
  @override
  PreScoreData? build() => null;

  /// Sets the pre-score data.
  // ignore: use_setters_to_change_properties
  void set(PreScoreData? data) => state = data;
}

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
