/// Route name constants used throughout the Verily app.
///
/// These names are used both as GoRouter route names and as path segments.
abstract final class RouteNames {
  // ---------------------------------------------------------------------------
  // Bottom-tab shells
  // ---------------------------------------------------------------------------

  /// Feed tab — shows nearby and trending actions.
  static const String feed = 'feed';

  /// Search tab — discover actions by keyword or category.
  static const String search = 'search';

  /// Profile tab — current user profile.
  static const String profile = 'profile';

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// Login screen.
  static const String login = 'login';

  /// Registration screen.
  static const String register = 'register';

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Action detail screen.
  static const String actionDetail = 'actionDetail';

  /// Create-action flow.
  static const String createAction = 'createAction';

  /// AI-assisted action creation.
  static const String aiCreateAction = 'aiCreateAction';

  // ---------------------------------------------------------------------------
  // Submission flow
  // ---------------------------------------------------------------------------

  /// Quick verification capture flow from center tab.
  static const String verifyCapture = 'verifyCapture';

  /// Video recording screen.
  static const String videoRecording = 'videoRecording';

  /// Video review screen (before submitting).
  static const String videoReview = 'videoReview';

  /// Submission status screen (verifying / passed / failed).
  static const String submissionStatus = 'submissionStatus';

  // ---------------------------------------------------------------------------
  // Profile / Social
  // ---------------------------------------------------------------------------

  /// Edit own profile.
  static const String editProfile = 'editProfile';

  /// Another user's profile.
  static const String userProfile = 'userProfile';

  // ---------------------------------------------------------------------------
  // Wallet / Solana
  // ---------------------------------------------------------------------------

  /// Wallet management screen.
  static const String wallet = 'wallet';

  /// Initial wallet setup during onboarding.
  static const String walletSetup = 'walletSetup';

  // ---------------------------------------------------------------------------
  // Reward Pools
  // ---------------------------------------------------------------------------

  /// Create a reward pool for an action.
  static const String createRewardPool = 'createRewardPool';

  /// Reward pool detail screen.
  static const String rewardPoolDetail = 'rewardPoolDetail';

  // ---------------------------------------------------------------------------
  // Misc
  // ---------------------------------------------------------------------------

  /// Rewards & badges.
  static const String rewards = 'rewards';

  /// Settings screen.
  static const String settings = 'settings';

  // ---------------------------------------------------------------------------
  // Paths (full path segments for GoRouter)
  // ---------------------------------------------------------------------------

  static const String feedPath = '/feed';
  static const String searchPath = '/search';
  static const String profilePath = '/profile';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String actionDetailPath = '/action/:actionId';
  static const String createActionPath = '/action/create';
  static const String aiCreateActionPath = '/action/create/ai';
  static const String verifyCapturePath = '/verify';
  static const String videoRecordingPath = '/submissions/:actionId/record';
  static const String videoReviewPath = '/submissions/:actionId/review';
  static const String submissionStatusPath = '/submissions/:actionId/status';
  static const String editProfilePath = '/profile/edit';
  static const String userProfilePath = '/user/:userId';
  static const String walletPath = '/wallet';
  static const String walletSetupPath = '/wallet/setup';
  static const String createRewardPoolPath =
      '/action/:actionId/reward-pool/create';
  static const String rewardPoolDetailPath = '/reward-pool/:poolId';
  static const String rewardsPath = '/rewards';
  static const String settingsPath = '/settings';
}
