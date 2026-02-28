import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';

/// Business logic for managing individual steps within sequential actions.
///
/// All methods are static and accept a [Session] as the first parameter.
class ActionStepService {
  ActionStepService._();

  static final _log = VLogger('ActionStepService');

  /// Creates a new step for a sequential action.
  ///
  /// Validates that the parent action exists, is sequential, and that the
  /// [stepNumber] does not exceed the action's `totalSteps`.
  static Future<ActionStep> create(
    Session session, {
    required int actionId,
    required int stepNumber,
    required String title,
    required String verificationCriteria,
    String? description,
  }) async {
    final action = await Action.db.findById(session, actionId);
    if (action == null) {
      throw NotFoundException('Action with id $actionId not found');
    }

    final type = ActionType.fromValue(action.actionType);
    if (type != ActionType.sequential) {
      throw ValidationException(
        'Steps can only be added to sequential actions',
      );
    }

    if (action.totalSteps != null && stepNumber > action.totalSteps!) {
      throw ValidationException(
        'Step number $stepNumber exceeds totalSteps (${action.totalSteps})',
      );
    }

    if (stepNumber < 1) {
      throw ValidationException('Step number must be >= 1');
    }

    final step = ActionStep(
      actionId: actionId,
      stepNumber: stepNumber,
      title: title,
      description: description,
      verificationCriteria: verificationCriteria,
      isOptional: false,
    );

    final inserted = await ActionStep.db.insertRow(session, step);
    _log.info(
      'Created step $stepNumber for action $actionId: "${inserted.title}"',
    );
    return inserted;
  }

  /// Creates multiple steps for an action in a single batch.
  ///
  /// Each entry in [steps] should contain `stepNumber`, `title`,
  /// `verificationCriteria`, and optionally `description`.
  static Future<List<ActionStep>> createBatch(
    Session session, {
    required int actionId,
    required List<ActionStep> steps,
  }) async {
    final action = await Action.db.findById(session, actionId);
    if (action == null) {
      throw NotFoundException('Action with id $actionId not found');
    }

    final type = ActionType.fromValue(action.actionType);
    if (type != ActionType.sequential) {
      throw ValidationException(
        'Steps can only be added to sequential actions',
      );
    }

    // Validate step numbers are within bounds and sequential.
    for (final step in steps) {
      if (step.stepNumber < 1) {
        throw ValidationException('Step number must be >= 1');
      }
      if (action.totalSteps != null && step.stepNumber > action.totalSteps!) {
        throw ValidationException(
          'Step number ${step.stepNumber} exceeds totalSteps '
          '(${action.totalSteps})',
        );
      }
    }

    final inserted = await ActionStep.db.insert(session, steps);
    _log.info('Created ${inserted.length} steps for action $actionId');
    return inserted;
  }

  /// Returns all steps for a given action, ordered by step number.
  static Future<List<ActionStep>> findByActionId(
    Session session, {
    required int actionId,
  }) async {
    return ActionStep.db.find(
      session,
      where: (t) => t.actionId.equals(actionId),
      orderBy: (t) => t.stepNumber,
    );
  }

  /// Returns a specific step by action id and step number.
  ///
  /// Throws [NotFoundException] if the step does not exist.
  static Future<ActionStep> findByActionAndStep(
    Session session, {
    required int actionId,
    required int stepNumber,
  }) async {
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
    return steps.first;
  }

  /// Returns a single step by its primary key [id].
  ///
  /// Throws [NotFoundException] when the step does not exist.
  static Future<ActionStep> findById(Session session, int id) async {
    final step = await ActionStep.db.findById(session, id);
    if (step == null) {
      throw NotFoundException('ActionStep with id $id not found');
    }
    return step;
  }

  /// Updates an existing step.
  static Future<ActionStep> update(
    Session session, {
    required int id,
    String? title,
    String? description,
    String? verificationCriteria,
  }) async {
    final step = await findById(session, id);

    if (title != null) step.title = title;
    if (description != null) step.description = description;
    if (verificationCriteria != null) {
      step.verificationCriteria = verificationCriteria;
    }

    return ActionStep.db.updateRow(session, step);
  }

  /// Deletes a step by its primary key [id].
  static Future<void> delete(Session session, int id) async {
    final step = await findById(session, id);
    await ActionStep.db.deleteRow(session, step);
    _log.info('Deleted action step id=$id');
  }

  /// Deletes all steps for a given action.
  static Future<void> deleteAllForAction(
    Session session, {
    required int actionId,
  }) async {
    final steps = await findByActionId(session, actionId: actionId);
    if (steps.isNotEmpty) {
      await ActionStep.db.delete(session, steps);
      _log.info('Deleted ${steps.length} steps for action $actionId');
    }
  }

  /// Counts the number of steps defined for an action.
  static Future<int> countForAction(
    Session session, {
    required int actionId,
  }) async {
    return ActionStep.db.count(
      session,
      where: (t) => t.actionId.equals(actionId),
    );
  }
}
