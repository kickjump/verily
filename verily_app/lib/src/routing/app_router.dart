import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/logging/navigation_observer.dart';
import 'package:verily_app/src/routing/route_names.dart';

part 'app_router.g.dart';

/// Placeholder screens — these will be replaced with real implementations.
///
/// Every widget extends [HookConsumerWidget] or [HookWidget] in production
/// code per the project convention. These placeholders use bare functions
/// wrapped in [Scaffold] so the router compiles before real screens exist.

Widget _placeholder(String label) {
  return Scaffold(body: Center(child: Text(label)));
}

/// Provides the application [GoRouter].
///
/// Auth redirect logic checks the session manager and pushes unauthenticated
/// users to the login screen.
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    initialLocation: RouteNames.feedPath,
    debugLogDiagnostics: true,
    observers: [NavigationObserver()],
    redirect: (context, state) {
      // TODO(auth): Check SessionManager.instance.isSignedIn and redirect
      // unauthenticated users to RouteNames.loginPath.
      //
      // final isLoggedIn = SessionManager.instance.isSignedIn;
      // final isOnAuth = state.matchedLocation == RouteNames.loginPath ||
      //     state.matchedLocation == RouteNames.registerPath;
      //
      // if (!isLoggedIn && !isOnAuth) return RouteNames.loginPath;
      // if (isLoggedIn && isOnAuth) return RouteNames.feedPath;
      return null;
    },
    routes: [
      // -----------------------------------------------------------------------
      // Bottom-tab shell
      // -----------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _ShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Feed tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.feedPath,
                name: RouteNames.feed,
                builder: (context, state) => _placeholder('Feed'),
              ),
            ],
          ),

          // Search tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.searchPath,
                name: RouteNames.search,
                builder: (context, state) => _placeholder('Search'),
              ),
            ],
          ),

          // Map tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.mapPath,
                name: RouteNames.map,
                builder: (context, state) => _placeholder('Map'),
              ),
            ],
          ),

          // Profile tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profilePath,
                name: RouteNames.profile,
                builder: (context, state) => _placeholder('Profile'),
              ),
            ],
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // Auth routes (full-screen, outside the shell)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => _placeholder('Login'),
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.register,
        builder: (context, state) => _placeholder('Register'),
      ),

      // -----------------------------------------------------------------------
      // Action routes
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.actionDetailPath,
        name: RouteNames.actionDetail,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return _placeholder('Action $actionId');
        },
      ),
      GoRoute(
        path: RouteNames.createActionPath,
        name: RouteNames.createAction,
        builder: (context, state) => _placeholder('Create Action'),
      ),

      // -----------------------------------------------------------------------
      // Submission flow
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.videoRecordingPath,
        name: RouteNames.videoRecording,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return _placeholder('Record Video for $actionId');
        },
      ),
      GoRoute(
        path: RouteNames.videoReviewPath,
        name: RouteNames.videoReview,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return _placeholder('Review Video for $actionId');
        },
      ),
      GoRoute(
        path: RouteNames.submissionStatusPath,
        name: RouteNames.submissionStatus,
        builder: (context, state) {
          final submissionId = state.pathParameters['submissionId']!;
          return _placeholder('Submission Status $submissionId');
        },
      ),

      // -----------------------------------------------------------------------
      // Profile / Social
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.editProfilePath,
        name: RouteNames.editProfile,
        builder: (context, state) => _placeholder('Edit Profile'),
      ),
      GoRoute(
        path: RouteNames.userProfilePath,
        name: RouteNames.userProfile,
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return _placeholder('User $userId');
        },
      ),

      // -----------------------------------------------------------------------
      // Misc
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.rewardsPath,
        name: RouteNames.rewards,
        builder: (context, state) => _placeholder('Rewards'),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (context, state) => _placeholder('Settings'),
      ),

      // -----------------------------------------------------------------------
      // Wallet / Solana
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.walletPath,
        name: RouteNames.wallet,
        builder: (context, state) => _placeholder('Wallet'),
      ),
      GoRoute(
        path: RouteNames.walletSetupPath,
        name: RouteNames.walletSetup,
        builder: (context, state) => _placeholder('Wallet Setup'),
      ),

      // -----------------------------------------------------------------------
      // Reward Pools
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.createRewardPoolPath,
        name: RouteNames.createRewardPool,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return _placeholder('Create Reward Pool for $actionId');
        },
      ),
      GoRoute(
        path: RouteNames.rewardPoolDetailPath,
        name: RouteNames.rewardPoolDetail,
        builder: (context, state) {
          final poolId = state.pathParameters['poolId']!;
          return _placeholder('Reward Pool $poolId');
        },
      ),
    ],
  );
}

/// Scaffold that hosts the [NavigationBar] for the bottom tabs.
class _ShellScaffold extends HookWidget {
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
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
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
