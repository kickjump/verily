import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/submission_service.dart';
import '../services/verification_service.dart';
import '../verification/gemini_service.dart';

/// Endpoint for accessing AI verification results.
///
/// All methods require authentication. Verification results are produced
/// by the AI pipeline after a submission is created.
class VerificationEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Retrieves the verification result for a given submission.
  Future<VerificationResult?> getBySubmission(
    Session session,
    int submissionId,
  ) async {
    return VerificationService.findBySubmissionId(session, submissionId);
  }

  /// Retries the AI verification for a submission.
  ///
  /// This re-triggers the verification pipeline by resetting the submission
  /// status to pending. The verification worker will pick it up on the next
  /// processing cycle.
  Future<VerificationResult?> retryVerification(
    Session session,
    int submissionId,
  ) async {
    // Reset the submission status to pending so the verification pipeline
    // reprocesses it.
    await SubmissionService.updateStatus(
      session,
      id: submissionId,
      status: 'pending',
    );

    // Attempt immediate re-verification via Gemini.
    final submission = await SubmissionService.findById(session, submissionId);
    final action = await Action.db.findById(session, submission.actionId);
    if (action == null) return null;

    final response = await GeminiService.analyzeVideo(
      session,
      videoUrl: submission.videoUrl,
      actionTitle: action.title,
      actionDescription: action.description,
      verificationCriteria: action.verificationCriteria,
      latitude: submission.latitude,
      longitude: submission.longitude,
    );

    if (response == null) return null;

    return VerificationService.createFromGeminiResponse(
      session,
      submissionId: submissionId,
      analysisText: response.analysisText,
      confidenceScore: response.confidenceScore,
      spoofingDetected: response.spoofingDetected,
      modelUsed: response.modelUsed,
      structuredResult: response.structuredResult,
    );
  }
}
