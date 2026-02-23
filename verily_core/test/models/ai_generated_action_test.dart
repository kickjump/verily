import 'package:test/test.dart';
import 'package:verily_core/verily_core.dart';

void main() {
  group('AiGeneratedAction', () {
    test('creates with required fields', () {
      const action = AiGeneratedAction(
        title: 'Do 10 Push-ups',
        description: 'Complete 10 push-ups with proper form',
        actionType: 'oneOff',
        verificationCriteria: 'Show full push-up motion',
        suggestedCategory: 'Fitness',
      );

      expect(action.title, 'Do 10 Push-ups');
      expect(action.actionType, 'oneOff');
      expect(action.suggestedTags, isEmpty);
      expect(action.suggestedLocation, isNull);
      expect(action.suggestedSteps, isNull);
    });

    test('creates with all fields', () {
      const action = AiGeneratedAction(
        title: '7-Day Challenge',
        description: 'Progressive challenge',
        actionType: 'sequential',
        verificationCriteria: 'Complete each day',
        suggestedCategory: 'Fitness',
        suggestedSteps: 7,
        suggestedIntervalDays: 1,
        suggestedTags: ['fitness', 'challenge'],
        suggestedLocation: AiGeneratedLocation(
          name: 'Central Park',
          address: 'New York, NY',
          latitude: 40.785091,
          longitude: -73.968285,
        ),
      );

      expect(action.suggestedSteps, 7);
      expect(action.suggestedIntervalDays, 1);
      expect(action.suggestedTags, ['fitness', 'challenge']);
      expect(action.suggestedLocation!.name, 'Central Park');
    });

    test('serializes to and from JSON', () {
      const action = AiGeneratedAction(
        title: 'Test Action',
        description: 'Test',
        actionType: 'oneOff',
        verificationCriteria: 'Verify',
        suggestedCategory: 'Fitness',
        suggestedTags: ['tag1'],
      );

      final json = action.toJson();
      final restored = AiGeneratedAction.fromJson(json);

      expect(restored.title, action.title);
      expect(restored.actionType, action.actionType);
      expect(restored.suggestedTags, action.suggestedTags);
    });

    test('equality works', () {
      const a = AiGeneratedAction(
        title: 'Test',
        description: 'Test',
        actionType: 'oneOff',
        verificationCriteria: 'Verify',
        suggestedCategory: 'Fitness',
      );
      const b = AiGeneratedAction(
        title: 'Test',
        description: 'Test',
        actionType: 'oneOff',
        verificationCriteria: 'Verify',
        suggestedCategory: 'Fitness',
      );

      expect(a, equals(b));
    });
  });

  group('AiGeneratedLocation', () {
    test('creates with required fields', () {
      const location = AiGeneratedLocation(
        name: 'Tower Bridge',
        address: 'London, UK',
        latitude: 51.5055,
        longitude: -0.0754,
      );

      expect(location.name, 'Tower Bridge');
      expect(location.suggestedRadiusMeters, 100.0);
    });

    test('serializes to and from JSON', () {
      const location = AiGeneratedLocation(
        name: 'Park',
        address: '123 Main St',
        latitude: 51.5,
        longitude: -0.1,
        suggestedRadiusMeters: 200.0,
      );

      final json = location.toJson();
      final restored = AiGeneratedLocation.fromJson(json);

      expect(restored.name, location.name);
      expect(restored.suggestedRadiusMeters, 200.0);
    });
  });

  group('AiGeneratedStep', () {
    test('creates with all fields', () {
      const step = AiGeneratedStep(
        stepNumber: 1,
        title: 'Day 1: 10 Push-ups',
        description: 'Start with 10 push-ups',
        verificationCriteria: 'Show 10 complete push-ups',
      );

      expect(step.stepNumber, 1);
      expect(step.title, 'Day 1: 10 Push-ups');
    });

    test('serializes to and from JSON', () {
      const step = AiGeneratedStep(
        stepNumber: 3,
        title: 'Day 3',
        description: 'Increase to 20',
        verificationCriteria: 'Complete 20',
      );

      final json = step.toJson();
      final restored = AiGeneratedStep.fromJson(json);

      expect(restored.stepNumber, 3);
      expect(restored.title, step.title);
    });
  });
}
