import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/profile/profile_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('ProfileScreen', () {
    Future<void> pumpProfileScreen(WidgetTester tester) async {
      await tester.pumpApp(const ProfileScreen());
    }

    testWidgets('renders user display name', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('renders username', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('@johndoe'), findsOneWidget);
    });

    testWidgets('renders bio text', (tester) async {
      await pumpProfileScreen(tester);

      expect(
        find.textContaining('Fitness enthusiast and community builder'),
        findsOneWidget,
      );
    });

    testWidgets('renders Profile app bar title', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('renders stats bar with Created count', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('12'), findsOneWidget);
      expect(find.text('Created'), findsWidgets);
    });

    testWidgets('renders stats bar with Completed count', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('28'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('renders stats bar with Badges count', (tester) async {
      await pumpProfileScreen(tester);

      // "Badges" appears both as a stat label and a tab name
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Badges'), findsWidgets);
    });

    testWidgets('renders Actions tab', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('Actions'), findsOneWidget);
    });

    testWidgets('renders Badges tab', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('Badges'), findsWidgets);
    });

    testWidgets('renders edit profile button in app bar', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('renders settings button in app bar', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });
  });
}
