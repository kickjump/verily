import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/profile/user_profile_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('UserProfileScreen', () {
    Future<void> pumpUserProfileScreen(WidgetTester tester) async {
      await tester.pumpApp(
        const UserProfileScreen(userId: 'abc123'),
      );
    }

    testWidgets('renders Follow button for non-followed user', (tester) async {
      await pumpUserProfileScreen(tester);

      // Default state is not following, so the Follow button should show.
      expect(find.text('Follow'), findsOneWidget);
      expect(find.byIcon(Icons.person_add_outlined), findsOneWidget);
    });

    testWidgets('renders user display name', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('User abc123'), findsOneWidget);
    });

    testWidgets('renders username in app bar and profile', (tester) async {
      await pumpUserProfileScreen(tester);

      // AppBar title and username text both show @user_abc123.
      expect(find.text('@user_abc123'), findsWidgets);
    });

    testWidgets('renders Followers stat', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('156'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
    });

    testWidgets('renders Following stat', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('89'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });

    testWidgets('renders Actions stat', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('34'), findsOneWidget);
      // "Actions" appears both as a stat and as a tab label.
      expect(find.text('Actions'), findsWidgets);
    });

    testWidgets('renders bio text', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(
        find.textContaining('Passionate about completing challenges'),
        findsOneWidget,
      );
    });

    testWidgets('renders Actions and Badges tabs', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('Actions'), findsWidgets);
      expect(find.text('Badges'), findsOneWidget);
    });

    testWidgets('renders more options icon in app bar', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });
  });
}
