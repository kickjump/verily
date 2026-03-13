// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations_en.dart';
import 'package:verily_app/src/features/actions/action_detail_screen.dart';
import 'package:verily_app/src/features/actions/providers/action_detail_provider.dart';
import 'package:verily_client/verily_client.dart' as vc;

import '../../helpers/pump_app_l10n.dart';

final _l10n = AppLocalizationsEn();

/// Shared test action used across rendering tests.
vc.Action _createTestAction({
  int id = 1,
  String title = 'Do 20 push-ups in the park',
  String description =
      'Head to any local park and record yourself doing 20 push-ups.',
  String actionType = 'one_off',
  String status = 'active',
  String verificationCriteria =
      '- Full body visible in frame during all push-ups\n'
      '- Must complete 20 consecutive push-ups\n'
      '- Park environment clearly visible in background\n'
      '- Proper push-up form (chest to ground, full extension)',
  String tags = 'Fitness,outdoor,exercise',
  int? maxPerformers = 50,
  int? locationId = 1,
  double? locationRadius = 500,
}) {
  return vc.Action(
    id: id,
    title: title,
    description: description,
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: actionType,
    status: status,
    verificationCriteria: verificationCriteria,
    tags: tags,
    maxPerformers: maxPerformers,
    locationId: locationId,
    locationRadius: locationRadius,
    createdAt: DateTime(2025, 6, 15),
    updatedAt: DateTime(2025, 6, 15),
  );
}

void main() {
  group('ActionDetailScreen — rendering', () {
    late vc.Action testAction;
    late ProviderContainer container;

    setUp(() {
      testAction = _createTestAction();
      container = ProviderContainer(
        overrides: [
          actionDetailProvider.overrideWith(
            (ref, actionId) async => testAction,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpActionDetailScreen(WidgetTester tester) async {
      await tester.pumpAppL10n(
        const ActionDetailScreen(actionId: '1'),
        container: container,
      );
      // Wait for the async provider to resolve.
      await tester.pumpAndSettle();
    }

    testWidgets('renders action title', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Do 20 push-ups in the park'), findsOneWidget);
    });

    testWidgets('renders Action Details app bar title', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text(_l10n.actionDetailTitle), findsOneWidget);
    });

    testWidgets('renders Start Action button', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Submit Video'), findsOneWidget);
      expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
    });

    testWidgets('renders Verification Criteria section header', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text(_l10n.verificationCriteria), findsOneWidget);
      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
    });

    testWidgets('renders verification criteria items', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(
        find.text('Full body visible in frame during all push-ups'),
        findsOneWidget,
      );
      expect(
        find.text('Must complete 20 consecutive push-ups'),
        findsOneWidget,
      );
      expect(
        find.text('Park environment clearly visible in background'),
        findsOneWidget,
      );
      expect(
        find.text('Proper push-up form (chest to ground, full extension)'),
        findsOneWidget,
      );
    });

    testWidgets('renders Location section', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text(_l10n.actionLocation), findsOneWidget);
      expect(find.text('Location set'), findsOneWidget);
      expect(find.text('Within 500m radius'), findsOneWidget);
    });

    testWidgets('renders category and type badges', (tester) async {
      await pumpActionDetailScreen(tester);

      // 'Fitness' appears both in the category badge and in the Tags section.
      expect(find.text('Fitness'), findsNWidgets(2));
      expect(find.text('One-Off'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('renders share action in app bar', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    });

    testWidgets('renders metadata rows', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text(_l10n.actionMaxPerformers), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('renders created date', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text(_l10n.actionCreatedLabel), findsOneWidget);
      expect(find.text('Jun 15, 2025'), findsOneWidget);
    });

    testWidgets('renders action description', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(
        find.text(
          'Head to any local park and record yourself doing 20 push-ups.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders tag chips', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('outdoor'), findsOneWidget);
      expect(find.text('exercise'), findsOneWidget);
    });

    // Note: The loading shimmer state is not tested here because
    // ShimmerActionDetail uses flutter_animate with repeating shimmer
    // animations that leave pending timers, which conflict with the
    // test framework's timer invariant checks.

    testWidgets('shows error state with retry button', (tester) async {
      final errorContainer = ProviderContainer(
        overrides: [
          actionDetailProvider.overrideWith(
            (ref, actionId) async => throw Exception('Not found'),
          ),
        ],
      );
      addTearDown(errorContainer.dispose);

      await tester.pumpAppL10n(
        const ActionDetailScreen(actionId: '1'),
        container: errorContainer,
      );
      await tester.pumpAndSettle();

      expect(find.text(_l10n.actionLoadFailed), findsOneWidget);
      expect(find.text(_l10n.retry), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows invalid ID message for non-numeric actionId', (
      tester,
    ) async {
      await tester.pumpAppL10n(
        const ActionDetailScreen(actionId: 'abc'),
        container: container,
      );
      await tester.pumpAndSettle();

      expect(find.text(_l10n.actionInvalidId), findsOneWidget);
    });

    testWidgets('hides Location section when no locationId', (tester) async {
      final noLocationAction = _createTestAction(
        locationId: null,
        locationRadius: null,
      );
      final noLocContainer = ProviderContainer(
        overrides: [
          actionDetailProvider.overrideWith(
            (ref, actionId) async => noLocationAction,
          ),
        ],
      );
      addTearDown(noLocContainer.dispose);

      await tester.pumpAppL10n(
        const ActionDetailScreen(actionId: '1'),
        container: noLocContainer,
      );
      await tester.pumpAndSettle();

      expect(find.text('Location set'), findsNothing);
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);
    });

    testWidgets('renders habit action metadata', (tester) async {
      final habitAction = vc.Action(
        id: 10,
        title: 'Morning meditation streak',
        description: 'Meditate for 7 days straight.',
        creatorId: vc.UuidValue.fromString(
          '00000000-0000-0000-0000-000000000001',
        ),
        actionType: 'habit',
        status: 'active',
        verificationCriteria: '- Show seated posture\n- Timer visible',
        tags: 'wellness,meditation',
        habitDurationDays: 7,
        habitFrequencyPerWeek: 7,
        createdAt: DateTime(2025, 6, 15),
        updatedAt: DateTime(2025, 6, 15),
      );

      final habitContainer = ProviderContainer(
        overrides: [
          actionDetailProvider.overrideWith(
            (ref, actionId) async => habitAction,
          ),
        ],
      );
      addTearDown(habitContainer.dispose);

      await tester.pumpAppL10n(
        const ActionDetailScreen(actionId: '10'),
        container: habitContainer,
      );
      await tester.pumpAndSettle();

      expect(find.text('Habit'), findsOneWidget);
      expect(find.text(_l10n.actionDuration), findsOneWidget);
      expect(find.text('7 days'), findsOneWidget);
      expect(find.text(_l10n.actionFrequency), findsOneWidget);
      expect(find.text('7x per week'), findsOneWidget);
    });
  });

  group('ActionDetailScreen — navigation', () {
    testWidgets('tapping Start Action button navigates to video recording', (
      tester,
    ) async {
      String? navigatedPath;
      final testAction = _createTestAction();

      final router = GoRouter(
        initialLocation: '/action/1',
        routes: [
          GoRoute(
            path: '/action/:actionId',
            builder: (context, state) =>
                ActionDetailScreen(actionId: state.pathParameters['actionId']!),
          ),
          GoRoute(
            path: '/submissions/:actionId/record',
            builder: (context, state) {
              navigatedPath = state.uri.toString();
              return Scaffold(
                body: Center(
                  child: Text('Recording ${state.pathParameters['actionId']}'),
                ),
              );
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          actionDetailProvider.overrideWith(
            (ref, actionId) async => testAction,
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpAppL10n(
        const SizedBox.shrink(),
        container: container,
        router: router,
      );
      await tester.pumpAndSettle();

      // Verify the Start Action button is visible.
      final startButton = find.byKey(
        const Key('actionDetail_startActionButton'),
      );
      expect(startButton, findsOneWidget);

      // Tap the Start Action button.
      await tester.tap(startButton);
      await tester.pumpAndSettle();

      // Verify navigation to the video recording route with correct action ID.
      expect(navigatedPath, equals('/submissions/1/record'));
      expect(find.text('Recording 1'), findsOneWidget);
    });

    testWidgets(
      'Start Action button navigates with correct actionId for different IDs',
      (tester) async {
        String? navigatedPath;
        final testAction = _createTestAction(id: 42);

        final router = GoRouter(
          initialLocation: '/action/42',
          routes: [
            GoRoute(
              path: '/action/:actionId',
              builder: (context, state) => ActionDetailScreen(
                actionId: state.pathParameters['actionId']!,
              ),
            ),
            GoRoute(
              path: '/submissions/:actionId/record',
              builder: (context, state) {
                navigatedPath = state.uri.toString();
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Recording ${state.pathParameters['actionId']}',
                    ),
                  ),
                );
              },
            ),
          ],
        );

        final container = ProviderContainer(
          overrides: [
            actionDetailProvider.overrideWith(
              (ref, actionId) async => testAction,
            ),
          ],
        );
        addTearDown(container.dispose);

        await tester.pumpAppL10n(
          const SizedBox.shrink(),
          container: container,
          router: router,
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('actionDetail_startActionButton')),
        );
        await tester.pumpAndSettle();

        expect(navigatedPath, equals('/submissions/42/record'));
        expect(find.text('Recording 42'), findsOneWidget);
      },
    );

    testWidgets('Start Action button shows videocam icon and correct label', (
      tester,
    ) async {
      final testAction = _createTestAction();

      final router = GoRouter(
        initialLocation: '/action/1',
        routes: [
          GoRoute(
            path: '/action/:actionId',
            builder: (context, state) =>
                ActionDetailScreen(actionId: state.pathParameters['actionId']!),
          ),
          GoRoute(
            path: '/submissions/:actionId/record',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Recording'))),
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          actionDetailProvider.overrideWith(
            (ref, actionId) async => testAction,
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpAppL10n(
        const SizedBox.shrink(),
        container: container,
        router: router,
      );
      await tester.pumpAndSettle();

      // Verify the button has the correct label and icon.
      expect(find.text('Submit Video'), findsOneWidget);
      expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
    });
  });
}
