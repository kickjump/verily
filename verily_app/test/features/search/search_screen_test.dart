import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/search/search_provider.dart';
import 'package:verily_app/src/features/search/search_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('SearchScreen', () {
    final mockCategories = [
      vc.ActionCategory(name: 'All', sortOrder: 0),
      vc.ActionCategory(name: 'Fitness', sortOrder: 1),
      vc.ActionCategory(name: 'Environment', sortOrder: 2),
      vc.ActionCategory(name: 'Community', sortOrder: 3),
      vc.ActionCategory(name: 'Education', sortOrder: 4),
      vc.ActionCategory(name: 'Wellness', sortOrder: 5),
      vc.ActionCategory(name: 'Creative', sortOrder: 6),
    ];

    Future<void> pumpSearchScreen(WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          actionCategoriesProvider.overrideWith((ref) async => mockCategories),
        ],
      );
      await tester.pumpApp(const SearchScreen(), container: container);
      // Allow async provider to resolve.
      await tester.pumpAndSettle();
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
        find.text('Find actions by title, description, or tags'),
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
