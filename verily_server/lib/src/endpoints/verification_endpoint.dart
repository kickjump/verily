import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/verification_service.dart';

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
    return VerificationService.getBySubmission(session, submissionId);
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
    final authId = session.authenticated!.userId;
    return VerificationService.retryVerification(
      session,
      submissionId,
      authId,
    );
  }
}
