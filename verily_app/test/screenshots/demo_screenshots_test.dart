// Golden screenshot tests for demo flows.
@Skip(
  'Requires platform plugin stubs (speech_to_text, connectivity_plus). '
  'Run locally with --update-goldens when plugins are mocked.',
)
library;

//
// Run with:
//   cd verily_app && flutter test --update-goldens test/screenshots/demo_screenshots_test.dart
//
// Generates golden PNGs in test/screenshots/goldens/ for each screen.
//
// NOTE: Screens using flutter_animate (ActionDetailScreen,
// SubmissionStatusScreen) have a compilation issue with .animate() extension
// and are excluded here. Those screenshots require the compilation fix first.
//
// ignore_for_file: scoped_providers_should_specify_dependencies
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/ai_create_action_screen.dart';
import 'package:verily_app/src/features/actions/create_action_screen.dart';
import 'package:verily_app/src/features/actions/providers/ai_action_provider.dart';
import 'package:verily_app/src/features/actions/providers/create_action_provider.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/feed/feed_screen.dart';
import 'package:verily_app/src/features/home/home_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_core/verily_core.dart';

import '../helpers/pump_app_l10n.dart';

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

final _mockActions = <vc.Action>[
  vc.Action(
    id: 1,
    title: 'Record 20 push-ups at a local park',
    description:
        'Head to any local park and record yourself doing 20 push-ups with '
        'proper form. This fitness challenge helps verify real-world activity.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Show your full body in frame while doing all reps\n'
        'Capture ambient park audio from start to finish\n'
        'Pan camera to a park sign before ending recording',
    tags: 'fitness,outdoor,exercise',
    createdAt: DateTime.utc(2025, 6, 15),
    updatedAt: DateTime.utc(2025, 6, 15),
  ),
  vc.Action(
    id: 2,
    title: 'Capture a 30s cleanup clip on your street',
    description:
        'Record yourself picking up litter on your street for 30 seconds. '
        'Help keep your neighborhood clean and earn rewards!',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Record litter before and after cleanup\n'
        'Keep gloves and collection bag visible in video\n'
        'Show street name sign in the first 10 seconds',
    tags: 'environment,community,cleanup',
    createdAt: DateTime.utc(2025, 6, 14),
    updatedAt: DateTime.utc(2025, 6, 14),
  ),
  vc.Action(
    id: 3,
    title: 'Meditate for 5 minutes in a quiet spot',
    description:
        'Find a peaceful location and record yourself meditating for '
        '5 minutes. Show the environment and your mindful practice.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Show a quiet environment\n'
        'Remain still for the full 5 minutes\n'
        'Capture ambient sounds',
    tags: 'wellness,mindfulness,health',
    createdAt: DateTime.utc(2025, 6, 13),
    updatedAt: DateTime.utc(2025, 6, 13),
  ),
];

// ---------------------------------------------------------------------------
// Fake providers
// ---------------------------------------------------------------------------

class _FakeAiActionGeneratorWithResult extends AiActionGenerator {
  @override
  AsyncValue<AiGeneratedAction?> build() => const AsyncData(
    AiGeneratedAction(
      title: 'Plant a Tree in Your Neighborhood',
      description:
          'Find a suitable spot in your neighborhood and plant a young '
          'tree sapling. Document the entire process from digging to '
          'watering.',
      actionType: 'one_off',
      verificationCriteria:
          '- Dig the hole to proper depth\n'
          '- Plant the sapling carefully\n'
          '- Water the tree thoroughly\n'
          '- Show the planted tree with surroundings',
      suggestedCategory: 'Environment',
      suggestedTags: ['green', 'community', 'sustainability'],
    ),
  );

  @override
  Future<void> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) async {}

  @override
  void reset() {}
}

class _FakeAiActionGeneratorEmpty extends AiActionGenerator {
  @override
  AsyncValue<AiGeneratedAction?> build() => const AsyncData(null);

  @override
  Future<void> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) async {}

  @override
  void reset() {}
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('Demo Screenshots', () {
    // -----------------------------------------------------------------------
    // 1. Home screen with actions
    // -----------------------------------------------------------------------
    testWidgets('01_home_screen', (tester) async {
      final container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpAppL10n(const HomeScreen(), container: container);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/01_home_screen.png'),
      );
    });

    // -----------------------------------------------------------------------
    // 2. Feed screen (Nearby tab)
    // -----------------------------------------------------------------------
    testWidgets('02_feed_screen', (tester) async {
      final container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpAppL10n(const FeedScreen(), container: container);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/02_feed_screen.png'),
      );
    });

    // -----------------------------------------------------------------------
    // 3. AI Create Action — input view
    // -----------------------------------------------------------------------
    testWidgets('03_ai_create_action_input', (tester) async {
      final container = ProviderContainer(
        overrides: [
          aiActionGeneratorProvider.overrideWith(
            _FakeAiActionGeneratorEmpty.new,
          ),
          createActionProvider.overrideWithValue(
            const AsyncData<vc.Action?>(null),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpAppL10n(
        const AiCreateActionScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/03_ai_create_action_input.png'),
      );
    });

    // -----------------------------------------------------------------------
    // 4. AI Create Action — review view (with generated action)
    // -----------------------------------------------------------------------
    testWidgets('04_ai_create_action_review', (tester) async {
      final container = ProviderContainer(
        overrides: [
          aiActionGeneratorProvider.overrideWith(
            _FakeAiActionGeneratorWithResult.new,
          ),
          createActionProvider.overrideWithValue(
            const AsyncData<vc.Action?>(null),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpAppL10n(
        const AiCreateActionScreen(),
        container: container,
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/04_ai_create_action_review.png'),
      );
    });

    // -----------------------------------------------------------------------
    // 5. Manual Create Action — Step 1 (Basic Info)
    // -----------------------------------------------------------------------
    testWidgets('05_manual_create_step1', (tester) async {
      await tester.pumpAppL10n(const CreateActionScreen());
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/05_manual_create_step1.png'),
      );
    });

    // -----------------------------------------------------------------------
    // 6. Manual Create Action — Step 2 (Verification) via Continue
    // -----------------------------------------------------------------------
    testWidgets('06_manual_create_step2', (tester) async {
      await tester.pumpAppL10n(const CreateActionScreen());
      await tester.pumpAndSettle();

      // Fill in required fields then advance to step 2
      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., Do 20 push-ups in the park'),
        'Record 20 push-ups at a local park',
      );
      await tester.pump();
      await tester.enterText(
        find.widgetWithText(
          TextFormField,
          'Describe what the performer needs to do...',
        ),
        'Head to any local park and record yourself doing 20 push-ups.',
      );
      await tester.pump();

      // Tap Continue
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/06_manual_create_step2.png'),
      );
    });
  });
}
