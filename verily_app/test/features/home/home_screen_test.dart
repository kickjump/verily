// Test overrides don't need scoped provider dependencies.
// ignore_for_file: scoped_providers_should_specify_dependencies
// UuidValue is required by Serverpod's generated Action model.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/src/features/feed/feed_provider.dart';
import 'package:verily_app/src/features/home/home_screen.dart';
import 'package:verily_client/verily_client.dart' as vc;
import 'package:verily_test_utils/verily_test_utils.dart';

final _mockActions = <vc.Action>[
  vc.Action(
    id: 1,
    title: 'Record 20 push-ups at a local park',
    description: 'Head to any local park and do push-ups.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Show your full body in frame while doing all reps\n'
        'Capture ambient park audio from start to finish\n'
        'Pan camera to a park sign before ending recording',
    tags: 'fitness,outdoor,exercise',
    createdAt: DateTime.utc(2025),
    updatedAt: DateTime.utc(2025),
  ),
  vc.Action(
    id: 2,
    title: 'Capture a 30s cleanup clip on your street',
    description: 'Record yourself picking up litter.',
    creatorId: vc.UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
    actionType: 'one_off',
    status: 'active',
    verificationCriteria:
        'Record litter before and after cleanup\n'
        'Keep gloves and collection bag visible in video\n'
        'Show street name sign in the first 10 seconds',
    tags: 'environment,community,cleanup',
    createdAt: DateTime.utc(2025),
    updatedAt: DateTime.utc(2025),
  ),
];

void main() {
  group('HomeScreen', () {
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

    Future<void> pumpHomeScreen(WidgetTester tester) async {
      await tester.pumpApp(const HomeScreen(), container: container);
      // Allow the async providers to settle.
      await tester.pumpAndSettle();
    }

    testWidgets('renders hero heading and summary', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.text('Ready to verify in the real world?'), findsOneWidget);
      expect(find.textContaining('Complete actions nearby'), findsOneWidget);
    });

    testWidgets('renders filter chips', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.byType(ChoiceChip), findsNWidgets(3));
      expect(find.text('Quick'), findsOneWidget);
      expect(find.text('High Reward'), findsOneWidget);
    });

    testWidgets('renders all actions section and browse button', (
      tester,
    ) async {
      await pumpHomeScreen(tester);

      await tester.scrollUntilVisible(
        find.text('All actions'),
        220,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('All actions'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Browse more actions'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Browse more actions'), findsOneWidget);
    });

    testWidgets('has scrollable content', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.byType(CustomScrollView), findsOneWidget);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pump();
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('marks an action as active and shows guidance', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.text('Active Action'), findsNothing);

      // The featured card "Set" button is near the bottom of the card which
      // extends beyond the default 600px test viewport. Scroll down to make
      // it visible and tappable.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -250));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_featured_setActive_1')));
      await tester.pumpAndSettle();

      // The active action guidance card appears at the top of the scroll view.
      // Scroll back up to see it.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, 400));
      await tester.pumpAndSettle();

      expect(find.text('Active Action'), findsOneWidget);
      expect(find.text('Verify at location'), findsOneWidget);
      expect(
        find.textContaining('Show your full body in frame'),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders featured action activation controls with stable keys',
      (tester) async {
        await pumpHomeScreen(tester);

        expect(
          find.byKey(const Key('home_featured_setActive_1')),
          findsOneWidget,
        );
        await tester.scrollUntilVisible(
          find.byKey(const Key('home_list_setActive_1')),
          220,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.byKey(const Key('home_list_setActive_1')), findsOneWidget);
        expect(
          find.byKey(const Key('home_openVerificationButton')),
          findsNothing,
        );

        // Scroll back up to find the featured card button
        await tester.scrollUntilVisible(
          find.byKey(const Key('home_featured_setActive_1')),
          -220,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.byKey(const Key('home_featured_setActive_1')));
        await tester.pump();

        expect(
          find.byKey(const Key('home_openVerificationButton')),
          findsOneWidget,
        );
      },
    );
  });
}
