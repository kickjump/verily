import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/auth/auth_gateway.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';

void main() {
  group('Auth provider', () {
    test('restores an authenticated session on startup', () async {
      final gateway = _FakeAuthGateway(
        currentProfile: (userId: 'user-1', email: 'user@example.com'),
      );
      final container = ProviderContainer(
        overrides: [authGatewayProvider.overrideWith((ref) => gateway)],
      );
      addTearDown(container.dispose);

      expect(container.read(authProvider), isA<AuthLoading>());

      await _waitForSettledAuthState(container);

      expect(gateway.initializeCalls, 1);
      final state = container.read(authProvider);
      expect(state, isA<Authenticated>());
      final authenticated = state as Authenticated;
      expect(authenticated.userId, 'user-1');
      expect(authenticated.email, 'user@example.com');
    });

    test('loginWithGoogle updates state to authenticated', () async {
      final gateway = _FakeAuthGateway(
        currentProfile: null,
        googleProfile: (userId: 'google-1', email: 'g@example.com'),
      );
      final container = ProviderContainer(
        overrides: [authGatewayProvider.overrideWith((ref) => gateway)],
      );
      addTearDown(container.dispose);

      await _waitForSettledAuthState(container);
      expect(container.read(authProvider), isA<Unauthenticated>());

      await container.read(authProvider.notifier).loginWithGoogle();

      final state = container.read(authProvider);
      expect(state, isA<Authenticated>());
      final authenticated = state as Authenticated;
      expect(authenticated.userId, 'google-1');
      expect(authenticated.email, 'g@example.com');
      expect(gateway.googleLoginCalls, 1);
    });

    test('loginWithApple failure falls back to unauthenticated', () async {
      final gateway = _FakeAuthGateway(
        currentProfile: null,
        throwOnAppleLogin: true,
      );
      final container = ProviderContainer(
        overrides: [authGatewayProvider.overrideWith((ref) => gateway)],
      );
      addTearDown(container.dispose);

      await _waitForSettledAuthState(container);
      expect(container.read(authProvider), isA<Unauthenticated>());

      await container.read(authProvider.notifier).loginWithApple();

      expect(container.read(authProvider), isA<Unauthenticated>());
      expect(gateway.appleLoginCalls, 1);
    });
  });
}

Future<void> _drainAsyncTasks() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Future<void> _waitForSettledAuthState(ProviderContainer container) async {
  for (var i = 0; i < 10; i++) {
    await _drainAsyncTasks();
    if (container.read(authProvider) is! AuthLoading) return;
  }
}

final class _FakeAuthGateway implements AuthGateway {
  _FakeAuthGateway({
    required this.currentProfile,
    this.googleProfile,
    this.throwOnAppleLogin = false,
  });

  final AuthProfile? currentProfile;
  final AuthProfile? googleProfile;
  final bool throwOnAppleLogin;

  int initializeCalls = 0;
  int googleLoginCalls = 0;
  int appleLoginCalls = 0;

  @override
  Future<AuthProfile?> getCurrentProfile() async => currentProfile;

  @override
  Future<void> initializeSession() async {
    initializeCalls += 1;
  }

  @override
  Future<AuthProfile> loginWithApple() async {
    appleLoginCalls += 1;
    if (throwOnAppleLogin) {
      throw Exception('Apple login failed');
    }
    return (userId: 'apple-user', email: 'apple@example.com');
  }

  @override
  Future<AuthProfile> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return (userId: 'email-user', email: email);
  }

  @override
  Future<AuthProfile> loginWithGoogle() async {
    googleLoginCalls += 1;
    return googleProfile ??
        (userId: 'google-user', email: 'google@example.com');
  }

  @override
  Future<void> logout() async {}
}
