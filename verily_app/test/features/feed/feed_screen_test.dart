// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/feed/feed_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

/// Mock actions used in feed tests.
final _mockActions = <vc.Action>[
  vc.Action(
    id: 1,
    title: 'Record 20 push-ups at a local park',
    description:
        'Head to any local park and record yourself doing 20 push-ups.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Show your full body in frame while doing all reps.',
    tags: 'fitness,outdoor,exercise',
    createdAt: DateTime(2025, 6, 15),
    updatedAt: DateTime(2025, 6, 15),
  ),
  vc.Action(
    id: 2,
    title: 'Capture a 30s cleanup clip on your street',
    description: 'Record yourself picking up litter on your street.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Record litter before and after cleanup.',
    tags: 'environment,community,cleanup',
    createdAt: DateTime(2025, 6, 14),
    updatedAt: DateTime(2025, 6, 14),
  ),
];

void main() {
  group('FeedScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpFeedScreen(WidgetTester tester) async {
      await tester.pumpApp(const FeedScreen(), container: container);
      // Wait for the async provider to resolve.
      await tester.pumpAndSettle();
    }

    testWidgets('renders Nearby tab', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text('Nearby'), findsOneWidget);
    });

    testWidgets('renders Trending tab', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text('Trending'), findsOneWidget);
    });

    testWidgets('renders FAB with Create Action label', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text('Create Action'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders app bar with Verily title', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text('Verily'), findsOneWidget);
    });

    testWidgets('renders search icon in app bar', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('renders notifications icon in app bar', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('renders action feed cards in list', (tester) async {
      await pumpFeedScreen(tester);

      // The feed list uses mock data with push-ups action.
      expect(find.textContaining('push-ups'), findsWidgets);
    });
  });
}
