/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: experimental_member_use
// ignore_for_file: inference_failure_on_function_return_type

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:verily_client/src/protocol/action_category.dart' as _i3;
import 'package:verily_client/src/protocol/action.dart' as _i4;
import 'package:verily_client/src/protocol/action_step.dart' as _i5;
import 'package:verily_core/src/models/ai_generated_action.dart' as _i6;
import 'package:verily_client/src/protocol/attestation_challenge.dart' as _i7;
import 'package:verily_client/src/protocol/device_attestation.dart' as _i8;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i9;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i10;
import 'package:verily_client/src/protocol/place_search_result.dart' as _i11;
import 'package:verily_client/src/protocol/location.dart' as _i12;
import 'package:verily_client/src/protocol/reward.dart' as _i13;
import 'package:verily_client/src/protocol/user_reward.dart' as _i14;
import 'package:verily_client/src/protocol/reward_pool.dart' as _i15;
import 'package:verily_client/src/protocol/reward_distribution.dart' as _i16;
import 'package:verily_client/src/protocol/solana_wallet.dart' as _i17;
import 'package:verily_client/src/protocol/action_submission.dart' as _i18;
import 'package:verily_client/src/protocol/user_follow.dart' as _i19;
import 'package:verily_client/src/protocol/user_profile.dart' as _i20;
import 'package:verily_client/src/protocol/verification_result.dart' as _i21;
import 'protocol.dart' as _i22;

/// Endpoint for managing action categories.
///
/// All methods require authentication. Categories are used to organize
/// and filter actions.
/// {@category Endpoint}
class EndpointActionCategory extends _i1.EndpointRef {
  EndpointActionCategory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'actionCategory';

  /// Lists all action categories, ordered by sort order.
  _i2.Future<List<_i3.ActionCategory>> list() =>
      caller.callServerEndpoint<List<_i3.ActionCategory>>(
        'actionCategory',
        'list',
        {},
      );

  /// Creates a new action category.
  _i2.Future<_i3.ActionCategory> create(_i3.ActionCategory category) =>
      caller.callServerEndpoint<_i3.ActionCategory>(
        'actionCategory',
        'create',
        {'category': category},
      );

  /// Retrieves a single action category by its ID.
  _i2.Future<_i3.ActionCategory> get(int id) =>
      caller.callServerEndpoint<_i3.ActionCategory>('actionCategory', 'get', {
        'id': id,
      });
}

/// Endpoint for managing verifiable actions.
///
/// All methods require authentication. Actions represent tasks that users
/// create for others to perform and verify.
/// {@category Endpoint}
class EndpointAction extends _i1.EndpointRef {
  EndpointAction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'action';

  /// Creates a new action.
  _i2.Future<_i4.Action> create(_i4.Action action) => caller
      .callServerEndpoint<_i4.Action>('action', 'create', {'action': action});

  /// Lists all active actions.
  _i2.Future<List<_i4.Action>> listActive() =>
      caller.callServerEndpoint<List<_i4.Action>>('action', 'listActive', {});

  /// Lists actions near a geographic location.
  _i2.Future<List<_i4.Action>> listNearby(
    double lat,
    double lng,
    double radiusMeters,
  ) => caller.callServerEndpoint<List<_i4.Action>>('action', 'listNearby', {
    'lat': lat,
    'lng': lng,
    'radiusMeters': radiusMeters,
  });

  /// Lists actions that have locations inside a bounding box.
  _i2.Future<List<_i4.Action>> listInBoundingBox(
    double southLat,
    double westLng,
    double northLat,
    double eastLng,
  ) => caller.callServerEndpoint<List<_i4.Action>>(
    'action',
    'listInBoundingBox',
    {
      'southLat': southLat,
      'westLng': westLng,
      'northLat': northLat,
      'eastLng': eastLng,
    },
  );

  /// Lists actions belonging to a specific category.
  _i2.Future<List<_i4.Action>> listByCategory(int categoryId) =>
      caller.callServerEndpoint<List<_i4.Action>>('action', 'listByCategory', {
        'categoryId': categoryId,
      });

  /// Searches actions by a query string.
  _i2.Future<List<_i4.Action>> search(String query) =>
      caller.callServerEndpoint<List<_i4.Action>>('action', 'search', {
        'query': query,
      });

  /// Retrieves a single action by its ID.
  _i2.Future<_i4.Action> get(int id) =>
      caller.callServerEndpoint<_i4.Action>('action', 'get', {'id': id});

  /// Updates an existing action.
  _i2.Future<_i4.Action> update(_i4.Action action) => caller
      .callServerEndpoint<_i4.Action>('action', 'update', {'action': action});

  /// Deletes an action by its ID.
  _i2.Future<void> delete(int id) =>
      caller.callServerEndpoint<void>('action', 'delete', {'id': id});

  /// Lists all actions created by the authenticated user.
  _i2.Future<List<_i4.Action>> listByCreator() => caller
      .callServerEndpoint<List<_i4.Action>>('action', 'listByCreator', {});
}

/// Endpoint for managing steps within an action.
///
/// All methods require authentication. Action steps define the sequential
/// stages a performer must complete for multi-step actions.
/// {@category Endpoint}
class EndpointActionStep extends _i1.EndpointRef {
  EndpointActionStep(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'actionStep';

  /// Creates a new action step.
  _i2.Future<_i5.ActionStep> create(_i5.ActionStep actionStep) =>
      caller.callServerEndpoint<_i5.ActionStep>('actionStep', 'create', {
        'actionStep': actionStep,
      });

  /// Lists all steps for a given action, ordered by step number.
  _i2.Future<List<_i5.ActionStep>> listByAction(int actionId) =>
      caller.callServerEndpoint<List<_i5.ActionStep>>(
        'actionStep',
        'listByAction',
        {'actionId': actionId},
      );

  /// Updates an existing action step.
  _i2.Future<_i5.ActionStep> update(_i5.ActionStep actionStep) =>
      caller.callServerEndpoint<_i5.ActionStep>('actionStep', 'update', {
        'actionStep': actionStep,
      });

  /// Deletes an action step by its ID.
  _i2.Future<void> delete(int id) =>
      caller.callServerEndpoint<void>('actionStep', 'delete', {'id': id});
}

/// Endpoint for AI-powered action creation.
///
/// Uses Gemini to transform natural language descriptions into structured
/// action data with verification criteria.
/// {@category Endpoint}
class EndpointAiAction extends _i1.EndpointRef {
  EndpointAiAction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'aiAction';

  /// Generates a structured action from a natural language description.
  ///
  /// Returns null if the Gemini API key is not configured.
  _i2.Future<_i6.AiGeneratedAction?> generate(
    String description, {
    double? latitude,
    double? longitude,
  }) => caller.callServerEndpoint<_i6.AiGeneratedAction?>(
    'aiAction',
    'generate',
    {'description': description, 'latitude': latitude, 'longitude': longitude},
  );

  /// Generates verification criteria for an action.
  _i2.Future<String?> generateCriteria(
    String actionTitle,
    String actionDescription,
  ) => caller.callServerEndpoint<String?>('aiAction', 'generateCriteria', {
    'actionTitle': actionTitle,
    'actionDescription': actionDescription,
  });

  /// Generates step breakdowns for a sequential action.
  _i2.Future<List<_i6.AiGeneratedStep>?> generateSteps(
    String actionTitle,
    String actionDescription,
    int numberOfSteps,
  ) => caller.callServerEndpoint<List<_i6.AiGeneratedStep>?>(
    'aiAction',
    'generateSteps',
    {
      'actionTitle': actionTitle,
      'actionDescription': actionDescription,
      'numberOfSteps': numberOfSteps,
    },
  );
}

/// Endpoint for device attestation and video nonce management.
///
/// Handles challenge nonce creation for video recording sessions and
/// platform attestation submission (Play Integrity, App Attest).
/// {@category Endpoint}
class EndpointAttestation extends _i1.EndpointRef {
  EndpointAttestation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'attestation';

  /// Creates a challenge nonce for a video recording session.
  ///
  /// The nonce must be displayed during recording and will be verified
  /// by Gemini in the submitted video.
  _i2.Future<_i7.AttestationChallenge> createChallenge(int actionId) =>
      caller.callServerEndpoint<_i7.AttestationChallenge>(
        'attestation',
        'createChallenge',
        {'actionId': actionId},
      );

  /// Submits a platform attestation for a video submission.
  ///
  /// [platform] should be 'android' or 'ios'.
  /// [token] is the Play Integrity token (Android) or App Attest object (iOS).
  _i2.Future<_i8.DeviceAttestation> submitAttestation(
    int submissionId,
    String platform,
    String token, {
    String? keyId,
  }) => caller.callServerEndpoint<_i8.DeviceAttestation>(
    'attestation',
    'submitAttestation',
    {
      'submissionId': submissionId,
      'platform': platform,
      'token': token,
      'keyId': keyId,
    },
  );
}

/// Concrete Apple auth endpoint for Serverpod IDP.
/// {@category Endpoint}
class EndpointAuthApple extends _i9.EndpointAppleIdpBase {
  EndpointAuthApple(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authApple';

  /// Signs in a user with their Apple account.
  ///
  /// If no user exists yet linked to the Apple-provided identifier, a new one
  /// will be created (without any `Scope`s). Further their provided name and
  /// email (if any) will be used for the `UserProfile` which will be linked to
  /// their `AuthUser`.
  ///
  /// Returns a session for the user upon successful login.
  @override
  _i2.Future<_i10.AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) => caller.callServerEndpoint<_i10.AuthSuccess>('authApple', 'login', {
    'identityToken': identityToken,
    'authorizationCode': authorizationCode,
    'isNativeApplePlatformSignIn': isNativeApplePlatformSignIn,
    'firstName': firstName,
    'lastName': lastName,
  });

  @override
  _i2.Future<bool> hasAccount() =>
      caller.callServerEndpoint<bool>('authApple', 'hasAccount', {});
}

/// Concrete email/password auth endpoint for Serverpod IDP.
/// {@category Endpoint}
class EndpointAuthEmail extends _i9.EndpointEmailIdpBase {
  EndpointAuthEmail(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authEmail';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i10.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i10.AuthSuccess>('authEmail', 'login', {
    'email': email,
    'password': password,
  });

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'authEmail',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) =>
      caller.callServerEndpoint<String>('authEmail', 'verifyRegistrationCode', {
        'accountRequestId': accountRequestId,
        'verificationCode': verificationCode,
      });

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i10.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i10.AuthSuccess>(
    'authEmail',
    'finishRegistration',
    {'registrationToken': registrationToken, 'password': password},
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'authEmail',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller
      .callServerEndpoint<String>('authEmail', 'verifyPasswordResetCode', {
        'passwordResetRequestId': passwordResetRequestId,
        'verificationCode': verificationCode,
      });

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>('authEmail', 'finishPasswordReset', {
    'finishPasswordResetToken': finishPasswordResetToken,
    'newPassword': newPassword,
  });

  @override
  _i2.Future<bool> hasAccount() =>
      caller.callServerEndpoint<bool>('authEmail', 'hasAccount', {});
}

/// Concrete Google auth endpoint for Serverpod IDP.
/// {@category Endpoint}
class EndpointAuthGoogle extends _i9.EndpointGoogleIdpBase {
  EndpointAuthGoogle(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authGoogle';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _i2.Future<_i10.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_i10.AuthSuccess>('authGoogle', 'login', {
    'idToken': idToken,
    'accessToken': accessToken,
  });

  @override
  _i2.Future<bool> hasAccount() =>
      caller.callServerEndpoint<bool>('authGoogle', 'hasAccount', {});
}

/// Endpoint for geocoding operations using Mapbox.
///
/// Acts as a server-side proxy so that the Mapbox access token is never
/// exposed to the Flutter client. All methods require authentication.
/// {@category Endpoint}
class EndpointGeocoding extends _i1.EndpointRef {
  EndpointGeocoding(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'geocoding';

  /// Searches for places matching [query].
  ///
  /// Optionally biases results toward [proximityLat]/[proximityLng] when
  /// provided.
  _i2.Future<List<_i11.PlaceSearchResult>> searchPlaces(
    String query,
    double? proximityLat,
    double? proximityLng,
  ) => caller.callServerEndpoint<List<_i11.PlaceSearchResult>>(
    'geocoding',
    'searchPlaces',
    {
      'query': query,
      'proximityLat': proximityLat,
      'proximityLng': proximityLng,
    },
  );

  /// Reverse-geocodes a coordinate to the nearest place.
  _i2.Future<_i11.PlaceSearchResult?> reverseGeocode(double lat, double lng) =>
      caller.callServerEndpoint<_i11.PlaceSearchResult?>(
        'geocoding',
        'reverseGeocode',
        {'lat': lat, 'lng': lng},
      );
}

/// Endpoint for managing geographic locations.
///
/// All methods require authentication. Locations can be attached to actions
/// to require geographic proximity for performing them.
/// {@category Endpoint}
class EndpointLocation extends _i1.EndpointRef {
  EndpointLocation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'location';

  /// Creates a new location.
  _i2.Future<_i12.Location> create(_i12.Location location) =>
      caller.callServerEndpoint<_i12.Location>('location', 'create', {
        'location': location,
      });

  /// Searches for locations near a geographic coordinate.
  _i2.Future<List<_i12.Location>> searchNearby(
    double lat,
    double lng,
    double radiusMeters,
  ) => caller.callServerEndpoint<List<_i12.Location>>(
    'location',
    'searchNearby',
    {'lat': lat, 'lng': lng, 'radiusMeters': radiusMeters},
  );

  /// Retrieves a single location by its ID.
  _i2.Future<_i12.Location> get(int id) =>
      caller.callServerEndpoint<_i12.Location>('location', 'get', {'id': id});
}

/// Endpoint for managing rewards and leaderboards.
///
/// All methods require authentication. Rewards are earned by users
/// upon successful verification of action submissions.
/// {@category Endpoint}
class EndpointReward extends _i1.EndpointRef {
  EndpointReward(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reward';

  /// Lists all rewards associated with a given action.
  _i2.Future<List<_i13.Reward>> listByAction(int actionId) =>
      caller.callServerEndpoint<List<_i13.Reward>>('reward', 'listByAction', {
        'actionId': actionId,
      });

  /// Lists all rewards earned by the authenticated user.
  _i2.Future<List<_i14.UserReward>> listByUser() => caller
      .callServerEndpoint<List<_i14.UserReward>>('reward', 'listByUser', {});

  /// Retrieves the leaderboard of users ranked by total reward points.
  _i2.Future<List<_i14.UserReward>> getLeaderboard() =>
      caller.callServerEndpoint<List<_i14.UserReward>>(
        'reward',
        'getLeaderboard',
        {},
      );
}

/// Endpoint for managing reward pools on actions.
///
/// Reward pools are funded pots of SOL, SPL tokens, or NFTs that are
/// distributed to performers who complete an action.
/// {@category Endpoint}
class EndpointRewardPool extends _i1.EndpointRef {
  EndpointRewardPool(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'rewardPool';

  /// Creates a new reward pool for an action.
  _i2.Future<_i15.RewardPool> create(
    int actionId,
    String rewardType,
    double totalAmount,
    double perPersonAmount, {
    String? tokenMintAddress,
    int? maxRecipients,
    DateTime? expiresAt,
  }) => caller.callServerEndpoint<_i15.RewardPool>('rewardPool', 'create', {
    'actionId': actionId,
    'rewardType': rewardType,
    'totalAmount': totalAmount,
    'perPersonAmount': perPersonAmount,
    'tokenMintAddress': tokenMintAddress,
    'maxRecipients': maxRecipients,
    'expiresAt': expiresAt,
  });

  /// Gets a reward pool by id.
  _i2.Future<_i15.RewardPool> get(int poolId) =>
      caller.callServerEndpoint<_i15.RewardPool>('rewardPool', 'get', {
        'poolId': poolId,
      });

  /// Lists all reward pools for an action.
  _i2.Future<List<_i15.RewardPool>> listByAction(int actionId) =>
      caller.callServerEndpoint<List<_i15.RewardPool>>(
        'rewardPool',
        'listByAction',
        {'actionId': actionId},
      );

  /// Lists all reward pools created by the authenticated user.
  _i2.Future<List<_i15.RewardPool>> listByCreator() =>
      caller.callServerEndpoint<List<_i15.RewardPool>>(
        'rewardPool',
        'listByCreator',
        {},
      );

  /// Cancels a reward pool (only the creator can cancel).
  _i2.Future<_i15.RewardPool> cancel(int poolId) =>
      caller.callServerEndpoint<_i15.RewardPool>('rewardPool', 'cancel', {
        'poolId': poolId,
      });

  /// Lists all distributions from a reward pool.
  _i2.Future<List<_i16.RewardDistribution>> getDistributions(int poolId) =>
      caller.callServerEndpoint<List<_i16.RewardDistribution>>(
        'rewardPool',
        'getDistributions',
        {'poolId': poolId},
      );
}

/// Endpoint for seeding the database with default data.
///
/// All methods require authentication. This is intended for administrative
/// use to populate the database with initial action definitions and
/// categories.
/// {@category Endpoint}
class EndpointSeed extends _i1.EndpointRef {
  EndpointSeed(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'seed';

  /// Seeds the database with default actions and their associated
  /// categories, steps, and rewards.
  _i2.Future<void> seedDefaultActions() =>
      caller.callServerEndpoint<void>('seed', 'seedDefaultActions', {});
}

/// Endpoint for Solana wallet management.
///
/// Allows users to create custodial wallets, link external wallets,
/// and query balances.
/// {@category Endpoint}
class EndpointSolana extends _i1.EndpointRef {
  EndpointSolana(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'solana';

  /// Creates a custodial wallet for the authenticated user.
  _i2.Future<_i17.SolanaWallet> createWallet({String? label}) =>
      caller.callServerEndpoint<_i17.SolanaWallet>('solana', 'createWallet', {
        'label': label,
      });

  /// Links an external Solana wallet.
  _i2.Future<_i17.SolanaWallet> linkWallet(String publicKey, {String? label}) =>
      caller.callServerEndpoint<_i17.SolanaWallet>('solana', 'linkWallet', {
        'publicKey': publicKey,
        'label': label,
      });

  /// Lists all wallets for the authenticated user.
  _i2.Future<List<_i17.SolanaWallet>> getWallets() => caller
      .callServerEndpoint<List<_i17.SolanaWallet>>('solana', 'getWallets', {});

  /// Sets a wallet as the user's default for receiving rewards.
  _i2.Future<_i17.SolanaWallet> setDefaultWallet(int walletId) =>
      caller.callServerEndpoint<_i17.SolanaWallet>(
        'solana',
        'setDefaultWallet',
        {'walletId': walletId},
      );

  /// Gets the SOL balance of the user's default wallet.
  _i2.Future<double> getBalance() =>
      caller.callServerEndpoint<double>('solana', 'getBalance', {});
}

/// Endpoint for managing action submissions.
///
/// All methods require authentication. Submissions represent a performer's
/// attempt to complete an action, including video evidence for verification.
/// {@category Endpoint}
class EndpointSubmission extends _i1.EndpointRef {
  EndpointSubmission(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'submission';

  /// Creates a new submission for an action.
  _i2.Future<_i18.ActionSubmission> create(_i18.ActionSubmission submission) =>
      caller.callServerEndpoint<_i18.ActionSubmission>('submission', 'create', {
        'submission': submission,
      });

  /// Lists all submissions for a given action.
  _i2.Future<List<_i18.ActionSubmission>> listByAction(int actionId) =>
      caller.callServerEndpoint<List<_i18.ActionSubmission>>(
        'submission',
        'listByAction',
        {'actionId': actionId},
      );

  /// Lists all submissions by the authenticated performer.
  _i2.Future<List<_i18.ActionSubmission>> listByPerformer() =>
      caller.callServerEndpoint<List<_i18.ActionSubmission>>(
        'submission',
        'listByPerformer',
        {},
      );

  /// Retrieves a single submission by its ID.
  _i2.Future<_i18.ActionSubmission> get(int id) =>
      caller.callServerEndpoint<_i18.ActionSubmission>('submission', 'get', {
        'id': id,
      });

  /// Gets the sequential progress for a multi-step action.
  ///
  /// Returns the list of submissions representing the performer's progress
  /// through each step of the action.
  _i2.Future<List<_i18.ActionSubmission>> getSequentialProgress(int actionId) =>
      caller.callServerEndpoint<List<_i18.ActionSubmission>>(
        'submission',
        'getSequentialProgress',
        {'actionId': actionId},
      );
}

/// Endpoint for managing user follow relationships.
///
/// All methods require authentication. Users can follow and unfollow
/// each other to see activity in their feeds.
/// {@category Endpoint}
class EndpointUserFollow extends _i1.EndpointRef {
  EndpointUserFollow(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userFollow';

  /// Follows another user.
  _i2.Future<_i19.UserFollow> follow(_i1.UuidValue userId) =>
      caller.callServerEndpoint<_i19.UserFollow>('userFollow', 'follow', {
        'userId': userId,
      });

  /// Unfollows another user.
  _i2.Future<void> unfollow(_i1.UuidValue userId) => caller
      .callServerEndpoint<void>('userFollow', 'unfollow', {'userId': userId});

  /// Lists all followers of a user.
  _i2.Future<List<_i19.UserFollow>> listFollowers(_i1.UuidValue userId) =>
      caller.callServerEndpoint<List<_i19.UserFollow>>(
        'userFollow',
        'listFollowers',
        {'userId': userId},
      );

  /// Lists all users that a user is following.
  _i2.Future<List<_i19.UserFollow>> listFollowing(_i1.UuidValue userId) =>
      caller.callServerEndpoint<List<_i19.UserFollow>>(
        'userFollow',
        'listFollowing',
        {'userId': userId},
      );

  /// Checks whether the authenticated user is following a given user.
  _i2.Future<bool> isFollowing(_i1.UuidValue userId) =>
      caller.callServerEndpoint<bool>('userFollow', 'isFollowing', {
        'userId': userId,
      });
}

/// Endpoint for managing user profiles.
///
/// All methods require authentication. Each authenticated user has a single
/// profile containing display information and social links.
/// {@category Endpoint}
class EndpointUserProfile extends _i1.EndpointRef {
  EndpointUserProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  /// Creates a new user profile for the authenticated user.
  _i2.Future<_i20.UserProfile> create(_i20.UserProfile profile) =>
      caller.callServerEndpoint<_i20.UserProfile>('userProfile', 'create', {
        'profile': profile,
      });

  /// Retrieves the authenticated user's profile.
  _i2.Future<_i20.UserProfile> get() =>
      caller.callServerEndpoint<_i20.UserProfile>('userProfile', 'get', {});

  /// Retrieves a user profile by username.
  _i2.Future<_i20.UserProfile?> getByUsername(String username) =>
      caller.callServerEndpoint<_i20.UserProfile?>(
        'userProfile',
        'getByUsername',
        {'username': username},
      );

  /// Updates the authenticated user's profile.
  _i2.Future<_i20.UserProfile> update(_i20.UserProfile profile) =>
      caller.callServerEndpoint<_i20.UserProfile>('userProfile', 'update', {
        'profile': profile,
      });

  /// Searches for user profiles by a query string.
  _i2.Future<List<_i20.UserProfile>> search(String query) =>
      caller.callServerEndpoint<List<_i20.UserProfile>>(
        'userProfile',
        'search',
        {'query': query},
      );
}

/// Endpoint for accessing AI verification results.
///
/// All methods require authentication. Verification results are produced
/// by the AI pipeline after a submission is created.
/// {@category Endpoint}
class EndpointVerification extends _i1.EndpointRef {
  EndpointVerification(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'verification';

  /// Retrieves the verification result for a given submission.
  _i2.Future<_i21.VerificationResult?> getBySubmission(int submissionId) =>
      caller.callServerEndpoint<_i21.VerificationResult?>(
        'verification',
        'getBySubmission',
        {'submissionId': submissionId},
      );

  /// Retries the AI verification for a submission.
  ///
  /// This re-triggers the verification pipeline, which may be useful if
  /// the initial verification encountered an error or produced unexpected
  /// results.
  _i2.Future<_i21.VerificationResult> retryVerification(int submissionId) =>
      caller.callServerEndpoint<_i21.VerificationResult>(
        'verification',
        'retryVerification',
        {'submissionId': submissionId},
      );
}

class Modules {
  Modules(Client client) {
    auth_idp = _i9.Caller(client);
    auth_core = _i10.Caller(client);
  }

  late final _i9.Caller auth_idp;

  late final _i10.Caller auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(_i1.MethodCallContext, Object, StackTrace)? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i22.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    actionCategory = EndpointActionCategory(this);
    action = EndpointAction(this);
    actionStep = EndpointActionStep(this);
    aiAction = EndpointAiAction(this);
    attestation = EndpointAttestation(this);
    authApple = EndpointAuthApple(this);
    authEmail = EndpointAuthEmail(this);
    authGoogle = EndpointAuthGoogle(this);
    geocoding = EndpointGeocoding(this);
    location = EndpointLocation(this);
    reward = EndpointReward(this);
    rewardPool = EndpointRewardPool(this);
    seed = EndpointSeed(this);
    solana = EndpointSolana(this);
    submission = EndpointSubmission(this);
    userFollow = EndpointUserFollow(this);
    userProfile = EndpointUserProfile(this);
    verification = EndpointVerification(this);
    modules = Modules(this);
  }

  late final EndpointActionCategory actionCategory;

  late final EndpointAction action;

  late final EndpointActionStep actionStep;

  late final EndpointAiAction aiAction;

  late final EndpointAttestation attestation;

  late final EndpointAuthApple authApple;

  late final EndpointAuthEmail authEmail;

  late final EndpointAuthGoogle authGoogle;

  late final EndpointGeocoding geocoding;

  late final EndpointLocation location;

  late final EndpointReward reward;

  late final EndpointRewardPool rewardPool;

  late final EndpointSeed seed;

  late final EndpointSolana solana;

  late final EndpointSubmission submission;

  late final EndpointUserFollow userFollow;

  late final EndpointUserProfile userProfile;

  late final EndpointVerification verification;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'actionCategory': actionCategory,
    'action': action,
    'actionStep': actionStep,
    'aiAction': aiAction,
    'attestation': attestation,
    'authApple': authApple,
    'authEmail': authEmail,
    'authGoogle': authGoogle,
    'geocoding': geocoding,
    'location': location,
    'reward': reward,
    'rewardPool': rewardPool,
    'seed': seed,
    'solana': solana,
    'submission': submission,
    'userFollow': userFollow,
    'userProfile': userProfile,
    'verification': verification,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth_idp': modules.auth_idp,
    'auth_core': modules.auth_core,
  };
}
