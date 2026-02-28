import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/home/home_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('HomeScreen', () {
    Future<void> pumpHomeScreen(WidgetTester tester) async {
      await tester.pumpApp(const HomeScreen());
    }

    testWidgets('renders hero heading and summary', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.text('Ready to verify in the real world?'), findsOneWidget);
      expect(find.textContaining('Complete actions nearby'), findsOneWidget);
    });

    testWidgets('renders filter chips', (tester) async {
      await pumpHomeScreen(tester);

      expect(find.byType(ChoiceChip), findsNWidgets(3));
      expect(find.text('Nearby'), findsOneWidget);
      expect(find.text('Quick'), findsOneWidget);
      expect(find.text('High Reward'), findsOneWidget);
    });

    testWidgets('renders nearby section and browse button', (tester) async {
      await pumpHomeScreen(tester);

      await tester.scrollUntilVisible(
        find.text('Nearby right now'),
        220,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Nearby right now'), findsOneWidget);
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
      final setActiveButton = tester.widget<TextButton>(
        find.byKey(const Key('home_featured_setActive_101')),
      );
      setActiveButton.onPressed?.call();
      await tester.pump();

      expect(find.text('Active Action'), findsOneWidget);
      expect(find.textContaining('to Memorial Park Track'), findsOneWidget);
      expect(find.text('Verify at location'), findsOneWidget);
      expect(find.textContaining('Show your full body'), findsOneWidget);
    });

    testWidgets(
      'renders featured action activation controls with stable keys',
      (tester) async {
        await pumpHomeScreen(tester);

        expect(
          find.byKey(const Key('home_featured_setActive_101')),
          findsOneWidget,
        );
        await tester.scrollUntilVisible(
          find.byKey(const Key('home_list_setActive_101')),
          220,
          scrollable: find.byType(Scrollable).first,
        );
        expect(
          find.byKey(const Key('home_list_setActive_101')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('home_openVerificationButton')),
          findsNothing,
        );

        await tester.tap(find.byKey(const Key('home_featured_setActive_101')));
        await tester.pump();

        expect(
          find.byKey(const Key('home_openVerificationButton')),
          findsOneWidget,
        );
      },
    );
  });
}
