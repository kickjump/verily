import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../exceptions/server_exceptions.dart';
import '../generated/protocol.dart';

/// Business logic for creating and managing action submissions.
///
/// A submission represents a user's video proof that they performed an action.
/// After creation the submission enters the verification pipeline where
/// Gemini AI analyses the video.
///
/// All methods are static and accept a [Session] as the first parameter.
class SubmissionService {
  SubmissionService._();

  static final _log = VLogger('SubmissionService');

  /// Creates a new submission for an action.
  ///
  /// For sequential actions, [stepNumber] must be provided and reference an
  /// existing step. The [videoUrl] should already be uploaded to cloud storage.
  static Future<ActionSubmission> create(
    Session session, {
    required int actionId,
    required UuidValue performerId,
    required String videoUrl,
    int? stepNumber,
    double? videoDurationSeconds,
    String? deviceMetadata,
    double? latitude,
    double? longitude,
  }) async {
    // Verify the action exists and is active.
    final action = await Action.db.findById(session, actionId);
    if (action == null) {
      throw NotFoundException('Action with id $actionId not found');
    }
    if (action.status != 'active') {
      throw ValidationException('Action is not active');
    }

    // For sequential actions, ensure the step number is valid.
    final type = ActionType.fromValue(action.actionType);
    if (type == ActionType.sequential) {
      if (stepNumber == null) {
        throw ValidationException(
          'stepNumber is required for sequential actions',
        );
      }

      // Verify the step exists.
      final steps = await ActionStep.db.find(
        session,
        where: (t) =>
            t.actionId.equals(actionId) & t.stepNumber.equals(stepNumber),
        limit: 1,
      );
      if (steps.isEmpty) {
        throw NotFoundException(
          'Step $stepNumber for action $actionId not found',
        );
      }

      // Ensure prior steps are completed (passed).
      if (stepNumber > 1) {
        final priorSubmissions = await ActionSubmission.db.find(
          session,
          where: (t) =>
              t.actionId.equals(actionId) &
              t.performerId.equals(performerId) &
              t.status.equals(VerificationStatus.passed.value),
        );

        final completedSteps =
            priorSubmissions.map((s) => s.stepNumber).whereType<int>().toSet();

        for (var i = 1; i < stepNumber; i++) {
          if (!completedSteps.contains(i)) {
            throw ValidationException(
              'Step $i must be completed before step $stepNumber',
            );
          }
        }
      }
    }

    // Check max performers limit if set.
    if (action.maxPerformers != null) {
      final performerCount = await _countDistinctPerformers(
        session,
        actionId: actionId,
      );
      if (performerCount >= action.maxPerformers!) {
        throw ValidationException(
          'Maximum number of performers reached for this action',
        );
      }
    }

    final now = DateTime.now().toUtc();
    final submission = ActionSubmission(
      actionId: actionId,
      performerId: performerId,
      stepNumber: stepNumber,
      videoUrl: videoUrl,
      videoDurationSeconds: videoDurationSeconds,
      deviceMetadata: deviceMetadata,
      latitude: latitude,
      longitude: longitude,
      status: VerificationStatus.pending.value,
      createdAt: now,
      updatedAt: now,
    );

    final inserted = await ActionSubmission.db.insertRow(session, submission);
    _log.info(
      'Created submission (id=${inserted.id}) for action $actionId '
      'by performer $performerId',
    );
    return inserted;
  }

  /// Finds a submission by its primary key [id].
  ///
  /// Throws [NotFoundException] if the submission does not exist.
  static Future<ActionSubmission> findById(Session session, int id) async {
    final submission = await ActionSubmission.db.findById(session, id);
    if (submission == null) {
      throw NotFoundException('Submission with id $id not found');
    }
    return submission;
  }

  /// Lists submissions for a specific action, optionally filtered by status.
  static Future<List<ActionSubmission>> findByAction(
    Session session, {
    required int actionId,
    String? status,
    int limit = 50,
    int offset = 0,
  }) async {
    var filter = ActionSubmission.t.actionId.equals(actionId);
    if (status != null) {
      filter = filter & ActionSubmission.t.status.equals(status);
    }

    return ActionSubmission.db.find(
      session,
      where: (_) => filter,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Lists all submissions by a specific performer.
  static Future<List<ActionSubmission>> findByPerformer(
    Session session, {
    required UuidValue performerId,
    String? status,
    int limit = 50,
    int offset = 0,
  }) async {
    var filter = ActionSubmission.t.performerId.equals(performerId);
    if (status != null) {
      filter = filter & ActionSubmission.t.status.equals(status);
    }

    return ActionSubmission.db.find(
      session,
      where: (_) => filter,
      limit: limit,
      offset: offset,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Updates the verification status of a submission.
  ///
  /// This is called by the verification pipeline after Gemini processes
  /// the video.
  static Future<ActionSubmission> updateStatus(
    Session session, {
    required int id,
    required String status,
  }) async {
    // Validate the status value.
    VerificationStatus.fromValue(status);

    final submission = await findById(session, id);
    submission.status = status;
    submission.updatedAt = DateTime.now().toUtc();

    final updated = await ActionSubmission.db.updateRow(session, submission);
    _log.info('Submission id=$id status updated to $status');
    return updated;
  }

  /// Marks a submission as currently being processed by Gemini.
  static Future<ActionSubmission> markProcessing(
    Session session, {
    required int id,
  }) async {
    return updateStatus(
      session,
      id: id,
      status: VerificationStatus.processing.value,
    );
  }

  /// Marks a submission as having passed verification.
  static Future<ActionSubmission> markPassed(
    Session session, {
    required int id,
  }) async {
    return updateStatus(
      session,
      id: id,
      status: VerificationStatus.passed.value,
    );
  }

  /// Marks a submission as having failed verification.
  static Future<ActionSubmission> markFailed(
    Session session, {
    required int id,
  }) async {
    return updateStatus(
      session,
      id: id,
      status: VerificationStatus.failed.value,
    );
  }

  /// Marks a submission as having encountered an error during verification.
  static Future<ActionSubmission> markError(
    Session session, {
    required int id,
  }) async {
    return updateStatus(
      session,
      id: id,
      status: VerificationStatus.error.value,
    );
  }

  /// Returns the count of pending submissions that need processing.
  static Future<int> countPending(Session session) async {
    return ActionSubmission.db.count(
      session,
      where: (t) => t.status.equals(VerificationStatus.pending.value),
    );
  }

  /// Fetches the next batch of pending submissions for the verification
  /// pipeline to process.
  static Future<List<ActionSubmission>> fetchPendingBatch(
    Session session, {
    int batchSize = 10,
  }) async {
    return ActionSubmission.db.find(
      session,
      where: (t) => t.status.equals(VerificationStatus.pending.value),
      limit: batchSize,
      orderBy: (t) => t.createdAt,
    );
  }

  /// Checks whether a performer has already completed all steps for a
  /// sequential action.
  static Future<bool> hasCompletedAllSteps(
    Session session, {
    required int actionId,
    required UuidValue performerId,
  }) async {
    final action = await Action.db.findById(session, actionId);
    if (action == null || action.totalSteps == null) return false;

    final passedSubmissions = await ActionSubmission.db.find(
      session,
      where: (t) =>
          t.actionId.equals(actionId) &
          t.performerId.equals(performerId) &
          t.status.equals(VerificationStatus.passed.value),
    );

    final completedSteps =
        passedSubmissions.map((s) => s.stepNumber).whereType<int>().toSet();

    for (var i = 1; i <= action.totalSteps!; i++) {
      if (!completedSteps.contains(i)) return false;
    }
    return true;
  }

  /// Counts the number of distinct performers who have submitted to an action.
  static Future<int> _countDistinctPerformers(
    Session session, {
    required int actionId,
  }) async {
    // TODO: Replace with a raw SQL `COUNT(DISTINCT performer_id)` query for
    // efficiency once raw query support is finalized.
    final submissions = await ActionSubmission.db.find(
      session,
      where: (t) => t.actionId.equals(actionId),
    );
    return submissions.map((s) => s.performerId).toSet().length;
  }
}
