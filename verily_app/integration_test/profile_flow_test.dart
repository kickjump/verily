import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:verily_app/src/routing/route_names.dart';

import 'common/patrol_helpers.dart';

// TODO(codegen): These tests use a minimal GoRouter setup that bypasses
// the full VerilyApp widget. Once localization codegen (`flutter gen-l10n`)
// and Riverpod codegen (`build_runner`) are complete, consider adding a
// variant that pumps `const VerilyApp()` directly inside a ProviderScope.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile flow -', () {
    testWidgets('profile tab shows user info', (tester) async {
      await tester.pumpWidget(
        buildShellApp(initialLocation: RouteNames.profilePath),
      );
      await tester.pumpAndSettle();

      final profilePage = ProfilePage(tester);

      // Profile header is visible.
      expect(profilePage.appBarTitle, findsOneWidget);
      expect(profilePage.displayName, findsOneWidget);
      expect(profilePage.username, findsOneWidget);

      // Stats bar is visible with expected counts.
      expect(profilePage.statsBar, findsOneWidget);
      expect(profilePage.createdCount, findsOneWidget);
      expect(profilePage.completedCount, findsOneWidget);
      expect(profilePage.badgesCount, findsOneWidget);

      // Profile action buttons in the app bar.
      expect(profilePage.editButton, findsOneWidget);
      expect(profilePage.settingsButton, findsOneWidget);

      // Tab bar with Actions and Badges tabs.
      expect(profilePage.actionsTab, findsOneWidget);
      expect(profilePage.badgesTab, findsOneWidget);
    });

    testWidgets('can navigate to settings from profile', (tester) async {
      await tester.pumpWidget(
        buildShellApp(initialLocation: RouteNames.profilePath),
      );
      await tester.pumpAndSettle();

      final profilePage = ProfilePage(tester);

      // Tap the settings button.
      await profilePage.tapSettingsButton();

      // The stub settings screen should render.
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('can navigate to edit profile from profile', (tester) async {
      await tester.pumpWidget(
        buildShellApp(initialLocation: RouteNames.profilePath),
      );
      await tester.pumpAndSettle();

      final profilePage = ProfilePage(tester);

      // Tap the edit button.
      await profilePage.tapEditButton();

      // The stub edit profile screen should render.
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('profile shows Actions and Badges tabs', (tester) async {
      await tester.pumpWidget(
        buildShellApp(initialLocation: RouteNames.profilePath),
      );
      await tester.pumpAndSettle();

      final profilePage = ProfilePage(tester);

      // Both tabs should be visible.
      expect(profilePage.actionsTab, findsOneWidget);
      expect(profilePage.badgesTab, findsOneWidget);
    });
  });
}
