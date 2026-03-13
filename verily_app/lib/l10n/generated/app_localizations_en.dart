// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Verily';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get done => 'Done';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading…';

  @override
  String get error => 'Error';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout => 'Request timed out. Please try again.';

  @override
  String get errorNotFound => 'The requested resource was not found.';

  @override
  String get errorUnauthorized =>
      'You are not authorized to perform this action.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get confirm => 'Confirm';

  @override
  String get continueLabel => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get submit => 'Submit';

  @override
  String get edit => 'Edit';

  @override
  String get share => 'Share';

  @override
  String get report => 'Report';

  @override
  String get seeAll => 'See All';

  @override
  String get noResults => 'No results found.';

  @override
  String get emptyState => 'Nothing here yet.';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletTotalBalance => 'Total Balance';

  @override
  String walletCount(int count) {
    return '$count wallets';
  }

  @override
  String get walletSecureCustody => 'Secure custody';

  @override
  String get walletReceive => 'Receive';

  @override
  String get walletSend => 'Send';

  @override
  String get walletRefresh => 'Refresh';

  @override
  String get walletYourWallets => 'Your Wallets';

  @override
  String get walletNoWalletsYet => 'No wallets yet';

  @override
  String get walletCreateOrConnect =>
      'Create or connect a wallet to get started';

  @override
  String get walletAddWallet => 'Add Wallet';

  @override
  String get walletAddressCopied => 'Address copied';

  @override
  String get walletDefault => 'Default';

  @override
  String get walletTypeCustodial => 'Custodial';

  @override
  String get walletTypeExternal => 'External';

  @override
  String get walletLoadFailed => 'Failed to load wallets. Pull to refresh.';

  @override
  String get walletPortfolio => 'Portfolio';

  @override
  String get walletTokens => 'Tokens';

  @override
  String get walletNfts => 'NFTs';

  @override
  String get walletActivity => 'Activity';

  @override
  String get walletNoTokensYet => 'No tokens yet';

  @override
  String get walletNoTokensSubtitle => 'Complete actions to earn token rewards';

  @override
  String get walletNoNftsYet => 'No NFTs yet';

  @override
  String get walletNoNftsSubtitle => 'Earn NFT badges by completing actions';

  @override
  String get walletNoActivityYet => 'No activity yet';

  @override
  String get walletNoActivitySubtitle =>
      'Your transaction history will appear here';

  @override
  String get walletCreateCustodial => 'Create Custodial Wallet';

  @override
  String get walletLinkExternal => 'Link External Wallet';

  @override
  String get walletLinkWallet => 'Link Wallet';

  @override
  String get walletSolanaPublicKey => 'Solana Public Key';

  @override
  String get walletEnterWalletAddress => 'Enter your wallet address';

  @override
  String get walletLink => 'Link';

  @override
  String get walletReceiveSol => 'Receive SOL';

  @override
  String get walletYourWalletAddress => 'Your wallet address:';

  @override
  String get walletCopyAddress => 'Copy Address';

  @override
  String get walletMyVerilyWallet => 'My Verily Wallet';

  @override
  String get walletPublicKey => 'Public Key';

  @override
  String get walletEnterSolanaPublicKey => 'Enter your Solana public key';

  @override
  String get walletExternalWallet => 'External Wallet';

  @override
  String get walletSetUpTitle => 'Set Up Wallet';

  @override
  String get walletYourVerilyWallet => 'Your Verily Wallet';

  @override
  String get walletSetupDescription =>
      'Create a wallet to receive SOL, tokens, and NFT rewards for completing actions. You can also link an existing Solana wallet.';

  @override
  String get walletCreateWallet => 'Create Wallet';

  @override
  String get walletLinkExisting => 'Link Existing Wallet';

  @override
  String get walletSkipForNow => 'Skip for now';

  @override
  String get loginTitle => 'Log In';

  @override
  String get loginSubtitle => 'Welcome back to Verily';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Join the Verily community';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get displayName => 'Display Name';

  @override
  String get displayNameHint => 'How others see you';

  @override
  String get displayNameRequired => 'Display name is required.';

  @override
  String get login => 'Log In';

  @override
  String get register => 'Sign Up';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get forgotPasswordMessage =>
      'Enter your email and we\'ll send you a link to reset your password.';

  @override
  String get resetPasswordSent =>
      'Password reset email sent. Check your inbox.';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get hasAccountPrompt => 'Already have an account?';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get termsAndPrivacy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy.';

  @override
  String get feedTitle => 'Feed';

  @override
  String get feedNearby => 'Nearby';

  @override
  String get feedTrending => 'Trending';

  @override
  String get feedRecent => 'Recent';

  @override
  String get feedNoActions =>
      'No actions nearby. Explore trending actions instead!';

  @override
  String get feedNoNearbyActionsTitle => 'No actions nearby';

  @override
  String get feedNoNearbyActionsSubtitle =>
      'Enable location to see actions around you';

  @override
  String get feedNoTrendingActionsTitle => 'No trending actions';

  @override
  String get feedNoTrendingActionsSubtitle =>
      'Check back later for popular actions';

  @override
  String get feedLoadFailed => 'Failed to load actions';

  @override
  String get feedHeroTitle => 'Action radar online';

  @override
  String feedHeroMissionCount(int count) {
    return '$count missions ready near you';
  }

  @override
  String get feedLiveBadge => 'Live';

  @override
  String get feedVerificationReady => 'AI verification ready';

  @override
  String get feedEarnRewards => 'Earn rewards';

  @override
  String get feedStartCta => 'Start';

  @override
  String get feedRefreshing => 'Refreshing…';

  @override
  String get feedEndOfList => 'You\'ve reached the end.';

  @override
  String feedPostedBy(String username) {
    return 'Posted by $username';
  }

  @override
  String feedTimeAgo(String time) {
    return '$time ago';
  }

  @override
  String get searchTitle => 'Search';

  @override
  String get searchActions => 'Search Actions';

  @override
  String get searchHint => 'Try \"plant a tree\" or \"clean a beach\"';

  @override
  String get searchActionsPlaceholder => 'Search actions...';

  @override
  String get searchMapViewTooltip => 'Map view';

  @override
  String get searchDiscoverByKeywordOrCategory =>
      'Discover actions by keyword or category';

  @override
  String get searchEmptyTitle => 'Search for actions';

  @override
  String get searchEmptySubtitle =>
      'Find actions by title, description, or tags';

  @override
  String get searchFailed => 'Search failed';

  @override
  String searchNoResultsFor(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get searchResultOpenStatus => 'Open';

  @override
  String get searchCategories => 'Categories';

  @override
  String get searchNoResults => 'No actions match your search.';

  @override
  String get searchRecent => 'Recent Searches';

  @override
  String get searchClearRecent => 'Clear Recent';

  @override
  String get searchFilterTitle => 'Filters';

  @override
  String get searchFilterApply => 'Apply Filters';

  @override
  String get searchFilterReset => 'Reset';

  @override
  String get searchFilterDistance => 'Distance';

  @override
  String get searchFilterReward => 'Reward Amount';

  @override
  String get searchFilterType => 'Action Type';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
      zero: 'No results',
    );
    return '$_temp0';
  }

  @override
  String get actionDetailTitle => 'Action Detail';

  @override
  String get createActionTitle => 'Create Action';

  @override
  String get editActionTitle => 'Edit Action';

  @override
  String get actionTitle => 'Title';

  @override
  String get actionTitleHint => 'What needs to be done?';

  @override
  String get actionTitleRequired => 'Title is required.';

  @override
  String get actionDescription => 'Description';

  @override
  String get actionDescriptionHint => 'Describe the action in detail…';

  @override
  String get actionDescriptionRequired => 'Description is required.';

  @override
  String get actionCategory => 'Category';

  @override
  String get actionCategoryRequired => 'Please select a category.';

  @override
  String get actionLocation => 'Location';

  @override
  String get actionLocationHint => 'Where should this be done?';

  @override
  String get actionLocationRequired => 'Location is required.';

  @override
  String get actionRadius => 'Verification Radius';

  @override
  String get actionRadiusHint => 'How close must the performer be?';

  @override
  String get actionReward => 'Reward';

  @override
  String get actionRewardHint => 'Points or badge awarded on completion';

  @override
  String get actionRewardRequired => 'Reward is required.';

  @override
  String get actionType => 'Action Type';

  @override
  String get actionTypeOneOff => 'One-Off';

  @override
  String get actionTypeSequential => 'Sequential';

  @override
  String get actionTypeHabit => 'Habit';

  @override
  String get actionTypeOneOffDescription =>
      'A single action completed in one step.';

  @override
  String get actionTypeSequentialDescription =>
      'A multi-step action completed over time.';

  @override
  String get verificationCriteria => 'Verification Criteria';

  @override
  String get verificationCriteriaHint =>
      'What should the video show to pass verification?';

  @override
  String get verificationCriteriaRequired =>
      'Verification criteria are required.';

  @override
  String get actionSteps => 'Steps';

  @override
  String get actionAddStep => 'Add Step';

  @override
  String get actionRemoveStep => 'Remove Step';

  @override
  String actionStepNumber(int number) {
    return 'Step $number';
  }

  @override
  String get actionDeadline => 'Deadline';

  @override
  String get actionDeadlineHint => 'Optional completion deadline';

  @override
  String get actionMaxParticipants => 'Max Participants';

  @override
  String get actionMaxParticipantsHint => 'Leave empty for unlimited';

  @override
  String get actionCreated => 'Action created successfully!';

  @override
  String get actionUpdated => 'Action updated successfully!';

  @override
  String get actionDeleted => 'Action deleted.';

  @override
  String get actionDeleteConfirm =>
      'Are you sure you want to delete this action?';

  @override
  String actionParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
      zero: 'No participants',
    );
    return '$_temp0';
  }

  @override
  String actionSubmissions(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count submissions',
      one: '1 submission',
      zero: 'No submissions',
    );
    return '$_temp0';
  }

  @override
  String get submitVideoTitle => 'Submit Video';

  @override
  String get recordingTitle => 'Recording';

  @override
  String get recordVideo => 'Record Video';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get recordingInProgress => 'Recording in progress…';

  @override
  String recordingDuration(String minutes, String seconds) {
    return '$minutes:$seconds';
  }

  @override
  String get reviewVideoTitle => 'Review Video';

  @override
  String get reviewVideoPrompt => 'Review your video before submitting.';

  @override
  String get retakeVideo => 'Retake';

  @override
  String get submitVideo => 'Submit Video';

  @override
  String get submitForAiReview => 'Submit for AI Review';

  @override
  String get submitting => 'Submitting…';

  @override
  String get submissionSuccess => 'Video submitted for verification!';

  @override
  String get submissionFailed => 'Submission failed. Please try again.';

  @override
  String get cameraPermissionTitle => 'Camera Access Required';

  @override
  String get cameraPermissionMessage =>
      'Verily needs camera access to record video proof.';

  @override
  String get microphonePermissionTitle => 'Microphone Access Required';

  @override
  String get microphonePermissionMessage =>
      'Verily needs microphone access to record audio with your video.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get verifying => 'Verifying…';

  @override
  String get verificationPassed => 'Verification Passed';

  @override
  String get verificationFailed => 'Verification Failed';

  @override
  String get verificationPending => 'Pending Review';

  @override
  String get verificationProcessing => 'Processing';

  @override
  String get verificationError => 'Verification encountered an error.';

  @override
  String confidenceScore(int score) {
    return 'Confidence: $score%';
  }

  @override
  String get verificationFeedback => 'AI Feedback';

  @override
  String get verificationRetry => 'You can re-submit with a new video.';

  @override
  String get submissionStatusTitle => 'Submission Status';

  @override
  String get rewardsTitle => 'Rewards';

  @override
  String get badges => 'Badges';

  @override
  String get badgesEmpty =>
      'No badges earned yet. Complete actions to earn them!';

  @override
  String get points => 'Points';

  @override
  String pointsTotal(int count) {
    return '$count points';
  }

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String leaderboardRank(int rank) {
    return '#$rank';
  }

  @override
  String earnedAt(String date) {
    return 'Earned $date';
  }

  @override
  String rewardPoints(int count) {
    return '+$count points';
  }

  @override
  String rewardBadge(String name) {
    return 'Badge: $name';
  }

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLoadFailed => 'Failed to load profile';

  @override
  String get profileWalletSubtitle => 'View balances, tokens & NFTs';

  @override
  String get profileActionsTab => 'Actions';

  @override
  String get profileActionsLoadFailed => 'Failed to load actions';

  @override
  String get profileNoActionsYet => 'No actions yet';

  @override
  String get profileCompleteActionCta => 'Complete';

  @override
  String get profileActionStatusActive => 'Active';

  @override
  String get profileActionStatusCompleted => 'Completed';

  @override
  String get profileActionStatusClosed => 'Closed';

  @override
  String get profileRewardsLoadFailed => 'Failed to load rewards';

  @override
  String get profileNoRewardsYet => 'No rewards yet';

  @override
  String get profileNoRewardsSubtitle => 'Complete actions to earn rewards';

  @override
  String profileRewardNumber(int rewardId) {
    return 'Reward #$rewardId';
  }

  @override
  String profileRewardEarnedDate(String date) {
    return 'Earned $date';
  }

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get profileBio => 'Bio';

  @override
  String get profileBioHint => 'Tell others about yourself';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get profilePhotoChange => 'Change Photo';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get follow => 'Follow';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get actionsCreated => 'Actions Created';

  @override
  String get actionsCompleted => 'Actions Completed';

  @override
  String get profileUpdated => 'Profile updated successfully!';

  @override
  String profileFollowerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '1 follower',
      zero: 'No followers',
    );
    return '$_temp0';
  }

  @override
  String profileFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Following $count',
      one: 'Following 1',
      zero: 'Not following anyone',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsLightMode => 'Light Mode';

  @override
  String get settingsSystemMode => 'System Default';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsPush => 'Push Notifications';

  @override
  String get settingsNotificationsEmail => 'Email Notifications';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPrivacyProfile => 'Public Profile';

  @override
  String get settingsPrivacyLocation => 'Share Location';

  @override
  String get settingsAbout => 'About';

  @override
  String settingsAboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsAboutLicenses => 'Open-Source Licenses';

  @override
  String get settingsAboutTerms => 'Terms of Service';

  @override
  String get settingsAboutPrivacy => 'Privacy Policy';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteAccountConfirm =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get locationNearby => 'Nearby';

  @override
  String get mapSearchPlacesHint => 'Search places...';

  @override
  String get mapDiscoverNearbyHint =>
      'Move map or search to discover nearby missions';

  @override
  String mapActionsInView(int count) {
    return '$count actions in view';
  }

  @override
  String mapRadiusKm(int radius) {
    return '$radius km';
  }

  @override
  String get mapNoActionsNearbyZoomOut => 'No actions nearby. Try zooming out.';

  @override
  String get mapRecenterTooltip => 'Re-center';

  @override
  String locationDistance(String distance) {
    return '$distance away';
  }

  @override
  String locationWithinRadius(String radius) {
    return 'Within $radius';
  }

  @override
  String get locationPermissionTitle => 'Location Access Required';

  @override
  String get locationPermissionMessage =>
      'Verily uses your location to show nearby actions and verify submissions.';

  @override
  String get locationPermissionDenied =>
      'Location permission denied. Some features may be unavailable.';

  @override
  String get locationServiceDisabled =>
      'Location services are disabled. Enable them in settings.';

  @override
  String get locationUpdating => 'Updating location…';

  @override
  String get homeTitle => 'Home';

  @override
  String get actionDetailsTitle => 'Action Details';

  @override
  String get actionInvalidId => 'Invalid action ID';

  @override
  String get actionLoadFailed => 'Failed to load action';

  @override
  String get actionTags => 'Tags';

  @override
  String get actionMaxPerformers => 'Max Performers';

  @override
  String get actionTotalSteps => 'Total Steps';

  @override
  String get actionSubmitVideo => 'Submit Video';

  @override
  String get actionDuration => 'Duration';

  @override
  String get actionFrequency => 'Frequency';

  @override
  String get actionCreatedLabel => 'Created';

  @override
  String get actionLinkCopiedToClipboard => 'Link copied to clipboard';

  @override
  String get actionCreateWithAi => 'Create with AI';

  @override
  String get actionCreateManual => 'Manual';

  @override
  String get actionDescribePrompt => 'Describe the action';

  @override
  String get actionGenerate => 'Generate Action';

  @override
  String get actionEditPrompt => 'Edit Prompt';

  @override
  String get actionStop => 'Stop';

  @override
  String get actionCreateFailedRetry =>
      'Failed to create action. Please try again.';

  @override
  String get actionLocationName => 'Location Name';

  @override
  String get actionMaxPerformersOptional => 'Max Performers (optional)';

  @override
  String get actionLocationExample => 'e.g., Central Park';

  @override
  String get actionTitleExample => 'e.g., Do 20 push-ups in the park';

  @override
  String get actionDescriptionPerformerHint =>
      'Describe what the performer needs to do...';

  @override
  String get authGoogle => 'Google';

  @override
  String get authApple => 'Apple';

  @override
  String get gateAboutVerily => 'About Verily';

  @override
  String get gateActionFailedPleaseTryAgain =>
      'Action failed. Please try again.';

  @override
  String get gateActions => 'Actions';

  @override
  String get gateAmountEachPerformerReceives =>
      'Amount each performer receives';

  @override
  String get gateAppearance => 'Appearance';

  @override
  String get gateAtLeast8Characters => 'At least 8 characters';

  @override
  String get gateAudio => 'Audio';

  @override
  String get gateAvailable => 'Available';

  @override
  String get gateBackToFeed => 'Back to Feed';

  @override
  String get gateBlockUser => 'Block user';

  @override
  String get gateBrowseMoreActions => 'Browse more actions';

  @override
  String get gateCancelPool => 'Cancel Pool';

  @override
  String get gateCancelPool_2 => 'Cancel Pool?';

  @override
  String get gateCaptureA30sCleanupClipOnYourStreet =>
      'Capture a 30s cleanup clip on your street';

  @override
  String get gateChooseAUniqueUsername => 'Choose a unique username';

  @override
  String get gateCleanUpABeachFor10Min => 'Clean up a beach for 10 min';

  @override
  String get gateClear => 'Clear';

  @override
  String get gateComplete => 'Complete';

  @override
  String get gateContinueToVideoCapture => 'Continue to Video Capture';

  @override
  String get gateCreateRewardPool => 'Create Reward Pool';

  @override
  String get gateCredentials => 'Credentials';

  @override
  String get gateDo50PushUpsAtAPark => 'Do 50 push-ups at a park';

  @override
  String get gateEnterSplTokenMintAddress => 'Enter SPL token mint address';

  @override
  String get gateFailedToCreateRewardPoolPleaseTryAgain =>
      'Failed to create reward pool. Please try again.';

  @override
  String get gateFailedToLoadDistributions => 'Failed to load distributions';

  @override
  String get gateFailedToOpenCameraPleaseTryAgain =>
      'Failed to open camera. Please try again.';

  @override
  String get gateFailedToSaveProfilePleaseTryAgain =>
      'Failed to save profile. Please try again.';

  @override
  String get gateFailedToSubmitVideoPleaseTryAgain =>
      'Failed to submit video. Please try again.';

  @override
  String get gateFileSize => 'File Size';

  @override
  String get gateFilmA1MinuteKindnessAction =>
      'Film a 1 minute kindness action';

  @override
  String get gateFundCreatePool => 'Fund & Create Pool';

  @override
  String get gateKeep => 'Keep';

  @override
  String get gateLive => 'Live';

  @override
  String get gateLocationSharing => 'Location Sharing';

  @override
  String get gateLogLocation => 'Log Location';

  @override
  String get gateMapView => 'Map view';

  @override
  String get gateMaxRecipientsOptional => 'Max Recipients (optional)';

  @override
  String get gateMeditateDailyForAWeek => 'Meditate daily for a week';

  @override
  String get gateMorningMeditation7DayStreak =>
      'Morning meditation - 7 day streak';

  @override
  String get gateNft => 'NFT';

  @override
  String get gateNoActionsNearbyTryZoomingOut =>
      'No actions nearby. Try zooming out.';

  @override
  String get gateOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get gateOpenVerification => 'Open Verification';

  @override
  String get gateOpenVerificationCapture => 'Open verification capture';

  @override
  String get gatePerPersonAmount => 'Per Person Amount';

  @override
  String get gatePleaseEnterATokenMintAddress =>
      'Please enter a token mint address.';

  @override
  String get gatePleaseEnterAValidPerPersonAmount =>
      'Please enter a valid per-person amount.';

  @override
  String get gatePleaseEnterAValidTotalAmount =>
      'Please enter a valid total amount.';

  @override
  String get gatePoolWillRemainActiveUntilDepleted =>
      'Pool will remain active until depleted';

  @override
  String get gateReCenter => 'Re-center';

  @override
  String get gateRecord20PushUpsAtALocalPark =>
      'Record 20 push-ups at a local park';

  @override
  String get gateReportSubmitted => 'Report submitted.';

  @override
  String get gateReportUser => 'Report user';

  @override
  String get gateResendCode => 'Resend Code';

  @override
  String get gateRewardPool => 'Reward Pool';

  @override
  String get gateRewardType => 'Reward Type';

  @override
  String get gateSol => 'SOL';

  @override
  String get gateSearchActions => 'Search actions...';

  @override
  String get gateSearchPlaces => 'Search places...';

  @override
  String get gateSelectAnActionBeforeStartingVerification =>
      'Select an action before starting verification.';

  @override
  String get gateSetExpiryDate => 'Set Expiry Date';

  @override
  String get gateStart => 'Start';

  @override
  String get gateStopRecordingBeforeSubmittingForReview =>
      'Stop recording before submitting for review.';

  @override
  String get gateStreak => 'Streak';

  @override
  String get gateTellOthersAboutYourself => 'Tell others about yourself...';

  @override
  String get gateToken => 'Token';

  @override
  String get gateTokenMintAddress => 'Token Mint Address';

  @override
  String get gateTryAgain => 'Try Again';

  @override
  String get gateType => 'Type';

  @override
  String get gateUserBlocked => 'User blocked.';

  @override
  String get gateUsername => 'Username';

  @override
  String get gateVerificationCapture => 'Verification Capture';

  @override
  String get gateVerificationCode => 'Verification Code';

  @override
  String get gateVerify => 'Verify';

  @override
  String get gateVideo => 'Video';

  @override
  String get gateViewDetails => 'View Details';

  @override
  String get gateVisit3LocalCoffeeShopsAndReview =>
      'Visit 3 local coffee shops and review';

  @override
  String get gateYourPublicName => 'Your public name';
}
