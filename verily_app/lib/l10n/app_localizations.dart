import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The application name.
  ///
  /// In en, this message translates to:
  /// **'Verily'**
  String get appName;

  /// Generic confirmation label.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Generic cancel label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic save label.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Generic delete label.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Generic done label.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Generic close label.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Generic retry label.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Generic loading indicator text.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// Generic error label.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Fallback error message.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Network connectivity error.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNetwork;

  /// Request timeout error.
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// 404 error message.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get errorNotFound;

  /// 401/403 error message.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action.'**
  String get errorUnauthorized;

  /// Generic yes label.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Generic no label.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Generic confirm label.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Generic continue label.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// Generic back navigation label.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Generic next label.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Generic skip label.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Generic submit label.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// Generic edit label.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Generic share label.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Generic report label.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// Label to view all items in a list.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Empty state when a search has zero results.
  ///
  /// In en, this message translates to:
  /// **'No results found.'**
  String get noResults;

  /// Generic empty state message.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get emptyState;

  /// Snackbar message when content is copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Login screen title.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginTitle;

  /// Login screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to Verily'**
  String get loginSubtitle;

  /// Registration screen title.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// Registration screen subtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the Verily community'**
  String get registerSubtitle;

  /// Email field label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Email field hint text.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// Validation: email empty.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailRequired;

  /// Validation: email format.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// Password field label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Password field hint text.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// Validation: password empty.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordRequired;

  /// Validation: password length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// Confirm password field label.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Confirm password field hint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// Validation: passwords differ.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// Display name field label.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// Display name field hint.
  ///
  /// In en, this message translates to:
  /// **'How others see you'**
  String get displayNameHint;

  /// Validation: display name empty.
  ///
  /// In en, this message translates to:
  /// **'Display name is required.'**
  String get displayNameRequired;

  /// Login button label.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// Register button label.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get register;

  /// Logout button label.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// Logout confirmation dialog message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// Forgot password link label.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Forgot password screen title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// Forgot password instructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password.'**
  String get forgotPasswordMessage;

  /// Confirmation after sending reset email.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent. Check your inbox.'**
  String get resetPasswordSent;

  /// Prompt to navigate to registration.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// Prompt to navigate to login.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get hasAccountPrompt;

  /// Social login separator.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// Apple sign-in button.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// Google sign-in button.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// Legal disclaimer on auth screens.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy.'**
  String get termsAndPrivacy;

  /// Feed tab title.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedTitle;

  /// Feed section: nearby actions.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get feedNearby;

  /// Feed section: trending actions.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get feedTrending;

  /// Feed section: recently created actions.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get feedRecent;

  /// Empty state for feed.
  ///
  /// In en, this message translates to:
  /// **'No actions nearby. Explore trending actions instead!'**
  String get feedNoActions;

  /// Pull-to-refresh indicator.
  ///
  /// In en, this message translates to:
  /// **'Refreshing…'**
  String get feedRefreshing;

  /// Message at the bottom of an infinite list.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the end.'**
  String get feedEndOfList;

  /// Attribution label on an action card.
  ///
  /// In en, this message translates to:
  /// **'Posted by {username}'**
  String feedPostedBy(String username);

  /// Relative time label.
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String feedTimeAgo(String time);

  /// Search tab title.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// Search bar label.
  ///
  /// In en, this message translates to:
  /// **'Search Actions'**
  String get searchActions;

  /// Search bar placeholder.
  ///
  /// In en, this message translates to:
  /// **'Try \"plant a tree\" or \"clean a beach\"'**
  String get searchHint;

  /// Section header: categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get searchCategories;

  /// Empty state for search.
  ///
  /// In en, this message translates to:
  /// **'No actions match your search.'**
  String get searchNoResults;

  /// Section header: recent searches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchRecent;

  /// Button to clear recent searches.
  ///
  /// In en, this message translates to:
  /// **'Clear Recent'**
  String get searchClearRecent;

  /// Filter sheet title.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFilterTitle;

  /// Apply filters button.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get searchFilterApply;

  /// Reset filters button.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get searchFilterReset;

  /// Distance filter label.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get searchFilterDistance;

  /// Reward filter label.
  ///
  /// In en, this message translates to:
  /// **'Reward Amount'**
  String get searchFilterReward;

  /// Action type filter label.
  ///
  /// In en, this message translates to:
  /// **'Action Type'**
  String get searchFilterType;

  /// Number of search results.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No results} =1{1 result} other{{count} results}}'**
  String searchResultCount(int count);

  /// Action detail screen title.
  ///
  /// In en, this message translates to:
  /// **'Action Detail'**
  String get actionDetailTitle;

  /// Create action screen title.
  ///
  /// In en, this message translates to:
  /// **'Create Action'**
  String get createActionTitle;

  /// Edit action screen title.
  ///
  /// In en, this message translates to:
  /// **'Edit Action'**
  String get editActionTitle;

  /// Action title field label.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get actionTitle;

  /// Action title field hint.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done?'**
  String get actionTitleHint;

  /// Validation: title empty.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get actionTitleRequired;

  /// Action description field label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get actionDescription;

  /// Action description field hint.
  ///
  /// In en, this message translates to:
  /// **'Describe the action in detail…'**
  String get actionDescriptionHint;

  /// Validation: description empty.
  ///
  /// In en, this message translates to:
  /// **'Description is required.'**
  String get actionDescriptionRequired;

  /// Action category field label.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get actionCategory;

  /// Validation: category empty.
  ///
  /// In en, this message translates to:
  /// **'Please select a category.'**
  String get actionCategoryRequired;

  /// Action location field label.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get actionLocation;

  /// Action location hint.
  ///
  /// In en, this message translates to:
  /// **'Where should this be done?'**
  String get actionLocationHint;

  /// Validation: location empty.
  ///
  /// In en, this message translates to:
  /// **'Location is required.'**
  String get actionLocationRequired;

  /// Radius within which the action must be completed.
  ///
  /// In en, this message translates to:
  /// **'Verification Radius'**
  String get actionRadius;

  /// Action radius hint.
  ///
  /// In en, this message translates to:
  /// **'How close must the performer be?'**
  String get actionRadiusHint;

  /// Action reward field label.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get actionReward;

  /// Action reward hint.
  ///
  /// In en, this message translates to:
  /// **'Points or badge awarded on completion'**
  String get actionRewardHint;

  /// Validation: reward empty.
  ///
  /// In en, this message translates to:
  /// **'Reward is required.'**
  String get actionRewardRequired;

  /// Action type selector label.
  ///
  /// In en, this message translates to:
  /// **'Action Type'**
  String get actionType;

  /// Label for single-step actions.
  ///
  /// In en, this message translates to:
  /// **'One-Off'**
  String get actionTypeOneOff;

  /// Label for multi-step actions.
  ///
  /// In en, this message translates to:
  /// **'Sequential'**
  String get actionTypeSequential;

  /// Description of one-off actions.
  ///
  /// In en, this message translates to:
  /// **'A single action completed in one step.'**
  String get actionTypeOneOffDescription;

  /// Description of sequential actions.
  ///
  /// In en, this message translates to:
  /// **'A multi-step action completed over time.'**
  String get actionTypeSequentialDescription;

  /// Section: what AI should look for.
  ///
  /// In en, this message translates to:
  /// **'Verification Criteria'**
  String get verificationCriteria;

  /// Verification criteria hint.
  ///
  /// In en, this message translates to:
  /// **'What should the video show to pass verification?'**
  String get verificationCriteriaHint;

  /// Validation: criteria empty.
  ///
  /// In en, this message translates to:
  /// **'Verification criteria are required.'**
  String get verificationCriteriaRequired;

  /// Section header for sequential action steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get actionSteps;

  /// Button to add a sequential step.
  ///
  /// In en, this message translates to:
  /// **'Add Step'**
  String get actionAddStep;

  /// Button to remove a sequential step.
  ///
  /// In en, this message translates to:
  /// **'Remove Step'**
  String get actionRemoveStep;

  /// Step label with number.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String actionStepNumber(int number);

  /// Action deadline field label.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get actionDeadline;

  /// Action deadline hint.
  ///
  /// In en, this message translates to:
  /// **'Optional completion deadline'**
  String get actionDeadlineHint;

  /// Maximum number of participants.
  ///
  /// In en, this message translates to:
  /// **'Max Participants'**
  String get actionMaxParticipants;

  /// Max participants hint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for unlimited'**
  String get actionMaxParticipantsHint;

  /// Success message after creating an action.
  ///
  /// In en, this message translates to:
  /// **'Action created successfully!'**
  String get actionCreated;

  /// Success message after updating an action.
  ///
  /// In en, this message translates to:
  /// **'Action updated successfully!'**
  String get actionUpdated;

  /// Success message after deleting an action.
  ///
  /// In en, this message translates to:
  /// **'Action deleted.'**
  String get actionDeleted;

  /// Delete action confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this action?'**
  String get actionDeleteConfirm;

  /// Number of participants.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No participants} =1{1 participant} other{{count} participants}}'**
  String actionParticipants(int count);

  /// Number of submissions.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No submissions} =1{1 submission} other{{count} submissions}}'**
  String actionSubmissions(int count);

  /// Submit video screen title.
  ///
  /// In en, this message translates to:
  /// **'Submit Video'**
  String get submitVideoTitle;

  /// Recording screen title.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recordingTitle;

  /// Button to start recording.
  ///
  /// In en, this message translates to:
  /// **'Record Video'**
  String get recordVideo;

  /// Button to stop recording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopRecording;

  /// Status label while recording.
  ///
  /// In en, this message translates to:
  /// **'Recording in progress…'**
  String get recordingInProgress;

  /// Recording timer display.
  ///
  /// In en, this message translates to:
  /// **'{minutes}:{seconds}'**
  String recordingDuration(String minutes, String seconds);

  /// Review video screen title.
  ///
  /// In en, this message translates to:
  /// **'Review Video'**
  String get reviewVideoTitle;

  /// Instruction on the review screen.
  ///
  /// In en, this message translates to:
  /// **'Review your video before submitting.'**
  String get reviewVideoPrompt;

  /// Button to re-record.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakeVideo;

  /// Button to submit video for verification.
  ///
  /// In en, this message translates to:
  /// **'Submit Video'**
  String get submitVideo;

  /// Status while uploading submission.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get submitting;

  /// Success message after submitting.
  ///
  /// In en, this message translates to:
  /// **'Video submitted for verification!'**
  String get submissionSuccess;

  /// Error message when submission fails.
  ///
  /// In en, this message translates to:
  /// **'Submission failed. Please try again.'**
  String get submissionFailed;

  /// Camera permission dialog title.
  ///
  /// In en, this message translates to:
  /// **'Camera Access Required'**
  String get cameraPermissionTitle;

  /// Camera permission dialog message.
  ///
  /// In en, this message translates to:
  /// **'Verily needs camera access to record video proof.'**
  String get cameraPermissionMessage;

  /// Microphone permission dialog title.
  ///
  /// In en, this message translates to:
  /// **'Microphone Access Required'**
  String get microphonePermissionTitle;

  /// Microphone permission dialog message.
  ///
  /// In en, this message translates to:
  /// **'Verily needs microphone access to record audio with your video.'**
  String get microphonePermissionMessage;

  /// Button to open device settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Status while AI is verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying…'**
  String get verifying;

  /// Status: video passed verification.
  ///
  /// In en, this message translates to:
  /// **'Verification Passed'**
  String get verificationPassed;

  /// Status: video failed verification.
  ///
  /// In en, this message translates to:
  /// **'Verification Failed'**
  String get verificationFailed;

  /// Status: awaiting verification.
  ///
  /// In en, this message translates to:
  /// **'Pending Review'**
  String get verificationPending;

  /// Status: AI is processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get verificationProcessing;

  /// Status: verification errored.
  ///
  /// In en, this message translates to:
  /// **'Verification encountered an error.'**
  String get verificationError;

  /// AI confidence score.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {score}%'**
  String confidenceScore(int score);

  /// Section header for AI reasoning.
  ///
  /// In en, this message translates to:
  /// **'AI Feedback'**
  String get verificationFeedback;

  /// Hint after a failed verification.
  ///
  /// In en, this message translates to:
  /// **'You can re-submit with a new video.'**
  String get verificationRetry;

  /// Submission status screen title.
  ///
  /// In en, this message translates to:
  /// **'Submission Status'**
  String get submissionStatusTitle;

  /// Rewards screen title.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewardsTitle;

  /// Badges section label.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// Empty state for badges.
  ///
  /// In en, this message translates to:
  /// **'No badges earned yet. Complete actions to earn them!'**
  String get badgesEmpty;

  /// Points label.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// Total points display.
  ///
  /// In en, this message translates to:
  /// **'{count} points'**
  String pointsTotal(int count);

  /// Leaderboard section label.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// Leaderboard rank display.
  ///
  /// In en, this message translates to:
  /// **'#{rank}'**
  String leaderboardRank(int rank);

  /// Date a reward was earned.
  ///
  /// In en, this message translates to:
  /// **'Earned {date}'**
  String earnedAt(String date);

  /// Points awarded for a reward.
  ///
  /// In en, this message translates to:
  /// **'+{count} points'**
  String rewardPoints(int count);

  /// Badge award display.
  ///
  /// In en, this message translates to:
  /// **'Badge: {name}'**
  String rewardBadge(String name);

  /// Profile tab title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Edit profile screen title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// Bio field label.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBio;

  /// Bio field hint.
  ///
  /// In en, this message translates to:
  /// **'Tell others about yourself'**
  String get profileBioHint;

  /// Profile photo label.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// Button to change profile photo.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get profilePhotoChange;

  /// Followers count label.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// Following count label.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// Follow button label.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// Unfollow button label.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// Profile stat: actions created.
  ///
  /// In en, this message translates to:
  /// **'Actions Created'**
  String get actionsCreated;

  /// Profile stat: actions completed.
  ///
  /// In en, this message translates to:
  /// **'Actions Completed'**
  String get actionsCompleted;

  /// Success message after updating profile.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// Follower count with pluralization.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No followers} =1{1 follower} other{{count} followers}}'**
  String profileFollowerCount(int count);

  /// Following count with pluralization.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not following anyone} =1{Following 1} other{Following {count}}}'**
  String profileFollowingCount(int count);

  /// Settings screen title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Theme setting label.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Dark mode option.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingsDarkMode;

  /// Light mode option.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get settingsLightMode;

  /// System theme option.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsSystemMode;

  /// Notifications setting label.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// Push notifications toggle.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get settingsNotificationsPush;

  /// Email notifications toggle.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get settingsNotificationsEmail;

  /// Privacy setting label.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// Public/private profile toggle.
  ///
  /// In en, this message translates to:
  /// **'Public Profile'**
  String get settingsPrivacyProfile;

  /// Location sharing toggle.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get settingsPrivacyLocation;

  /// About section label.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// App version display.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsAboutVersion(String version);

  /// Link to open-source licenses.
  ///
  /// In en, this message translates to:
  /// **'Open-Source Licenses'**
  String get settingsAboutLicenses;

  /// Link to terms of service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsAboutTerms;

  /// Link to privacy policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsAboutPrivacy;

  /// Delete account button.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// Delete account confirmation message.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get settingsDeleteAccountConfirm;

  /// Language setting label.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Label for nearby actions.
  ///
  /// In en, this message translates to:
  /// **'Nearby'**
  String get locationNearby;

  /// Distance to an action.
  ///
  /// In en, this message translates to:
  /// **'{distance} away'**
  String locationDistance(String distance);

  /// Actions within a given radius.
  ///
  /// In en, this message translates to:
  /// **'Within {radius}'**
  String locationWithinRadius(String radius);

  /// Location permission dialog title.
  ///
  /// In en, this message translates to:
  /// **'Location Access Required'**
  String get locationPermissionTitle;

  /// Location permission dialog message.
  ///
  /// In en, this message translates to:
  /// **'Verily uses your location to show nearby actions and verify submissions.'**
  String get locationPermissionMessage;

  /// Message when location is denied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Some features may be unavailable.'**
  String get locationPermissionDenied;

  /// Message when location services are off.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Enable them in settings.'**
  String get locationServiceDisabled;

  /// Status while fetching location.
  ///
  /// In en, this message translates to:
  /// **'Updating location…'**
  String get locationUpdating;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
