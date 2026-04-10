// UuidValue is required by Serverpod's generated Action model.
// ignore_for_file: experimental_member_use

import 'package:verily_client/verily_client.dart';

/// Pre-built mock actions for demo and development fallback.
final demoActions = <Action>[
  Action(
    id: 1,
    title: 'Record 20 push-ups at a local park',
    description:
        'Head to any local park and record yourself doing 20 push-ups. '
        'Make sure your full body is visible and the park environment is '
        'clearly in frame.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Show your full body in frame while doing all reps. '
        'Capture ambient park audio from start to finish. '
        'Pan camera to a park sign before ending recording.',
    tags: 'fitness,outdoor,exercise',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Action(
    id: 2,
    title: 'Capture a 30s cleanup clip on your street',
    description:
        'Record yourself picking up litter on your street for at least '
        '30 seconds. Show the before and after state.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Record litter before and after cleanup. '
        'Keep gloves and collection bag visible in video. '
        'Show street name sign in the first 10 seconds.',
    tags: 'environment,community,cleanup',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  Action(
    id: 3,
    title: 'Film a 1 minute kindness action',
    description:
        'Record yourself performing a random act of kindness in your '
        'community. This could be helping someone carry groceries, '
        'giving a compliment, or any positive interaction.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Clearly show the positive interaction in one take. '
        'Capture consent-friendly angle with no private details. '
        'Show the community center sign before wrapping up.',
    tags: 'community,social,kindness',
    createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  Action(
    id: 4,
    title: 'Morning meditation - 7 day streak',
    description:
        'Meditate for at least 5 minutes every morning for 7 days in a row. '
        'Record a short clip at the beginning and end of each session.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    actionType: 'habit',
    status: 'active',
    habitDurationDays: 7,
    habitFrequencyPerWeek: 7,
    habitTotalRequired: 7,
    verificationCriteria:
        'Record yourself in a seated meditation posture. '
        'Show a timer or clock at the start and end. '
        'Capture at least 30 seconds of the meditation session.',
    tags: 'wellness,meditation,habit',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Action(
    id: 5,
    title: 'Visit 3 local coffee shops and review',
    description:
        'Visit three different local coffee shops in your area. At each one, '
        'order a drink, film a short review, and show the storefront.',
    creatorId: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    actionType: 'sequential',
    status: 'active',
    totalSteps: 3,
    stepOrdering: 'unordered',
    verificationCriteria:
        'Show the storefront and shop name clearly. '
        'Film yourself ordering and tasting the drink. '
        'Give a brief verbal review of the experience.',
    tags: 'food,social,adventure,review',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

/// Demo user profile for unauthenticated demo mode.
final demoUserProfile = UserProfile(
  id: 1,
  authUserId: UuidValue.fromString('00000000-0000-0000-0000-demo00000001'),
  username: 'demo_user',
  displayName: 'Demo User',
  bio: 'Exploring Verily in demo mode.',
  isPublic: true,
  createdAt: DateTime.now().subtract(const Duration(days: 30)),
  updatedAt: DateTime.now(),
);
