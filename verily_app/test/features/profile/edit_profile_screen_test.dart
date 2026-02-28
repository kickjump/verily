// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies
// UuidValue is required by Serverpod's generated models.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/profile/edit_profile_screen.dart';
import 'package:verily_app/src/features/profile/providers/user_profile_provider.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

final _mockProfile = vc.UserProfile(
  id: 1,
  authUserId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  username: 'johndoe',
  displayName: 'John Doe',
  bio: 'Fitness enthusiast and community builder',
  isPublic: true,
  createdAt: DateTime.utc(2025),
  updatedAt: DateTime.utc(2025),
);

void main() {
  group('EditProfileScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          currentUserProfileProvider.overrideWith((ref) async => _mockProfile),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpEditProfileScreen(WidgetTester tester) async {
      await tester.pumpApp(const EditProfileScreen(), container: container);
      // Allow the async providers to settle.
      await tester.pumpAndSettle();
    }

    testWidgets('renders Username field with pre-populated value', (
      tester,
    ) async {
      await pumpEditProfileScreen(tester);

      expect(find.text('Username'), findsOneWidget);
      // The controller is pre-populated with 'johndoe'.
      expect(find.text('johndoe'), findsOneWidget);
    });

    testWidgets('renders Display Name field with pre-populated value', (
      tester,
    ) async {
      await pumpEditProfileScreen(tester);

      expect(find.text('Display Name'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('renders Bio field with pre-populated value', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.text('Bio'), findsOneWidget);
      expect(
        find.textContaining('Fitness enthusiast and community builder'),
        findsOneWidget,
      );
    });

    testWidgets('renders Save button in app bar', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('renders Edit Profile app bar title', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('renders camera icon for avatar picker', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    testWidgets('renders bio character count', (tester) async {
      await pumpEditProfileScreen(tester);

      // The bio text is pre-populated, so a character count should display.
      // Bio = 'Fitness enthusiast and community builder' = 40 chars
      expect(find.textContaining('/ 250'), findsOneWidget);
    });

    testWidgets('renders form field icons', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.byIcon(Icons.alternate_email), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('shows loading state before data arrives', (tester) async {
      await tester.pumpApp(const EditProfileScreen(), container: container);
      // Don't settle - check the loading state.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
