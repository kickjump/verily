import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:verily_app/src/app/providers/serverpod_client_provider.dart';
import 'package:verily_client/verily_client.dart';

part 'auth_gateway.g.dart';

/// The profile data needed by app auth state.
typedef AuthProfile = ({String userId, String email});

const _googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
const _googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
const _appleServiceIdentifier = String.fromEnvironment(
  'APPLE_SERVICE_IDENTIFIER',
);
const _appleRedirectUri = String.fromEnvironment('APPLE_REDIRECT_URI');

/// Abstraction over app authentication operations.
abstract interface class AuthGateway {
  /// Restores and validates a persisted auth session.
  Future<void> initializeSession();

  /// Returns the current user profile if signed in.
  Future<AuthProfile?> getCurrentProfile();

  /// Signs in using email and password.
  Future<AuthProfile> loginWithEmail({
    required String email,
    required String password,
  });

  /// Starts email registration and returns the account request identifier.
  Future<Object> startEmailRegistration({required String email});

  /// Verifies an email registration code and returns the registration token.
  Future<String> verifyEmailRegistrationCode({
    required Object accountRequestId,
    required String verificationCode,
  });

  /// Completes email registration and signs the user in.
  Future<AuthProfile> finishEmailRegistration({
    required String registrationToken,
    required String password,
  });

  /// Signs in using Google IDP.
  Future<AuthProfile> loginWithGoogle();

  /// Signs in using Apple IDP.
  Future<AuthProfile> loginWithApple();

  /// Signs in using a Solana wallet public key.
  ///
  /// The server links the wallet to an existing or new account.
  Future<AuthProfile> loginWithWallet({required String publicKey});

  /// Signs out from the current device.
  Future<void> logout();
}

@riverpod
AuthGateway authGateway(Ref ref) {
  final client = ref.watch(serverpodClientProvider);
  return ServerpodAuthGateway(client);
}

/// Serverpod-backed auth implementation.
class ServerpodAuthGateway implements AuthGateway {
  ServerpodAuthGateway(this._client);

  final Client _client;

  @override
  Future<void> initializeSession() async {
    await _client.auth.initialize();
    await _initializeGoogleSignIn();
    await _initializeAppleSignIn();
  }

  @override
  Future<AuthProfile?> getCurrentProfile() async {
    if (!_client.auth.isAuthenticated) return null;

    try {
      final profile = await _client.modules.auth_core.userProfileInfo.get();
      return (
        userId: profile.authUserId.toString(),
        email: profile.email ?? '',
      );
    } on Exception {
      final authInfo = _client.auth.authInfo;
      if (authInfo == null) return null;
      return (userId: authInfo.authUserId.toString(), email: '');
    }
  }

  @override
  Future<AuthProfile> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final authSuccess = await _client.authEmail.login(
      email: email,
      password: password,
    );
    await _client.auth.updateSignedInUser(authSuccess);
    return _requireCurrentProfile();
  }

  @override
  Future<Object> startEmailRegistration({required String email}) {
    return _client.authEmail.startRegistration(email: email);
  }

  @override
  Future<String> verifyEmailRegistrationCode({
    required Object accountRequestId,
    required String verificationCode,
  }) {
    return _client.authEmail.caller.callServerEndpoint<String>(
      'authEmail',
      'verifyRegistrationCode',
      {
        'accountRequestId': accountRequestId,
        'verificationCode': verificationCode,
      },
    );
  }

  @override
  Future<AuthProfile> finishEmailRegistration({
    required String registrationToken,
    required String password,
  }) async {
    final authSuccess = await _client.authEmail.finishRegistration(
      registrationToken: registrationToken,
      password: password,
    );
    await _client.auth.updateSignedInUser(authSuccess);
    return _requireCurrentProfile();
  }

  @override
  Future<AuthProfile> loginWithGoogle() async {
    await _initializeGoogleSignIn();

    final account = await GoogleSignIn.instance.authenticate(
      scopeHint: GoogleAuthController.defaultScopes,
    );

    final authorization = await account.authorizationClient.ensureAuthorized(
      GoogleAuthController.defaultScopes,
    );

    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw StateError('Google sign-in did not return an ID token.');
    }

    final authSuccess = await _client.authGoogle.login(
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
    await _client.auth.updateSignedInUser(authSuccess);
    return _requireCurrentProfile();
  }

  @override
  Future<AuthProfile> loginWithApple() async {
    await _initializeAppleSignIn();
    if (!await SignInWithApple.isAvailable()) {
      throw StateError('Sign in with Apple is not available on this platform.');
    }

    final webAuthenticationOptions = await AppleSignInService.instance
        .webAuthenticationOptions();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: AppleAuthController.defaultScopes,
      webAuthenticationOptions: webAuthenticationOptions,
    );

    final identityToken = credential.identityToken;
    if (identityToken == null) {
      throw AppleIdTokenVerificationException();
    }

    final authSuccess = await _client.authApple.login(
      identityToken: identityToken,
      authorizationCode: credential.authorizationCode,
      isNativeApplePlatformSignIn:
          !kIsWeb && (Platform.isIOS || Platform.isMacOS),
      firstName: credential.givenName,
      lastName: credential.familyName,
    );

    await _client.auth.updateSignedInUser(authSuccess);
    return _requireCurrentProfile();
  }

  @override
  Future<AuthProfile> loginWithWallet({required String publicKey}) async {
    // Link the wallet and authenticate via the Solana endpoint.
    // The server creates or retrieves the user account associated with
    // this public key.
    final wallet = await _client.solana.linkWallet(publicKey);

    // If the user is already authenticated, return current profile.
    final profile = await getCurrentProfile();
    if (profile != null) return profile;

    // If not yet authenticated, use the wallet userId as identifier.
    return (userId: wallet.userId.toString(), email: '');
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOutDevice();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _client.auth.initializeGoogleSignIn(
        clientId: _optionalDefine(_googleClientId),
        serverClientId: _optionalDefine(_googleServerClientId),
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('Google Sign-In init skipped: $error\n$stackTrace');
    }
  }

  Future<void> _initializeAppleSignIn() async {
    try {
      await _client.auth.initializeAppleSignIn(
        serviceIdentifier: _optionalDefine(_appleServiceIdentifier),
        redirectUri: _optionalDefine(_appleRedirectUri),
      );
    } on Exception catch (error, stackTrace) {
      debugPrint('Apple Sign-In init skipped: $error\n$stackTrace');
    }
  }

  Future<AuthProfile> _requireCurrentProfile() async {
    final profile = await getCurrentProfile();
    if (profile != null) return profile;
    throw StateError('Sign-in succeeded but no profile was returned.');
  }
}

String? _optionalDefine(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

extension on GoogleSignInAuthorizationClient {
  Future<GoogleSignInClientAuthorization> ensureAuthorized(
    List<String> scopes,
  ) async {
    final authorization = await authorizationForScopes(scopes);
    if (authorization != null) return authorization;
    return authorizeScopes(scopes);
  }
}
