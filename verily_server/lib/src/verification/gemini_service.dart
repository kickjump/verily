import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

/// Service for verifying video submissions using Gemini 2.0 Flash.
class GeminiService {
  GeminiService._();

  static final _log = VLogger('GeminiService');
  static const _modelName = 'gemini-2.0-flash';

  /// Analyzes a video file against action verification criteria.
  ///
  /// Returns a structured result with pass/fail, confidence score,
  /// analysis text, and spoofing indicators.
  ///
  /// Returns `null` if the Gemini API key is not configured.
  static Future<GeminiVerificationResponse?> analyzeVideo(
    Session session, {
    required String videoUrl,
    required String actionTitle,
    required String actionDescription,
    required String verificationCriteria,
    double? latitude,
    double? longitude,
  }) async {
    final apiKey = session.passwords['geminiApiKey'];

    if (apiKey == null || apiKey.isEmpty) {
      _log.warning(
        'Gemini API key not configured. '
        'Video verification is unavailable.',
      );
      return null;
    }

    try {
      final model = GenerativeModel(model: _modelName, apiKey: apiKey);

      final prompt = _buildPrompt(
        actionTitle: actionTitle,
        actionDescription: actionDescription,
        verificationCriteria: verificationCriteria,
        latitude: latitude,
        longitude: longitude,
      );

      // For MVP, we pass the video URL. In production, we'd upload the
      // video bytes directly to the Gemini API.
      final content = [
        Content.text(prompt),
        Content.text(
          'Video URL for analysis: $videoUrl\n'
          'Note: Please analyze based on the verification criteria above.',
        ),
      ];

      final response = await model.generateContent(content);
      final responseText = response.text;

      if (responseText == null || responseText.isEmpty) {
        _log.warning('Empty response from Gemini API');
        return GeminiVerificationResponse(
          passed: false,
          confidenceScore: 0,
          analysisText: 'Empty response from verification AI.',
          spoofingDetected: false,
          modelUsed: _modelName,
        );
      }

      return _parseResponse(responseText);
    } catch (e, stack) {
      _log.severe('Gemini API error', e, stack);
      return GeminiVerificationResponse(
        passed: false,
        confidenceScore: 0,
        analysisText: 'Verification service encountered an error: $e',
        spoofingDetected: false,
        modelUsed: _modelName,
      );
    }
  }

  static String _buildPrompt({
    required String actionTitle,
    required String actionDescription,
    required String verificationCriteria,
    double? latitude,
    double? longitude,
  }) {
    final locationContext = latitude != null && longitude != null
        ? '\n\nExpected location: lat=$latitude, lng=$longitude. '
              'If the video contains GPS metadata, verify it matches.'
        : '';

    return '''
You are a video verification AI for the Verily platform. Your job is to analyze
submitted video evidence and determine if it satisfies the action requirements.

## Action Details
- **Title**: $actionTitle
- **Description**: $actionDescription
- **Verification Criteria**: $verificationCriteria
$locationContext

## Your Tasks

1. **Content Verification**: Does the video show the person completing the
   required action as described in the verification criteria?

2. **Forensic Analysis**: Check for signs of video manipulation:
   - Screen recording artifacts (status bars, notification bars, Moiré patterns)
   - Video editing signs (jump cuts, sudden lighting changes, audio
     discontinuities)
   - Camera perspective inconsistencies
   - Temporal continuity (smooth, uninterrupted flow)
   - Signs of pre-recorded playback on another screen

3. **Confidence Assessment**: Rate your confidence that this is a legitimate,
   unmanipulated video of the person performing the action (0.0 to 1.0).

## Response Format (JSON only)

Respond with ONLY valid JSON, no markdown formatting:

{
  "passed": true/false,
  "confidenceScore": 0.0-1.0,
  "analysisText": "Detailed explanation of your analysis",
  "spoofingDetected": true/false,
  "spoofingIndicators": ["list", "of", "suspicious", "elements"]
}
''';
  }

  static GeminiVerificationResponse _parseResponse(String responseText) {
    try {
      // Try to extract JSON from the response (Gemini sometimes wraps in
      // markdown code blocks).
      var jsonStr = responseText.trim();
      if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr
            .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
            .replaceFirst(RegExp(r'\s*```$'), '');
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      return GeminiVerificationResponse(
        passed: json['passed'] as bool? ?? false,
        confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0,
        analysisText:
            json['analysisText'] as String? ?? 'No analysis provided.',
        spoofingDetected: json['spoofingDetected'] as bool? ?? false,
        structuredResult: jsonStr,
        modelUsed: _modelName,
      );
    } catch (e) {
      _log.warning('Failed to parse Gemini response as JSON: $e');
      return GeminiVerificationResponse(
        passed: false,
        confidenceScore: 0,
        analysisText: responseText,
        spoofingDetected: false,
        modelUsed: _modelName,
      );
    }
  }
}

/// Structured response from Gemini video analysis.
class GeminiVerificationResponse {
  GeminiVerificationResponse({
    required this.passed,
    required this.confidenceScore,
    required this.analysisText,
    required this.spoofingDetected,
    required this.modelUsed,
    this.structuredResult,
  });

  final bool passed;
  final double confidenceScore;
  final String analysisText;
  final bool spoofingDetected;
  final String modelUsed;
  final String? structuredResult;
}
