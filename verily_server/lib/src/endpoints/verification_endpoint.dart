import 'package:serverpod/serverpod.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/submission_service.dart';
import 'package:verily_server/src/services/verification/submission_verification_orchestrator.dart';
import 'package:verily_server/src/services/verification_service.dart';

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
    await _assertCanAccessSubmission(session, submissionId);
    return VerificationService.findBySubmissionId(session, submissionId);
  }

  /// Retries the AI verification for a submission.
  ///
  /// This re-triggers the verification pipeline, which may be useful if
  /// the initial verification encountered an error or produced unexpected
  /// results.
  Future<VerificationResult> retryVerification(
    Session session,
    int submissionId,
  ) async {
    await _assertCanAccessSubmission(session, submissionId);

    final result = await SubmissionVerificationOrchestrator.processSubmission(
      session,
      submissionId: submissionId,
      forceReprocess: true,
    );
    if (result == null) {
      throw ValidationException(
        'Verification could not run. Ensure Gemini is configured.',
      );
    }
    return result;
  }

  Future<void> _assertCanAccessSubmission(
    Session session,
    int submissionId,
  ) async {
    final authId = _authenticatedUserId(session);
    final submission = await SubmissionService.findById(session, submissionId);
    if (submission.performerId == authId) return;

    final action = await Action.db.findById(session, submission.actionId);
    if (action != null && action.creatorId == authId) return;

    throw ForbiddenException(
      'You are not allowed to access verification for this submission',
    );
  }
}

UuidValue _authenticatedUserId(Session session) {
  return UuidValue.fromString(session.authenticated!.userIdentifier);
}
