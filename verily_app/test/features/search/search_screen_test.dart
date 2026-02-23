import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/search/search_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('SearchScreen', () {
    Future<void> pumpSearchScreen(WidgetTester tester) async {
      await tester.pumpApp(const SearchScreen());
    }

    testWidgets('renders search text field with hint', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Search actions...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsWidgets);
    });

    testWidgets('renders All category filter chip', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('renders Fitness category filter chip', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Fitness'), findsOneWidget);
    });

    testWidgets('renders Environment category filter chip', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Environment'), findsOneWidget);
    });

    testWidgets('renders Community category filter chip', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Community'), findsOneWidget);
    });

    testWidgets('renders Education category filter chip', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Education'), findsOneWidget);
    });

    testWidgets('renders Wellness category filter chip', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Wellness'), findsOneWidget);
    });

    testWidgets('renders Creative category filter chip', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Creative'), findsOneWidget);
    });

    testWidgets('renders empty state when no query is entered', (tester) async {
      await pumpSearchScreen(tester);

      expect(find.text('Search for actions'), findsOneWidget);
      expect(
        find.text('Find actions by title, description, or category'),
        findsOneWidget,
      );
    });

    testWidgets('renders FilterChip widgets for categories', (tester) async {
      await pumpSearchScreen(tester);

      // There are 7 categories: All, Fitness, Environment, Community,
      // Education, Wellness, Creative.
      expect(find.byType(FilterChip), findsNWidgets(7));
    });
  });
}
