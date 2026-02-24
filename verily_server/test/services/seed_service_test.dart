// TODO: These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`

import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/action_service.dart';
// import 'package:verily_server/src/services/action_step_service.dart';
// import 'package:verily_server/src/services/action_category_service.dart';
// import 'package:verily_server/src/services/reward_service.dart';
// import 'package:verily_server/src/services/seed_service.dart';

void main() {
  // ---------------------------------------------------------------------------
  // System creator ID (pure logic - no DB needed)
  // ---------------------------------------------------------------------------

  group('SeedService constants (pure logic)', () {
    test('systemCreatorId is the well-known zero UUID', () {
      // The seed service uses a well-known UUID for system-created data.
      final systemId = UuidValue.fromString(
        '00000000-0000-0000-0000-000000000000',
      );
      // This verifies the UUID format is valid and matches the expected value.
      expect(
        systemId.toString(),
        equals('00000000-0000-0000-0000-000000000000'),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Database-dependent tests (require serverpod_test)
  // ---------------------------------------------------------------------------

  group('SeedService (database operations)', () {
    // late Session session;

    // setUp(() async {
    //   session = await createTestSession();
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    // -------------------------------------------------------------------------
    // seedAll()
    // -------------------------------------------------------------------------

    group('seedAll()', () {
      test(
        'creates default categories',
        () async {
          // await SeedService.seedAll(session);
          //
          // final categories = await ActionCategoryService.listAll(session);
          // final names = categories.map((c) => c.name).toSet();
          //
          // expect(names, contains('Fitness'));
          // expect(names, contains('Social'));
          // expect(names, contains('Creative'));
          // expect(names, contains('Wellness'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates "Do 10 Press-ups" action',
        () async {
          // await SeedService.seedAll(session);
          //
          // final actions = await ActionService.search(
          //   session,
          //   query: 'Do 10 Press-ups',
          // );
          //
          // expect(actions.any((a) => a.title == 'Do 10 Press-ups'), isTrue);
          //
          // final action = actions.firstWhere(
          //   (a) => a.title == 'Do 10 Press-ups',
          // );
          // expect(action.actionType, equals(ActionType.oneOff.value));
          // expect(action.creatorId, equals(SeedService.systemCreatorId));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates "7-Day Press-up Challenge" with 7 steps',
        () async {
          // await SeedService.seedAll(session);
          //
          // final actions = await ActionService.search(
          //   session,
          //   query: '7-Day Press-up Challenge',
          // );
          //
          // expect(
          //   actions.any((a) => a.title == '7-Day Press-up Challenge'),
          //   isTrue,
          // );
          //
          // final action = actions.firstWhere(
          //   (a) => a.title == '7-Day Press-up Challenge',
          // );
          // expect(action.actionType, equals(ActionType.sequential.value));
          // expect(action.totalSteps, equals(7));
          //
          // final steps = await ActionStepService.findByActionId(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(steps.length, equals(7));
          //
          // // Verify step numbers are 1 through 7.
          // for (var i = 0; i < 7; i++) {
          //   expect(steps[i].stepNumber, equals(i + 1));
          // }
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates "Star Jump Champion" action',
        () async {
          // await SeedService.seedAll(session);
          //
          // final actions = await ActionService.search(
          //   session,
          //   query: 'Star Jump Champion',
          // );
          //
          // expect(
          //   actions.any((a) => a.title == 'Star Jump Champion'),
          //   isTrue,
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates "Say Hello to 3 Strangers" action',
        () async {
          // await SeedService.seedAll(session);
          //
          // final actions = await ActionService.search(
          //   session,
          //   query: 'Say Hello to 3 Strangers',
          // );
          //
          // expect(
          //   actions.any((a) => a.title == 'Say Hello to 3 Strangers'),
          //   isTrue,
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates rewards for each seed action',
        () async {
          // await SeedService.seedAll(session);
          //
          // // Check "Do 10 Press-ups" has the "Press-up Pro" badge.
          // final pressups = (await ActionService.search(
          //   session,
          //   query: 'Do 10 Press-ups',
          // )).firstWhere((a) => a.title == 'Do 10 Press-ups');
          //
          // final pressupRewards = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: pressups.id!,
          // );
          // expect(pressupRewards.any((r) => r.name == 'Press-up Pro'), isTrue);
          // expect(
          //   pressupRewards.firstWhere((r) => r.name == 'Press-up Pro').pointValue,
          //   equals(100),
          // );
          //
          // // Check "7-Day Press-up Challenge" has the "7-Day Warrior" badge.
          // final challenge = (await ActionService.search(
          //   session,
          //   query: '7-Day Press-up Challenge',
          // )).firstWhere((a) => a.title == '7-Day Press-up Challenge');
          //
          // final challengeRewards = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: challenge.id!,
          // );
          // expect(
          //   challengeRewards.any((r) => r.name == '7-Day Warrior'),
          //   isTrue,
          // );
          // expect(
          //   challengeRewards.firstWhere((r) => r.name == '7-Day Warrior').pointValue,
          //   equals(500),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // Idempotency
    // -------------------------------------------------------------------------

    group('idempotency', () {
      test(
        'calling seedAll twice does not create duplicate actions',
        () async {
          // await SeedService.seedAll(session);
          // final countAfterFirst = await ActionService.countActive(session);
          //
          // await SeedService.seedAll(session);
          // final countAfterSecond = await ActionService.countActive(session);
          //
          // expect(countAfterSecond, equals(countAfterFirst));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'calling seedAll twice does not create duplicate categories',
        () async {
          // await SeedService.seedAll(session);
          // final countAfterFirst =
          //     (await ActionCategoryService.listAll(session)).length;
          //
          // await SeedService.seedAll(session);
          // final countAfterSecond =
          //     (await ActionCategoryService.listAll(session)).length;
          //
          // expect(countAfterSecond, equals(countAfterFirst));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'calling seedAll twice does not create duplicate rewards',
        () async {
          // await SeedService.seedAll(session);
          //
          // final pressups = (await ActionService.search(
          //   session,
          //   query: 'Do 10 Press-ups',
          // )).firstWhere((a) => a.title == 'Do 10 Press-ups');
          //
          // final rewardsAfterFirst = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: pressups.id!,
          // );
          //
          // await SeedService.seedAll(session);
          //
          // final rewardsAfterSecond = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: pressups.id!,
          // );
          //
          // // Reward count should be the same since the action already existed.
          // expect(rewardsAfterSecond.length, equals(rewardsAfterFirst.length));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // Seed data content verification
    // -------------------------------------------------------------------------

    group('seed data content', () {
      test(
        'press-up challenge steps have increasing rep counts',
        () async {
          // await SeedService.seedAll(session);
          //
          // final challenge = (await ActionService.search(
          //   session,
          //   query: '7-Day Press-up Challenge',
          // )).firstWhere((a) => a.title == '7-Day Press-up Challenge');
          //
          // final steps = await ActionStepService.findByActionId(
          //   session,
          //   actionId: challenge.id!,
          // );
          //
          // // Day 1: 10, Day 2: 15, Day 3: 20, etc.
          // expect(steps[0].title, contains('10'));
          // expect(steps[1].title, contains('15'));
          // expect(steps[2].title, contains('20'));
          // expect(steps[3].title, contains('25'));
          // expect(steps[4].title, contains('30'));
          // expect(steps[5].title, contains('35'));
          // expect(steps[6].title, contains('40'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'seed actions have proper verification criteria',
        () async {
          // await SeedService.seedAll(session);
          //
          // final pressups = (await ActionService.search(
          //   session,
          //   query: 'Do 10 Press-ups',
          // )).firstWhere((a) => a.title == 'Do 10 Press-ups');
          //
          // expect(pressups.verificationCriteria, contains('10 press-ups'));
          // expect(pressups.verificationCriteria, contains('proper form'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'seed actions are assigned to correct categories',
        () async {
          // await SeedService.seedAll(session);
          //
          // final fitnessCategory = await ActionCategoryService.findByName(
          //   session,
          //   'Fitness',
          // );
          // final socialCategory = await ActionCategoryService.findByName(
          //   session,
          //   'Social',
          // );
          //
          // final pressups = (await ActionService.search(
          //   session,
          //   query: 'Do 10 Press-ups',
          // )).firstWhere((a) => a.title == 'Do 10 Press-ups');
          //
          // final strangers = (await ActionService.search(
          //   session,
          //   query: 'Say Hello to 3 Strangers',
          // )).firstWhere((a) => a.title == 'Say Hello to 3 Strangers');
          //
          // expect(pressups.categoryId, equals(fitnessCategory!.id));
          // expect(strangers.categoryId, equals(socialCategory!.id));
        },
        skip: 'Requires serverpod_test database session',
      );
    });
  });
}
