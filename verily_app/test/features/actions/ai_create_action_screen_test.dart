// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations_en.dart';
import 'package:verily_app/src/features/actions/ai_create_action_screen.dart';
import 'package:verily_app/src/features/actions/providers/ai_action_provider.dart';
import 'package:verily_app/src/features/actions/providers/create_action_provider.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_core/verily_core.dart';

import '../../helpers/pump_app_l10n.dart';

final _l10n = AppLocalizationsEn();

/// A fake [AiActionGenerator] for testing that avoids real API calls.
class _FakeAiActionGenerator extends AiActionGenerator {
  _FakeAiActionGenerator({this.initialValue});

  final AiGeneratedAction? initialValue;

  @override
  AsyncValue<AiGeneratedAction?> build() => AsyncData(initialValue);

  @override
  Future<void> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) async {
    // No-op in tests.
  }

  @override
  void reset() {
    state = const AsyncData(null);
  }
}

/// A fake [AiActionGenerator] that simulates a loading state.
class _LoadingAiActionGenerator extends AiActionGenerator {
  @override
  AsyncValue<AiGeneratedAction?> build() => const AsyncLoading();

  @override
  Future<void> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) async {}

  @override
  void reset() {}
}

/// A fake [AiActionGenerator] that simulates an error state.
class _ErrorAiActionGenerator extends AiActionGenerator {
  @override
  AsyncValue<AiGeneratedAction?> build() =>
      AsyncError(Exception('Network error'), StackTrace.current);

  @override
  Future<void> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) async {}

  @override
  void reset() {}
}

void main() {
  group('AiCreateActionScreen', () {
    late ProviderContainer container;

    setUpAll(() {
      // Mock the speech_to_text platform channel to prevent
      // MissingPluginException in tests.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugin.csdcorp.com/speech_to_text'),
            (MethodCall methodCall) async {
              switch (methodCall.method) {
                case 'initialize':
                  return false; // Speech not available in tests.
                case 'has_permission':
                  return false;
                case 'cancel':
                case 'stop':
                  return null;
                default:
                  return null;
              }
            },
          );
    });

    tearDownAll(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugin.csdcorp.com/speech_to_text'),
            null,
          );
    });

    setUp(() {
      container = ProviderContainer(
        overrides: [
          aiActionGeneratorProvider.overrideWith(_FakeAiActionGenerator.new),
          createActionProvider.overrideWithValue(
            const AsyncData<vc.Action?>(null),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpScreen(WidgetTester tester) async {
      await tester.pumpAppL10n(
        const AiCreateActionScreen(),
        container: container,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders app bar with AI title', (tester) async {
      await pumpScreen(tester);

      expect(find.text(_l10n.actionCreateWithAi), findsOneWidget);
    });

    testWidgets('renders Manual navigation button in app bar', (tester) async {
      await pumpScreen(tester);

      expect(find.text(_l10n.actionCreateManual), findsOneWidget);
    });

    testWidgets('renders header with icon and description', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.auto_awesome), findsWidgets);
      expect(find.text('Describe your action'), findsOneWidget);
      expect(
        find.textContaining('Tell us what you want people to do'),
        findsOneWidget,
      );
    });

    testWidgets('renders text input field with label', (tester) async {
      await pumpScreen(tester);

      expect(find.text(_l10n.actionDescribePrompt), findsOneWidget);
    });

    testWidgets('renders character count hint when under 10 chars', (
      tester,
    ) async {
      await pumpScreen(tester);

      // Initially 0 chars → 10 more characters needed.
      expect(find.text('10 more characters needed'), findsOneWidget);
    });

    testWidgets('renders example chips section', (tester) async {
      await pumpScreen(tester);

      // Scroll down to reveal example chips below the viewport.
      await tester.scrollUntilVisible(
        find.text('Try saying:'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      expect(find.text('Try saying:'), findsOneWidget);
      expect(find.text('Do 50 push-ups at a park'), findsOneWidget);
      expect(find.text('Clean up a beach for 10 min'), findsOneWidget);
      expect(find.text('Meditate daily for a week'), findsOneWidget);
    });

    testWidgets('renders Generate Action button', (tester) async {
      await pumpScreen(tester);

      expect(find.text(_l10n.actionGenerate), findsOneWidget);
    });

    testWidgets('renders microphone button', (tester) async {
      await pumpScreen(tester);

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('generate button is disabled when text is under 10 chars', (
      tester,
    ) async {
      await pumpScreen(tester);

      // Find the FilledButton inside the VFilledButton that contains
      // "Generate Action".
      final filledButton = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text(_l10n.actionGenerate),
          matching: find.byType(FilledButton),
        ),
      );

      // onPressed should be null (disabled) when text < 10 chars.
      expect(filledButton.onPressed, isNull);
    });

    testWidgets('generate button is enabled after entering 10+ chars', (
      tester,
    ) async {
      await pumpScreen(tester);

      // Enter 10+ characters into the text field.
      await tester.enterText(
        find.byType(TextField),
        'Do some push-ups at the park',
      );
      await tester.pump();

      final filledButton = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text(_l10n.actionGenerate),
          matching: find.byType(FilledButton),
        ),
      );

      // onPressed should be non-null (enabled) when text >= 10 chars.
      expect(filledButton.onPressed, isNotNull);
    });

    testWidgets('character count updates when text is entered', (tester) async {
      await pumpScreen(tester);

      // Initially: '10 more characters needed'
      expect(find.text('10 more characters needed'), findsOneWidget);

      // Enter 5 characters.
      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      expect(find.text('5 more characters needed'), findsOneWidget);

      // Enter 12 characters.
      await tester.enterText(find.byType(TextField), 'Hello World!');
      await tester.pump();

      expect(find.text('12 characters'), findsOneWidget);
    });

    testWidgets('tapping example chip populates text field', (tester) async {
      await pumpScreen(tester);

      // Scroll down to reveal example chips below the viewport.
      await tester.scrollUntilVisible(
        find.text('Do 50 push-ups at a park'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      // Tap the first example chip: "Do 50 push-ups at a park"
      await tester.tap(find.text('Do 50 push-ups at a park'));
      await tester.pump();

      // The text field should now contain the full prompt text.
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, contains('Do 50 push-ups at a park'));
      expect(textField.controller?.text, contains('full body reps'));

      // Character count should update and show enabled state.
      expect(find.textContaining('characters'), findsOneWidget);
      expect(find.textContaining('more characters needed'), findsNothing);
    });

    testWidgets('tapping example chip enables generate button', (tester) async {
      await pumpScreen(tester);

      // Scroll down to reveal example chips below the viewport.
      await tester.scrollUntilVisible(
        find.text('Clean up a beach for 10 min'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      // Tap an example chip.
      await tester.tap(find.text('Clean up a beach for 10 min'));
      await tester.pump();

      final filledButton = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text(_l10n.actionGenerate),
          matching: find.byType(FilledButton),
        ),
      );

      expect(filledButton.onPressed, isNotNull);
    });

    group('review view', () {
      late ProviderContainer reviewContainer;

      const testGeneratedAction = AiGeneratedAction(
        title: 'Plant a Tree',
        description: 'Plant a tree in your neighborhood.',
        actionType: 'one_off',
        verificationCriteria:
            '- Dig the hole\n- Plant the sapling\n- Water the tree',
        suggestedCategory: 'Environment',
        suggestedTags: ['green', 'community'],
      );

      setUp(() {
        reviewContainer = ProviderContainer(
          overrides: [
            aiActionGeneratorProvider.overrideWith(
              () => _FakeAiActionGenerator(initialValue: testGeneratedAction),
            ),
            createActionProvider.overrideWithValue(
              const AsyncData<vc.Action?>(null),
            ),
          ],
        );
      });

      tearDown(() {
        reviewContainer.dispose();
      });

      Future<void> pumpReviewScreen(WidgetTester tester) async {
        await tester.pumpAppL10n(
          const AiCreateActionScreen(),
          container: reviewContainer,
        );
        await tester.pumpAndSettle();
      }

      testWidgets('shows review view when AI generates an action', (
        tester,
      ) async {
        await pumpReviewScreen(tester);

        // The success banner should be visible.
        expect(
          find.text('AI generated your action! Review and edit below.'),
          findsOneWidget,
        );
      });

      testWidgets('review view displays generated title', (tester) async {
        await pumpReviewScreen(tester);

        expect(find.text('Plant a Tree'), findsOneWidget);
      });

      testWidgets('review view displays generated description', (tester) async {
        await pumpReviewScreen(tester);

        expect(find.text('Plant a tree in your neighborhood.'), findsOneWidget);
      });

      testWidgets('review view displays action type', (tester) async {
        await pumpReviewScreen(tester);

        expect(find.text('Type'), findsOneWidget);
        expect(find.text('one_off'), findsOneWidget);
      });

      testWidgets('review view displays category', (tester) async {
        await pumpReviewScreen(tester);

        expect(find.text(_l10n.actionCategory), findsOneWidget);
        expect(find.text('Environment'), findsOneWidget);
      });

      testWidgets('review view displays verification criteria', (tester) async {
        await pumpReviewScreen(tester);

        expect(find.text(_l10n.verificationCriteria), findsOneWidget);
        expect(find.text('Dig the hole'), findsOneWidget);
        expect(find.text('Plant the sapling'), findsOneWidget);
        expect(find.text('Water the tree'), findsOneWidget);
      });

      testWidgets('review view displays tags', (tester) async {
        await pumpReviewScreen(tester);

        // Scroll down to reveal tags section below the viewport.
        await tester.scrollUntilVisible(
          find.text(_l10n.actionTags),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pump();

        expect(find.text(_l10n.actionTags), findsOneWidget);
        expect(find.text('green'), findsOneWidget);
        expect(find.text('community'), findsOneWidget);
      });

      testWidgets('review view shows Edit Prompt and Create Action buttons', (
        tester,
      ) async {
        await pumpReviewScreen(tester);

        expect(find.text(_l10n.actionEditPrompt), findsOneWidget);
        expect(find.text(_l10n.createActionTitle), findsOneWidget);
      });

      testWidgets('review view does not show input form', (tester) async {
        await pumpReviewScreen(tester);

        // The input header and text field should not be visible.
        expect(find.text('Describe your action'), findsNothing);
        expect(find.text('Try saying:'), findsNothing);
      });
    });

    group('loading state', () {
      late ProviderContainer loadingContainer;

      setUp(() {
        loadingContainer = ProviderContainer(
          overrides: [
            aiActionGeneratorProvider.overrideWith(
              _LoadingAiActionGenerator.new,
            ),
            createActionProvider.overrideWithValue(
              const AsyncData<vc.Action?>(null),
            ),
          ],
        );
      });

      tearDown(() {
        loadingContainer.dispose();
      });

      testWidgets('generate button shows loading indicator', (tester) async {
        await tester.pumpAppL10n(
          const AiCreateActionScreen(),
          container: loadingContainer,
        );
        // Pump enough frames for flutter_animate entrance animations to
        // complete without using pumpAndSettle (which never settles when
        // CircularProgressIndicator is spinning).
        await tester.pump(const Duration(seconds: 2));

        // The button should be disabled (showing a loading indicator).
        // VFilledButton renders a CircularProgressIndicator when isLoading.
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('error state', () {
      late ProviderContainer errorContainer;

      setUp(() {
        errorContainer = ProviderContainer(
          overrides: [
            aiActionGeneratorProvider.overrideWith(_ErrorAiActionGenerator.new),
            createActionProvider.overrideWithValue(
              const AsyncData<vc.Action?>(null),
            ),
          ],
        );
      });

      tearDown(() {
        errorContainer.dispose();
      });

      testWidgets('shows error message when AI generation fails', (
        tester,
      ) async {
        await tester.pumpAppL10n(
          const AiCreateActionScreen(),
          container: errorContainer,
        );
        await tester.pumpAndSettle();

        // The error text may be below the visible viewport in the ListView,
        // so search including offstage widgets.
        expect(
          find.text(
            'AI generation failed. Check your connection and try again.',
            skipOffstage: false,
          ),
          findsOneWidget,
        );
      });
    });
  });
}
