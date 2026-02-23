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
    final authId = session.authenticated!.userId;
    return SubmissionService.create(session, submission, authId);
  }

  /// Lists all submissions for a given action.
  Future<List<ActionSubmission>> listByAction(
    Session session,
    int actionId,
  ) async {
    return SubmissionService.listByAction(session, actionId);
  }

  /// Lists all submissions by the authenticated performer.
  Future<List<ActionSubmission>> listByPerformer(Session session) async {
    final authId = session.authenticated!.userId;
    return SubmissionService.listByPerformer(session, authId);
  }

  /// Retrieves a single submission by its ID.
  Future<ActionSubmission?> get(Session session, int id) async {
    return SubmissionService.get(session, id);
  }

  /// Gets the sequential progress for a multi-step action.
  ///
  /// Returns the list of submissions representing the performer's progress
  /// through each step of the action.
  Future<List<ActionSubmission>> getSequentialProgress(
    Session session,
    int actionId,
  ) async {
    final authId = session.authenticated!.userId;
    return SubmissionService.getSequentialProgress(session, actionId, authId);
  }
}
