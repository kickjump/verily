import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'common/patrol_helpers.dart';

// TODO(codegen): These tests use a minimal GoRouter setup that bypasses
// the full VerilyApp widget. Once localization codegen (`flutter gen-l10n`)
// and Riverpod codegen (`build_runner`) are complete, consider adding a
// variant that pumps `const VerilyApp()` directly inside a ProviderScope.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tab navigation -', () {
    testWidgets('bottom navigation has 3 tabs', (tester) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final shell = MainShellPage(tester);

      // The navigation bar itself should be present.
      expect(shell.navigationBar, findsOneWidget);

      // All three destination labels should be visible.
      expect(find.text('Feed'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // All three NavigationDestination widgets should exist.
      expect(
        find.descendant(
          of: shell.navigationBar,
          matching: find.byType(NavigationDestination),
        ),
        findsNWidgets(3),
      );
    });

    testWidgets('can switch to Search tab', (tester) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final shell = MainShellPage(tester);

      // Initially on the Feed tab — verify Feed content is present.
      final feedPage = FeedPage(tester);
      expect(feedPage.nearbyTab, findsOneWidget);

      // Switch to Search tab.
      await shell.tapSearchTab();

      // The search screen should now be visible with its hint text.
      expect(find.text('Search actions...'), findsOneWidget);
    });

    testWidgets('can switch to Profile tab', (tester) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final shell = MainShellPage(tester);

      // Switch to Profile tab.
      await shell.tapProfileTab();

      // The profile screen should be visible.
      final profilePage = ProfilePage(tester);
      expect(profilePage.displayName, findsOneWidget);
      expect(profilePage.username, findsOneWidget);
    });

    testWidgets('can switch between Feed, Search, and Profile tabs', (
      tester,
    ) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final shell = MainShellPage(tester);
      final feedPage = FeedPage(tester);
      final profilePage = ProfilePage(tester);

      // Start on Feed — verify Feed content.
      expect(feedPage.nearbyTab, findsOneWidget);
      expect(feedPage.createActionFab, findsOneWidget);

      // Switch to Search.
      await shell.tapSearchTab();
      expect(find.text('Search actions...'), findsOneWidget);

      // Switch to Profile.
      await shell.tapProfileTab();
      expect(profilePage.displayName, findsOneWidget);

      // Switch back to Feed.
      await shell.tapFeedTab();
      expect(feedPage.nearbyTab, findsOneWidget);
      expect(feedPage.createActionFab, findsOneWidget);
    });

    testWidgets('tapping current tab does not cause errors', (tester) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final shell = MainShellPage(tester);
      final feedPage = FeedPage(tester);

      // Feed is already active. Tapping it again should be a no-op.
      await shell.tapFeedTab();

      // Feed content should still be visible without errors.
      expect(feedPage.nearbyTab, findsOneWidget);
      expect(feedPage.createActionFab, findsOneWidget);
    });
  });
}
