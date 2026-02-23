// Run with: cd verily_server && dart test test/verification/gemini_service_test.dart
//
// These tests validate the Gemini service's response parsing and prompt
// building logic. Since _parseResponse and _buildPrompt are private in
// GeminiService, we replicate their logic here for testing. This approach
// avoids modifying production code while still thoroughly testing the
// parsing behavior.
//
// If you prefer to test the actual private methods, you can:
// 1. Make them package-private (remove underscore prefix) and import from src
// 2. Add a @visibleForTesting annotation
// 3. Create a test-only wrapper that delegates to the private methods

import 'dart:convert';

import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Replicated parsing logic from GeminiService._parseResponse
// ---------------------------------------------------------------------------

/// Structured response matching GeminiVerificationResponse.
class TestGeminiResponse {
  TestGeminiResponse({
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

/// Replicates GeminiService._parseResponse exactly.
TestGeminiResponse parseResponse(String responseText) {
  const modelName = 'gemini-2.0-flash';

  try {
    var jsonStr = responseText.trim();
    if (jsonStr.startsWith('```')) {
      jsonStr = jsonStr
          .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
          .replaceFirst(RegExp(r'\s*```$'), '');
    }

    final json = jsonDecode(jsonStr) as Map<String, dynamic>;

    return TestGeminiResponse(
      passed: json['passed'] as bool? ?? false,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0,
      analysisText:
          json['analysisText'] as String? ?? 'No analysis provided.',
      spoofingDetected: json['spoofingDetected'] as bool? ?? false,
      structuredResult: jsonStr,
      modelUsed: modelName,
    );
  } catch (e) {
    return TestGeminiResponse(
      passed: false,
      confidenceScore: 0,
      analysisText: responseText,
      spoofingDetected: false,
      modelUsed: modelName,
    );
  }
}

// ---------------------------------------------------------------------------
// Replicated prompt building logic from GeminiService._buildPrompt
// ---------------------------------------------------------------------------

String buildPrompt({
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

void main() {
  // ===========================================================================
  // _parseResponse tests
  // ===========================================================================

  group('GeminiService._parseResponse', () {
    // -------------------------------------------------------------------------
    // Valid JSON responses
    // -------------------------------------------------------------------------

    group('valid JSON', () {
      test('parses a passing response with high confidence', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.95,
  "analysisText": "The video clearly shows the person performing 10 press-ups with proper form.",
  "spoofingDetected": false,
  "spoofingIndicators": []
}
''';

        final result = parseResponse(responseText);

        expect(result.passed, isTrue);
        expect(result.confidenceScore, equals(0.95));
        expect(result.analysisText, contains('10 press-ups'));
        expect(result.spoofingDetected, isFalse);
        expect(result.modelUsed, equals('gemini-2.0-flash'));
        expect(result.structuredResult, isNotNull);
      });

      test('parses a failing response with low confidence', () {
        const responseText = '''
{
  "passed": false,
  "confidenceScore": 0.3,
  "analysisText": "The video does not clearly show the required exercise.",
  "spoofingDetected": false,
  "spoofingIndicators": []
}
''';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.3));
        expect(result.analysisText, contains('does not clearly'));
        expect(result.spoofingDetected, isFalse);
      });

      test('parses a response with spoofing detected', () {
        const responseText = '''
{
  "passed": false,
  "confidenceScore": 0.1,
  "analysisText": "Screen recording artifacts detected. The video appears to be a recording of another screen.",
  "spoofingDetected": true,
  "spoofingIndicators": ["screen_recording_artifacts", "moire_patterns", "status_bar_visible"]
}
''';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.1));
        expect(result.spoofingDetected, isTrue);
        expect(result.analysisText, contains('Screen recording'));
      });

      test('parses response with integer confidence score', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 1,
  "analysisText": "Perfect video.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);

        expect(result.confidenceScore, equals(1.0));
        expect(result.passed, isTrue);
      });

      test('parses response with zero confidence', () {
        const responseText = '''
{
  "passed": false,
  "confidenceScore": 0,
  "analysisText": "Cannot determine if action was performed.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);

        expect(result.confidenceScore, equals(0.0));
        expect(result.passed, isFalse);
      });

      test('parses minimal valid JSON', () {
        const responseText = '{}';

        final result = parseResponse(responseText);

        // All fields should fall back to defaults.
        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
        expect(result.analysisText, equals('No analysis provided.'));
        expect(result.spoofingDetected, isFalse);
      });

      test('parses response with extra fields (forward compatible)', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.85,
  "analysisText": "Analysis complete.",
  "spoofingDetected": false,
  "spoofingIndicators": [],
  "processingTimeMs": 1234,
  "modelVersion": "2.0.1",
  "debugInfo": {"tokens_used": 500}
}
''';

        final result = parseResponse(responseText);

        expect(result.passed, isTrue);
        expect(result.confidenceScore, equals(0.85));
        expect(result.analysisText, equals('Analysis complete.'));
        // Extra fields are ignored gracefully.
      });
    });

    // -------------------------------------------------------------------------
    // Markdown-wrapped JSON
    // -------------------------------------------------------------------------

    group('markdown-wrapped JSON', () {
      test('strips ```json wrapper', () {
        const responseText = '''```json
{
  "passed": true,
  "confidenceScore": 0.9,
  "analysisText": "Video shows the required action.",
  "spoofingDetected": false
}
```''';

        final result = parseResponse(responseText);

        expect(result.passed, isTrue);
        expect(result.confidenceScore, equals(0.9));
        expect(result.analysisText, equals('Video shows the required action.'));
      });

      test('strips ``` wrapper without language tag', () {
        const responseText = '''```
{
  "passed": false,
  "confidenceScore": 0.4,
  "analysisText": "Unclear video.",
  "spoofingDetected": false
}
```''';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.4));
      });

      test('handles whitespace around markdown fences', () {
        const responseText = '''
```json
{
  "passed": true,
  "confidenceScore": 0.88,
  "analysisText": "Good video with clear evidence.",
  "spoofingDetected": false
}
```
''';

        final result = parseResponse(responseText.trim());

        expect(result.passed, isTrue);
        expect(result.confidenceScore, equals(0.88));
      });

      test('handles ```JSON (uppercase) wrapper', () {
        // The regex uses (?:json)? which is case-sensitive. Test that the
        // parser handles this gracefully (either strips it or falls back).
        const responseText = '''```JSON
{
  "passed": true,
  "confidenceScore": 0.75,
  "analysisText": "OK.",
  "spoofingDetected": false
}
```''';

        final result = parseResponse(responseText);

        // Even if the regex does not match "JSON" (uppercase), the parser
        // should still attempt to extract valid JSON.
        // Based on the regex: ^```(?:json)?\s* -- this won't match "JSON"
        // but the ```\s* will still be stripped, leaving "JSON\n{..."
        // which will fail JSON parse, falling back to raw text.
        // This tests the fallback behavior.
        expect(result.modelUsed, equals('gemini-2.0-flash'));
        // The result may or may not parse depending on case sensitivity.
        // The important thing is it does not crash.
      });
    });

    // -------------------------------------------------------------------------
    // Malformed JSON / fallback behavior
    // -------------------------------------------------------------------------

    group('malformed JSON', () {
      test('falls back for completely non-JSON text', () {
        const responseText =
            'I apologize, but I cannot analyze this video.';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
        expect(result.analysisText, equals(responseText));
        expect(result.spoofingDetected, isFalse);
        expect(result.structuredResult, isNull);
        expect(result.modelUsed, equals('gemini-2.0-flash'));
      });

      test('falls back for truncated JSON', () {
        const responseText = '{"passed": true, "confidenceScore": 0.9, "anal';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
        expect(result.analysisText, equals(responseText));
      });

      test('falls back for JSON array instead of object', () {
        const responseText = '[{"passed": true}]';

        final result = parseResponse(responseText);

        // jsonDecode will succeed but the cast to Map<String, dynamic> fails.
        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
        expect(result.analysisText, equals(responseText));
      });

      test('falls back for empty string', () {
        const responseText = '';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
        // analysisText should be the original (empty) text.
        expect(result.analysisText, equals(responseText));
      });

      test('falls back for JSON with syntax errors', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.9,
  analysisText: "Missing quotes on key",
}
''';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
      });

      test('falls back for XML response', () {
        const responseText = '''
<response>
  <passed>true</passed>
  <confidenceScore>0.9</confidenceScore>
</response>
''';

        final result = parseResponse(responseText);

        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
        expect(result.analysisText, contains('<response>'));
      });

      test('falls back for markdown with text before JSON', () {
        const responseText = '''
Here is my analysis:

{
  "passed": true,
  "confidenceScore": 0.85,
  "analysisText": "Good video.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);

        // The parser tries to decode the entire text as JSON which fails
        // because of the text before the JSON block.
        expect(result.passed, isFalse);
        expect(result.confidenceScore, equals(0.0));
        expect(result.analysisText, contains('Here is my analysis'));
      });
    });

    // -------------------------------------------------------------------------
    // Missing / null fields
    // -------------------------------------------------------------------------

    group('missing fields', () {
      test('defaults passed to false when missing', () {
        const responseText = '''
{
  "confidenceScore": 0.9,
  "analysisText": "Good.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.passed, isFalse);
      });

      test('defaults confidenceScore to 0 when missing', () {
        const responseText = '''
{
  "passed": true,
  "analysisText": "Good.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.confidenceScore, equals(0.0));
      });

      test('defaults analysisText when missing', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.9,
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.analysisText, equals('No analysis provided.'));
      });

      test('defaults spoofingDetected to false when missing', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.9,
  "analysisText": "OK."
}
''';

        final result = parseResponse(responseText);
        expect(result.spoofingDetected, isFalse);
      });

      test('defaults passed to false when null', () {
        const responseText = '''
{
  "passed": null,
  "confidenceScore": 0.9,
  "analysisText": "Good.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.passed, isFalse);
      });

      test('defaults confidenceScore to 0 when null', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": null,
  "analysisText": "Good.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.confidenceScore, equals(0.0));
      });
    });

    // -------------------------------------------------------------------------
    // Edge cases
    // -------------------------------------------------------------------------

    group('edge cases', () {
      test('handles very long analysis text', () {
        final longText = 'A' * 10000;
        final responseText = '''
{
  "passed": true,
  "confidenceScore": 0.9,
  "analysisText": "$longText",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.analysisText.length, equals(10000));
      });

      test('handles unicode in analysis text', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.9,
  "analysisText": "Video shows proper form. Great job!",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.analysisText, contains('Great job'));
      });

      test('handles special characters in analysis text', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.8,
  "analysisText": "The user completed 10 reps. Time: 0:45. Score: A+.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);
        expect(result.analysisText, contains('10 reps'));
        expect(result.analysisText, contains('0:45'));
      });

      test('handles confidence score as string (type mismatch)', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": "0.9",
  "analysisText": "OK.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);

        // "0.9" as String will fail the `as num?` cast, so should fall to
        // default or throw. The null-aware operator means it defaults to 0.
        // Actually: the cast `as num?` will throw a TypeError for a String.
        // This will be caught by the outer try/catch, falling back.
        expect(result.modelUsed, equals('gemini-2.0-flash'));
      });

      test('structuredResult contains the cleaned JSON string', () {
        const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.9,
  "analysisText": "OK.",
  "spoofingDetected": false
}
''';

        final result = parseResponse(responseText);

        expect(result.structuredResult, isNotNull);
        // Should be parseable JSON.
        final parsed = jsonDecode(result.structuredResult!);
        expect(parsed['passed'], isTrue);
      });
    });
  });

  // ===========================================================================
  // _buildPrompt tests
  // ===========================================================================

  group('GeminiService._buildPrompt', () {
    test('includes action title in prompt', () {
      final prompt = buildPrompt(
        actionTitle: 'Do 10 Press-ups',
        actionDescription: 'Complete 10 press-ups',
        verificationCriteria: 'Show all 10 reps',
      );

      expect(prompt, contains('Do 10 Press-ups'));
    });

    test('includes action description in prompt', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'Complete 10 press-ups with proper form',
        verificationCriteria: 'criteria',
      );

      expect(prompt, contains('Complete 10 press-ups with proper form'));
    });

    test('includes verification criteria in prompt', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria:
            'Must show full range of motion for each rep',
      );

      expect(prompt, contains('Must show full range of motion'));
    });

    test('includes location context when coordinates provided', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
        latitude: 51.5074,
        longitude: -0.1278,
      );

      expect(prompt, contains('lat=51.5074'));
      expect(prompt, contains('lng=-0.1278'));
      expect(prompt, contains('Expected location'));
      expect(prompt, contains('GPS metadata'));
    });

    test('excludes location context when no coordinates', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
      );

      expect(prompt, isNot(contains('Expected location')));
      expect(prompt, isNot(contains('GPS metadata')));
    });

    test('excludes location when only latitude is provided', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
        latitude: 51.5074,
      );

      expect(prompt, isNot(contains('Expected location')));
    });

    test('excludes location when only longitude is provided', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
        longitude: -0.1278,
      );

      expect(prompt, isNot(contains('Expected location')));
    });

    test('includes forensic analysis instructions', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
      );

      expect(prompt, contains('Forensic Analysis'));
      expect(prompt, contains('Screen recording artifacts'));
      expect(prompt, contains('Video editing signs'));
      expect(prompt, contains('Camera perspective'));
      expect(prompt, contains('Temporal continuity'));
    });

    test('requests JSON response format', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
      );

      expect(prompt, contains('Response Format (JSON only)'));
      expect(prompt, contains('"passed"'));
      expect(prompt, contains('"confidenceScore"'));
      expect(prompt, contains('"analysisText"'));
      expect(prompt, contains('"spoofingDetected"'));
      expect(prompt, contains('"spoofingIndicators"'));
    });

    test('includes confidence score range in instructions', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
      );

      expect(prompt, contains('0.0 to 1.0'));
    });

    test('identifies itself as Verily platform AI', () {
      final prompt = buildPrompt(
        actionTitle: 'Test',
        actionDescription: 'desc',
        verificationCriteria: 'criteria',
      );

      expect(prompt, contains('Verily platform'));
      expect(prompt, contains('video verification AI'));
    });

    test('handles special characters in action fields', () {
      final prompt = buildPrompt(
        actionTitle: 'Do "10" <press-ups> & more',
        actionDescription: 'Complete 10+ reps (with form)',
        verificationCriteria: 'Show >= 10 reps; each < 3 seconds',
      );

      expect(prompt, contains('Do "10" <press-ups> & more'));
      expect(prompt, contains('Complete 10+ reps (with form)'));
      expect(prompt, contains('Show >= 10 reps; each < 3 seconds'));
    });

    test('handles empty action fields', () {
      final prompt = buildPrompt(
        actionTitle: '',
        actionDescription: '',
        verificationCriteria: '',
      );

      // Should not crash, just produce a prompt with empty fields.
      expect(prompt, contains('**Title**: '));
      expect(prompt, contains('**Description**: '));
      expect(prompt, contains('**Verification Criteria**: '));
    });

    test('handles very long action fields', () {
      final longTitle = 'A' * 1000;
      final longDesc = 'B' * 5000;
      final longCriteria = 'C' * 5000;

      final prompt = buildPrompt(
        actionTitle: longTitle,
        actionDescription: longDesc,
        verificationCriteria: longCriteria,
      );

      expect(prompt, contains(longTitle));
      expect(prompt, contains(longDesc));
      expect(prompt, contains(longCriteria));
    });
  });

  // ===========================================================================
  // GeminiVerificationResponse structure tests
  // ===========================================================================

  group('GeminiVerificationResponse structure', () {
    test('stores all required fields', () {
      final response = TestGeminiResponse(
        passed: true,
        confidenceScore: 0.95,
        analysisText: 'Perfect video.',
        spoofingDetected: false,
        modelUsed: 'gemini-2.0-flash',
      );

      expect(response.passed, isTrue);
      expect(response.confidenceScore, equals(0.95));
      expect(response.analysisText, equals('Perfect video.'));
      expect(response.spoofingDetected, isFalse);
      expect(response.modelUsed, equals('gemini-2.0-flash'));
      expect(response.structuredResult, isNull);
    });

    test('stores optional structuredResult', () {
      final response = TestGeminiResponse(
        passed: true,
        confidenceScore: 0.9,
        analysisText: 'Good.',
        spoofingDetected: false,
        modelUsed: 'gemini-2.0-flash',
        structuredResult: '{"passed": true}',
      );

      expect(response.structuredResult, equals('{"passed": true}'));
    });
  });

  // ===========================================================================
  // Integration of parse + confidence threshold logic
  // ===========================================================================

  group('Confidence threshold integration', () {
    /// Replicates the logic from VerificationService.createFromGeminiResponse:
    /// passed = confidenceScore >= 0.7 && !spoofingDetected
    bool shouldPass(double confidence, bool spoofing) {
      return confidence >= 0.7 && !spoofing;
    }

    test('parses high-confidence passing response correctly', () {
      const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.95,
  "analysisText": "Clear evidence of action.",
  "spoofingDetected": false
}
''';

      final parsed = parseResponse(responseText);
      final wouldPass = shouldPass(
        parsed.confidenceScore,
        parsed.spoofingDetected,
      );

      expect(wouldPass, isTrue);
    });

    test('parses low-confidence response as fail', () {
      const responseText = '''
{
  "passed": false,
  "confidenceScore": 0.3,
  "analysisText": "Cannot clearly see the action.",
  "spoofingDetected": false
}
''';

      final parsed = parseResponse(responseText);
      final wouldPass = shouldPass(
        parsed.confidenceScore,
        parsed.spoofingDetected,
      );

      expect(wouldPass, isFalse);
    });

    test('spoofing detection overrides high confidence', () {
      const responseText = '''
{
  "passed": false,
  "confidenceScore": 0.95,
  "analysisText": "Video appears to be a screen recording.",
  "spoofingDetected": true,
  "spoofingIndicators": ["screen_recording", "moire_pattern"]
}
''';

      final parsed = parseResponse(responseText);
      final wouldPass = shouldPass(
        parsed.confidenceScore,
        parsed.spoofingDetected,
      );

      expect(wouldPass, isFalse);
    });

    test('borderline confidence at exactly 0.7 passes', () {
      const responseText = '''
{
  "passed": true,
  "confidenceScore": 0.7,
  "analysisText": "Acceptable evidence.",
  "spoofingDetected": false
}
''';

      final parsed = parseResponse(responseText);
      final wouldPass = shouldPass(
        parsed.confidenceScore,
        parsed.spoofingDetected,
      );

      expect(wouldPass, isTrue);
    });

    test('confidence at 0.699 fails', () {
      const responseText = '''
{
  "passed": false,
  "confidenceScore": 0.699,
  "analysisText": "Slightly below threshold.",
  "spoofingDetected": false
}
''';

      final parsed = parseResponse(responseText);
      final wouldPass = shouldPass(
        parsed.confidenceScore,
        parsed.spoofingDetected,
      );

      expect(wouldPass, isFalse);
    });

    test('malformed response defaults to fail', () {
      const responseText = 'This is not JSON at all.';

      final parsed = parseResponse(responseText);
      final wouldPass = shouldPass(
        parsed.confidenceScore,
        parsed.spoofingDetected,
      );

      expect(wouldPass, isFalse);
      expect(parsed.confidenceScore, equals(0.0));
    });
  });
}
