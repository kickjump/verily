import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../services/ai_action_service.dart';

/// Endpoint for AI-powered action creation.
///
/// Uses Gemini to transform natural language descriptions into structured
/// action data with verification criteria.
class AiActionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Generates a structured action from a natural language description.
  ///
  /// Returns null if the Gemini API key is not configured.
  Future<AiGeneratedAction?> generate(
    Session session,
    String description, {
    double? latitude,
    double? longitude,
  }) async {
    return AiActionService.generateAction(
      session,
      description: description,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Generates verification criteria for an action.
  Future<String?> generateCriteria(
    Session session,
    String actionTitle,
    String actionDescription,
  ) async {
    return AiActionService.generateVerificationCriteria(
      session,
      actionTitle: actionTitle,
      actionDescription: actionDescription,
    );
  }

  /// Generates step breakdowns for a sequential action.
  Future<List<AiGeneratedStep>?> generateSteps(
    Session session,
    String actionTitle,
    String actionDescription,
    int numberOfSteps,
  ) async {
    return AiActionService.generateSteps(
      session,
      actionTitle: actionTitle,
      actionDescription: actionDescription,
      numberOfSteps: numberOfSteps,
    );
  }
}
