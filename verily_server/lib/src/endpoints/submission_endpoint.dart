import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/submission_service.dart';
import 'package:verily_server/src/services/verification/submission_verification_orchestrator.dart';

/// Endpoint for managing action submissions.
///
/// All methods require authentication. Submissions represent a performer's
/// attempt to complete an action, including video evidence for verification.
class SubmissionEndpoint extends Endpoint {
  static final _log = VLogger('SubmissionEndpoint');

  @override
  bool get requireLogin => true;

  /// Creates a new submission for an action.
  Future<ActionSubmission> create(
    Session session,
    ActionSubmission submission,
  ) async {
    final authId = _authenticatedUserId(session);
    final created = await SubmissionService.create(
      session,
      actionId: submission.actionId,
      performerId: authId,
      stepNumber: submission.stepNumber,
      videoUrl: submission.videoUrl,
      videoDurationSeconds: submission.videoDurationSeconds,
      deviceMetadata: submission.deviceMetadata,
      latitude: submission.latitude,
      longitude: submission.longitude,
    );

    // Keep submission creation resilient: verification failures should not
    // prevent users from creating a submission record.
    try {
      await SubmissionVerificationOrchestrator.processSubmission(
        session,
        submissionId: created.id!,
      );
    } on Exception catch (error, stackTrace) {
      _log.warning(
        'Submission ${created.id} created, but verification failed to run',
        error,
        stackTrace,
      );
    }

    return created;
  }

  /// Lists all submissions for a given action.
  Future<List<ActionSubmission>> listByAction(
    Session session,
    int actionId,
  ) async {
    return SubmissionService.findByAction(session, actionId: actionId);
  }

  /// Lists all submissions by the authenticated performer.
  Future<List<ActionSubmission>> listByPerformer(Session session) async {
    final authId = _authenticatedUserId(session);
    return SubmissionService.findByPerformer(session, performerId: authId);
  }

  /// Retrieves a single submission by its ID.
  Future<ActionSubmission> get(Session session, int id) async {
    return SubmissionService.findById(session, id);
  }

  /// Gets the sequential progress for a multi-step action.
  ///
  /// Returns the list of submissions representing the performer's progress
  /// through each step of the action.
  Future<List<ActionSubmission>> getSequentialProgress(
    Session session,
    int actionId,
  ) async {
    final authId = _authenticatedUserId(session);
    return ActionSubmission.db.find(
      session,
      where: (t) => t.actionId.equals(actionId) & t.performerId.equals(authId),
      orderBy: (t) => t.stepNumber,
    );
  }
}

UuidValue _authenticatedUserId(Session session) {
  return UuidValue.fromString(session.authenticated!.userIdentifier);
}
