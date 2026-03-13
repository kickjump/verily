import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/actions/action_category_service.dart';
import 'package:verily_server/src/services/actions/action_service.dart';
import 'package:verily_server/src/services/actions/action_step_service.dart';
import 'package:verily_server/src/services/location/location_service.dart';
import 'package:verily_server/src/services/rewards/reward_pool_service.dart';
import 'package:verily_server/src/services/rewards/reward_service.dart';

/// Seeds the database with the built-in default actions and their rewards.
///
/// This service is idempotent -- calling [seedAll] multiple times will not
/// create duplicates because it checks for existing records by title before
/// inserting.
///
/// All methods are static and accept a [Session] as the first parameter.
class SeedService {
  SeedService._();

  static final _log = VLogger('SeedService');

  /// The `creatorId` used for system-created seed data.
  ///
  /// This is a well-known UUID that identifies the "system" user. It does not
  /// correspond to a real authentication user.
  static final systemCreatorId = UuidValue.fromString(
    '00000000-0000-0000-0000-000000000000',
  );

  /// Runs all seed operations: categories first, locations, then actions with
  /// rewards and reward pools.
  static Future<void> seedAll(Session session) async {
    _log.info('Starting database seed...');

    // Ensure default categories exist.
    await ActionCategoryService.ensureDefaults(session);

    // Seed locations for geo-tagged actions.
    await _seedLocations(session);

    // ---------------------------------------------------------------------------
    // ONE-OFF ACTIONS — Quick, single-attempt challenges
    // ---------------------------------------------------------------------------
    await _seedDoTenPressUps(session);
    await _seedStarJumpChampion(session);
    await _seedSayHelloToStrangers(session);
    await _seedColdPlunge(session);
    await _seedPublicSpeech(session);
    await _seedRandomActOfKindness(session);
    await _seedSunriseMeditation(session);
    await _seedStreetArtSketch(session);

    // ---------------------------------------------------------------------------
    // SEQUENTIAL ACTIONS — Multi-step progressions
    // ---------------------------------------------------------------------------
    await _seedSevenDayPressUpChallenge(session);
    await _seedCouchTo5K(session);
    await _seedZeroWasteWeek(session);

    // ---------------------------------------------------------------------------
    // HABIT ACTIONS — Repeated behaviors over time
    // ---------------------------------------------------------------------------
    await _seedDailyGratitudeJournal(session);
    await _seedHydrationHabit(session);
    await _seedDigitalDetox(session);

    _log.info('Database seed complete — all demo actions ready');
  }

  // ===========================================================================
  // LOCATIONS
  // ===========================================================================

  static Future<void> _seedLocations(Session session) async {
    final existing = await Location.db.find(session, limit: 1);
    if (existing.isNotEmpty) {
      _log.info('Locations already seeded, skipping');
      return;
    }

    await LocationService.create(
      session,
      name: 'Central Park, New York',
      latitude: 40.7829,
      longitude: -73.9654,
      radiusMeters: 2000,
      address: 'Central Park, New York, NY 10024',
    );
    await LocationService.create(
      session,
      name: 'Hyde Park, London',
      latitude: 51.5073,
      longitude: -0.1657,
      radiusMeters: 1500,
      address: 'Hyde Park, London W2 2UH, UK',
    );
    await LocationService.create(
      session,
      name: 'Bondi Beach, Sydney',
      latitude: -33.8915,
      longitude: 151.2767,
      radiusMeters: 1000,
      address: 'Bondi Beach, NSW 2026, Australia',
    );
    await LocationService.create(
      session,
      name: 'Golden Gate Park, San Francisco',
      latitude: 37.7694,
      longitude: -122.4862,
      radiusMeters: 2500,
      address: 'Golden Gate Park, San Francisco, CA 94122',
    );
    await LocationService.create(
      session,
      name: 'Shibuya Crossing, Tokyo',
      latitude: 35.6595,
      longitude: 139.7004,
      radiusMeters: 500,
      address: '2-chōme-2-1 Dōgenzaka, Shibuya, Tokyo 150-0043, Japan',
    );

    _log.info('Seeded 5 demo locations');
  }

  // ===========================================================================
  // ONE-OFF ACTIONS
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // 1. Do 10 Press-ups (one-off, fitness, badge reward)
  // ---------------------------------------------------------------------------

  static Future<void> _seedDoTenPressUps(Session session) async {
    const title = 'Do 10 Press-ups';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final fitnessCategory = await ActionCategoryService.findByName(
      session,
      'Fitness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Complete 10 press-ups in a single set and record yourself on '
          'video. Your form should be clearly visible and each rep must show '
          'full range of motion from arms extended to chest near the ground.',
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must show the person performing exactly 10 press-ups '
          'with proper form. Each rep should have full arm extension at the '
          'top and the chest should come close to the ground at the bottom. '
          'The entire body should remain in a straight plank position '
          'throughout. Count each completed rep.',
      categoryId: fitnessCategory?.id,
      tags: 'fitness,strength,beginner,bodyweight',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Press-up Pro',
      description: 'Completed 10 press-ups with verified form',
      pointValue: 100,
      actionId: action.id!,
    );

    // SOL reward pool — 0.5 SOL split across up to 50 performers
    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 0.5,
      perPersonAmount: 0.01,
      maxRecipients: 50,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 2. Star Jump Champion (one-off, fitness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedStarJumpChampion(Session session) async {
    const title = 'Star Jump Champion';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final fitnessCategory = await ActionCategoryService.findByName(
      session,
      'Fitness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Perform 20 star jumps (jumping jacks) in a row. Arms must fully '
          'extend overhead and legs must spread wide on each jump. Record '
          'the full set on video with your whole body visible.',
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must show the person performing 20 star jumps '
          '(jumping jacks). Each jump must show arms extending fully '
          'overhead and legs spreading apart, then returning to a standing '
          'position with arms at the sides. The whole body should be '
          'visible throughout. Count each completed rep.',
      categoryId: fitnessCategory?.id,
      tags: 'fitness,cardio,beginner',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Star Jump Champion',
      description: 'Completed 20 star jumps with verified form',
      pointValue: 100,
      actionId: action.id!,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 3. Say Hello to 3 Strangers (one-off, social)
  // ---------------------------------------------------------------------------

  static Future<void> _seedSayHelloToStrangers(Session session) async {
    const title = 'Say Hello to 3 Strangers';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final socialCategory = await ActionCategoryService.findByName(
      session,
      'Social',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Step out of your comfort zone and say hello to 3 strangers! '
          'Record a short video of yourself greeting people you do not know '
          'in a public place. Be friendly, respectful, and genuine. The '
          'goal is to spread positivity and build confidence in social '
          'situations.',
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must show the person approaching and saying hello to '
          'at least 3 different people who appear to be strangers in a '
          'public setting. Each interaction should be friendly and '
          'respectful. The greetings should be clearly audible or visibly '
          'acknowledged by the strangers. No staged or pre-arranged '
          'interactions.',
      categoryId: socialCategory?.id,
      tags: 'social,confidence,public',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Social Butterfly',
      description: 'Said hello to 3 strangers in public',
      pointValue: 150,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 1,
      perPersonAmount: 0.05,
      maxRecipients: 20,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 4. Cold Plunge Challenge (one-off, wellness, location: Bondi Beach)
  // ---------------------------------------------------------------------------

  static Future<void> _seedColdPlunge(Session session) async {
    const title = '60-Second Cold Plunge';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final wellnessCategory = await ActionCategoryService.findByName(
      session,
      'Wellness',
    );

    // Find Bondi Beach location for geo-tag.
    final locations = await Location.db.find(
      session,
      where: (t) => t.name.like('%Bondi%'),
      limit: 1,
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Submerge yourself in cold water (ocean, lake, or ice bath) for '
          'at least 60 seconds. Film the entire duration showing a visible '
          'timer or countdown. Cold exposure builds mental resilience and '
          "activates your body's recovery systems.",
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must clearly show the person entering cold water and '
          'staying submerged (at least shoulders under) for a minimum of 60 '
          'seconds. A timer, clock, or verbal countdown should be visible or '
          'audible. The person must be recognizable in the video.',
      categoryId: wellnessCategory?.id,
      locationId: locations.isNotEmpty ? locations.first.id : null,
      tags: 'wellness,coldexposure,resilience,advanced',
      maxPerformers: 100,
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Ice Breaker',
      description: 'Survived a 60-second cold plunge',
      pointValue: 300,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 2,
      perPersonAmount: 0.1,
      maxRecipients: 20,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 5. Public Speech Challenge (one-off, social, location: Hyde Park)
  // ---------------------------------------------------------------------------

  static Future<void> _seedPublicSpeech(Session session) async {
    const title = 'Give a 2-Minute Public Speech';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final socialCategory = await ActionCategoryService.findByName(
      session,
      'Social',
    );

    final locations = await Location.db.find(
      session,
      where: (t) => t.name.like('%Hyde Park%'),
      limit: 1,
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Stand in a public space and deliver a 2-minute speech on any '
          "topic you're passionate about. This is about conquering the fear "
          'of public speaking and sharing your voice with the world. Speak '
          'clearly, make eye contact with passersby, and own the moment!',
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must show the person standing in a clearly public space '
          '(park, square, street corner) and delivering a speech for at least '
          '2 minutes. The speech must be audible and directed at the public. '
          'The person should be standing (not sitting) and speaking '
          'continuously. Reading from a phone is acceptable but eye contact '
          'with the surroundings is preferred.',
      categoryId: socialCategory?.id,
      locationId: locations.isNotEmpty ? locations.first.id : null,
      tags: 'social,publicspeaking,confidence,courage',
      maxPerformers: 50,
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Orator',
      description: 'Delivered a 2-minute public speech',
      pointValue: 500,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 5,
      perPersonAmount: 0.25,
      maxRecipients: 20,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 6. Random Act of Kindness (one-off, social)
  // ---------------------------------------------------------------------------

  static Future<void> _seedRandomActOfKindness(Session session) async {
    const title = 'Random Act of Kindness';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final socialCategory = await ActionCategoryService.findByName(
      session,
      'Social',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Perform a genuine act of kindness for a stranger and capture it '
          'on video. Buy someone a coffee, help carry groceries, leave a '
          'generous tip, or clean up a public space. The key is that it must '
          "be spontaneous, genuine, and make someone else's day better.",
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must show the person performing a clear, genuine act of '
          'kindness for someone else. The act should be visible and '
          'unambiguous (e.g., handing coffee to a stranger, helping someone '
          "with bags, picking up litter). The recipient's positive reaction "
          'or the completed kind act should be visible. No staged '
          'interactions — it must appear spontaneous.',
      categoryId: socialCategory?.id,
      tags: 'social,kindness,community,feelgood',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Kind Soul',
      description: 'Performed a verified random act of kindness',
      pointValue: 200,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 2.5,
      perPersonAmount: 0.05,
      maxRecipients: 50,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 7. Sunrise Meditation (one-off, wellness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedSunriseMeditation(Session session) async {
    const title = 'Sunrise Meditation';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final wellnessCategory = await ActionCategoryService.findByName(
      session,
      'Wellness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Wake up before dawn, find a peaceful outdoor spot, and meditate '
          'for 10 minutes as the sun rises. Film a time-lapse or continuous '
          'clip showing you sitting peacefully as the sky transforms. '
          'Connect with nature and start your day with intention.',
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must show the person sitting in a meditative posture '
          'outdoors during sunrise. The sky should visibly transition from '
          'dark/dawn to daylight during the video. The person should remain '
          'still and composed for the visible duration (at least 2 minutes '
          'shown, can be time-lapse). Outdoor setting with visible horizon '
          'or sky required.',
      categoryId: wellnessCategory?.id,
      tags: 'wellness,meditation,mindfulness,sunrise,nature',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Dawn Seeker',
      description: 'Completed a sunrise meditation session',
      pointValue: 250,
      actionId: action.id!,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 8. Street Art Sketch (one-off, creative, location: Shibuya)
  // ---------------------------------------------------------------------------

  static Future<void> _seedStreetArtSketch(Session session) async {
    const title = 'Street Art Speed Sketch';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final creativeCategory = await ActionCategoryService.findByName(
      session,
      'Creative',
    );

    final locations = await Location.db.find(
      session,
      where: (t) => t.name.like('%Shibuya%'),
      limit: 1,
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Set up in a busy public area and create a sketch, drawing, or '
          'painting of your surroundings in under 15 minutes. Film the '
          'entire process from blank page to finished piece. Show the '
          'bustling world around you as you create art in the middle of it.',
      creatorId: systemCreatorId,
      actionType: ActionType.oneOff.value,
      verificationCriteria:
          'The video must show the person creating art (drawing, sketching, '
          'painting) in a public location. The process should start from a '
          'blank surface and show progression to a recognizable piece. The '
          'public setting must be visible (people walking by, street scene). '
          'The finished artwork should be clearly shown at the end.',
      categoryId: creativeCategory?.id,
      locationId: locations.isNotEmpty ? locations.first.id : null,
      tags: 'creative,art,drawing,public,urban',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Street Artist',
      description: 'Created art in a public space',
      pointValue: 200,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 1.5,
      perPersonAmount: 0.1,
      maxRecipients: 15,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ===========================================================================
  // SEQUENTIAL ACTIONS
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // 9. 7-Day Press-up Challenge (sequential, 7 steps, fitness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedSevenDayPressUpChallenge(Session session) async {
    const title = '7-Day Press-up Challenge';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final fitnessCategory = await ActionCategoryService.findByName(
      session,
      'Fitness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Build your press-up strength over 7 days! Each day adds 5 more '
          'press-ups to your target. Start with 10 on Day 1 and work up to '
          '40 by Day 7. Record each day separately.',
      creatorId: systemCreatorId,
      actionType: ActionType.sequential.value,
      verificationCriteria:
          'Each daily video must show the required number of press-ups with '
          'proper form. Full range of motion required for each rep.',
      totalSteps: 7,
      intervalDays: 1,
      categoryId: fitnessCategory?.id,
      tags: 'fitness,strength,progressive,weekly',
    );

    // Create the 7 daily steps.
    final steps = <ActionStep>[];
    for (var day = 1; day <= 7; day++) {
      final reps = 10 + (day - 1) * 5; // 10, 15, 20, 25, 30, 35, 40
      steps.add(
        ActionStep(
          actionId: action.id!,
          stepNumber: day,
          title: 'Day $day: $reps Press-ups',
          description: 'Complete $reps press-ups with proper form.',
          verificationCriteria:
              'Video must show exactly $reps press-ups with full range of '
              'motion. The person must be clearly visible performing each rep '
              'with a straight body position.',
          isOptional: false,
        ),
      );
    }

    await ActionStepService.createBatch(
      session,
      actionId: action.id!,
      steps: steps,
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: '7-Day Warrior',
      description: 'Completed the entire 7-Day Press-up Challenge',
      pointValue: 500,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 3.5,
      perPersonAmount: 0.5,
      maxRecipients: 7,
    );

    _log.info('Seeded action "$title" (id=${action.id}) with 7 steps');
  }

  // ---------------------------------------------------------------------------
  // 10. Couch to 5K — 4-Week Running Plan (sequential, 4 steps, fitness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedCouchTo5K(Session session) async {
    const title = 'Couch to 5K in 4 Weeks';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final fitnessCategory = await ActionCategoryService.findByName(
      session,
      'Fitness',
    );

    final locations = await Location.db.find(
      session,
      where: (t) => t.name.like('%Central Park%'),
      limit: 1,
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Go from zero to a 5K run in just 4 weeks! Each week increases '
          'your distance and endurance. Film each weekly milestone run to '
          "prove your progress. You'll be amazed at what consistent effort "
          'can achieve.',
      creatorId: systemCreatorId,
      actionType: ActionType.sequential.value,
      verificationCriteria:
          'Each weekly video must show the person running outdoors for the '
          'required distance. A running app or GPS watch showing distance '
          'should be visible at the end of the run. The person must be '
          'visibly running (not walking) for the majority of the clip.',
      totalSteps: 4,
      intervalDays: 7,
      categoryId: fitnessCategory?.id,
      locationId: locations.isNotEmpty ? locations.first.id : null,
      tags: 'fitness,running,cardio,progressive,beginner',
    );

    final weeklySteps = [
      (1, '1.5 km', 'Run/walk 1.5 km at your own pace'),
      (2, '2.5 km', 'Run 2.5 km with walking breaks if needed'),
      (3, '4 km', "Run 4 km — you're almost there!"),
      (4, '5 km', 'The full 5K! Run the entire distance'),
    ];

    final steps = <ActionStep>[];
    for (final (week, distance, desc) in weeklySteps) {
      steps.add(
        ActionStep(
          actionId: action.id!,
          stepNumber: week,
          title: 'Week $week: $distance Run',
          description: desc,
          verificationCriteria:
              'Video must show the person completing a $distance run. '
              'A running app or GPS device should display the distance '
              'covered. The person should be outdoors and visibly running.',
          isOptional: false,
        ),
      );
    }

    await ActionStepService.createBatch(
      session,
      actionId: action.id!,
      steps: steps,
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: '5K Finisher',
      description: 'Completed the Couch to 5K challenge',
      pointValue: 750,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 5,
      perPersonAmount: 1,
      maxRecipients: 5,
    );

    _log.info('Seeded action "$title" (id=${action.id}) with 4 steps');
  }

  // ---------------------------------------------------------------------------
  // 11. Zero Waste Week (sequential, 5 steps, wellness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedZeroWasteWeek(Session session) async {
    const title = 'Zero Waste Week Challenge';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final wellnessCategory = await ActionCategoryService.findByName(
      session,
      'Wellness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Transform your environmental impact in 5 progressive steps! '
          'Each step eliminates a category of single-use waste from your '
          'daily life. Document your journey and inspire others to reduce '
          'their footprint.',
      creatorId: systemCreatorId,
      actionType: ActionType.sequential.value,
      verificationCriteria:
          'Each step must be documented with a video showing the specific '
          'waste-reduction action being taken. The person must explain what '
          'they changed and show the reusable alternative.',
      totalSteps: 5,
      intervalDays: 1,
      categoryId: wellnessCategory?.id,
      tags: 'wellness,environment,sustainability,zerowaste',
    );

    final wasteSteps = [
      (
        1,
        'Ditch Single-Use Bottles',
        'Switch to a reusable water bottle for the entire day',
        'Video must show the person using a reusable water bottle and '
            'refusing or avoiding single-use plastic bottles throughout '
            'the day. Show the reusable bottle being filled and used.',
      ),
      (
        2,
        'Bag-Free Shopping',
        'Do a grocery run using only reusable bags and containers',
        'Video must show the person shopping with reusable bags. '
            'No plastic bags should be visible. Show the checkout process '
            'and the reusable bags being used.',
      ),
      (
        3,
        'Homemade Lunch',
        'Prepare and eat lunch from home — no takeout packaging',
        'Video must show the person preparing food at home, packing '
            'it in reusable containers, and eating it. No disposable '
            'packaging or takeout containers should be visible.',
      ),
      (
        4,
        'Plastic-Free Hygiene',
        'Use bar soap, bamboo toothbrush, or other plastic-free alternatives',
        'Video must show the person using plastic-free hygiene products. '
            'Show the products and explain what plastic items they replace.',
      ),
      (
        5,
        'Full Zero-Waste Day',
        'Complete an entire day generating zero single-use waste',
        'Video must document the full day showing all meals, drinks, and '
            'activities completed without generating single-use waste. '
            'Show the empty (or nearly empty) trash at end of day.',
      ),
    ];

    final steps = <ActionStep>[];
    for (final (step, stepTitle, desc, criteria) in wasteSteps) {
      steps.add(
        ActionStep(
          actionId: action.id!,
          stepNumber: step,
          title: 'Step $step: $stepTitle',
          description: desc,
          verificationCriteria: criteria,
          isOptional: false,
        ),
      );
    }

    await ActionStepService.createBatch(
      session,
      actionId: action.id!,
      steps: steps,
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Eco Warrior',
      description: 'Completed the Zero Waste Week Challenge',
      pointValue: 600,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 2,
      perPersonAmount: 0.2,
      maxRecipients: 10,
    );

    _log.info('Seeded action "$title" (id=${action.id}) with 5 steps');
  }

  // ===========================================================================
  // HABIT ACTIONS
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // 12. Daily Gratitude Journal (habit, 21 days, wellness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedDailyGratitudeJournal(Session session) async {
    const title = 'Daily Gratitude Journal — 21 Days';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final wellnessCategory = await ActionCategoryService.findByName(
      session,
      'Wellness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Build a life-changing gratitude practice! Every day for 21 days, '
          "record a short video sharing 3 things you're grateful for. "
          'Research shows 21 days is all it takes to form a lasting habit. '
          'Be specific, be genuine, and watch your mindset transform.',
      creatorId: systemCreatorId,
      actionType: ActionType.habit.value,
      verificationCriteria:
          'Each daily video must show the person speaking to camera and '
          'clearly stating at least 3 specific things they are grateful for. '
          'Generic statements like "I\'m grateful for everything" do not '
          'count — each item must be specific and different from previous '
          'days where possible.',
      habitDurationDays: 21,
      habitFrequencyPerWeek: 7,
      habitTotalRequired: 21,
      categoryId: wellnessCategory?.id,
      tags: 'wellness,gratitude,mindfulness,habit,daily',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Gratitude Master',
      description: 'Completed 21 days of gratitude journaling',
      pointValue: 1000,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 10,
      perPersonAmount: 1,
      maxRecipients: 10,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 13. Hydration Habit (habit, 14 days, wellness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedHydrationHabit(Session session) async {
    const title = 'Drink 8 Glasses of Water Daily';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final wellnessCategory = await ActionCategoryService.findByName(
      session,
      'Wellness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Hydration is the foundation of health! For 14 days, drink at '
          'least 8 glasses (2 liters) of water each day. Film a quick '
          'check-in each day showing your water intake tracking — whether '
          "it's a marked water bottle, an app, or tally marks on paper.",
      creatorId: systemCreatorId,
      actionType: ActionType.habit.value,
      verificationCriteria:
          'Each daily video must show evidence of water consumption tracking. '
          'This can be a marked water bottle showing completion, a hydration '
          'app showing 8+ glasses logged, or a physical tally. The person '
          'should be visible and briefly confirm they hit the daily target.',
      habitDurationDays: 14,
      habitFrequencyPerWeek: 7,
      habitTotalRequired: 14,
      categoryId: wellnessCategory?.id,
      tags: 'wellness,hydration,health,habit,daily,beginner',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Hydration Hero',
      description: 'Drank 8 glasses of water daily for 14 days',
      pointValue: 400,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 1.5,
      perPersonAmount: 0.15,
      maxRecipients: 10,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 14. Digital Detox (habit, 7 days, wellness)
  // ---------------------------------------------------------------------------

  static Future<void> _seedDigitalDetox(Session session) async {
    const title = 'Digital Detox — No Screens After 9pm';

    if (await _actionExists(session, title)) {
      _log.info('Seed action "$title" already exists, skipping');
      return;
    }

    final wellnessCategory = await ActionCategoryService.findByName(
      session,
      'Wellness',
    );

    final action = await ActionService.create(
      session,
      title: title,
      description:
          'Reclaim your evenings! For 7 days, put away all screens (phone, '
          'tablet, laptop, TV) after 9pm. Record a quick video at 9pm '
          'showing your devices being put away, then a morning follow-up '
          'confirming you stayed screen-free until bed. Replace screen time '
          'with reading, journaling, stretching, or conversation.',
      creatorId: systemCreatorId,
      actionType: ActionType.habit.value,
      verificationCriteria:
          'Each daily video should have two parts: (1) An evening clip '
          'recorded around 9pm showing the person putting away their '
          'electronic devices, and (2) a brief morning confirmation that '
          'they remained screen-free for the rest of the evening. The '
          'person should mention what they did instead (reading, talking, '
          'etc). A single combined video is acceptable.',
      habitDurationDays: 7,
      habitFrequencyPerWeek: 7,
      habitTotalRequired: 7,
      categoryId: wellnessCategory?.id,
      tags: 'wellness,digitaldetox,sleep,screentime,habit',
    );

    await RewardService.createReward(
      session,
      rewardType: RewardType.badge.value,
      name: 'Digital Detoxer',
      description: 'Completed 7 days of no screens after 9pm',
      pointValue: 350,
      actionId: action.id!,
    );

    await RewardPoolService.create(
      session,
      actionId: action.id!,
      creatorId: systemCreatorId,
      rewardType: RewardType.sol.value,
      totalAmount: 1,
      perPersonAmount: 0.1,
      maxRecipients: 10,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  /// Checks whether a seed action already exists by its exact title.
  static Future<bool> _actionExists(Session session, String title) async {
    final results = await Action.db.find(
      session,
      where: (t) => t.title.equals(title) & t.creatorId.equals(systemCreatorId),
      limit: 1,
    );
    return results.isNotEmpty;
  }
}
