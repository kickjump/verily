import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/submission_service.dart';

/// Endpoint for managing action submissions.
///
/// All methods require authentication. Submissions represent a performer's
/// attempt to complete an action, including video evidence for verification.
class SubmissionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new submission for an action.
  Future<ActionSubmission> create(
    Session session,
    ActionSubmission submission,
  ) async {
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return SubmissionService.create(
      session,
      actionId: submission.actionId,
      performerId: authId,
      videoUrl: submission.videoUrl,
      stepNumber: submission.stepNumber,
      videoDurationSeconds: submission.videoDurationSeconds,
      deviceMetadata: submission.deviceMetadata,
      latitude: submission.latitude,
      longitude: submission.longitude,
    );
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
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    return SubmissionService.findByPerformer(session, performerId: authId);
  }

  /// Retrieves a single submission by its ID.
  Future<ActionSubmission?> get(Session session, int id) async {
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
    final authId = UuidValue.fromString(session.authenticated!.userIdentifier);
    // Fetch all submissions for this action, then filter by performer.
    final submissions = await SubmissionService.findByAction(
      session,
      actionId: actionId,
    );
    return submissions.where((s) => s.performerId == authId).toList();
  }
}
