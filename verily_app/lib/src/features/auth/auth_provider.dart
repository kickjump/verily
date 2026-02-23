import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Represents the current authentication state.
sealed class AuthState {
  const AuthState();
}

/// The user is authenticated.
class Authenticated extends AuthState {
  const Authenticated({required this.userId, required this.email});

  /// The unique identifier of the authenticated user.
  final String userId;

  /// The email address of the authenticated user.
  final String email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Authenticated &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          email == other.email;

  @override
  int get hashCode => userId.hashCode ^ email.hashCode;
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
    // Check initial auth status on creation.
    _checkAuth();
    return const AuthLoading();
  }

  /// Attempts to log in with the provided [email] and [password].
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      // TODO: Integrate with Serverpod auth.
      await Future<void>.delayed(const Duration(seconds: 1));
      state = Authenticated(userId: 'user_1', email: email);
    } on Exception catch (e) {
      debugPrint('Login failed: $e');
      state = const Unauthenticated();
    }
  }

  /// Attempts to register a new account with the provided credentials.
  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    try {
      // TODO: Integrate with Serverpod auth registration.
      await Future<void>.delayed(const Duration(seconds: 1));
      state = Authenticated(userId: 'user_new', email: email);
    } on Exception catch (e) {
      debugPrint('Registration failed: $e');
      state = const Unauthenticated();
    }
  }

  /// Attempts to log in using Google OAuth.
  Future<void> loginWithGoogle() async {
    state = const AuthLoading();
    try {
      // TODO: Integrate with Google Sign-In via Serverpod IDP.
      await Future<void>.delayed(const Duration(seconds: 1));
      state = const Authenticated(
        userId: 'google_user',
        email: 'user@gmail.com',
      );
    } on Exception catch (e) {
      debugPrint('Google login failed: $e');
      state = const Unauthenticated();
    }
  }

  /// Attempts to log in using Apple Sign-In.
  Future<void> loginWithApple() async {
    state = const AuthLoading();
    try {
      // TODO: Integrate with Apple Sign-In via Serverpod IDP.
      await Future<void>.delayed(const Duration(seconds: 1));
      state = const Authenticated(
        userId: 'apple_user',
        email: 'user@icloud.com',
      );
    } on Exception catch (e) {
      debugPrint('Apple login failed: $e');
      state = const Unauthenticated();
    }
  }

  /// Logs the current user out and resets to unauthenticated state.
  Future<void> logout() async {
    state = const AuthLoading();
    try {
      // TODO: Integrate with Serverpod auth logout.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      state = const Unauthenticated();
    } on Exception catch (e) {
      debugPrint('Logout failed: $e');
      state = const Unauthenticated();
    }
  }

  /// Checks whether the user has an existing authenticated session.
  Future<void> _checkAuth() async {
    try {
      // TODO: Check Serverpod session token validity.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      state = const Unauthenticated();
    } on Exception catch (e) {
      debugPrint('Auth check failed: $e');
      state = const Unauthenticated();
    }
  }
}
