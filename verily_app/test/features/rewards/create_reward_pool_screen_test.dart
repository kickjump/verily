import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/rewards/create_reward_pool_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('CreateRewardPoolScreen', () {
    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpApp(
        const CreateRewardPoolScreen(actionId: '1'),
      );

      expect(find.text('Create Reward Pool'), findsOneWidget);
    });

    testWidgets('shows reward type selector', (tester) async {
      await tester.pumpApp(
        const CreateRewardPoolScreen(actionId: '1'),
      );

      expect(find.text('SOL'), findsOneWidget);
      expect(find.text('Token'), findsOneWidget);
      expect(find.text('NFT'), findsOneWidget);
    });

    testWidgets('shows reward type section label', (tester) async {
      await tester.pumpApp(
        const CreateRewardPoolScreen(actionId: '1'),
      );

      expect(find.text('Reward Type'), findsOneWidget);
    });

    testWidgets('shows platform fee info card', (tester) async {
      await tester.pumpApp(
        const CreateRewardPoolScreen(actionId: '1'),
      );

      expect(find.textContaining('5% platform fee'), findsOneWidget);
    });

    testWidgets('shows create button', (tester) async {
      await tester.pumpApp(
        const CreateRewardPoolScreen(actionId: '1'),
      );

      expect(find.text('Fund & Create Pool'), findsOneWidget);
    });

    testWidgets('shows max recipients field', (tester) async {
      await tester.pumpApp(
        const CreateRewardPoolScreen(actionId: '1'),
      );

      expect(find.text('Max Recipients (optional)'), findsOneWidget);
    });
  });
}
