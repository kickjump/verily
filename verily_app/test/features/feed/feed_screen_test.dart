import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/feed/feed_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('FeedScreen', () {
    Future<void> pumpFeedScreen(WidgetTester tester) async {
      await tester.pumpApp(const FeedScreen());
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

      // The feed list uses placeholder data with 10 items.
      // At least the first few should be visible.
      expect(find.textContaining('push-ups'), findsWidgets);
    });
  });
}
