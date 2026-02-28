// Smoke test for the Verily app root widget.
// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/main.dart';
import 'package:verily_app/src/features/auth/auth_provider.dart';
import 'package:verily_app/src/routing/app_router.dart';

void main() {
  testWidgets('VerilyApp renders without errors', (WidgetTester tester) async {
    // Provide a minimal GoRouter and a fake auth state to avoid
    // the real ServerpodClient which creates pending timers.
    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Test Home'))),
        ),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuth.new),
        appRouterProvider.overrideWithValue(testRouter),
      ],
    );

    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const VerilyApp()),
    );

    // Just verify the widget tree built without throwing.
    expect(find.byType(VerilyApp), findsOneWidget);
  });
}

/// Fake Auth notifier that starts in [Unauthenticated] state without
/// triggering any server calls.
class _FakeAuth extends Auth {
  @override
  AuthState build() => const Unauthenticated();

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> loginWithGoogle() async {}

  @override
  Future<void> loginWithApple() async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> register({
    required Object accountRequestId,
    required String verificationCode,
    required String password,
  }) async {}
}
