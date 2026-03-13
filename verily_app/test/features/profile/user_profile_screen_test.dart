// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/profile/providers/user_profile_provider.dart';
import 'package:verily_app/src/features/profile/user_profile_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

final _mockProfile = vc.UserProfile(
  id: 1,
  authUserId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  username: 'testuser',
  displayName: 'Test User',
  bio: 'Passionate about completing challenges.',
  isPublic: true,
  createdAt: DateTime.utc(2025),
  updatedAt: DateTime.utc(2025),
);

final _mockActions = <vc.Action>[
  vc.Action(
    id: 1,
    title: 'Record 20 push-ups',
    description: 'Do push-ups at a local park.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Show your full body.',
    tags: 'fitness,outdoor',
    createdAt: DateTime.utc(2025),
    updatedAt: DateTime.utc(2025),
  ),
];

void main() {
  group('UserProfileScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          userProfileByUsernameProvider(
            'testuser',
          ).overrideWith((ref) async => _mockProfile),
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpUserProfileScreen(WidgetTester tester) async {
      await tester.pumpApp(
        const UserProfileScreen(userId: 'testuser'),
        container: container,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders Follow button for non-followed user', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('Follow'), findsOneWidget);
      expect(find.byIcon(Icons.person_add_outlined), findsOneWidget);
    });

    testWidgets('renders user display name', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('renders username in app bar and profile', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('@testuser'), findsWidgets);
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

      expect(find.text('Actions'), findsOneWidget);
      expect(find.text('Badges'), findsOneWidget);
    });

    testWidgets('renders more options icon in app bar', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders user actions in Actions tab', (tester) async {
      await pumpUserProfileScreen(tester);

      expect(find.text('Record 20 push-ups'), findsOneWidget);
    });
  });
}
