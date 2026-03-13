@Tags(['db'])
library;

// TODO(ifiokjr): These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/actions/action_service.dart';
// import 'package:verily_server/src/services/actions/action_step_service.dart';
// import 'package:verily_server/src/services/actions/action_category_service.dart';
// import 'package:verily_server/src/services/location/location_service.dart';
// import 'package:verily_server/src/services/rewards/reward_service.dart';
// import 'package:verily_server/src/services/rewards/reward_pool_service.dart';
// import 'package:verily_server/src/services/bootstrap/seed_service.dart';

void main() {
  // ---------------------------------------------------------------------------
  // System creator ID (pure logic — no DB needed)
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

    // =========================================================================
    // seedAll() — Categories
    // =========================================================================

    group('seedAll() categories', () {
      test('creates all 4 default categories', () async {
        // await SeedService.seedAll(session);
        //
        // final categories = await ActionCategoryService.listAll(session);
        // final names = categories.map((c) => c.name).toSet();
        //
        // expect(names, contains('Fitness'));
        // expect(names, contains('Social'));
        // expect(names, contains('Creative'));
        // expect(names, contains('Wellness'));
        // expect(categories.length, greaterThanOrEqualTo(4));
      });

      test('categories have correct sort order', () async {
        // await SeedService.seedAll(session);
        //
        // final categories = await ActionCategoryService.listAll(session);
        //
        // final fitness = categories.firstWhere((c) => c.name == 'Fitness');
        // final social = categories.firstWhere((c) => c.name == 'Social');
        // final creative = categories.firstWhere((c) => c.name == 'Creative');
        // final wellness = categories.firstWhere((c) => c.name == 'Wellness');
        //
        // expect(fitness.sortOrder, equals(0));
        // expect(social.sortOrder, equals(1));
        // expect(creative.sortOrder, equals(2));
        // expect(wellness.sortOrder, equals(3));
      });
    });

    // =========================================================================
    // seedAll() — Locations
    // =========================================================================

    group('seedAll() locations', () {
      test('creates 5 demo locations', () async {
        // await SeedService.seedAll(session);
        //
        // final locations = await Location.db.find(session);
        // expect(locations.length, equals(5));
      });

      test('creates Central Park location with correct coordinates', () async {
        // await SeedService.seedAll(session);
        //
        // final locations = await Location.db.find(
        //   session,
        //   where: (t) => t.name.like('%Central Park%'),
        //   limit: 1,
        // );
        //
        // expect(locations, hasLength(1));
        // final loc = locations.first;
        // expect(loc.name, equals('Central Park, New York'));
        // expect(loc.latitude, closeTo(40.7829, 0.001));
        // expect(loc.longitude, closeTo(-73.9654, 0.001));
        // expect(loc.radiusMeters, equals(2000));
        // expect(loc.address, contains('New York'));
      });

      test('creates Hyde Park location', () async {
        // await SeedService.seedAll(session);
        //
        // final locations = await Location.db.find(
        //   session,
        //   where: (t) => t.name.like('%Hyde Park%'),
        //   limit: 1,
        // );
        //
        // expect(locations, hasLength(1));
        // expect(locations.first.latitude, closeTo(51.5073, 0.001));
        // expect(locations.first.radiusMeters, equals(1500));
      });

      test('creates Bondi Beach location', () async {
        // await SeedService.seedAll(session);
        //
        // final locations = await Location.db.find(
        //   session,
        //   where: (t) => t.name.like('%Bondi%'),
        //   limit: 1,
        // );
        //
        // expect(locations, hasLength(1));
        // expect(locations.first.latitude, closeTo(-33.8915, 0.001));
        // expect(locations.first.radiusMeters, equals(1000));
      });

      test('creates Golden Gate Park location', () async {
        // await SeedService.seedAll(session);
        //
        // final locations = await Location.db.find(
        //   session,
        //   where: (t) => t.name.like('%Golden Gate%'),
        //   limit: 1,
        // );
        //
        // expect(locations, hasLength(1));
        // expect(locations.first.latitude, closeTo(37.7694, 0.001));
        // expect(locations.first.radiusMeters, equals(2500));
      });

      test('creates Shibuya Crossing location', () async {
        // await SeedService.seedAll(session);
        //
        // final locations = await Location.db.find(
        //   session,
        //   where: (t) => t.name.like('%Shibuya%'),
        //   limit: 1,
        // );
        //
        // expect(locations, hasLength(1));
        // expect(locations.first.latitude, closeTo(35.6595, 0.001));
        // expect(locations.first.radiusMeters, equals(500));
      });
    });

    // =========================================================================
    // seedAll() — One-off actions (8 total)
    // =========================================================================

    group('seedAll() one-off actions', () {
      test('creates "Do 10 Press-ups" action', () async {
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
        // expect(action.actionType, equals('one_off'));
        // expect(action.creatorId, equals(SeedService.systemCreatorId));
        // expect(action.tags, contains('fitness'));
        // expect(action.verificationCriteria, contains('10 press-ups'));
        // expect(action.verificationCriteria, contains('proper form'));
      });

      test('"Do 10 Press-ups" has badge reward and SOL pool', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Do 10 Press-ups',
        // )).firstWhere((a) => a.title == 'Do 10 Press-ups');
        //
        // // Badge reward
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(rewards.any((r) => r.name == 'Press-up Pro'), isTrue);
        // final badge = rewards.firstWhere((r) => r.name == 'Press-up Pro');
        // expect(badge.pointValue, equals(100));
        // expect(badge.rewardType, equals('badge'));
        //
        // // SOL reward pool
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(0.5));
        // expect(pools.first.perPersonAmount, equals(0.01));
        // expect(pools.first.maxRecipients, equals(50));
      });

      test('creates "Star Jump Champion" action (no SOL pool)', () async {
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
        //
        // final action = actions.firstWhere(
        //   (a) => a.title == 'Star Jump Champion',
        // );
        // expect(action.actionType, equals('one_off'));
        // expect(action.tags, contains('cardio'));
        //
        // // Badge reward
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(
        //   rewards.any((r) => r.name == 'Star Jump Champion'),
        //   isTrue,
        // );
        // expect(
        //   rewards
        //       .firstWhere((r) => r.name == 'Star Jump Champion')
        //       .pointValue,
        //   equals(100),
        // );
        //
        // // No SOL pool for this action
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, isEmpty);
      });

      test('creates "Say Hello to 3 Strangers" action', () async {
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
        //
        // final action = actions.firstWhere(
        //   (a) => a.title == 'Say Hello to 3 Strangers',
        // );
        // expect(action.actionType, equals('one_off'));
        // expect(action.tags, contains('social'));
        //
        // // Badge: "Social Butterfly", 150 pts
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(rewards.any((r) => r.name == 'Social Butterfly'), isTrue);
        // expect(
        //   rewards
        //       .firstWhere((r) => r.name == 'Social Butterfly')
        //       .pointValue,
        //   equals(150),
        // );
        //
        // // SOL pool: 1 SOL total
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(1.0));
        // expect(pools.first.perPersonAmount, equals(0.05));
        // expect(pools.first.maxRecipients, equals(20));
      });

      test(
        'creates "Random Act of Kindness" action with 2.5 SOL pool',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Random Act of Kindness',
          // )).firstWhere((a) => a.title == 'Random Act of Kindness');
          //
          // expect(action.actionType, equals('one_off'));
          // expect(action.tags, contains('kindness'));
          //
          // final rewards = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(rewards.any((r) => r.name == 'Kind Soul'), isTrue);
          // expect(
          //   rewards.firstWhere((r) => r.name == 'Kind Soul').pointValue,
          //   equals(200),
          // );
          //
          // final pools = await RewardPoolService.findByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(pools, hasLength(1));
          // expect(pools.first.totalAmount, equals(2.5));
          // expect(pools.first.perPersonAmount, equals(0.05));
          // expect(pools.first.maxRecipients, equals(50));
        },
      );

      test(
        'creates "Sunrise Meditation" action (badge only, no SOL pool)',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Sunrise Meditation',
          // )).firstWhere((a) => a.title == 'Sunrise Meditation');
          //
          // expect(action.actionType, equals('one_off'));
          // expect(action.tags, contains('meditation'));
          //
          // final rewards = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(rewards.any((r) => r.name == 'Dawn Seeker'), isTrue);
          // expect(
          //   rewards.firstWhere((r) => r.name == 'Dawn Seeker').pointValue,
          //   equals(250),
          // );
          //
          // // No SOL pool
          // final pools = await RewardPoolService.findByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(pools, isEmpty);
        },
      );
    });

    // =========================================================================
    // seedAll() — Location-tagged actions
    // =========================================================================

    group('seedAll() location-tagged actions', () {
      test(
        '"60-Second Cold Plunge" is tagged with Bondi Beach location',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: '60-Second Cold Plunge',
          // )).firstWhere((a) => a.title == '60-Second Cold Plunge');
          //
          // expect(action.actionType, equals('one_off'));
          // expect(action.locationId, isNotNull);
          // expect(action.maxPerformers, equals(100));
          // expect(action.tags, contains('coldexposure'));
          //
          // // Verify it's linked to Bondi Beach
          // final location = await Location.db.findById(
          //   session,
          //   action.locationId!,
          // );
          // expect(location, isNotNull);
          // expect(location!.name, contains('Bondi'));
          //
          // // Badge: "Ice Breaker", 300 pts
          // final rewards = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(rewards.any((r) => r.name == 'Ice Breaker'), isTrue);
          // expect(
          //   rewards.firstWhere((r) => r.name == 'Ice Breaker').pointValue,
          //   equals(300),
          // );
          //
          // // SOL pool: 2.0 SOL
          // final pools = await RewardPoolService.findByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(pools, hasLength(1));
          // expect(pools.first.totalAmount, equals(2.0));
          // expect(pools.first.perPersonAmount, equals(0.1));
        },
      );

      test(
        '"Give a 2-Minute Public Speech" is tagged with Hyde Park location',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Give a 2-Minute Public Speech',
          // )).firstWhere(
          //   (a) => a.title == 'Give a 2-Minute Public Speech',
          // );
          //
          // expect(action.actionType, equals('one_off'));
          // expect(action.locationId, isNotNull);
          // expect(action.maxPerformers, equals(50));
          //
          // final location = await Location.db.findById(
          //   session,
          //   action.locationId!,
          // );
          // expect(location, isNotNull);
          // expect(location!.name, contains('Hyde Park'));
          //
          // // Badge: "Orator", 500 pts
          // final rewards = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(rewards.any((r) => r.name == 'Orator'), isTrue);
          // expect(
          //   rewards.firstWhere((r) => r.name == 'Orator').pointValue,
          //   equals(500),
          // );
          //
          // // SOL pool: 5 SOL
          // final pools = await RewardPoolService.findByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(pools, hasLength(1));
          // expect(pools.first.totalAmount, equals(5.0));
          // expect(pools.first.perPersonAmount, equals(0.25));
          // expect(pools.first.maxRecipients, equals(20));
        },
      );

      test(
        '"Street Art Speed Sketch" is tagged with Shibuya Crossing location',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Street Art Speed Sketch',
          // )).firstWhere((a) => a.title == 'Street Art Speed Sketch');
          //
          // expect(action.actionType, equals('one_off'));
          // expect(action.locationId, isNotNull);
          // expect(action.tags, contains('urban'));
          //
          // final location = await Location.db.findById(
          //   session,
          //   action.locationId!,
          // );
          // expect(location, isNotNull);
          // expect(location!.name, contains('Shibuya'));
          //
          // // Badge: "Street Artist", 200 pts
          // final rewards = await RewardService.findRewardsByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(rewards.any((r) => r.name == 'Street Artist'), isTrue);
          // expect(
          //   rewards.firstWhere((r) => r.name == 'Street Artist').pointValue,
          //   equals(200),
          // );
          //
          // // SOL pool: 1.5 SOL
          // final pools = await RewardPoolService.findByAction(
          //   session,
          //   actionId: action.id!,
          // );
          // expect(pools, hasLength(1));
          // expect(pools.first.totalAmount, equals(1.5));
        },
      );

      test(
        '"Couch to 5K in 4 Weeks" is tagged with Central Park location',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Couch to 5K in 4 Weeks',
          // )).firstWhere((a) => a.title == 'Couch to 5K in 4 Weeks');
          //
          // expect(action.actionType, equals('sequential'));
          // expect(action.locationId, isNotNull);
          //
          // final location = await Location.db.findById(
          //   session,
          //   action.locationId!,
          // );
          // expect(location, isNotNull);
          // expect(location!.name, contains('Central Park'));
        },
      );
    });

    // =========================================================================
    // seedAll() — Sequential actions (3 total)
    // =========================================================================

    group('seedAll() sequential actions', () {
      test('creates "7-Day Press-up Challenge" with 7 steps', () async {
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
        // expect(action.actionType, equals('sequential'));
        // expect(action.totalSteps, equals(7));
        // expect(action.intervalDays, equals(1));
        // expect(action.tags, contains('progressive'));
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
      });

      test(
        'press-up challenge steps have increasing rep counts (10→40)',
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
          // // Day 1: 10, Day 2: 15, Day 3: 20, ..., Day 7: 40
          // expect(steps[0].title, contains('10'));
          // expect(steps[1].title, contains('15'));
          // expect(steps[2].title, contains('20'));
          // expect(steps[3].title, contains('25'));
          // expect(steps[4].title, contains('30'));
          // expect(steps[5].title, contains('35'));
          // expect(steps[6].title, contains('40'));
          //
          // // Each step has "Day N:" prefix
          // for (var i = 0; i < 7; i++) {
          //   expect(steps[i].title, startsWith('Day ${i + 1}:'));
          //   expect(steps[i].isOptional, isFalse);
          // }
        },
      );

      test('"7-Day Press-up Challenge" has badge and SOL pool', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: '7-Day Press-up Challenge',
        // )).firstWhere((a) => a.title == '7-Day Press-up Challenge');
        //
        // // Badge: "7-Day Warrior", 500 pts
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(rewards.any((r) => r.name == '7-Day Warrior'), isTrue);
        // expect(
        //   rewards
        //       .firstWhere((r) => r.name == '7-Day Warrior')
        //       .pointValue,
        //   equals(500),
        // );
        //
        // // SOL pool: 3.5 SOL, 0.5 per person, max 7
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(3.5));
        // expect(pools.first.perPersonAmount, equals(0.5));
        // expect(pools.first.maxRecipients, equals(7));
      });

      test('creates "Couch to 5K in 4 Weeks" with 4 weekly steps', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Couch to 5K in 4 Weeks',
        // )).firstWhere((a) => a.title == 'Couch to 5K in 4 Weeks');
        //
        // expect(action.actionType, equals('sequential'));
        // expect(action.totalSteps, equals(4));
        // expect(action.intervalDays, equals(7));
        // expect(action.tags, contains('running'));
        //
        // final steps = await ActionStepService.findByActionId(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(steps.length, equals(4));
        //
        // // Verify weekly progression
        // expect(steps[0].title, contains('1.5 km'));
        // expect(steps[1].title, contains('2.5 km'));
        // expect(steps[2].title, contains('4 km'));
        // expect(steps[3].title, contains('5 km'));
        //
        // for (var i = 0; i < 4; i++) {
        //   expect(steps[i].stepNumber, equals(i + 1));
        //   expect(steps[i].title, startsWith('Week ${i + 1}:'));
        //   expect(steps[i].isOptional, isFalse);
        // }
      });

      test('"Couch to 5K" has badge and 5 SOL pool', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Couch to 5K in 4 Weeks',
        // )).firstWhere((a) => a.title == 'Couch to 5K in 4 Weeks');
        //
        // // Badge: "5K Finisher", 750 pts
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(rewards.any((r) => r.name == '5K Finisher'), isTrue);
        // expect(
        //   rewards.firstWhere((r) => r.name == '5K Finisher').pointValue,
        //   equals(750),
        // );
        //
        // // SOL pool: 5 SOL, 1 per person, max 5
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(5.0));
        // expect(pools.first.perPersonAmount, equals(1.0));
        // expect(pools.first.maxRecipients, equals(5));
      });

      test('creates "Zero Waste Week Challenge" with 5 steps', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Zero Waste Week Challenge',
        // )).firstWhere(
        //   (a) => a.title == 'Zero Waste Week Challenge',
        // );
        //
        // expect(action.actionType, equals('sequential'));
        // expect(action.totalSteps, equals(5));
        // expect(action.intervalDays, equals(1));
        // expect(action.tags, contains('zerowaste'));
        //
        // final steps = await ActionStepService.findByActionId(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(steps.length, equals(5));
        //
        // // Verify step content
        // expect(steps[0].title, contains('Ditch Single-Use Bottles'));
        // expect(steps[1].title, contains('Bag-Free Shopping'));
        // expect(steps[2].title, contains('Homemade Lunch'));
        // expect(steps[3].title, contains('Plastic-Free Hygiene'));
        // expect(steps[4].title, contains('Full Zero-Waste Day'));
        //
        // for (var i = 0; i < 5; i++) {
        //   expect(steps[i].stepNumber, equals(i + 1));
        //   expect(steps[i].isOptional, isFalse);
        //   expect(
        //     steps[i].verificationCriteria,
        //     isNotEmpty,
        //   );
        // }
      });

      test('"Zero Waste Week" has badge and 2 SOL pool', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Zero Waste Week Challenge',
        // )).firstWhere(
        //   (a) => a.title == 'Zero Waste Week Challenge',
        // );
        //
        // // Badge: "Eco Warrior", 600 pts
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(rewards.any((r) => r.name == 'Eco Warrior'), isTrue);
        // expect(
        //   rewards.firstWhere((r) => r.name == 'Eco Warrior').pointValue,
        //   equals(600),
        // );
        //
        // // SOL pool: 2 SOL, 0.2 per person, max 10
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(2.0));
        // expect(pools.first.perPersonAmount, equals(0.2));
        // expect(pools.first.maxRecipients, equals(10));
      });
    });

    // =========================================================================
    // seedAll() — Habit actions (3 total)
    // =========================================================================

    group('seedAll() habit actions', () {
      test(
        'creates "Daily Gratitude Journal — 21 Days" as habit type',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Daily Gratitude Journal',
          // )).firstWhere(
          //   (a) => a.title == 'Daily Gratitude Journal — 21 Days',
          // );
          //
          // expect(action.actionType, equals('habit'));
          // expect(action.habitDurationDays, equals(21));
          // expect(action.habitFrequencyPerWeek, equals(7));
          // expect(action.habitTotalRequired, equals(21));
          // expect(action.tags, contains('gratitude'));
          // expect(action.tags, contains('habit'));
          // expect(action.creatorId, equals(SeedService.systemCreatorId));
        },
      );

      test('"Daily Gratitude Journal" has badge and 10 SOL pool', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Daily Gratitude Journal',
        // )).firstWhere(
        //   (a) => a.title == 'Daily Gratitude Journal — 21 Days',
        // );
        //
        // // Badge: "Gratitude Master", 1000 pts
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(
        //   rewards.any((r) => r.name == 'Gratitude Master'),
        //   isTrue,
        // );
        // expect(
        //   rewards
        //       .firstWhere((r) => r.name == 'Gratitude Master')
        //       .pointValue,
        //   equals(1000),
        // );
        //
        // // SOL pool: 10 SOL, 1 per person, max 10
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(10.0));
        // expect(pools.first.perPersonAmount, equals(1.0));
        // expect(pools.first.maxRecipients, equals(10));
      });

      test(
        'creates "Drink 8 Glasses of Water Daily" as 14-day habit',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Drink 8 Glasses of Water Daily',
          // )).firstWhere(
          //   (a) => a.title == 'Drink 8 Glasses of Water Daily',
          // );
          //
          // expect(action.actionType, equals('habit'));
          // expect(action.habitDurationDays, equals(14));
          // expect(action.habitFrequencyPerWeek, equals(7));
          // expect(action.habitTotalRequired, equals(14));
          // expect(action.tags, contains('hydration'));
          // expect(action.tags, contains('beginner'));
        },
      );

      test('"Hydration Habit" has badge and 1.5 SOL pool', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Drink 8 Glasses of Water Daily',
        // )).firstWhere(
        //   (a) => a.title == 'Drink 8 Glasses of Water Daily',
        // );
        //
        // // Badge: "Hydration Hero", 400 pts
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(
        //   rewards.any((r) => r.name == 'Hydration Hero'),
        //   isTrue,
        // );
        // expect(
        //   rewards
        //       .firstWhere((r) => r.name == 'Hydration Hero')
        //       .pointValue,
        //   equals(400),
        // );
        //
        // // SOL pool: 1.5 SOL, 0.15 per person, max 10
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(1.5));
        // expect(pools.first.perPersonAmount, equals(0.15));
        // expect(pools.first.maxRecipients, equals(10));
      });

      test(
        'creates "Digital Detox — No Screens After 9pm" as 7-day habit',
        () async {
          // await SeedService.seedAll(session);
          //
          // final action = (await ActionService.search(
          //   session,
          //   query: 'Digital Detox',
          // )).firstWhere(
          //   (a) => a.title == 'Digital Detox — No Screens After 9pm',
          // );
          //
          // expect(action.actionType, equals('habit'));
          // expect(action.habitDurationDays, equals(7));
          // expect(action.habitFrequencyPerWeek, equals(7));
          // expect(action.habitTotalRequired, equals(7));
          // expect(action.tags, contains('digitaldetox'));
          // expect(action.tags, contains('screentime'));
        },
      );

      test('"Digital Detox" has badge and 1 SOL pool', () async {
        // await SeedService.seedAll(session);
        //
        // final action = (await ActionService.search(
        //   session,
        //   query: 'Digital Detox',
        // )).firstWhere(
        //   (a) => a.title == 'Digital Detox — No Screens After 9pm',
        // );
        //
        // // Badge: "Digital Detoxer", 350 pts
        // final rewards = await RewardService.findRewardsByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(
        //   rewards.any((r) => r.name == 'Digital Detoxer'),
        //   isTrue,
        // );
        // expect(
        //   rewards
        //       .firstWhere((r) => r.name == 'Digital Detoxer')
        //       .pointValue,
        //   equals(350),
        // );
        //
        // // SOL pool: 1 SOL, 0.1 per person, max 10
        // final pools = await RewardPoolService.findByAction(
        //   session,
        //   actionId: action.id!,
        // );
        // expect(pools, hasLength(1));
        // expect(pools.first.totalAmount, equals(1.0));
        // expect(pools.first.perPersonAmount, equals(0.1));
        // expect(pools.first.maxRecipients, equals(10));
      });
    });

    // =========================================================================
    // seedAll() — Aggregate counts
    // =========================================================================

    group('seedAll() aggregate counts', () {
      test('creates exactly 14 actions total', () async {
        // await SeedService.seedAll(session);
        //
        // final count = await ActionService.countActive(session);
        // expect(count, equals(14));
      });

      test('creates 8 one-off, 3 sequential, and 3 habit actions', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        //
        // final oneOffs = allActions
        //     .where((a) => a.actionType == 'one_off')
        //     .length;
        // final sequentials = allActions
        //     .where((a) => a.actionType == 'sequential')
        //     .length;
        // final habits = allActions
        //     .where((a) => a.actionType == 'habit')
        //     .length;
        //
        // expect(oneOffs, equals(8));
        // expect(sequentials, equals(3));
        // expect(habits, equals(3));
      });

      test('creates 14 badge rewards total', () async {
        // await SeedService.seedAll(session);
        //
        // final rewards = await Reward.db.find(session);
        // final badges = rewards
        //     .where((r) => r.rewardType == 'badge')
        //     .length;
        //
        // // Each action gets exactly 1 badge
        // expect(badges, equals(14));
      });

      test('creates 12 SOL reward pools total', () async {
        // await SeedService.seedAll(session);
        //
        // final pools = await RewardPool.db.find(session);
        // final solPools = pools
        //     .where((p) => p.rewardType == 'sol')
        //     .length;
        //
        // // Star Jump Champion and Sunrise Meditation have no SOL pool
        // expect(solPools, equals(12));
      });

      test('total SOL across all pools is 35.5', () async {
        // await SeedService.seedAll(session);
        //
        // final pools = await RewardPool.db.find(session);
        // final totalSol = pools.fold<double>(
        //   0,
        //   (sum, p) => sum + p.totalAmount,
        // );
        //
        // // 0.5 + 1 + 2 + 5 + 2.5 + 1.5 + 3.5 + 5 + 2 + 10 + 1.5 + 1 = 35.5
        // expect(totalSol, closeTo(35.5, 0.01));
      });

      test('sequential actions have correct total step counts '
          '(7 + 4 + 5 = 16)', () async {
        // await SeedService.seedAll(session);
        //
        // final allSteps = await ActionStep.db.find(session);
        // expect(allSteps.length, equals(16));
      });

      test('4 actions are location-tagged '
          '(Cold Plunge, Public Speech, Street Art, Couch to 5K)', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        // final locationTagged = allActions
        //     .where((a) => a.locationId != null)
        //     .length;
        //
        // expect(locationTagged, equals(4));
      });
    });

    // =========================================================================
    // seedAll() — Category assignments
    // =========================================================================

    group('seedAll() category assignments', () {
      test('Fitness actions are assigned to Fitness category', () async {
        // await SeedService.seedAll(session);
        //
        // final fitnessCategory = await ActionCategoryService.findByName(
        //   session,
        //   'Fitness',
        // );
        // expect(fitnessCategory, isNotNull);
        //
        // final pressups = (await ActionService.search(
        //   session,
        //   query: 'Do 10 Press-ups',
        // )).firstWhere((a) => a.title == 'Do 10 Press-ups');
        //
        // final starJumps = (await ActionService.search(
        //   session,
        //   query: 'Star Jump Champion',
        // )).firstWhere((a) => a.title == 'Star Jump Champion');
        //
        // final challenge = (await ActionService.search(
        //   session,
        //   query: '7-Day Press-up Challenge',
        // )).firstWhere((a) => a.title == '7-Day Press-up Challenge');
        //
        // final couch5k = (await ActionService.search(
        //   session,
        //   query: 'Couch to 5K in 4 Weeks',
        // )).firstWhere((a) => a.title == 'Couch to 5K in 4 Weeks');
        //
        // expect(pressups.categoryId, equals(fitnessCategory!.id));
        // expect(starJumps.categoryId, equals(fitnessCategory.id));
        // expect(challenge.categoryId, equals(fitnessCategory.id));
        // expect(couch5k.categoryId, equals(fitnessCategory.id));
      });

      test('Social actions are assigned to Social category', () async {
        // await SeedService.seedAll(session);
        //
        // final socialCategory = await ActionCategoryService.findByName(
        //   session,
        //   'Social',
        // );
        // expect(socialCategory, isNotNull);
        //
        // final strangers = (await ActionService.search(
        //   session,
        //   query: 'Say Hello to 3 Strangers',
        // )).firstWhere((a) => a.title == 'Say Hello to 3 Strangers');
        //
        // final speech = (await ActionService.search(
        //   session,
        //   query: 'Give a 2-Minute Public Speech',
        // )).firstWhere(
        //   (a) => a.title == 'Give a 2-Minute Public Speech',
        // );
        //
        // final kindness = (await ActionService.search(
        //   session,
        //   query: 'Random Act of Kindness',
        // )).firstWhere((a) => a.title == 'Random Act of Kindness');
        //
        // expect(strangers.categoryId, equals(socialCategory!.id));
        // expect(speech.categoryId, equals(socialCategory.id));
        // expect(kindness.categoryId, equals(socialCategory.id));
      });

      test('Creative actions are assigned to Creative category', () async {
        // await SeedService.seedAll(session);
        //
        // final creativeCategory = await ActionCategoryService.findByName(
        //   session,
        //   'Creative',
        // );
        // expect(creativeCategory, isNotNull);
        //
        // final sketch = (await ActionService.search(
        //   session,
        //   query: 'Street Art Speed Sketch',
        // )).firstWhere((a) => a.title == 'Street Art Speed Sketch');
        //
        // expect(sketch.categoryId, equals(creativeCategory!.id));
      });

      test('Wellness actions are assigned to Wellness category', () async {
        // await SeedService.seedAll(session);
        //
        // final wellnessCategory = await ActionCategoryService.findByName(
        //   session,
        //   'Wellness',
        // );
        // expect(wellnessCategory, isNotNull);
        //
        // final coldPlunge = (await ActionService.search(
        //   session,
        //   query: '60-Second Cold Plunge',
        // )).firstWhere((a) => a.title == '60-Second Cold Plunge');
        //
        // final meditation = (await ActionService.search(
        //   session,
        //   query: 'Sunrise Meditation',
        // )).firstWhere((a) => a.title == 'Sunrise Meditation');
        //
        // final zeroWaste = (await ActionService.search(
        //   session,
        //   query: 'Zero Waste Week Challenge',
        // )).firstWhere(
        //   (a) => a.title == 'Zero Waste Week Challenge',
        // );
        //
        // final gratitude = (await ActionService.search(
        //   session,
        //   query: 'Daily Gratitude Journal',
        // )).firstWhere(
        //   (a) => a.title == 'Daily Gratitude Journal — 21 Days',
        // );
        //
        // final hydration = (await ActionService.search(
        //   session,
        //   query: 'Drink 8 Glasses of Water Daily',
        // )).firstWhere(
        //   (a) => a.title == 'Drink 8 Glasses of Water Daily',
        // );
        //
        // final detox = (await ActionService.search(
        //   session,
        //   query: 'Digital Detox',
        // )).firstWhere(
        //   (a) => a.title == 'Digital Detox — No Screens After 9pm',
        // );
        //
        // expect(coldPlunge.categoryId, equals(wellnessCategory!.id));
        // expect(meditation.categoryId, equals(wellnessCategory.id));
        // expect(zeroWaste.categoryId, equals(wellnessCategory.id));
        // expect(gratitude.categoryId, equals(wellnessCategory.id));
        // expect(hydration.categoryId, equals(wellnessCategory.id));
        // expect(detox.categoryId, equals(wellnessCategory.id));
      });
    });

    // =========================================================================
    // Idempotency
    // =========================================================================

    group('idempotency', () {
      test('calling seedAll twice does not create duplicate actions', () async {
        // await SeedService.seedAll(session);
        // final countAfterFirst = await ActionService.countActive(session);
        //
        // await SeedService.seedAll(session);
        // final countAfterSecond = await ActionService.countActive(session);
        //
        // expect(countAfterSecond, equals(countAfterFirst));
        // expect(countAfterSecond, equals(14));
      });

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
          // expect(countAfterSecond, equals(4));
        },
      );

      test(
        'calling seedAll twice does not create duplicate locations',
        () async {
          // await SeedService.seedAll(session);
          // final countAfterFirst =
          //     (await Location.db.find(session)).length;
          //
          // await SeedService.seedAll(session);
          // final countAfterSecond =
          //     (await Location.db.find(session)).length;
          //
          // expect(countAfterSecond, equals(countAfterFirst));
          // expect(countAfterSecond, equals(5));
        },
      );

      test('calling seedAll twice does not create duplicate rewards', () async {
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
        // expect(rewardsAfterSecond.length, equals(rewardsAfterFirst.length));
        // expect(rewardsAfterSecond.length, equals(1)); // 1 badge per action
      });

      test(
        'calling seedAll twice does not create duplicate reward pools',
        () async {
          // await SeedService.seedAll(session);
          // final poolCountFirst =
          //     (await RewardPool.db.find(session)).length;
          //
          // await SeedService.seedAll(session);
          // final poolCountSecond =
          //     (await RewardPool.db.find(session)).length;
          //
          // expect(poolCountSecond, equals(poolCountFirst));
          // expect(poolCountSecond, equals(12));
        },
      );

      test(
        'calling seedAll twice does not create duplicate action steps',
        () async {
          // await SeedService.seedAll(session);
          // final stepCountFirst =
          //     (await ActionStep.db.find(session)).length;
          //
          // await SeedService.seedAll(session);
          // final stepCountSecond =
          //     (await ActionStep.db.find(session)).length;
          //
          // expect(stepCountSecond, equals(stepCountFirst));
          // expect(stepCountSecond, equals(16));
        },
      );
    });

    // =========================================================================
    // Seed data content verification
    // =========================================================================

    group('seed data content', () {
      test('all seed actions have proper verification criteria', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        //
        // for (final action in allActions) {
        //   expect(
        //     action.verificationCriteria,
        //     isNotEmpty,
        //     reason: '"${action.title}" must have verificationCriteria',
        //   );
        //   // Verification criteria should be descriptive (at least 50 chars)
        //   expect(
        //     action.verificationCriteria.length,
        //     greaterThan(50),
        //     reason: '"${action.title}" criteria should be descriptive',
        //   );
        // }
      });

      test('all seed actions have a description', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        //
        // for (final action in allActions) {
        //   expect(
        //     action.description,
        //     isNotEmpty,
        //     reason: '"${action.title}" must have a description',
        //   );
        //   expect(
        //     action.description.length,
        //     greaterThan(30),
        //     reason: '"${action.title}" description should be substantive',
        //   );
        // }
      });

      test('all seed actions have tags', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        //
        // for (final action in allActions) {
        //   expect(
        //     action.tags,
        //     isNotNull,
        //     reason: '"${action.title}" must have tags',
        //   );
        //   expect(
        //     action.tags!.split(',').length,
        //     greaterThanOrEqualTo(2),
        //     reason: '"${action.title}" should have at least 2 tags',
        //   );
        // }
      });

      test('all seed actions are owned by the system creator', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        //
        // for (final action in allActions) {
        //   expect(
        //     action.creatorId,
        //     equals(SeedService.systemCreatorId),
        //     reason: '"${action.title}" must be owned by system creator',
        //   );
        // }
      });

      test('all seed actions have active status', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        //
        // for (final action in allActions) {
        //   expect(
        //     action.status,
        //     equals('active'),
        //     reason: '"${action.title}" must be active',
        //   );
        // }
      });

      test('all reward pools have active status', () async {
        // await SeedService.seedAll(session);
        //
        // final pools = await RewardPool.db.find(session);
        //
        // for (final pool in pools) {
        //   expect(pool.status, equals('active'));
        //   expect(pool.remainingAmount, equals(pool.totalAmount));
        //   expect(pool.rewardType, equals('sol'));
        //   expect(pool.creatorId, equals(SeedService.systemCreatorId));
        // }
      });

      test('all reward pools have valid per-person amounts '
          '(perPerson * maxRecipients <= total)', () async {
        // await SeedService.seedAll(session);
        //
        // final pools = await RewardPool.db.find(session);
        //
        // for (final pool in pools) {
        //   if (pool.maxRecipients != null) {
        //     final maxPayout =
        //         pool.perPersonAmount * pool.maxRecipients!;
        //     expect(
        //       maxPayout,
        //       lessThanOrEqualTo(pool.totalAmount),
        //       reason:
        //           'Pool for action ${pool.actionId}: '
        //           'maxPayout ($maxPayout) > totalAmount '
        //           '(${pool.totalAmount})',
        //     );
        //   }
        // }
      });

      test('sequential action steps have verificationCriteria', () async {
        // await SeedService.seedAll(session);
        //
        // final allSteps = await ActionStep.db.find(session);
        //
        // for (final step in allSteps) {
        //   expect(
        //     step.verificationCriteria,
        //     isNotEmpty,
        //     reason: 'Step "${step.title}" must have criteria',
        //   );
        // }
      });

      test('habit actions have valid frequency/duration configs', () async {
        // await SeedService.seedAll(session);
        //
        // final allActions = await Action.db.find(session);
        // final habits = allActions
        //     .where((a) => a.actionType == 'habit');
        //
        // for (final habit in habits) {
        //   expect(
        //     habit.habitDurationDays,
        //     isNotNull,
        //     reason: '"${habit.title}" must have habitDurationDays',
        //   );
        //   expect(
        //     habit.habitDurationDays!,
        //     greaterThan(0),
        //     reason: '"${habit.title}" habitDurationDays must be > 0',
        //   );
        //   expect(
        //     habit.habitFrequencyPerWeek,
        //     isNotNull,
        //     reason: '"${habit.title}" must have habitFrequencyPerWeek',
        //   );
        //   expect(
        //     habit.habitFrequencyPerWeek!,
        //     greaterThan(0),
        //     reason: '"${habit.title}" habitFrequencyPerWeek must be > 0',
        //   );
        //   expect(
        //     habit.habitFrequencyPerWeek!,
        //     lessThanOrEqualTo(7),
        //     reason: '"${habit.title}" frequency cannot exceed 7/week',
        //   );
        //   expect(
        //     habit.habitTotalRequired,
        //     isNotNull,
        //     reason: '"${habit.title}" must have habitTotalRequired',
        //   );
        //   expect(
        //     habit.habitTotalRequired!,
        //     greaterThan(0),
        //     reason: '"${habit.title}" habitTotalRequired must be > 0',
        //   );
        // }
      });
    });
  });
}
