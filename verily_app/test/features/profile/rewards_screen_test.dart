// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies
// UuidValue is required by Serverpod's generated models.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/profile/providers/rewards_provider.dart';
import 'package:verily_app/src/features/profile/rewards_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

final _mockRewards = <vc.UserReward>[
  vc.UserReward(
    id: 1,
    userId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    rewardId: 100,
    earnedAt: DateTime.utc(2025, 6, 15),
  ),
  vc.UserReward(
    id: 2,
    userId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    rewardId: 200,
    earnedAt: DateTime.utc(2025, 7, 20),
  ),
  vc.UserReward(
    id: 3,
    userId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    rewardId: 300,
    earnedAt: DateTime.utc(2025, 8, 10),
  ),
];

void main() {
  group('RewardsScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          userRewardsProvider.overrideWith((ref) async => _mockRewards),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpRewardsScreen(WidgetTester tester) async {
      await tester.pumpApp(const RewardsScreen(), container: container);
      // Allow the async providers to settle.
      await tester.pumpAndSettle();
    }

    testWidgets('renders total rewards count card with trophy icon', (
      tester,
    ) async {
      await pumpRewardsScreen(tester);

      // 3 mock rewards
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Total Rewards'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('renders Rewards app bar title', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Rewards'), findsOneWidget);
    });

    testWidgets('renders Earned Rewards section header', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Earned Rewards'), findsOneWidget);
      expect(find.byIcon(Icons.military_tech_outlined), findsOneWidget);
    });

    testWidgets('renders reward card labels', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Reward #100'), findsOneWidget);
      expect(find.text('Reward #200'), findsOneWidget);
      expect(find.text('Reward #300'), findsOneWidget);
    });

    testWidgets('renders earned date for rewards', (tester) async {
      await pumpRewardsScreen(tester);

      expect(find.text('Earned Jun 15, 2025'), findsOneWidget);
      expect(find.text('Earned Jul 20, 2025'), findsOneWidget);
      expect(find.text('Earned Aug 10, 2025'), findsOneWidget);
    });

    testWidgets('renders check circle icons for earned rewards', (
      tester,
    ) async {
      await pumpRewardsScreen(tester);

      // Each reward card shows a check_circle icon.
      expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
    });

    testWidgets('renders reward event icons', (tester) async {
      await pumpRewardsScreen(tester);

      // Each reward card shows an emoji_events_outlined icon.
      expect(find.byIcon(Icons.emoji_events_outlined), findsNWidgets(3));
    });

    testWidgets('shows empty state when no rewards', (tester) async {
      final emptyContainer = ProviderContainer(
        overrides: [
          userRewardsProvider.overrideWith((ref) async => <vc.UserReward>[]),
        ],
      );
      addTearDown(emptyContainer.dispose);

      await tester.pumpApp(const RewardsScreen(), container: emptyContainer);
      await tester.pumpAndSettle();

      expect(find.text('No rewards yet'), findsOneWidget);
      expect(
        find.text('Complete actions to start earning rewards'),
        findsOneWidget,
      );
    });
  });
}
