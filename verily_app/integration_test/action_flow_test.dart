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

  group('Action flow -', () {
    testWidgets('create action FAB is visible on feed', (tester) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final feedPage = FeedPage(tester);

      // The FAB should be visible.
      expect(feedPage.createActionFab, findsOneWidget);
      expect(feedPage.createActionLabel, findsOneWidget);
    });

    testWidgets('feed has Nearby and Trending tabs', (tester) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final feedPage = FeedPage(tester);

      // Both tabs should be visible.
      expect(feedPage.nearbyTab, findsOneWidget);
      expect(feedPage.trendingTab, findsOneWidget);
    });

    testWidgets('can switch between Nearby and Trending tabs', (
      tester,
    ) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final feedPage = FeedPage(tester);

      // Tap Trending tab.
      await feedPage.tapTrendingTab();

      // Trending tab should still be visible (we're on it now).
      expect(feedPage.trendingTab, findsOneWidget);

      // Tap back to Nearby tab.
      await feedPage.tapNearbyTab();

      // Nearby tab should still be visible (we're on it now).
      expect(feedPage.nearbyTab, findsOneWidget);
    });

    testWidgets('action detail screen renders placeholder content', (
      tester,
    ) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final feedPage = FeedPage(tester);

      // Tap the create action FAB to navigate to the create action stub.
      await feedPage.tapCreateActionFab();

      // The stub screen should render the placeholder text.
      // TODO(screens): Update this assertion once the real CreateAction screen
      // is implemented to check for form fields instead.
      expect(find.text('Create Action'), findsOneWidget);
    });

    testWidgets('feed app bar has search and notifications buttons', (
      tester,
    ) async {
      await tester.pumpWidget(buildShellApp());
      await tester.pumpAndSettle();

      final feedPage = FeedPage(tester);

      // App bar title and action icons should be present.
      expect(feedPage.appBarTitle, findsOneWidget);
      expect(feedPage.notificationsButton, findsOneWidget);
    });
  });
}
