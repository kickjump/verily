import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';
import 'package:verily_app/src/features/auth/login_screen.dart';
import 'package:verily_app/src/features/auth/register_screen.dart';
import 'package:verily_app/src/features/feed/feed_screen.dart';
import 'package:verily_app/src/features/profile/profile_screen.dart';
import 'package:verily_app/src/features/search/search_screen.dart';
import 'package:verily_app/src/routing/route_names.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Pumps until [finder] evaluates to at least one widget, or throws after
/// [timeout].
Future<void> waitForFinder(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  const step = Duration(milliseconds: 200);
  var elapsed = Duration.zero;
  while (elapsed < timeout) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
    elapsed += step;
  }
  throw StateError('Timed out waiting for finder: $finder');
}

// ---------------------------------------------------------------------------
// App bootstrapping
// ---------------------------------------------------------------------------

/// Builds a minimal Verily app routed to auth screens for testing.
///
/// The [initialLocation] defaults to the login screen. The auth provider
/// is overridden to [Unauthenticated] so the redirect guard (once enabled)
/// keeps users on the auth flow.
Widget buildAuthApp({String initialLocation = RouteNames.loginPath}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      // Stub route so GoRouter does not throw when auth redirects to /feed.
      GoRoute(
        path: RouteNames.feedPath,
        name: RouteNames.feed,
        builder: (_, __) => const Scaffold(body: Center(child: Text('Feed'))),
      ),
    ],
  );

  return ProviderScope(
    overrides: [authProvider.overrideWith(_IntegrationTestAuth.new)],
    child: MaterialApp.router(
      theme: ThemeData.light(useMaterial3: true),
      routerConfig: router,
    ),
  );
}

class _IntegrationTestAuth extends Auth {
  @override
  AuthState build() => const Unauthenticated();

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> loginWithGoogle() async {}

  @override
  Future<void> loginWithApple() async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {}
}

/// Builds the main shell app with bottom navigation for tab testing.
///
/// Uses the real [FeedScreen], [SearchScreen], and [ProfileScreen] wrapped
/// in a [StatefulShellRoute.indexedStack], matching the production router
/// structure.
Widget buildShellApp({String initialLocation = RouteNames.feedPath}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.feedPath,
                name: RouteNames.feed,
                builder: (_, __) => const FeedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.searchPath,
                name: RouteNames.search,
                builder: (_, __) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profilePath,
                name: RouteNames.profile,
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      // Stub routes for push targets that screens reference.
      GoRoute(
        path: RouteNames.createActionPath,
        name: RouteNames.createAction,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Create Action'))),
      ),
      GoRoute(
        path: RouteNames.actionDetailPath,
        name: RouteNames.actionDetail,
        builder: (_, state) => Scaffold(
          body: Center(
            child: Text('Action Detail ${state.pathParameters["actionId"]}'),
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.editProfilePath,
        name: RouteNames.editProfile,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Edit Profile'))),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (_, __) =>
            const Scaffold(body: Center(child: Text('Settings'))),
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(
      theme: ThemeData.light(useMaterial3: true),
      routerConfig: router,
    ),
  );
}

// ---------------------------------------------------------------------------
// Shell scaffold (mirrors production _ShellScaffold)
// ---------------------------------------------------------------------------

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Page objects
// ---------------------------------------------------------------------------

/// Page object for the login screen.
class LoginPage {
  LoginPage(this.tester);

  final WidgetTester tester;

  /// The email text field (first TextField on the login screen).
  Finder get emailField => find.byType(TextField).at(0);

  /// The password text field (second TextField on the login screen).
  Finder get passwordField => find.byType(TextField).at(1);

  /// The primary "Log In" filled button.
  Finder get loginButton => find.widgetWithText(FilledButton, 'Log In');

  /// The "Sign Up" text button that navigates to the register screen.
  Finder get registerLink => find.widgetWithText(TextButton, 'Sign Up');

  /// The Google social login button.
  Finder get googleButton => find.widgetWithText(OutlinedButton, 'Google');

  /// The Apple social login button.
  Finder get appleButton => find.widgetWithText(OutlinedButton, 'Apple');

  /// The "or continue with" divider text.
  Finder get socialDivider => find.text('or continue with');

  /// The app branding title.
  Finder get brandingTitle => find.text('Verily');

  /// The app tagline.
  Finder get tagline => find.text('Verify real-world actions with AI');

  /// Enter credentials and tap the login button.
  Future<void> signIn(String email, String password) async {
    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);
    await tester.tap(loginButton);
    // Wait for async login + potential GoRouter redirect.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  /// Navigate to the register screen by tapping the "Sign Up" link.
  Future<void> tapRegisterLink() async {
    await tester.ensureVisible(registerLink);
    await tester.tap(registerLink);
    await tester.pumpAndSettle();
  }
}

/// Page object for the register screen.
class RegisterPage {
  RegisterPage(this.tester);

  final WidgetTester tester;

  /// The email field (first TextFormField with "Email" label).
  Finder get emailField => find.widgetWithText(TextFormField, 'Email');

  /// The password field (TextFormField with "Password" label).
  Finder get passwordField => find.widgetWithText(TextFormField, 'Password');

  /// The confirm password field (TextFormField with "Confirm Password" label).
  Finder get confirmPasswordField =>
      find.widgetWithText(TextFormField, 'Confirm Password');

  /// The "Continue" filled button on the credentials step.
  Finder get continueButton => find.widgetWithText(FilledButton, 'Continue');

  /// The "Create Account" filled button on the verification step.
  Finder get createAccountButton =>
      find.widgetWithText(FilledButton, 'Create Account');

  /// The "Log In" text button that navigates back to the login screen.
  Finder get loginLink => find.widgetWithText(TextButton, 'Log In');

  /// The "Already have an account?" prompt text.
  Finder get loginPrompt => find.text('Already have an account?');

  /// The app bar title on the credentials step.
  Finder get createAccountTitle => find.text('Create Account');

  /// The app bar title on the verification step.
  Finder get verifyEmailTitle => find.text('Verify Email');

  /// The step 1 label.
  Finder get credentialsStepLabel => find.text('Credentials');

  /// The step 2 label.
  Finder get verifyStepLabel => find.text('Verify');

  /// The back button in the app bar.
  Finder get backButton => find.byIcon(Icons.arrow_back);

  /// Navigate back to the login screen by tapping the "Log In" link.
  Future<void> tapLoginLink() async {
    await tester.ensureVisible(loginLink);
    await tester.tap(loginLink);
    await tester.pumpAndSettle();
  }

  /// Navigate back using the AppBar back button.
  Future<void> tapBackButton() async {
    await tester.ensureVisible(backButton);
    await tester.tap(backButton);
    await tester.pumpAndSettle();
  }
}

/// Page object for the feed screen.
class FeedPage {
  FeedPage(this.tester);

  final WidgetTester tester;

  /// The "Nearby" tab in the feed tab bar.
  Finder get nearbyTab => find.text('Nearby');

  /// The "Trending" tab in the feed tab bar.
  Finder get trendingTab => find.text('Trending');

  /// The "Create Action" floating action button.
  Finder get createActionFab => find.byType(FloatingActionButton);

  /// The FAB label text.
  Finder get createActionLabel => find.text('Create Action');

  /// The app bar title.
  Finder get appBarTitle => find.text('Verily');

  /// The search icon button in the app bar.
  Finder get searchButton => find.byIcon(Icons.search).first;

  /// The notifications icon button in the app bar.
  Finder get notificationsButton => find.byIcon(Icons.notifications_outlined);

  /// Tap the Nearby tab.
  Future<void> tapNearbyTab() async {
    await tester.tap(nearbyTab);
    await tester.pumpAndSettle();
  }

  /// Tap the Trending tab.
  Future<void> tapTrendingTab() async {
    await tester.tap(trendingTab);
    await tester.pumpAndSettle();
  }

  /// Tap the Create Action FAB.
  Future<void> tapCreateActionFab() async {
    await tester.tap(createActionFab);
    await tester.pumpAndSettle();
  }
}

/// Page object for the profile screen.
class ProfilePage {
  ProfilePage(this.tester);

  final WidgetTester tester;

  /// The app bar title.
  Finder get appBarTitle => find.widgetWithText(AppBar, 'Profile');

  /// The edit profile icon button in the app bar.
  Finder get editButton => find.byIcon(Icons.edit_outlined);

  /// The settings icon button in the app bar.
  Finder get settingsButton => find.byIcon(Icons.settings_outlined);

  /// The display name text.
  Finder get displayName => find.text('John Doe');

  /// The username text.
  Finder get username => find.text('@johndoe');

  /// The stats bar (the VCard containing Created/Completed/Badges stats).
  Finder get statsBar => find.byIcon(Icons.add_circle_outline);

  /// The "Created" stat count.
  Finder get createdCount => find.text('12');

  /// The "Completed" stat count.
  Finder get completedCount => find.text('28');

  /// The "Badges" stat count.
  Finder get badgesCount => find.text('7');

  /// The "Actions" tab.
  Finder get actionsTab => find.widgetWithText(Tab, 'Actions');

  /// The "Badges" tab.
  Finder get badgesTab => find.widgetWithText(Tab, 'Badges');

  /// Tap the edit profile button.
  Future<void> tapEditButton() async {
    await tester.tap(editButton);
    await tester.pumpAndSettle();
  }

  /// Tap the settings button.
  Future<void> tapSettingsButton() async {
    await tester.tap(settingsButton);
    await tester.pumpAndSettle();
  }
}

/// Page object for the bottom navigation shell.
class MainShellPage {
  MainShellPage(this.tester);

  final WidgetTester tester;

  /// The bottom navigation bar widget.
  Finder get navigationBar => find.byType(NavigationBar);

  /// The Feed tab in the bottom navigation.
  Finder get feedTab => _destination(Icons.home, Icons.home_outlined);

  /// The Search tab in the bottom navigation.
  Finder get searchTab => _destination(Icons.search, Icons.search_outlined);

  /// The Profile tab in the bottom navigation.
  Finder get profileTab => _destination(Icons.person, Icons.person_outline);

  /// Tap the Feed tab.
  Future<void> tapFeedTab() async {
    await tester.tap(feedTab);
    await tester.pumpAndSettle();
  }

  /// Tap the Search tab.
  Future<void> tapSearchTab() async {
    await tester.tap(searchTab);
    await tester.pumpAndSettle();
  }

  /// Tap the Profile tab.
  Future<void> tapProfileTab() async {
    await tester.tap(profileTab);
    await tester.pumpAndSettle();
  }

  /// Locates a [NavigationDestination] by its selected or unselected icon.
  Finder _destination(IconData selectedIcon, IconData unselectedIcon) {
    final selected = find.descendant(
      of: navigationBar,
      matching: find.byIcon(selectedIcon),
    );
    if (selected.evaluate().isNotEmpty) {
      return selected.first;
    }
    final unselected = find.descendant(
      of: navigationBar,
      matching: find.byIcon(unselectedIcon),
    );
    if (unselected.evaluate().isNotEmpty) {
      return unselected.first;
    }
    // Fallback: return the first NavigationDestination.
    return find
        .descendant(
          of: navigationBar,
          matching: find.byType(NavigationDestination),
        )
        .first;
  }
}
