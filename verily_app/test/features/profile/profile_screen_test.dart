// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies
// UuidValue is required by Serverpod's generated models.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/profile/profile_screen.dart';
import 'package:verily_app/src/features/profile/providers/rewards_provider.dart';
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

final _mockActions = <vc.Action>[
  vc.Action(
    id: 1,
    title: 'Record 20 push-ups at a local park',
    description: 'Head to any local park and do push-ups.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Show your full body in frame.',
    tags: 'fitness',
    createdAt: DateTime.utc(2025),
    updatedAt: DateTime.utc(2025),
  ),
  vc.Action(
    id: 2,
    title: 'Capture a cleanup clip',
    description: 'Record yourself picking up litter.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Record litter before and after cleanup.',
    tags: 'environment',
    createdAt: DateTime.utc(2025),
    updatedAt: DateTime.utc(2025),
  ),
];

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
  group('ProfileScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          currentUserProfileProvider.overrideWith((ref) async => _mockProfile),
          feedActionsProvider.overrideWith((ref) async => _mockActions),
          userRewardsProvider.overrideWith((ref) async => _mockRewards),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpProfileScreen(WidgetTester tester) async {
      await tester.pumpApp(const ProfileScreen(), container: container);
      // Allow the async providers to settle.
      await tester.pumpAndSettle();
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

      expect(find.widgetWithText(AppBar, 'Profile'), findsOneWidget);
    });

    testWidgets('renders stats bar with Actions count', (tester) async {
      await pumpProfileScreen(tester);

      // 2 mock actions
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Actions'), findsWidgets);
    });

    testWidgets('renders stats bar with Rewards count', (tester) async {
      await pumpProfileScreen(tester);

      // 3 mock rewards
      expect(find.text('3'), findsOneWidget);
      expect(find.text('Rewards'), findsWidgets);
    });

    testWidgets('renders Actions tab', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('Actions'), findsWidgets);
    });

    testWidgets('renders Badges tab', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('Badges'), findsWidgets);
    });

    testWidgets('renders Wallet card', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('View balances, tokens & NFTs'), findsOneWidget);
    });

    testWidgets('renders edit profile button in app bar', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('renders settings button in app bar', (tester) async {
      await pumpProfileScreen(tester);

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    });

    testWidgets('shows loading state before data arrives', (tester) async {
      await tester.pumpApp(const ProfileScreen(), container: container);
      // Don't settle - check the loading state.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
