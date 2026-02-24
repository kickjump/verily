import 'package:serverpod/serverpod.dart';

import 'package:verily_server/src/generated/protocol.dart';
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
    final existing = await VerificationService.findBySubmissionId(
      session,
      submissionId,
    );
    if (existing == null) {
      throw Exception(
        'Verification result for submission $submissionId not found',
      );
    }
    return existing;
  }
}
