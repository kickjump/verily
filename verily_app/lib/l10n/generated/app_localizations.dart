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
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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

  /// Wallet screen title and default wallet label.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletTitle;

  /// Header label for the wallet aggregate balance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get walletTotalBalance;

  /// Wallet count pill label.
  ///
  /// In en, this message translates to:
  /// **'{count} wallets'**
  String walletCount(int count);

  /// Security status pill label on wallet hero card.
  ///
  /// In en, this message translates to:
  /// **'Secure custody'**
  String get walletSecureCustody;

  /// Wallet quick action label to receive funds.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get walletReceive;

  /// Wallet quick action label to send funds.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get walletSend;

  /// Wallet quick action label to refresh balances and wallets.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get walletRefresh;

  /// Section header for user wallets list.
  ///
  /// In en, this message translates to:
  /// **'Your Wallets'**
  String get walletYourWallets;

  /// Empty state title when user has no wallets.
  ///
  /// In en, this message translates to:
  /// **'No wallets yet'**
  String get walletNoWalletsYet;

  /// Empty state description when user has no wallets.
  ///
  /// In en, this message translates to:
  /// **'Create or connect a wallet to get started'**
  String get walletCreateOrConnect;

  /// CTA/button label to add a wallet.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get walletAddWallet;

  /// Snackbar text when wallet address has been copied.
  ///
  /// In en, this message translates to:
  /// **'Address copied'**
  String get walletAddressCopied;

  /// Badge text indicating default wallet.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get walletDefault;

  /// Wallet type label for custodial wallets.
  ///
  /// In en, this message translates to:
  /// **'Custodial'**
  String get walletTypeCustodial;

  /// Wallet type label for linked external wallets.
  ///
  /// In en, this message translates to:
  /// **'External'**
  String get walletTypeExternal;

  /// Error state shown when wallet list fails to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wallets. Pull to refresh.'**
  String get walletLoadFailed;

  /// Section header for wallet portfolio tabs.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get walletPortfolio;

  /// Portfolio tab label for tokens.
  ///
  /// In en, this message translates to:
  /// **'Tokens'**
  String get walletTokens;

  /// Portfolio tab label for NFTs.
  ///
  /// In en, this message translates to:
  /// **'NFTs'**
  String get walletNfts;

  /// Portfolio tab label for activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get walletActivity;

  /// Empty state title for tokens tab.
  ///
  /// In en, this message translates to:
  /// **'No tokens yet'**
  String get walletNoTokensYet;

  /// Empty state subtitle for tokens tab.
  ///
  /// In en, this message translates to:
  /// **'Complete actions to earn token rewards'**
  String get walletNoTokensSubtitle;

  /// Empty state title for NFTs tab.
  ///
  /// In en, this message translates to:
  /// **'No NFTs yet'**
  String get walletNoNftsYet;

  /// Empty state subtitle for NFTs tab.
  ///
  /// In en, this message translates to:
  /// **'Earn NFT badges by completing actions'**
  String get walletNoNftsSubtitle;

  /// Empty state title for activity tab.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get walletNoActivityYet;

  /// Empty state subtitle for activity tab.
  ///
  /// In en, this message translates to:
  /// **'Your transaction history will appear here'**
  String get walletNoActivitySubtitle;

  /// Bottom sheet action to create a custodial wallet.
  ///
  /// In en, this message translates to:
  /// **'Create Custodial Wallet'**
  String get walletCreateCustodial;

  /// Bottom sheet action to link an external wallet.
  ///
  /// In en, this message translates to:
  /// **'Link External Wallet'**
  String get walletLinkExternal;

  /// Dialog title for linking a wallet.
  ///
  /// In en, this message translates to:
  /// **'Link Wallet'**
  String get walletLinkWallet;

  /// Input label for a Solana public key.
  ///
  /// In en, this message translates to:
  /// **'Solana Public Key'**
  String get walletSolanaPublicKey;

  /// Input hint for entering wallet address.
  ///
  /// In en, this message translates to:
  /// **'Enter your wallet address'**
  String get walletEnterWalletAddress;

  /// Confirm action button label for linking wallet.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get walletLink;

  /// Dialog title for receiving SOL.
  ///
  /// In en, this message translates to:
  /// **'Receive SOL'**
  String get walletReceiveSol;

  /// Label preceding displayed wallet address.
  ///
  /// In en, this message translates to:
  /// **'Your wallet address:'**
  String get walletYourWalletAddress;

  /// Button label to copy wallet address.
  ///
  /// In en, this message translates to:
  /// **'Copy Address'**
  String get walletCopyAddress;

  /// Default label for created custodial wallet during setup.
  ///
  /// In en, this message translates to:
  /// **'My Verily Wallet'**
  String get walletMyVerilyWallet;

  /// Generic input label for wallet public key.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get walletPublicKey;

  /// Input hint on setup link dialog.
  ///
  /// In en, this message translates to:
  /// **'Enter your Solana public key'**
  String get walletEnterSolanaPublicKey;

  /// Default label for linked external wallet during setup.
  ///
  /// In en, this message translates to:
  /// **'External Wallet'**
  String get walletExternalWallet;

  /// Wallet setup screen app bar title.
  ///
  /// In en, this message translates to:
  /// **'Set Up Wallet'**
  String get walletSetUpTitle;

  /// Wallet setup hero title.
  ///
  /// In en, this message translates to:
  /// **'Your Verily Wallet'**
  String get walletYourVerilyWallet;

  /// Wallet setup informational description.
  ///
  /// In en, this message translates to:
  /// **'Create a wallet to receive SOL, tokens, and NFT rewards for completing actions. You can also link an existing Solana wallet.'**
  String get walletSetupDescription;

  /// Primary CTA button on wallet setup screen.
  ///
  /// In en, this message translates to:
  /// **'Create Wallet'**
  String get walletCreateWallet;

  /// Secondary CTA button on wallet setup screen.
  ///
  /// In en, this message translates to:
  /// **'Link Existing Wallet'**
  String get walletLinkExisting;

  /// Tertiary CTA to skip wallet setup.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get walletSkipForNow;

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

  /// Feed empty state title for nearby tab.
  ///
  /// In en, this message translates to:
  /// **'No actions nearby'**
  String get feedNoNearbyActionsTitle;

  /// Feed empty state subtitle for nearby tab.
  ///
  /// In en, this message translates to:
  /// **'Enable location to see actions around you'**
  String get feedNoNearbyActionsSubtitle;

  /// Feed empty state title for trending tab.
  ///
  /// In en, this message translates to:
  /// **'No trending actions'**
  String get feedNoTrendingActionsTitle;

  /// Feed empty state subtitle for trending tab.
  ///
  /// In en, this message translates to:
  /// **'Check back later for popular actions'**
  String get feedNoTrendingActionsSubtitle;

  /// Feed error title shown when actions fail to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load actions'**
  String get feedLoadFailed;

  /// Title text in the premium feed hero card.
  ///
  /// In en, this message translates to:
  /// **'Action radar online'**
  String get feedHeroTitle;

  /// Subtitle in the feed hero card showing mission count.
  ///
  /// In en, this message translates to:
  /// **'{count} missions ready near you'**
  String feedHeroMissionCount(int count);

  /// Badge label shown in feed hero card.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get feedLiveBadge;

  /// Status label shown at top of feed action cards.
  ///
  /// In en, this message translates to:
  /// **'AI verification ready'**
  String get feedVerificationReady;

  /// Label shown in feed action card metadata row.
  ///
  /// In en, this message translates to:
  /// **'Earn rewards'**
  String get feedEarnRewards;

  /// CTA label on feed action cards to begin an action.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get feedStartCta;

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

  /// Search input hint used in the search app bar.
  ///
  /// In en, this message translates to:
  /// **'Search actions...'**
  String get searchActionsPlaceholder;

  /// Tooltip for opening map view from search.
  ///
  /// In en, this message translates to:
  /// **'Map view'**
  String get searchMapViewTooltip;

  /// Search hero helper text encouraging keyword or category discovery.
  ///
  /// In en, this message translates to:
  /// **'Discover actions by keyword or category'**
  String get searchDiscoverByKeywordOrCategory;

  /// Empty state title shown before a search query is entered.
  ///
  /// In en, this message translates to:
  /// **'Search for actions'**
  String get searchEmptyTitle;

  /// Empty state subtitle shown before a search query is entered.
  ///
  /// In en, this message translates to:
  /// **'Find actions by title, description, or tags'**
  String get searchEmptySubtitle;

  /// Error title shown when search request fails.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get searchFailed;

  /// No-results message with the user's search query.
  ///
  /// In en, this message translates to:
  /// **'No results for \"{query}\"'**
  String searchNoResultsFor(String query);

  /// Status label shown on search result cards for open actions.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get searchResultOpenStatus;

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

  /// Label for recurring or habit-style actions.
  ///
  /// In en, this message translates to:
  /// **'Habit'**
  String get actionTypeHabit;

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

  /// Button on action detail screen to begin recording a video submission.
  ///
  /// In en, this message translates to:
  /// **'Start Action'**
  String get startAction;

  /// Button label used to submit verification capture for AI review.
  ///
  /// In en, this message translates to:
  /// **'Submit for AI Review'**
  String get submitForAiReview;

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

  /// Error title shown when the profile fails to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadFailed;

  /// Subtitle text on the wallet card in profile.
  ///
  /// In en, this message translates to:
  /// **'View balances, tokens & NFTs'**
  String get profileWalletSubtitle;

  /// Profile tab label for created actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get profileActionsTab;

  /// Error text shown when profile actions fail to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load actions'**
  String get profileActionsLoadFailed;

  /// Empty state title when the user has no created actions.
  ///
  /// In en, this message translates to:
  /// **'No actions yet'**
  String get profileNoActionsYet;

  /// CTA label for completing an action from profile.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get profileCompleteActionCta;

  /// Localized action status label for active actions on profile.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profileActionStatusActive;

  /// Localized action status label for completed actions on profile.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get profileActionStatusCompleted;

  /// Localized action status label for closed actions on profile.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get profileActionStatusClosed;

  /// Error text shown when profile rewards fail to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load rewards'**
  String get profileRewardsLoadFailed;

  /// Empty state title when the user has no rewards.
  ///
  /// In en, this message translates to:
  /// **'No rewards yet'**
  String get profileNoRewardsYet;

  /// Empty state subtitle encouraging users to complete actions for rewards.
  ///
  /// In en, this message translates to:
  /// **'Complete actions to earn rewards'**
  String get profileNoRewardsSubtitle;

  /// Label for a reward item by reward identifier.
  ///
  /// In en, this message translates to:
  /// **'Reward #{rewardId}'**
  String profileRewardNumber(int rewardId);

  /// Text showing when a reward was earned.
  ///
  /// In en, this message translates to:
  /// **'Earned {date}'**
  String profileRewardEarnedDate(String date);

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

  /// Hint text for the map location search input.
  ///
  /// In en, this message translates to:
  /// **'Search places...'**
  String get mapSearchPlacesHint;

  /// Map overlay hint when no actions are currently visible.
  ///
  /// In en, this message translates to:
  /// **'Move map or search to discover nearby missions'**
  String get mapDiscoverNearbyHint;

  /// Map overlay summary showing number of actions currently in the viewport.
  ///
  /// In en, this message translates to:
  /// **'{count} actions in view'**
  String mapActionsInView(int count);

  /// Radius label in kilometers for map filters and badges.
  ///
  /// In en, this message translates to:
  /// **'{radius} km'**
  String mapRadiusKm(int radius);

  /// Empty state message on map when no nearby actions are found.
  ///
  /// In en, this message translates to:
  /// **'No actions nearby. Try zooming out.'**
  String get mapNoActionsNearbyZoomOut;

  /// Tooltip for the map floating action button that recenters to user location.
  ///
  /// In en, this message translates to:
  /// **'Re-center'**
  String get mapRecenterTooltip;

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

  /// Home tab title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Action details screen title.
  ///
  /// In en, this message translates to:
  /// **'Action Details'**
  String get actionDetailsTitle;

  /// Error shown when an action identifier is invalid or missing.
  ///
  /// In en, this message translates to:
  /// **'Invalid action ID'**
  String get actionInvalidId;

  /// Error shown when action details fail to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load action'**
  String get actionLoadFailed;

  /// Label for action tags metadata.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get actionTags;

  /// Label for maximum number of performers allowed for an action.
  ///
  /// In en, this message translates to:
  /// **'Max Performers'**
  String get actionMaxPerformers;

  /// Label for total number of steps in a sequential action.
  ///
  /// In en, this message translates to:
  /// **'Total Steps'**
  String get actionTotalSteps;

  /// Label for action duration metadata.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get actionDuration;

  /// Label for action recurrence or frequency metadata.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get actionFrequency;

  /// Label preceding action creation timestamp or date.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get actionCreatedLabel;

  /// Snackbar message shown after copying an action share link.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get actionLinkCopiedToClipboard;

  /// Button or mode label for creating an action with AI assistance.
  ///
  /// In en, this message translates to:
  /// **'Create with AI'**
  String get actionCreateWithAi;

  /// Button or mode label for manually creating an action without AI.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get actionCreateManual;

  /// Prompt label asking the user to describe the action for AI generation.
  ///
  /// In en, this message translates to:
  /// **'Describe the action'**
  String get actionDescribePrompt;

  /// Button label to generate an action using AI.
  ///
  /// In en, this message translates to:
  /// **'Generate Action'**
  String get actionGenerate;

  /// Button label to edit the AI generation prompt.
  ///
  /// In en, this message translates to:
  /// **'Edit Prompt'**
  String get actionEditPrompt;

  /// Button label to stop an in-progress AI generation request.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get actionStop;

  /// Error message shown when creating an action fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to create action. Please try again.'**
  String get actionCreateFailedRetry;

  /// Field label for entering a human-readable location name.
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get actionLocationName;

  /// Optional field label for maximum number of performers.
  ///
  /// In en, this message translates to:
  /// **'Max Performers (optional)'**
  String get actionMaxPerformersOptional;

  /// Example placeholder text for action location name input.
  ///
  /// In en, this message translates to:
  /// **'e.g., Central Park'**
  String get actionLocationExample;

  /// Example placeholder text for action title input.
  ///
  /// In en, this message translates to:
  /// **'e.g., Do 20 push-ups in the park'**
  String get actionTitleExample;

  /// Hint text for describing performer instructions in action creation.
  ///
  /// In en, this message translates to:
  /// **'Describe what the performer needs to do...'**
  String get actionDescriptionPerformerHint;

  /// Tooltip for action verb quality dot in AI action creation.
  ///
  /// In en, this message translates to:
  /// **'Action verb'**
  String get aiActionTooltipActionVerb;

  /// Tooltip for specificity quality dot in AI action creation.
  ///
  /// In en, this message translates to:
  /// **'Specific details'**
  String get aiActionTooltipSpecificDetails;

  /// Tooltip for measurable goal quality dot in AI action creation.
  ///
  /// In en, this message translates to:
  /// **'Measurable goal'**
  String get aiActionTooltipMeasurableGoal;

  /// Tooltip for verifiable element quality dot in AI action creation.
  ///
  /// In en, this message translates to:
  /// **'Verifiable element'**
  String get aiActionTooltipVerifiableElement;

  /// Label for video resolution metadata in submission review.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get submissionResolution;

  /// Short provider label for Google authentication option.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get authGoogle;

  /// Short provider label for Apple authentication option.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get authApple;

  /// Localized UI text: About Verily
  ///
  /// In en, this message translates to:
  /// **'About Verily'**
  String get settingsAboutVerily;

  /// Localized UI text: Action failed. Please try again.
  ///
  /// In en, this message translates to:
  /// **'Action failed. Please try again.'**
  String get profileActionFailedRetry;

  /// Localized UI text: Amount each performer receives
  ///
  /// In en, this message translates to:
  /// **'Amount each performer receives'**
  String get rewardPoolPerPersonAmountHint;

  /// Localized UI text: Appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Localized UI text: At least 8 characters
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get authPasswordMinEightChars;

  /// Localized UI text: Audio
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get verificationAudio;

  /// Localized UI text: Available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get homeAvailableLabel;

  /// Localized UI text: Back to Feed
  ///
  /// In en, this message translates to:
  /// **'Back to Feed'**
  String get submissionBackToFeed;

  /// Localized UI text: Block user
  ///
  /// In en, this message translates to:
  /// **'Block user'**
  String get profileBlockUser;

  /// Localized UI text: Browse more actions
  ///
  /// In en, this message translates to:
  /// **'Browse more actions'**
  String get homeBrowseMoreActions;

  /// Localized UI text: Cancel Pool
  ///
  /// In en, this message translates to:
  /// **'Cancel Pool'**
  String get rewardPoolCancelPool;

  /// Localized UI text: Cancel Pool?
  ///
  /// In en, this message translates to:
  /// **'Cancel Pool?'**
  String get rewardPoolCancelPoolTitle;

  /// Localized UI text: Choose a unique username
  ///
  /// In en, this message translates to:
  /// **'Choose a unique username'**
  String get profileChooseUniqueUsername;

  /// Localized UI text: Clean up a beach for 10 min
  ///
  /// In en, this message translates to:
  /// **'Clean up a beach for 10 min'**
  String get aiActionPromptCleanUpBeachTenMin;

  /// Localized UI text: Clear
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get homeClear;

  /// Localized UI text: Create Reward Pool
  ///
  /// In en, this message translates to:
  /// **'Create Reward Pool'**
  String get rewardPoolCreateRewardPool;

  /// Localized UI text: Credentials
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get authCredentials;

  /// Localized UI text: Do 50 push-ups at a park
  ///
  /// In en, this message translates to:
  /// **'Do 50 push-ups at a park'**
  String get aiActionPromptDo50PushUpsAtPark;

  /// Localized UI text: Enter SPL token mint address
  ///
  /// In en, this message translates to:
  /// **'Enter SPL token mint address'**
  String get rewardPoolEnterSplTokenMintAddress;

  /// Localized UI text: Failed to create reward pool. Please try again.
  ///
  /// In en, this message translates to:
  /// **'Failed to create reward pool. Please try again.'**
  String get rewardPoolCreateFailedTryAgain;

  /// Localized UI text: Failed to load distributions
  ///
  /// In en, this message translates to:
  /// **'Failed to load distributions'**
  String get rewardPoolFailedToLoadDistributions;

  /// Localized UI text: Failed to open camera. Please try again.
  ///
  /// In en, this message translates to:
  /// **'Failed to open camera. Please try again.'**
  String get submissionFailedToOpenCameraTryAgain;

  /// Localized UI text: Failed to save profile. Please try again.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get profileFailedToSaveTryAgain;

  /// Localized UI text: Failed to submit video. Please try again.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit video. Please try again.'**
  String get submissionFailedToSubmitVideoTryAgain;

  /// Localized UI text: File Size
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get submissionFileSize;

  /// Localized UI text: Fund & Create Pool
  ///
  /// In en, this message translates to:
  /// **'Fund & Create Pool'**
  String get rewardPoolFundAndCreatePool;

  /// Localized UI text: Keep
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get rewardPoolKeep;

  /// Localized UI text: Location Sharing
  ///
  /// In en, this message translates to:
  /// **'Location Sharing'**
  String get settingsLocationSharing;

  /// Localized UI text: Log Location
  ///
  /// In en, this message translates to:
  /// **'Log Location'**
  String get verificationLogLocation;

  /// Localized UI text: Max Recipients (optional)
  ///
  /// In en, this message translates to:
  /// **'Max Recipients (optional)'**
  String get rewardPoolMaxRecipientsOptional;

  /// Localized UI text: Meditate daily for a week
  ///
  /// In en, this message translates to:
  /// **'Meditate daily for a week'**
  String get aiActionPromptMeditateDailyForAWeek;

  /// Localized UI text: NFT
  ///
  /// In en, this message translates to:
  /// **'NFT'**
  String get rewardPoolNft;

  /// Localized UI text: Open Source Licenses
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsOpenSourceLicenses;

  /// Localized UI text: Open Verification
  ///
  /// In en, this message translates to:
  /// **'Open Verification'**
  String get homeOpenVerification;

  /// Localized UI text: Open verification capture
  ///
  /// In en, this message translates to:
  /// **'Open verification capture'**
  String get navigationOpenVerificationCapture;

  /// Localized UI text: Per Person Amount
  ///
  /// In en, this message translates to:
  /// **'Per Person Amount'**
  String get rewardPoolPerPersonAmount;

  /// Localized UI text: Please enter a token mint address.
  ///
  /// In en, this message translates to:
  /// **'Please enter a token mint address.'**
  String get rewardPoolPleaseEnterTokenMintAddress;

  /// Localized UI text: Please enter a valid per-person amount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid per-person amount.'**
  String get rewardPoolPleaseEnterValidPerPersonAmount;

  /// Localized UI text: Please enter a valid total amount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid total amount.'**
  String get rewardPoolPleaseEnterValidTotalAmount;

  /// Localized UI text: Pool will remain active until depleted
  ///
  /// In en, this message translates to:
  /// **'Pool will remain active until depleted'**
  String get rewardPoolWillRemainActiveUntilDepleted;

  /// Localized UI text: Report submitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted.'**
  String get profileReportSubmitted;

  /// Localized UI text: Report user
  ///
  /// In en, this message translates to:
  /// **'Report user'**
  String get profileReportUser;

  /// Localized UI text: Resend Code
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get authResendCode;

  /// Localized UI text: Reward Pool
  ///
  /// In en, this message translates to:
  /// **'Reward Pool'**
  String get rewardPoolTitle;

  /// Localized UI text: Reward Type
  ///
  /// In en, this message translates to:
  /// **'Reward Type'**
  String get rewardPoolRewardType;

  /// Localized UI text: SOL
  ///
  /// In en, this message translates to:
  /// **'SOL'**
  String get rewardPoolSol;

  /// Localized UI text: Set Expiry Date
  ///
  /// In en, this message translates to:
  /// **'Set Expiry Date'**
  String get rewardPoolSetExpiryDate;

  /// Localized UI text: Stop recording before submitting for review.
  ///
  /// In en, this message translates to:
  /// **'Stop recording before submitting for review.'**
  String get verificationStopRecordingBeforeSubmitting;

  /// Localized UI text: Streak
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get homeStreak;

  /// Localized UI text: Tell others about yourself...
  ///
  /// In en, this message translates to:
  /// **'Tell others about yourself...'**
  String get profileTellOthersAboutYourself;

  /// Localized UI text: Token
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get rewardPoolToken;

  /// Localized UI text: Token Mint Address
  ///
  /// In en, this message translates to:
  /// **'Token Mint Address'**
  String get rewardPoolTokenMintAddress;

  /// Localized UI text: Try Again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get submissionTryAgain;

  /// Localized UI text: Type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get actionTypeLabel;

  /// Localized UI text: User blocked.
  ///
  /// In en, this message translates to:
  /// **'User blocked.'**
  String get profileUserBlocked;

  /// Localized UI text: Username
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get profileUsername;

  /// Localized UI text: Verification Capture
  ///
  /// In en, this message translates to:
  /// **'Verification Capture'**
  String get verificationCapture;

  /// Localized UI text: Verification Code
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get authVerificationCode;

  /// Localized UI text: Verify
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get appVerify;

  /// Localized UI text: Video
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get submissionVideo;

  /// Localized UI text: View Details
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get actionViewDetails;

  /// Localized UI text: Your public name
  ///
  /// In en, this message translates to:
  /// **'Your public name'**
  String get profileYourPublicName;

  /// Title for the on-device video quality analysis card.
  ///
  /// In en, this message translates to:
  /// **'Quality Pre-Check'**
  String get videoQualityPreCheckTitle;

  /// Status label while video quality analysis is running.
  ///
  /// In en, this message translates to:
  /// **'Analyzing…'**
  String get videoQualityAnalyzing;

  /// Status badge when all quality checks pass.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get videoQualityPassed;

  /// Status badge when quality checks find issues.
  ///
  /// In en, this message translates to:
  /// **'Issues Found'**
  String get videoQualityIssuesFound;

  /// Status badge when quality analysis was skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get videoQualitySkipped;

  /// Loading text while quality checks are in progress.
  ///
  /// In en, this message translates to:
  /// **'Running quality checks on your video…'**
  String get videoQualityRunningChecks;

  /// Error fallback text when quality analysis fails.
  ///
  /// In en, this message translates to:
  /// **'Quality analysis could not complete. You can still submit.'**
  String get videoQualityAnalysisFailed;

  /// Text when no quality checks were performed.
  ///
  /// In en, this message translates to:
  /// **'No quality checks were run.'**
  String get videoQualityNoChecksRun;

  /// Shows how long the quality analysis took.
  ///
  /// In en, this message translates to:
  /// **'Analyzed in {timeMs}ms'**
  String videoQualityAnalysisTime(int timeMs);

  /// Title for the geo-fence warning dialog when user is outside the required location.
  ///
  /// In en, this message translates to:
  /// **'Outside Required Area'**
  String get geoFenceOutsideTitle;

  /// Body text for the geo-fence warning dialog.
  ///
  /// In en, this message translates to:
  /// **'You are {overshoot} outside the required area ({distance} from the target location). Submissions from outside the geo-fence are likely to be rejected by AI verification.'**
  String geoFenceOutsideBody(String overshoot, String distance);

  /// Hint text in the geo-fence warning dialog suggesting the user move closer.
  ///
  /// In en, this message translates to:
  /// **'Move closer to the required location for the best chance of verification success.'**
  String get geoFenceOutsideHint;

  /// Button label to dismiss the geo-fence warning and go closer to the location.
  ///
  /// In en, this message translates to:
  /// **'Go Closer'**
  String get geoFenceGoCloser;

  /// Button label to submit despite being outside the geo-fence.
  ///
  /// In en, this message translates to:
  /// **'Submit Anyway'**
  String get geoFenceSubmitAnyway;

  /// Warning banner text on the video review screen when outside geo-fence.
  ///
  /// In en, this message translates to:
  /// **'You are {overshoot} outside the required area. Submission may be rejected.'**
  String geoFenceBannerWarning(String overshoot);

  /// Text shown while geo-fence proximity is being calculated.
  ///
  /// In en, this message translates to:
  /// **'Checking your proximity…'**
  String get geoFenceCheckingProximity;

  /// Text shown when GPS is unavailable for geo-fence check.
  ///
  /// In en, this message translates to:
  /// **'Unable to check proximity'**
  String get geoFenceUnableToCheck;

  /// Text shown when user is inside the required geo-fence area.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the area ({distance} from target)'**
  String geoFenceInsideArea(String distance);

  /// Text shown when user is outside the required geo-fence area.
  ///
  /// In en, this message translates to:
  /// **'You\'re {overshoot} outside the required area'**
  String geoFenceOutsideArea(String overshoot);

  /// Snackbar message when action link is copied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get actionLinkCopied;

  /// Button label to submit video proof.
  ///
  /// In en, this message translates to:
  /// **'Submit Video'**
  String get actionSubmitVideo;

  /// Section header for verification criteria.
  ///
  /// In en, this message translates to:
  /// **'Verification Criteria'**
  String get actionVerificationCriteria;

  /// Button label to create an action from AI-generated content.
  ///
  /// In en, this message translates to:
  /// **'Create Action'**
  String get aiActionCreateAction;

  /// Tab label for AI-assisted action creation.
  ///
  /// In en, this message translates to:
  /// **'Create with AI'**
  String get aiActionCreateWithAi;

  /// Placeholder text for the AI action description input.
  ///
  /// In en, this message translates to:
  /// **'Describe the action'**
  String get aiActionDescribeAction;

  /// Button label to edit the AI prompt.
  ///
  /// In en, this message translates to:
  /// **'Edit Prompt'**
  String get aiActionEditPrompt;

  /// Button label to generate an action with AI.
  ///
  /// In en, this message translates to:
  /// **'Generate Action'**
  String get aiActionGenerate;

  /// Tab label for manual action creation.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get aiActionManual;

  /// Button label to stop AI generation.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get aiActionStop;

  /// Error message when video submission fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit video. Please try again.'**
  String get submissionFailedRetry;

  /// Label for location info on video review screen.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get submissionLocation;

  /// Button label to retake the video.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get submissionRetake;

  /// Title for the video review screen.
  ///
  /// In en, this message translates to:
  /// **'Review Video'**
  String get submissionReviewVideo;

  /// Button label to submit the video.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submissionSubmit;
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
