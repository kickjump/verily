import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/analytics/posthog_analytics.dart';
import 'package:verily_app/src/features/actions/action_detail_screen.dart';
import 'package:verily_app/src/features/actions/ai_create_action_screen.dart';
import 'package:verily_app/src/features/actions/create_action_screen.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';
import 'package:verily_app/src/features/auth/login_screen.dart';
import 'package:verily_app/src/features/auth/register_screen.dart';
import 'package:verily_app/src/features/home/home_screen.dart';
import 'package:verily_app/src/features/map/map_screen.dart';
import 'package:verily_app/src/features/profile/edit_profile_screen.dart';
import 'package:verily_app/src/features/profile/profile_screen.dart';
import 'package:verily_app/src/features/profile/rewards_screen.dart';
import 'package:verily_app/src/features/profile/user_profile_screen.dart';
import 'package:verily_app/src/features/rewards/create_reward_pool_screen.dart';
import 'package:verily_app/src/features/rewards/reward_pool_detail_screen.dart';
import 'package:verily_app/src/features/search/search_screen.dart';
import 'package:verily_app/src/features/settings/settings_screen.dart';
import 'package:verily_app/src/features/submissions/submission_status_screen.dart';
import 'package:verily_app/src/features/submissions/verification_capture_screen.dart';
import 'package:verily_app/src/features/submissions/video_recording_screen.dart';
import 'package:verily_app/src/features/submissions/video_review_screen.dart';
import 'package:verily_app/src/features/wallet/wallet_screen.dart';
import 'package:verily_app/src/features/wallet/wallet_setup_screen.dart';
import 'package:verily_app/src/logging/navigation_observer.dart';
import 'package:verily_app/src/routing/route_names.dart';
import 'package:verily_app/src/routing/widgets/home_shell_scaffold.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Shared transition duration
// ---------------------------------------------------------------------------
const _kTransitionDuration = Duration(milliseconds: 300);

// ---------------------------------------------------------------------------
// Reusable page transition builders
// ---------------------------------------------------------------------------

/// Fade transition — used for auth screens and simple page swaps.
CustomTransitionPage<void> _fadePage({
  required Widget child,
  required GoRouterState state,
  Duration duration = _kTransitionDuration,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

/// Shared-axis vertical (slide up + fade) — used for detail screens.
CustomTransitionPage<void> _sharedAxisVerticalPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Slide from right + fade — used for linear flow screens (recording, review).
CustomTransitionPage<void> _slideRightPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.25, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Modal-style slide up from bottom — for creation / edit sheets.
CustomTransitionPage<void> _modalSlideUpPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Scale + fade — for result / status screens.
CustomTransitionPage<void> _scaleFadePage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Provides the application [GoRouter].
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.feedPath,
    debugLogDiagnostics: true,
    observers: [
      NavigationObserver(),
      if (isPosthogConfigured) PosthogObserver(),
    ],
    redirect: (context, state) {
      final isOnAuthRoute =
          state.matchedLocation == RouteNames.loginPath ||
          state.matchedLocation == RouteNames.registerPath;

      if (authState is AuthLoading) return null;

      final isLoggedIn = authState is Authenticated;
      if (!isLoggedIn && !isOnAuthRoute) {
        return RouteNames.loginPath;
      }
      if (isLoggedIn && isOnAuthRoute) {
        return RouteNames.feedPath;
      }

      return null;
    },
    routes: [
      // -----------------------------------------------------------------------
      // Bottom-tab shell — tabs use builder (handled by IndexedStack internally)
      // -----------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.feedPath,
                name: RouteNames.feed,
                pageBuilder: (context, state) =>
                    _fadePage(child: const HomeScreen(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.searchPath,
                name: RouteNames.search,
                pageBuilder: (context, state) =>
                    _fadePage(child: const SearchScreen(), state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profilePath,
                name: RouteNames.profile,
                pageBuilder: (context, state) =>
                    _fadePage(child: const ProfileScreen(), state: state),
              ),
            ],
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // Auth — fade transition (clean entry/exit)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        pageBuilder: (context, state) =>
            _fadePage(child: const LoginScreen(), state: state),
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.register,
        pageBuilder: (context, state) =>
            _fadePage(child: const RegisterScreen(), state: state),
      ),

      // -----------------------------------------------------------------------
      // Verification / Camera — slide from right (linear flow)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.verifyCapturePath,
        name: RouteNames.verifyCapture,
        pageBuilder: (context, state) => _slideRightPage(
          child: const VerificationCaptureScreen(),
          state: state,
        ),
      ),

      // -----------------------------------------------------------------------
      // Action detail — shared-axis vertical (drill-in from list)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.actionDetailPath,
        name: RouteNames.actionDetail,
        pageBuilder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return _sharedAxisVerticalPage(
            child: ActionDetailScreen(actionId: actionId),
            state: state,
          );
        },
      ),

      // -----------------------------------------------------------------------
      // Creation flows — modal slide up
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.createActionPath,
        name: RouteNames.createAction,
        pageBuilder: (context, state) =>
            _modalSlideUpPage(child: const CreateActionScreen(), state: state),
      ),
      GoRoute(
        path: RouteNames.aiCreateActionPath,
        name: RouteNames.aiCreateAction,
        pageBuilder: (context, state) => _modalSlideUpPage(
          child: const AiCreateActionScreen(),
          state: state,
        ),
      ),

      // -----------------------------------------------------------------------
      // Submission flow — slide from right (sequential steps)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.videoRecordingPath,
        name: RouteNames.videoRecording,
        pageBuilder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return _slideRightPage(
            child: VideoRecordingScreen(actionId: actionId),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RouteNames.videoReviewPath,
        name: RouteNames.videoReview,
        pageBuilder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          final videoPath = state.extra as String?;
          return _slideRightPage(
            child: VideoReviewScreen(actionId: actionId, videoPath: videoPath),
            state: state,
          );
        },
      ),

      // -----------------------------------------------------------------------
      // Submission status — scale + fade (result reveal)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.submissionStatusPath,
        name: RouteNames.submissionStatus,
        pageBuilder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          final submissionId = state.extra as int?;
          return _scaleFadePage(
            child: SubmissionStatusScreen(
              actionId: actionId,
              submissionId: submissionId,
            ),
            state: state,
          );
        },
      ),

      // -----------------------------------------------------------------------
      // Profile — modal slide up for edit, shared-axis for viewing others
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.editProfilePath,
        name: RouteNames.editProfile,
        pageBuilder: (context, state) =>
            _modalSlideUpPage(child: const EditProfileScreen(), state: state),
      ),
      GoRoute(
        path: RouteNames.userProfilePath,
        name: RouteNames.userProfile,
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return _sharedAxisVerticalPage(
            child: UserProfileScreen(userId: userId),
            state: state,
          );
        },
      ),

      // -----------------------------------------------------------------------
      // Rewards & Settings — shared-axis vertical
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.rewardsPath,
        name: RouteNames.rewards,
        pageBuilder: (context, state) =>
            _sharedAxisVerticalPage(child: const RewardsScreen(), state: state),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        pageBuilder: (context, state) => _sharedAxisVerticalPage(
          child: const SettingsScreen(),
          state: state,
        ),
      ),

      // -----------------------------------------------------------------------
      // Map — fade (spatial context switch)
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.mapPath,
        name: RouteNames.map,
        pageBuilder: (context, state) =>
            _fadePage(child: const MapScreen(), state: state),
      ),

      // -----------------------------------------------------------------------
      // Wallet — shared-axis vertical for main, slide right for setup flow
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.walletPath,
        name: RouteNames.wallet,
        pageBuilder: (context, state) =>
            _sharedAxisVerticalPage(child: const WalletScreen(), state: state),
      ),
      GoRoute(
        path: RouteNames.walletSetupPath,
        name: RouteNames.walletSetup,
        pageBuilder: (context, state) =>
            _slideRightPage(child: const WalletSetupScreen(), state: state),
      ),

      // -----------------------------------------------------------------------
      // Reward pools — modal slide up for creation, shared-axis for detail
      // -----------------------------------------------------------------------
      GoRoute(
        path: RouteNames.createRewardPoolPath,
        name: RouteNames.createRewardPool,
        pageBuilder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return _modalSlideUpPage(
            child: CreateRewardPoolScreen(actionId: actionId),
            state: state,
          );
        },
      ),
      GoRoute(
        path: RouteNames.rewardPoolDetailPath,
        name: RouteNames.rewardPoolDetail,
        pageBuilder: (context, state) {
          final poolId = state.pathParameters['poolId']!;
          return _sharedAxisVerticalPage(
            child: RewardPoolDetailScreen(poolId: poolId),
            state: state,
          );
        },
      ),
    ],
  );
}
