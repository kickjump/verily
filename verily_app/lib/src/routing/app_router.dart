import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/features/actions/action_detail_screen.dart';
import 'package:verily_app/src/features/actions/ai_create_action_screen.dart';
import 'package:verily_app/src/features/actions/create_action_screen.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';
import 'package:verily_app/src/features/auth/login_screen.dart';
import 'package:verily_app/src/features/auth/register_screen.dart';
import 'package:verily_app/src/features/home/home_screen.dart';
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

/// Provides the application [GoRouter].
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.feedPath,
    debugLogDiagnostics: true,
    observers: [NavigationObserver()],
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
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.searchPath,
                name: RouteNames.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profilePath,
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.verifyCapturePath,
        name: RouteNames.verifyCapture,
        builder: (context, state) => const VerificationCaptureScreen(),
      ),
      GoRoute(
        path: RouteNames.actionDetailPath,
        name: RouteNames.actionDetail,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return ActionDetailScreen(actionId: actionId);
        },
      ),
      GoRoute(
        path: RouteNames.createActionPath,
        name: RouteNames.createAction,
        builder: (context, state) => const CreateActionScreen(),
      ),
      GoRoute(
        path: RouteNames.aiCreateActionPath,
        name: RouteNames.aiCreateAction,
        builder: (context, state) => const AiCreateActionScreen(),
      ),
      GoRoute(
        path: RouteNames.videoRecordingPath,
        name: RouteNames.videoRecording,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return VideoRecordingScreen(actionId: actionId);
        },
      ),
      GoRoute(
        path: RouteNames.videoReviewPath,
        name: RouteNames.videoReview,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return VideoReviewScreen(actionId: actionId);
        },
      ),
      GoRoute(
        path: RouteNames.submissionStatusPath,
        name: RouteNames.submissionStatus,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return SubmissionStatusScreen(actionId: actionId);
        },
      ),
      GoRoute(
        path: RouteNames.editProfilePath,
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.userProfilePath,
        name: RouteNames.userProfile,
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return UserProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: RouteNames.rewardsPath,
        name: RouteNames.rewards,
        builder: (context, state) => const RewardsScreen(),
      ),
      GoRoute(
        path: RouteNames.settingsPath,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.walletPath,
        name: RouteNames.wallet,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: RouteNames.walletSetupPath,
        name: RouteNames.walletSetup,
        builder: (context, state) => const WalletSetupScreen(),
      ),
      GoRoute(
        path: RouteNames.createRewardPoolPath,
        name: RouteNames.createRewardPool,
        builder: (context, state) {
          final actionId = state.pathParameters['actionId']!;
          return CreateRewardPoolScreen(actionId: actionId);
        },
      ),
      GoRoute(
        path: RouteNames.rewardPoolDetailPath,
        name: RouteNames.rewardPoolDetail,
        builder: (context, state) {
          final poolId = state.pathParameters['poolId']!;
          return RewardPoolDetailScreen(poolId: poolId);
        },
      ),
    ],
  );
}
