import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/profile/edit_profile_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('EditProfileScreen', () {
    Future<void> pumpEditProfileScreen(WidgetTester tester) async {
      await tester.pumpApp(const EditProfileScreen());
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

    testWidgets('renders Change Photo button', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.text('Change Photo'), findsOneWidget);
    });

    testWidgets('renders camera icon for avatar picker', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
    });

    testWidgets('renders bio character count', (tester) async {
      await pumpEditProfileScreen(tester);

      // The bio text is pre-populated, so a character count should display.
      expect(find.textContaining('/ 250'), findsOneWidget);
    });

    testWidgets('renders form field icons', (tester) async {
      await pumpEditProfileScreen(tester);

      expect(find.byIcon(Icons.alternate_email), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });
  });
}
