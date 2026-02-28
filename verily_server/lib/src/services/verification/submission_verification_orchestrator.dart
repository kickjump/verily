import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/submission_service.dart';
import 'package:verily_server/src/services/verification_service.dart';
import 'package:verily_server/src/verification/gemini_service.dart';

/// Coordinates end-to-end Gemini verification for a submission.
class SubmissionVerificationOrchestrator {
  SubmissionVerificationOrchestrator._();

  static final _log = VLogger('SubmissionVerificationOrchestrator');

  /// Runs (or re-runs) verification for [submissionId].
  ///
  /// If [forceReprocess] is false and a result exists, returns the existing
  /// record. If Gemini is unavailable, marks the submission as `error` and
  /// returns `null`.
  static Future<VerificationResult?> processSubmission(
    Session session, {
    required int submissionId,
    bool forceReprocess = false,
  }) async {
    final submission = await ActionSubmission.db.findById(
      session,
      submissionId,
    );
    if (submission == null) {
      throw NotFoundException('Submission with id $submissionId not found');
    }

    final action = await Action.db.findById(session, submission.actionId);
    if (action == null) {
      await SubmissionService.markError(session, id: submissionId);
      throw NotFoundException(
        'Action with id ${submission.actionId} not found',
      );
    }

    final existing = await VerificationService.findBySubmissionId(
      session,
      submissionId,
    );
    if (existing != null && !forceReprocess) {
      return existing;
    }

    try {
      await SubmissionService.markProcessing(session, id: submissionId);

      final geminiResponse = await GeminiService.analyzeVideo(
        session,
        videoUrl: submission.videoUrl,
        actionTitle: action.title,
        actionDescription: action.description,
        verificationCriteria: action.verificationCriteria,
        latitude: submission.latitude,
        longitude: submission.longitude,
      );

      if (geminiResponse == null) {
        await SubmissionService.markError(session, id: submissionId);
        return null;
      }

      if (existing != null) {
        final passed =
            geminiResponse.confidenceScore >=
                VerificationService.passingConfidenceThreshold &&
            !geminiResponse.spoofingDetected;

        existing
          ..passed = passed
          ..confidenceScore = geminiResponse.confidenceScore
          ..analysisText = geminiResponse.analysisText
          ..spoofingDetected = geminiResponse.spoofingDetected
          ..structuredResult = geminiResponse.structuredResult
          ..modelUsed = geminiResponse.modelUsed
          ..createdAt = DateTime.now().toUtc();

        final updated = await VerificationResult.db.updateRow(
          session,
          existing,
        );
        if (passed) {
          await SubmissionService.markPassed(session, id: submissionId);
        } else {
          await SubmissionService.markFailed(session, id: submissionId);
        }
        return updated;
      }

      return VerificationService.createFromGeminiResponse(
        session,
        submissionId: submissionId,
        analysisText: geminiResponse.analysisText,
        confidenceScore: geminiResponse.confidenceScore,
        spoofingDetected: geminiResponse.spoofingDetected,
        modelUsed: geminiResponse.modelUsed,
        structuredResult: geminiResponse.structuredResult,
      );
    } on Exception catch (error, stackTrace) {
      _log.severe(
        'Failed processing verification for submission $submissionId',
        error,
        stackTrace,
      );
      await SubmissionService.markError(session, id: submissionId);
      rethrow;
    }
  }
}
