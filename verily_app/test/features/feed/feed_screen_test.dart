// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/l10n/generated/app_localizations.dart';
import 'package:verily_app/l10n/generated/app_localizations_en.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/feed/feed_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

import '../../helpers/pump_app_l10n.dart';

/// Mock actions used in feed tests.
final _mockActions = <vc.Action>[
  vc.Action(
    id: 1,
    title: 'Record 20 push-ups at a local park',
    description:
        'Head to any local park and record yourself doing 20 push-ups.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Show your full body in frame while doing all reps.',
    tags: 'fitness,outdoor,exercise',
    createdAt: DateTime(2025, 6, 15),
    updatedAt: DateTime(2025, 6, 15),
  ),
  vc.Action(
    id: 2,
    title: 'Capture a 30s cleanup clip on your street',
    description: 'Record yourself picking up litter on your street.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria: 'Record litter before and after cleanup.',
    tags: 'environment,community,cleanup',
    createdAt: DateTime(2025, 6, 14),
    updatedAt: DateTime(2025, 6, 14),
  ),
];

final _l10n = AppLocalizationsEn();

void main() {
  group('FeedScreen — rendering', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<void> pumpFeedScreen(WidgetTester tester) async {
      await tester.pumpAppL10n(const FeedScreen(), container: container);
      // Wait for the async provider to resolve.
      await tester.pumpAndSettle();
    }

    testWidgets('renders Nearby tab', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text(_l10n.feedNearby), findsOneWidget);
    });

    testWidgets('renders Trending tab', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text(_l10n.feedTrending), findsOneWidget);
    });

    testWidgets('renders FAB with Create Action label', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text(_l10n.createActionTitle), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders app bar with Verily title', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text(_l10n.appName), findsOneWidget);
    });

    testWidgets('renders search icon in app bar', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('renders notifications icon in app bar', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('renders action feed cards in list', (tester) async {
      await pumpFeedScreen(tester);

      // The feed list uses mock data with push-ups action.
      expect(find.textContaining('push-ups'), findsWidgets);
    });

    testWidgets('renders both action card titles', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text('Record 20 push-ups at a local park'), findsOneWidget);
      expect(
        find.text('Capture a 30s cleanup clip on your street'),
        findsOneWidget,
      );
    });

    testWidgets('renders action card descriptions', (tester) async {
      await pumpFeedScreen(tester);

      expect(
        find.text(
          'Head to any local park and record yourself doing 20 push-ups.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Record yourself picking up litter on your street.'),
        findsOneWidget,
      );
    });

    testWidgets('renders category badge chips from tags', (tester) async {
      await pumpFeedScreen(tester);

      // First tag of each action is shown as the category badge.
      expect(find.text('fitness'), findsOneWidget);
      expect(find.text('environment'), findsOneWidget);
    });

    testWidgets('renders "Earn rewards" label on each card', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.text(_l10n.feedEarnRewards), findsNWidgets(2));
    });

    testWidgets('renders One-Off type badge on both cards', (tester) async {
      await pumpFeedScreen(tester);

      // Both mock actions are one_off.
      expect(find.text(_l10n.actionTypeOneOff), findsNWidgets(2));
    });

    testWidgets('shows loading indicator before data resolves', (tester) async {
      // Use a Completer that never completes — no timers left pending.
      final completer = Completer<List<vc.Action>>();
      final loadingContainer = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) => completer.future),
        ],
      );
      addTearDown(loadingContainer.dispose);

      await tester.pumpApp(
        const FeedScreen(),
        container: loadingContainer,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
      // Only pump one frame — don't settle.
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('shows error state with retry button', (tester) async {
      final errorContainer = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith(
            (ref) async => throw Exception('Network error'),
          ),
        ],
      );
      addTearDown(errorContainer.dispose);

      await tester.pumpApp(
        const FeedScreen(),
        container: errorContainer,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
      await tester.pumpAndSettle();

      expect(find.text(_l10n.feedLoadFailed), findsWidgets);
      expect(find.text(_l10n.retry), findsWidgets);
      expect(find.byIcon(Icons.error_outline), findsWidgets);
    });

    testWidgets('shows empty state when no actions', (tester) async {
      final emptyContainer = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => <vc.Action>[]),
        ],
      );
      addTearDown(emptyContainer.dispose);

      await tester.pumpApp(
        const FeedScreen(),
        container: emptyContainer,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
      await tester.pumpAndSettle();

      expect(find.text(_l10n.feedNoNearbyActionsTitle), findsOneWidget);
      expect(find.text(_l10n.feedNoNearbyActionsSubtitle), findsOneWidget);
    });
  });

  group('FeedScreen — navigation', () {
    testWidgets('tapping action card navigates to action detail', (
      tester,
    ) async {
      String? navigatedPath;

      final router = GoRouter(
        initialLocation: '/feed',
        routes: [
          GoRoute(
            path: '/feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/action/:actionId',
            builder: (context, state) {
              navigatedPath = state.uri.toString();
              return Scaffold(
                body: Center(
                  child: Text('Detail ${state.pathParameters['actionId']}'),
                ),
              );
            },
          ),
          // Search route needed by the search icon button.
          GoRoute(
            path: '/search',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Search'))),
          ),
          // AI create action route needed by the FAB.
          GoRoute(
            path: '/action/create/ai',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('AI Create'))),
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpApp(
        const SizedBox.shrink(), // placeholder — router provides the widget
        container: container,
        router: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
      await tester.pumpAndSettle();

      // Tap the first action card (push-ups).
      final firstCard = find.text('Record 20 push-ups at a local park');
      expect(firstCard, findsOneWidget);
      await tester.tap(firstCard);
      await tester.pumpAndSettle();

      // Verify navigation to the action detail route with correct ID.
      expect(navigatedPath, equals('/action/1'));
      expect(find.text('Detail 1'), findsOneWidget);
    });

    testWidgets('tapping second action card navigates to its detail', (
      tester,
    ) async {
      String? navigatedPath;

      final router = GoRouter(
        initialLocation: '/feed',
        routes: [
          GoRoute(
            path: '/feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/action/:actionId',
            builder: (context, state) {
              navigatedPath = state.uri.toString();
              return Scaffold(
                body: Center(
                  child: Text('Detail ${state.pathParameters['actionId']}'),
                ),
              );
            },
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Search'))),
          ),
          GoRoute(
            path: '/action/create/ai',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('AI Create'))),
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpApp(
        const SizedBox.shrink(),
        container: container,
        router: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
      await tester.pumpAndSettle();

      // Tap the second action card (cleanup).
      final secondCard = find.text('Capture a 30s cleanup clip on your street');
      expect(secondCard, findsOneWidget);
      await tester.tap(secondCard);
      await tester.pumpAndSettle();

      expect(navigatedPath, equals('/action/2'));
      expect(find.text('Detail 2'), findsOneWidget);
    });

    testWidgets('tapping FAB navigates to AI create action', (tester) async {
      String? navigatedPath;

      final router = GoRouter(
        initialLocation: '/feed',
        routes: [
          GoRoute(
            path: '/feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/action/:actionId',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Detail'))),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Search'))),
          ),
          GoRoute(
            path: '/action/create/ai',
            builder: (context, state) {
              navigatedPath = state.uri.toString();
              return const Scaffold(
                body: Center(child: Text('AI Create Action')),
              );
            },
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpApp(
        const SizedBox.shrink(),
        container: container,
        router: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
      await tester.pumpAndSettle();

      // Tap the FAB.
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(navigatedPath, equals('/action/create/ai'));
      expect(find.text('AI Create Action'), findsOneWidget);
    });

    testWidgets('tapping search icon navigates to search', (tester) async {
      String? navigatedPath;

      final router = GoRouter(
        initialLocation: '/feed',
        routes: [
          GoRoute(
            path: '/feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/action/:actionId',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Detail'))),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) {
              navigatedPath = state.uri.toString();
              return const Scaffold(body: Center(child: Text('Search Screen')));
            },
          ),
          GoRoute(
            path: '/action/create/ai',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('AI Create'))),
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          feedActionsProvider.overrideWith((ref) async => _mockActions),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpApp(
        const SizedBox.shrink(),
        container: container,
        router: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(navigatedPath, equals('/search'));
      expect(find.text('Search Screen'), findsOneWidget);
    });
  });
}
