import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import '../generated/protocol.dart';
import 'action_category_service.dart';
import 'action_service.dart';
import 'action_step_service.dart';
import 'reward_service.dart';

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

  /// The [creatorId] used for system-created seed data.
  ///
  /// This is a well-known UUID that identifies the "system" user. It does not
  /// correspond to a real authentication user.
  static final systemCreatorId =
      UuidValue.fromString('00000000-0000-0000-0000-000000000000');

  /// Runs all seed operations: categories first, then actions with rewards.
  static Future<void> seedAll(Session session) async {
    _log.info('Starting database seed...');

    await ActionCategoryService.ensureDefaults(session);
    await _seedDoTenPressUps(session);
    await _seedSevenDayPressUpChallenge(session);
    await _seedStarJumpChampion(session);
    await _seedSayHelloToStrangers(session);

    _log.info('Database seed complete');
  }

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
    );

    await RewardService.createReward(
      session,
      rewardType: 'badge',
      name: 'Press-up Pro',
      description: 'Completed 10 press-ups with verified form',
      iconUrl: null,
      pointValue: 100,
      actionId: action.id!,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 2. 7-Day Press-up Challenge (sequential, 7 steps, fitness, badge reward)
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
      rewardType: 'badge',
      name: '7-Day Warrior',
      description: 'Completed the entire 7-Day Press-up Challenge',
      iconUrl: null,
      pointValue: 500,
      actionId: action.id!,
    );

    _log.info('Seeded action "$title" (id=${action.id}) with 7 steps');
  }

  // ---------------------------------------------------------------------------
  // 3. Star Jump Champion (one-off, fitness, badge reward)
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
    );

    await RewardService.createReward(
      session,
      rewardType: 'badge',
      name: 'Star Jump Champion',
      description: 'Completed 20 star jumps with verified form',
      iconUrl: null,
      pointValue: 100,
      actionId: action.id!,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // 4. Say Hello to 3 Strangers (one-off, social, badge reward)
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
    );

    await RewardService.createReward(
      session,
      rewardType: 'badge',
      name: 'Social Butterfly',
      description: 'Said hello to 3 strangers in public',
      iconUrl: null,
      pointValue: 150,
      actionId: action.id!,
    );

    _log.info('Seeded action "$title" (id=${action.id})');
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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
