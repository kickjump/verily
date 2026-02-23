import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';

/// Business logic for storing and querying AI verification results.
///
/// Each [ActionSubmission] may have at most one [VerificationResult] (enforced
/// by a unique index on [submissionId]). The result is created after the Gemini
/// AI model finishes analyzing the submission's video.
///
/// All methods are static and accept a [Session] as the first parameter.
class VerificationService {
  VerificationService._();

  static final _log = VLogger('VerificationService');

  /// The minimum confidence score required for a submission to pass.
  static const double passingConfidenceThreshold = 0.7;

  /// Creates a verification result for a submission.
  ///
  /// Also updates the parent submission's status to either `passed` or
  /// `failed` based on the result.
  static Future<VerificationResult> create(
    Session session, {
    required int submissionId,
    required bool passed,
    required double confidenceScore,
    required String analysisText,
    required bool spoofingDetected,
    required String modelUsed,
    String? structuredResult,
  }) async {
    // Verify the submission exists.
    final submission = await ActionSubmission.db.findById(
      session,
      submissionId,
    );
    if (submission == null) {
      throw NotFoundException('Submission with id $submissionId not found');
    }

    // Check that a result does not already exist for this submission.
    final existing = await findBySubmissionId(session, submissionId);
    if (existing != null) {
      throw ValidationException(
        'Verification result already exists for submission $submissionId',
      );
    }

    final result = VerificationResult(
      submissionId: submissionId,
      passed: passed,
      confidenceScore: confidenceScore,
      analysisText: analysisText,
      structuredResult: structuredResult,
      spoofingDetected: spoofingDetected,
      modelUsed: modelUsed,
      createdAt: DateTime.now().toUtc(),
    );

    final inserted = await VerificationResult.db.insertRow(session, result);

    // Update the submission status based on the verification outcome.
    final newStatus = passed
        ? VerificationStatus.passed.value
        : VerificationStatus.failed.value;
    submission.status = newStatus;
    submission.updatedAt = DateTime.now().toUtc();
    await ActionSubmission.db.updateRow(session, submission);

    _log.info(
      'Verification result for submission $submissionId: '
      'passed=$passed, confidence=$confidenceScore, '
      'spoofing=$spoofingDetected',
    );

    return inserted;
  }

  /// Creates a verification result from a Gemini API response.
  ///
  /// This is a convenience method that parses the structured response from
  /// the Gemini model and delegates to [create].
  static Future<VerificationResult> createFromGeminiResponse(
    Session session, {
    required int submissionId,
    required String analysisText,
    required double confidenceScore,
    required bool spoofingDetected,
    required String modelUsed,
    String? structuredResult,
  }) async {
    final passed =
        confidenceScore >= passingConfidenceThreshold && !spoofingDetected;

    return create(
      session,
      submissionId: submissionId,
      passed: passed,
      confidenceScore: confidenceScore,
      analysisText: analysisText,
      spoofingDetected: spoofingDetected,
      modelUsed: modelUsed,
      structuredResult: structuredResult,
    );
  }

  /// Finds a verification result by its primary key [id].
  ///
  /// Throws [NotFoundException] if the result does not exist.
  static Future<VerificationResult> findById(Session session, int id) async {
    final result = await VerificationResult.db.findById(session, id);
    if (result == null) {
      throw NotFoundException('VerificationResult with id $id not found');
    }
    return result;
  }

  /// Finds the verification result for a given submission, or returns `null`
  /// if no result exists yet.
  static Future<VerificationResult?> findBySubmissionId(
    Session session,
    int submissionId,
  ) async {
    final results = await VerificationResult.db.find(
      session,
      where: (t) => t.submissionId.equals(submissionId),
      limit: 1,
    );
    return results.isEmpty ? null : results.first;
  }

  /// Returns all verification results that detected spoofing, for admin
  /// review.
  static Future<List<VerificationResult>> findSpoofingDetected(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    return VerificationResult.db.find(
      session,
      where: (t) => t.spoofingDetected.equals(true),
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Returns verification results with low confidence scores for manual
  /// review.
  static Future<List<VerificationResult>> findLowConfidence(
    Session session, {
    double threshold = 0.5,
    int limit = 50,
    int offset = 0,
  }) async {
    // TODO: Use `t.confidenceScore < threshold` once generated column
    // comparison operators are available. For now, fetch and filter in memory.
    final all = await VerificationResult.db.find(
      session,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.confidenceScore,
    );
    return all.where((r) => r.confidenceScore < threshold).toList();
  }

  /// Computes aggregate statistics for verification results.
  static Future<VerificationStats> getStats(Session session) async {
    final totalCount = await VerificationResult.db.count(session);
    final passedCount = await VerificationResult.db.count(
      session,
      where: (t) => t.passed.equals(true),
    );
    final spoofingCount = await VerificationResult.db.count(
      session,
      where: (t) => t.spoofingDetected.equals(true),
    );

    return VerificationStats(
      totalCount: totalCount,
      passedCount: passedCount,
      failedCount: totalCount - passedCount,
      spoofingDetectedCount: spoofingCount,
    );
  }
}

/// Aggregate statistics about verification outcomes.
class VerificationStats {
  VerificationStats({
    required this.totalCount,
    required this.passedCount,
    required this.failedCount,
    required this.spoofingDetectedCount,
  });

  final int totalCount;
  final int passedCount;
  final int failedCount;
  final int spoofingDetectedCount;

  double get passRate =>
      totalCount > 0 ? passedCount / totalCount : 0.0;
}
