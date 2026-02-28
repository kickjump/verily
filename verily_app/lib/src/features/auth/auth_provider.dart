import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_app/src/analytics/posthog_analytics.dart';
import 'package:verily_app/src/features/auth/auth_gateway.dart';

part 'auth_provider.g.dart';

const _bypassAuthForTests = bool.fromEnvironment('BYPASS_AUTH_FOR_TESTS');
const _forceLoggedOutForTests = bool.fromEnvironment(
  'FORCE_LOGGED_OUT_FOR_TESTS',
);

/// Represents the current authentication state.
sealed class AuthState {
  const AuthState();
}

/// The user is authenticated.
@immutable
class Authenticated extends AuthState {
  const Authenticated({
    required this.userId,
    required this.email,
    this.walletAddress,
  });

  /// The unique identifier of the authenticated user.
  final String userId;

  /// The email address of the authenticated user.
  final String email;

  /// The Solana wallet address if authenticated via wallet.
  final String? walletAddress;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Authenticated &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          email == other.email &&
          walletAddress == other.walletAddress;

  @override
  int get hashCode => userId.hashCode ^ email.hashCode ^ walletAddress.hashCode;
}

/// The user is not authenticated.
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// The authentication state is being determined.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Manages authentication state and operations.
@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    if (_bypassAuthForTests) {
      return const Authenticated(
        userId: 'preview_user',
        email: 'preview@verily.fun',
      );
    }
    if (_forceLoggedOutForTests) {
      return const Unauthenticated();
    }

    // Check initial auth status on creation.
    _checkAuth();
    return const AuthLoading();
  }

  /// Attempts to log in with the provided [email] and [password].
  Future<void> login({required String email, required String password}) async {
    state = const AuthLoading();
    try {
      final profile = await ref
          .read(authGatewayProvider)
          .loginWithEmail(email: email, password: password);
      if (!ref.mounted) return;
      final auth = Authenticated(userId: profile.userId, email: profile.email);
      state = auth;
      _identifyPosthog(auth);
    } on Exception catch (e) {
      debugPrint('Login failed: $e');
      if (!ref.mounted) return;
      state = const Unauthenticated();
    }
  }

  /// Attempts to register a new account with the provided credentials.
  Future<Object> startRegistration({required String email}) async {
    state = const AuthLoading();
    try {
      final accountRequestId = await ref
          .read(authGatewayProvider)
          .startEmailRegistration(email: email);
      if (!ref.mounted) return accountRequestId;
      state = const Unauthenticated();
      return accountRequestId;
    } on Exception catch (e) {
      debugPrint('Registration start failed: $e');
      if (!ref.mounted) rethrow;
      state = const Unauthenticated();
      rethrow;
    }
  }

  /// Verifies email ownership and completes account registration.
  Future<void> register({
    required Object accountRequestId,
    required String verificationCode,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      final gateway = ref.read(authGatewayProvider);
      final registrationToken = await gateway.verifyEmailRegistrationCode(
        accountRequestId: accountRequestId,
        verificationCode: verificationCode,
      );
      final profile = await gateway.finishEmailRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      if (!ref.mounted) return;
      final auth = Authenticated(userId: profile.userId, email: profile.email);
      state = auth;
      _identifyPosthog(auth);
    } on Exception catch (e) {
      debugPrint('Registration failed: $e');
      if (!ref.mounted) return;
      state = const Unauthenticated();
      rethrow;
    }
  }

  /// Attempts to log in using Google OAuth.
  Future<void> loginWithGoogle() async {
    state = const AuthLoading();
    try {
      final profile = await ref.read(authGatewayProvider).loginWithGoogle();
      if (!ref.mounted) return;
      final auth = Authenticated(userId: profile.userId, email: profile.email);
      state = auth;
      _identifyPosthog(auth);
    } on Exception catch (e) {
      debugPrint('Google login failed: $e');
      if (!ref.mounted) return;
      state = const Unauthenticated();
    }
  }

  /// Attempts to log in using Apple Sign-In.
  Future<void> loginWithApple() async {
    state = const AuthLoading();
    try {
      final profile = await ref.read(authGatewayProvider).loginWithApple();
      if (!ref.mounted) return;
      final auth = Authenticated(userId: profile.userId, email: profile.email);
      state = auth;
      _identifyPosthog(auth);
    } on Exception catch (e) {
      debugPrint('Apple login failed: $e');
      if (!ref.mounted) return;
      state = const Unauthenticated();
    }
  }

  /// Attempts to log in using a Solana wallet (Mobile Wallet Adapter).
  ///
  /// On Android, the wallet app signs a challenge message to prove ownership.
  /// The server verifies the signature and creates/retrieves the user account.
  Future<void> loginWithWallet({required String publicKey}) async {
    state = const AuthLoading();
    try {
      final profile = await ref
          .read(authGatewayProvider)
          .loginWithWallet(publicKey: publicKey);
      if (!ref.mounted) return;
      final auth = Authenticated(
        userId: profile.userId,
        email: profile.email,
        walletAddress: publicKey,
      );
      state = auth;
      _identifyPosthog(auth);
    } on Exception catch (e) {
      debugPrint('Wallet login failed: $e');
      if (!ref.mounted) return;
      state = const Unauthenticated();
    }
  }

  /// Logs the current user out and resets to unauthenticated state.
  Future<void> logout() async {
    state = const AuthLoading();
    try {
      await ref.read(authGatewayProvider).logout();
      _resetPosthog();
      if (!ref.mounted) return;
      state = const Unauthenticated();
    } on Exception catch (e) {
      debugPrint('Logout failed: $e');
      if (!ref.mounted) return;
      state = const Unauthenticated();
    }
  }

  void _identifyPosthog(Authenticated auth) {
    final posthog = ref.read(posthogInstanceProvider);
    posthog?.identifyUser(
      userId: auth.userId,
      email: auth.email,
      walletAddress: auth.walletAddress,
    );
  }

  void _resetPosthog() {
    final posthog = ref.read(posthogInstanceProvider);
    posthog?.clearUser();
  }

  /// Checks whether the user has an existing authenticated session.
  Future<void> _checkAuth() async {
    try {
      final gateway = ref.read(authGatewayProvider);
      await gateway.initializeSession();
      final profile = await gateway.getCurrentProfile();
      if (!ref.mounted) return;
      if (profile == null) {
        state = const Unauthenticated();
      } else {
        final auth = Authenticated(
          userId: profile.userId,
          email: profile.email,
        );
        state = auth;
        _identifyPosthog(auth);
      }
    } on Exception catch (e) {
      debugPrint('Auth check failed: $e');
      if (!ref.mounted) return;
      state = const Unauthenticated();
    }
  }
}
