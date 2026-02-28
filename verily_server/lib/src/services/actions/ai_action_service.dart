import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

/// Service for AI-powered action creation using Gemini.
///
/// Transforms natural language descriptions into structured action data,
/// suggests locations, and generates verification criteria.
///
/// All methods are static and accept a [Session] as the first parameter.
class AiActionService {
  AiActionService._();

  static final _log = VLogger('AiActionService');
  static const _modelName = 'gemini-2.5-flash-lite';

  /// Generates a structured action from a natural language description.
  ///
  /// The AI parses the user's intent and returns a structured action with
  /// title, description, type, verification criteria, suggested category,
  /// and optionally a location suggestion.
  ///
  /// Returns `null` if the Gemini API key is not configured.
  static Future<AiGeneratedAction?> generateAction(
    Session session, {
    required String description,
    double? latitude,
    double? longitude,
  }) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null || apiKey.isEmpty) {
      _log.warning('Gemini API key not configured');
      return null;
    }

    try {
      final model = GenerativeModel(model: _modelName, apiKey: apiKey);

      final locationCtx = latitude != null && longitude != null
          ? '\nUser location: lat=$latitude, lng=$longitude. '
                'If the description mentions a place, suggest coordinates near '
                "the user's location."
          : '';

      final prompt =
          '''
You are an action creation AI for Verily, a real-world action verification
marketplace. Transform the natural language description into a structured action
that can be verified via video/photo proof.

## User Description
"$description"
$locationCtx

## Action Types

Choose the most appropriate type:

- **"oneOff"**: A single action completed once (e.g., "do 20 push-ups",
  "take a photo at the Eiffel Tower").
- **"sequential"**: Multiple distinct steps, either in order or any order
  (e.g., "visit 3 coffee shops and review each one"). Set stepOrdering to
  "ordered" if steps must be done in sequence, or "unordered" if any order.
  Include the actual steps in the "steps" array.
- **"habit"**: A repeated action over a time period (e.g., "run 5K every day
  for 30 days", "meditate 5 times a week for 4 weeks"). Set habitDurationDays,
  habitFrequencyPerWeek, and habitTotalRequired.

## Your Task

1. A clear, concise title (max 60 chars)
2. A detailed description explaining exactly what to do
3. The correct actionType with all relevant fields
4. Clear, specific verification criteria that AI can use to verify video/photo
5. Category: Fitness, Social, Creative, Wellness, Adventure, Learning,
   Community, Food, Shopping, Travel
6. For sequential: steps array with per-step verification criteria
7. For habit: duration, frequency, and total completions
8. Relevant tags for discoverability
9. If a specific location is mentioned, suggest coordinates and radius

## Response Format (JSON only)

{
  "title": "string",
  "description": "string",
  "actionType": "oneOff" | "sequential" | "habit",
  "verificationCriteria": "string (overall criteria)",
  "suggestedCategory": "string",
  "stepOrdering": null | "ordered" | "unordered",
  "suggestedSteps": null | number,
  "suggestedIntervalDays": null | number,
  "habitDurationDays": null | number,
  "habitFrequencyPerWeek": null | number,
  "habitTotalRequired": null | number,
  "suggestedTags": ["tag1", "tag2"],
  "suggestedMaxPerformers": null | number,
  "suggestedLocation": null | {
    "name": "string",
    "address": "string",
    "latitude": number,
    "longitude": number,
    "suggestedRadiusMeters": number
  },
  "steps": [] | [
    {
      "stepNumber": 1,
      "title": "string",
      "description": "string",
      "verificationCriteria": "string"
    }
  ]
}

Respond with ONLY valid JSON, no markdown formatting.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) {
        _log.warning('Empty response from Gemini for action generation');
        return null;
      }

      return _parseActionResponse(text);
    } on Exception catch (e, stack) {
      _log.severe('AI action generation error', e, stack);
      return null;
    }
  }

  /// Generates verification criteria for an action.
  ///
  /// Given a title and description, produces detailed criteria that can be
  /// used by the video verification AI.
  static Future<String?> generateVerificationCriteria(
    Session session, {
    required String actionTitle,
    required String actionDescription,
  }) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null || apiKey.isEmpty) {
      _log.warning('Gemini API key not configured');
      return null;
    }

    try {
      final model = GenerativeModel(model: _modelName, apiKey: apiKey);

      final prompt =
          '''
Generate specific, measurable verification criteria for this action that can
be verified by watching a video:

Title: $actionTitle
Description: $actionDescription

The criteria should:
1. Be specific and unambiguous
2. Be verifiable from video alone
3. Include what should be visible (person, activity, environment)
4. Include minimum duration or count requirements
5. Note any form/technique requirements

Respond with ONLY the verification criteria text (2-4 sentences), no JSON.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text?.trim();
    } on Exception catch (e, stack) {
      _log.severe('AI verification criteria generation error', e, stack);
      return null;
    }
  }

  /// Generates step breakdowns for a sequential action.
  static Future<List<AiGeneratedStep>?> generateSteps(
    Session session, {
    required String actionTitle,
    required String actionDescription,
    required int numberOfSteps,
  }) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null || apiKey.isEmpty) {
      _log.warning('Gemini API key not configured');
      return null;
    }

    try {
      final model = GenerativeModel(model: _modelName, apiKey: apiKey);

      final prompt =
          '''
Generate $numberOfSteps progressive steps for this sequential action challenge:

Title: $actionTitle
Description: $actionDescription

Each step should:
1. Be progressively more challenging or build on the previous step
2. Have clear, video-verifiable criteria
3. Have a descriptive title

## Response Format (JSON array only)

[
  {
    "stepNumber": 1,
    "title": "string",
    "description": "string",
    "verificationCriteria": "string"
  },
  ...
]

Respond with ONLY valid JSON, no markdown formatting.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text == null || text.isEmpty) return null;
      return _parseStepsResponse(text);
    } on Exception catch (e, stack) {
      _log.severe('AI step generation error', e, stack);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static AiGeneratedAction? _parseActionResponse(String responseText) {
    try {
      var jsonStr = responseText.trim();
      if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr
            .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
            .replaceFirst(RegExp(r'\s*```$'), '');
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return AiGeneratedAction.fromJson(json);
    } on Exception catch (e) {
      _log.warning('Failed to parse AI action response: $e');
      return null;
    }
  }

  static List<AiGeneratedStep>? _parseStepsResponse(String responseText) {
    try {
      var jsonStr = responseText.trim();
      if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr
            .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
            .replaceFirst(RegExp(r'\s*```$'), '');
      }

      final jsonList = jsonDecode(jsonStr) as List<dynamic>;
      return jsonList
          .map((e) => AiGeneratedStep.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      _log.warning('Failed to parse AI steps response: $e');
      return null;
    }
  }
}
