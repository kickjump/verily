import 'package:flutter/material.dart';
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

  group('Auth flow -', () {
    testWidgets('login screen renders on app start', (tester) async {
      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      final loginPage = LoginPage(tester);

      // Branding is visible.
      expect(loginPage.brandingTitle, findsOneWidget);
      expect(loginPage.tagline, findsOneWidget);

      // Input fields are present.
      expect(loginPage.emailField, findsOneWidget);
      expect(loginPage.passwordField, findsOneWidget);

      // Primary login button is present.
      expect(loginPage.loginButton, findsOneWidget);

      // Social login section is present.
      expect(loginPage.socialDivider, findsOneWidget);
      expect(loginPage.googleButton, findsOneWidget);
      expect(loginPage.appleButton, findsOneWidget);

      // Register link is visible.
      expect(loginPage.registerLink, findsOneWidget);
    });

    testWidgets('can navigate to register screen', (tester) async {
      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      final loginPage = LoginPage(tester);
      await loginPage.tapRegisterLink();

      // Should now be on the register screen.
      final registerPage = RegisterPage(tester);
      expect(registerPage.createAccountTitle, findsOneWidget);
      expect(registerPage.emailField, findsOneWidget);
    });

    testWidgets('register screen has required fields', (tester) async {
      await tester.pumpWidget(
        buildAuthApp(initialLocation: RouteNames.registerPath),
      );
      await tester.pumpAndSettle();

      final registerPage = RegisterPage(tester);

      // Title and step indicators.
      expect(registerPage.createAccountTitle, findsOneWidget);
      expect(registerPage.credentialsStepLabel, findsOneWidget);
      expect(registerPage.verifyStepLabel, findsOneWidget);

      // All three credential fields are present.
      expect(registerPage.emailField, findsOneWidget);
      expect(registerPage.passwordField, findsOneWidget);
      expect(registerPage.confirmPasswordField, findsOneWidget);

      // Continue button is present.
      expect(registerPage.continueButton, findsOneWidget);

      // Login link is present.
      expect(registerPage.loginPrompt, findsOneWidget);
      expect(registerPage.loginLink, findsOneWidget);
    });

    testWidgets('can navigate back to login from register', (tester) async {
      await tester.pumpWidget(
        buildAuthApp(initialLocation: RouteNames.registerPath),
      );
      await tester.pumpAndSettle();

      final registerPage = RegisterPage(tester);

      // Verify we are on the register screen.
      expect(registerPage.createAccountTitle, findsOneWidget);

      // Tap the "Log In" link to go back.
      await registerPage.tapLoginLink();

      // Should now be on the login screen.
      final loginPage = LoginPage(tester);
      expect(loginPage.brandingTitle, findsOneWidget);
      expect(loginPage.loginButton, findsOneWidget);
    });

    testWidgets('can navigate back to login using back button', (
      tester,
    ) async {
      // Start at login, then push to register (matching real app flow).
      await tester.pumpWidget(buildAuthApp());
      await tester.pumpAndSettle();

      final loginPage = LoginPage(tester);
      await loginPage.tapRegisterLink();

      final registerPage = RegisterPage(tester);
      expect(registerPage.createAccountTitle, findsOneWidget);

      // Tap the AppBar back button.
      await registerPage.tapBackButton();

      // Should be back on the login screen.
      expect(loginPage.brandingTitle, findsOneWidget);
      expect(loginPage.loginButton, findsOneWidget);
    });
  });
}
