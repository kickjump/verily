import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/rewards/reward_pool_detail_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('RewardPoolDetailScreen', () {
    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
      );

      expect(find.text('Reward Pool'), findsOneWidget);
    });

    testWidgets('shows status badge', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
      );

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows pool info rows', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
      );

      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Type'), findsOneWidget);
      expect(find.text('Total Amount'), findsOneWidget);
      expect(find.text('Per Person'), findsOneWidget);
      expect(find.text('Platform Fee'), findsOneWidget);
    });

    testWidgets('shows distribution progress', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
      );

      expect(find.text('Distribution Progress'), findsOneWidget);
      expect(find.text('15% distributed'), findsOneWidget);
    });

    testWidgets('shows recent distributions section', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
      );

      expect(find.text('Recent Distributions'), findsOneWidget);
      expect(find.text('No distributions yet'), findsOneWidget);
    });

    testWidgets('has overflow menu with cancel option', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
      );

      // Find the popup menu button
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });
  });
}
