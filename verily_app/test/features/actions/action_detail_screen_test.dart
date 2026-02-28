// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/actions/action_detail_screen.dart';
import 'package:verily_app/src/features/actions/providers/action_detail_provider.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('ActionDetailScreen', () {
    late vc.Action testAction;
    late ProviderContainer container;

    setUp(() {
      testAction = vc.Action(
        id: 1,
        title: 'Do 20 push-ups in the park',
        description:
            'Head to any local park and record yourself doing 20 push-ups.',
        creatorId: vc.UuidValue.fromString(
          '00000000-0000-0000-0000-000000000001',
        ),
        actionType: 'one_off',
        status: 'active',
        verificationCriteria:
            '- Full body visible in frame during all push-ups\n'
            '- Must complete 20 consecutive push-ups\n'
            '- Park environment clearly visible in background\n'
            '- Proper push-up form (chest to ground, full extension)',
        tags: 'Fitness,outdoor,exercise',
        maxPerformers: 50,
        locationId: 1,
        locationRadius: 500,
        createdAt: DateTime(2025, 6, 15),
        updatedAt: DateTime(2025, 6, 15),
      );

      container = ProviderContainer(
        overrides: [
          actionDetailProvider.overrideWith(
            (ref, actionId) async => testAction,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpActionDetailScreen(WidgetTester tester) async {
      await tester.pumpApp(
        const ActionDetailScreen(actionId: '1'),
        container: container,
      );
      // Wait for the async provider to resolve.
      await tester.pumpAndSettle();
    }

    testWidgets('renders action title', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Do 20 push-ups in the park'), findsOneWidget);
    });

    testWidgets('renders Action Details app bar title', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Action Details'), findsOneWidget);
    });

    testWidgets('renders Submit Video button', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Submit Video'), findsOneWidget);
      expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
    });

    testWidgets('renders Verification Criteria section header', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Verification Criteria'), findsOneWidget);
      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
    });

    testWidgets('renders verification criteria items', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(
        find.text('Full body visible in frame during all push-ups'),
        findsOneWidget,
      );
      expect(
        find.text('Must complete 20 consecutive push-ups'),
        findsOneWidget,
      );
      expect(
        find.text('Park environment clearly visible in background'),
        findsOneWidget,
      );
      expect(
        find.text('Proper push-up form (chest to ground, full extension)'),
        findsOneWidget,
      );
    });

    testWidgets('renders Location section', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Location set'), findsOneWidget);
      expect(find.text('Within 500m radius'), findsOneWidget);
    });

    testWidgets('renders category and type badges', (tester) async {
      await pumpActionDetailScreen(tester);

      // 'Fitness' appears both in the category badge and in the Tags section.
      expect(find.text('Fitness'), findsNWidgets(2));
      expect(find.text('One-Off'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('renders share action in app bar', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets('renders metadata rows', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Max Performers'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('renders created date', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Created'), findsOneWidget);
      expect(find.text('Jun 15, 2025'), findsOneWidget);
    });
  });
}
