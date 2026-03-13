import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_app/src/features/actions/providers/ai_action_provider.dart';
import 'package:verily_client/verily_client.dart';
import 'package:verily_core/verily_core.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeAiActionEndpoint extends Fake implements EndpointAiAction {
  String? lastDescription;
  double? lastLatitude;
  double? lastLongitude;
  AiGeneratedAction? responseAction;
  Exception? errorToThrow;

  String? lastCriteriaTitle;
  String? lastCriteriaDescription;
  String? criteriaResponse;
  Exception? criteriaError;

  @override
  Future<AiGeneratedAction> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    lastDescription = description;
    lastLatitude = latitude;
    lastLongitude = longitude;
    return responseAction ??
        const AiGeneratedAction(
          title: 'Generated Title',
          description: 'Generated Description',
          actionType: 'one_off',
          verificationCriteria: '- Check 1\n- Check 2',
          suggestedCategory: 'Fitness',
          suggestedTags: ['active', 'outdoors'],
        );
  }

  @override
  Future<String> generateCriteria(String title, String description) async {
    if (criteriaError != null) throw criteriaError!;
    lastCriteriaTitle = title;
    lastCriteriaDescription = description;
    return criteriaResponse ?? 'Generated criteria for $title';
  }
}

class _FakeClient extends Fake implements Client {
  _FakeClient(this._aiActionEndpoint);

  final _FakeAiActionEndpoint _aiActionEndpoint;

  @override
  EndpointAiAction get aiAction => _aiActionEndpoint;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AiActionGenerator', () {
    late _FakeAiActionEndpoint fakeEndpoint;
    late _FakeClient fakeClient;
    late ProviderContainer container;

    setUp(() {
      fakeEndpoint = _FakeAiActionEndpoint();
      fakeClient = _FakeClient(fakeEndpoint);

      container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is AsyncData(null)', () {
      final state = container.read(aiActionGeneratorProvider);
      expect(state, isA<AsyncData<AiGeneratedAction?>>());
      expect(state.value, isNull);
    });

    test('generate sends description to server', () async {
      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('Do 50 push-ups at a local park');

      expect(
        fakeEndpoint.lastDescription,
        equals('Do 50 push-ups at a local park'),
      );
    });

    test('generate sends latitude and longitude when provided', () async {
      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate(
            'Clean up litter at a beach',
            latitude: 34.0195,
            longitude: -118.4912,
          );

      expect(fakeEndpoint.lastLatitude, equals(34.0195));
      expect(fakeEndpoint.lastLongitude, equals(-118.4912));
    });

    test('generate updates state with generated action', () async {
      fakeEndpoint.responseAction = const AiGeneratedAction(
        title: 'Park Push-Ups',
        description: 'Do 50 push-ups in a park setting',
        actionType: 'one_off',
        verificationCriteria: '- Full body visible\n- Park in background',
        suggestedCategory: 'Fitness',
        suggestedTags: ['fitness', 'outdoor'],
        suggestedMaxPerformers: 100,
      );

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('Do push-ups at a park');

      final state = container.read(aiActionGeneratorProvider);
      expect(state, isA<AsyncData<AiGeneratedAction?>>());
      expect(state.value, isNotNull);
      expect(state.value!.title, equals('Park Push-Ups'));
      expect(state.value!.suggestedCategory, equals('Fitness'));
      expect(state.value!.suggestedTags, contains('fitness'));
      expect(state.value!.suggestedMaxPerformers, equals(100));
    });

    test('generate sets error state on failure', () async {
      fakeEndpoint.errorToThrow = Exception('AI service unavailable');

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('This will fail');

      final state = container.read(aiActionGeneratorProvider);
      expect(state, isA<AsyncError<AiGeneratedAction?>>());
    });

    test('reset clears generated action', () async {
      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('Generate something');

      expect(container.read(aiActionGeneratorProvider).value, isNotNull);

      container.read(aiActionGeneratorProvider.notifier).reset();

      final state = container.read(aiActionGeneratorProvider);
      expect(state, isA<AsyncData<AiGeneratedAction?>>());
      expect(state.value, isNull);
    });

    test('reset after error clears error state', () async {
      fakeEndpoint.errorToThrow = Exception('Network error');

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('This will fail');

      expect(
        container.read(aiActionGeneratorProvider),
        isA<AsyncError<AiGeneratedAction?>>(),
      );

      container.read(aiActionGeneratorProvider.notifier).reset();

      final state = container.read(aiActionGeneratorProvider);
      expect(state, isA<AsyncData<AiGeneratedAction?>>());
      expect(state.value, isNull);
    });

    test('generate with sequential action type returns steps', () async {
      fakeEndpoint.responseAction = const AiGeneratedAction(
        title: 'Morning Routine',
        description: 'Complete a morning exercise routine',
        actionType: 'sequential',
        verificationCriteria: '- Complete each step in order',
        suggestedCategory: 'Wellness',
        stepOrdering: 'ordered',
        suggestedSteps: 3,
        steps: [
          AiGeneratedStep(
            stepNumber: 1,
            title: 'Warm up',
            description: 'Light stretching for 5 minutes',
            verificationCriteria: 'Show stretching',
          ),
          AiGeneratedStep(
            stepNumber: 2,
            title: 'Push-ups',
            description: 'Do 20 push-ups',
            verificationCriteria: 'Full body visible',
          ),
          AiGeneratedStep(
            stepNumber: 3,
            title: 'Cool down',
            description: 'Walk for 5 minutes',
            verificationCriteria: 'Show walking',
          ),
        ],
      );

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('Create a morning exercise routine');

      final action = container.read(aiActionGeneratorProvider).value!;
      expect(action.actionType, equals('sequential'));
      expect(action.steps, hasLength(3));
      expect(action.steps[0].title, equals('Warm up'));
      expect(action.steps[2].stepNumber, equals(3));
      expect(action.stepOrdering, equals('ordered'));
    });

    test('generate with habit action returns habit fields', () async {
      fakeEndpoint.responseAction = const AiGeneratedAction(
        title: 'Daily Meditation',
        description: 'Meditate for 5 minutes daily',
        actionType: 'habit',
        verificationCriteria: '- Seated position\n- Eyes closed',
        suggestedCategory: 'Wellness',
        habitDurationDays: 30,
        habitFrequencyPerWeek: 7,
        habitTotalRequired: 30,
      );

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('Meditate daily for a month');

      final action = container.read(aiActionGeneratorProvider).value!;
      expect(action.actionType, equals('habit'));
      expect(action.habitDurationDays, equals(30));
      expect(action.habitFrequencyPerWeek, equals(7));
      expect(action.habitTotalRequired, equals(30));
    });

    test('generate with location returns location data', () async {
      fakeEndpoint.responseAction = const AiGeneratedAction(
        title: 'Beach Cleanup',
        description: 'Pick up litter at the beach',
        actionType: 'one_off',
        verificationCriteria: '- Before and after visible',
        suggestedCategory: 'Environment',
        suggestedLocation: AiGeneratedLocation(
          name: 'Santa Monica Beach',
          address: '123 Ocean Ave, Santa Monica, CA',
          latitude: 34.0195,
          longitude: -118.4912,
          suggestedRadiusMeters: 500,
        ),
      );

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('Clean up a beach');

      final action = container.read(aiActionGeneratorProvider).value!;
      expect(action.suggestedLocation, isNotNull);
      expect(action.suggestedLocation!.name, equals('Santa Monica Beach'));
      expect(action.suggestedLocation!.latitude, equals(34.0195));
      expect(action.suggestedLocation!.suggestedRadiusMeters, equals(500.0));
    });

    test('successive generates replace previous result', () async {
      fakeEndpoint.responseAction = const AiGeneratedAction(
        title: 'First Action',
        description: 'First',
        actionType: 'one_off',
        verificationCriteria: 'Check',
        suggestedCategory: 'Fitness',
      );

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('First');
      expect(
        container.read(aiActionGeneratorProvider).value!.title,
        equals('First Action'),
      );

      fakeEndpoint.responseAction = const AiGeneratedAction(
        title: 'Second Action',
        description: 'Second',
        actionType: 'habit',
        verificationCriteria: 'Check again',
        suggestedCategory: 'Wellness',
      );

      await container
          .read(aiActionGeneratorProvider.notifier)
          .generate('Second');
      expect(
        container.read(aiActionGeneratorProvider).value!.title,
        equals('Second Action'),
      );
    });
  });

  group('generateCriteria', () {
    late _FakeAiActionEndpoint fakeEndpoint;
    late _FakeClient fakeClient;
    late ProviderContainer container;

    setUp(() {
      fakeEndpoint = _FakeAiActionEndpoint();
      fakeClient = _FakeClient(fakeEndpoint);

      container = ProviderContainer(
        overrides: [serverpodClientProvider.overrideWithValue(fakeClient)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('sends title and description to server', () async {
      final result = await container.read(
        generateCriteriaProvider(
          title: 'Push-Ups',
          description: 'Do push-ups at a park',
        ).future,
      );

      expect(fakeEndpoint.lastCriteriaTitle, equals('Push-Ups'));
      expect(
        fakeEndpoint.lastCriteriaDescription,
        equals('Do push-ups at a park'),
      );
      expect(result, contains('Push-Ups'));
    });

    test('returns null on error', () async {
      fakeEndpoint.criteriaError = Exception('Service down');

      final result = await container.read(
        generateCriteriaProvider(
          title: 'Failing',
          description: 'Will fail',
        ).future,
      );

      expect(result, isNull);
    });
  });
}
