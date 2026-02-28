// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies
// UuidValue is required by Serverpod's generated models.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/rewards/providers/reward_pool_provider.dart';
import 'package:verily_app/src/features/rewards/reward_pool_detail_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

final _mockPool = vc.RewardPool(
  id: 1,
  actionId: 10,
  creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  rewardType: 'sol',
  totalAmount: 100,
  remainingAmount: 75,
  perPersonAmount: 5,
  platformFeePercent: 5,
  status: 'active',
  createdAt: DateTime.utc(2025, 6),
);

void main() {
  group('RewardPoolDetailScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          fetchRewardPoolProvider.overrideWith(
            (ref, poolId) async => _mockPool,
          ),
          rewardDistributionsProvider.overrideWith(
            (ref, poolId) async => <vc.RewardDistribution>[],
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('renders app bar with title', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
        container: container,
      );

      expect(find.text('Reward Pool'), findsOneWidget);
    });

    testWidgets('shows pool data after loading', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
        container: container,
      );
      await tester.pumpAndSettle();

      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('Distribution Progress'), findsOneWidget);
    });

    testWidgets('has overflow menu button', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
        container: container,
      );

      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('shows no distributions message when empty', (tester) async {
      await tester.pumpApp(
        const RewardPoolDetailScreen(poolId: '1'),
        container: container,
      );
      await tester.pumpAndSettle();

      expect(find.text('No distributions yet'), findsOneWidget);
    });
  });
}
