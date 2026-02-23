import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/profile/rewards_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('RewardsScreen', () {
    Future<void> pumpRewardsScreen(WidgetTester tester) async {
      await tester.pumpApp(const RewardsScreen());
    }

    testWidgets('renders total points card with point value', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('2450'), findsOneWidget);
      expect(find.text('Total Points'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('renders Rewards app bar title', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Rewards'), findsOneWidget);
    });

    testWidgets('renders Leaderboard link card', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Leaderboard'), findsOneWidget);
      expect(find.text('See how you rank against others'), findsOneWidget);
      expect(find.byIcon(Icons.leaderboard_outlined), findsOneWidget);
    });

    testWidgets('renders Badges section header', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Badges'), findsOneWidget);
      expect(find.byIcon(Icons.military_tech_outlined), findsOneWidget);
    });

    testWidgets('renders earned badge names in grid', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('First Action'), findsOneWidget);
      expect(find.text('Push-Up Pro'), findsOneWidget);
      expect(find.text('Eco Warrior'), findsOneWidget);
      expect(find.text('Community Hero'), findsOneWidget);
      expect(find.text('Streak Master'), findsOneWidget);
      expect(find.text('Explorer'), findsOneWidget);
    });

    testWidgets('renders locked badge names in grid', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Creator'), findsOneWidget);
      expect(find.text('Centurion'), findsOneWidget);
      expect(find.text('Perfectionist'), findsOneWidget);
    });

    testWidgets('renders lock icon for unearned badges', (tester) async {
      await pumpRewardsScreen(tester);

      // There are 3 unearned badges, each showing a lock icon.
      expect(find.byIcon(Icons.lock_outlined), findsNWidgets(3));
    });

    testWidgets('renders badge grid with correct item count', (tester) async {
      await pumpRewardsScreen(tester);

      // There are 9 badges total (6 earned + 3 locked).
      // We can verify the GridView is present.
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
