import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/action_step_service.dart';

/// Endpoint for managing steps within an action.
///
/// All methods require authentication. Action steps define the sequential
/// stages a performer must complete for multi-step actions.
class ActionStepEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new action step.
  Future<ActionStep> create(Session session, ActionStep actionStep) async {
    return ActionStepService.create(
      session,
      actionId: actionStep.actionId,
      stepNumber: actionStep.stepNumber,
      title: actionStep.title,
      verificationCriteria: actionStep.verificationCriteria,
      description: actionStep.description,
    );
  }

  /// Lists all steps for a given action, ordered by step number.
  Future<List<ActionStep>> listByAction(Session session, int actionId) async {
    return ActionStepService.findByActionId(session, actionId: actionId);
  }

  /// Updates an existing action step.
  Future<ActionStep> update(Session session, ActionStep actionStep) async {
    return ActionStepService.update(
      session,
      id: actionStep.id!,
      title: actionStep.title,
      description: actionStep.description,
      verificationCriteria: actionStep.verificationCriteria,
    );
  }

  /// Deletes an action step by its ID.
  Future<void> delete(Session session, int id) async {
    return ActionStepService.delete(session, id);
  }
}
