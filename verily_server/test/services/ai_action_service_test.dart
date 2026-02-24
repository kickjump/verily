import 'dart:convert';

import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('AiActionService response parsing (pure logic)', () {
    test('parses valid action JSON response', () {
      final json = {
        'title': 'Do 20 Star Jumps',
        'description': 'Complete 20 star jumps in one go',
        'actionType': 'oneOff',
        'verificationCriteria':
            'Show 20 complete star jumps with arms above head',
        'suggestedCategory': 'Fitness',
        'suggestedTags': ['fitness', 'exercise'],
      };

      final action = AiGeneratedAction.fromJson(json);

      expect(action.title, 'Do 20 Star Jumps');
      expect(action.actionType, 'oneOff');
      expect(action.suggestedCategory, 'Fitness');
      expect(action.suggestedTags, contains('fitness'));
      expect(action.suggestedLocation, isNull);
    });

    test('parses action with location', () {
      final json = {
        'title': 'Run around Tower Bridge',
        'description': 'Run a lap around Tower Bridge',
        'actionType': 'oneOff',
        'verificationCriteria': 'Video showing running near Tower Bridge',
        'suggestedCategory': 'Fitness',
        'suggestedTags': ['running', 'london'],
        'suggestedLocation': {
          'name': 'Tower Bridge',
          'address': 'Tower Bridge Rd, London',
          'latitude': 51.5055,
          'longitude': -0.0754,
          'suggestedRadiusMeters': 500.0,
        },
      };

      final action = AiGeneratedAction.fromJson(json);

      expect(action.suggestedLocation, isNotNull);
      expect(action.suggestedLocation!.name, 'Tower Bridge');
      expect(action.suggestedLocation!.latitude, closeTo(51.5, 0.1));
    });

    test('parses sequential action with steps', () {
      final json = {
        'title': '5-Day Yoga Challenge',
        'description': 'Progressive yoga challenge',
        'actionType': 'sequential',
        'verificationCriteria': 'Complete each day yoga session',
        'suggestedCategory': 'Wellness',
        'suggestedSteps': 5,
        'suggestedIntervalDays': 1,
        'suggestedTags': ['yoga', 'wellness'],
      };

      final action = AiGeneratedAction.fromJson(json);

      expect(action.actionType, 'sequential');
      expect(action.suggestedSteps, 5);
      expect(action.suggestedIntervalDays, 1);
    });

    test('parses step array', () {
      final jsonList = [
        {
          'stepNumber': 1,
          'title': 'Day 1: Basics',
          'description': 'Learn the basics',
          'verificationCriteria': 'Show basic poses',
        },
        {
          'stepNumber': 2,
          'title': 'Day 2: Intermediate',
          'description': 'Build on day 1',
          'verificationCriteria': 'Show intermediate poses',
        },
      ];

      final steps = jsonList.map(AiGeneratedStep.fromJson).toList();

      expect(steps.length, 2);
      expect(steps[0].stepNumber, 1);
      expect(steps[1].stepNumber, 2);
      expect(steps[0].title, contains('Day 1'));
    });

    test('handles markdown-wrapped JSON', () {
      const wrapped =
          '```json\n{"title":"Test","description":"Test desc","actionType":"oneOff","verificationCriteria":"Verify","suggestedCategory":"Fitness","suggestedTags":[]}\n```';

      var jsonStr = wrapped.trim();
      if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr
            .replaceFirst(RegExp(r'^```(?:json)?\s*'), '')
            .replaceFirst(RegExp(r'\s*```$'), '');
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final action = AiGeneratedAction.fromJson(json);

      expect(action.title, 'Test');
    });

    test('default tags are empty list', () {
      final json = {
        'title': 'Test',
        'description': 'Test',
        'actionType': 'oneOff',
        'verificationCriteria': 'Verify',
        'suggestedCategory': 'Fitness',
      };

      final action = AiGeneratedAction.fromJson(json);
      expect(action.suggestedTags, isEmpty);
    });
  });
}
