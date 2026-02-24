import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/actions/create_action_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('CreateActionScreen', () {
    Future<void> pumpCreateActionScreen(WidgetTester tester) async {
      await tester.pumpApp(const CreateActionScreen());
    }

    testWidgets('renders step 1 title field', (tester) async {
      await pumpCreateActionScreen(tester);

      // Step 1 (Basic Information) should be visible by default.
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('e.g., Do 20 push-ups in the park'), findsOneWidget);
    });

    testWidgets('renders step 1 description field', (tester) async {
      await pumpCreateActionScreen(tester);

      expect(find.text('Description'), findsOneWidget);
      expect(
        find.text('Describe what the performer needs to do...'),
        findsOneWidget,
      );
    });

    testWidgets('renders step 1 Basic Information header', (tester) async {
      await pumpCreateActionScreen(tester);

      expect(find.text('Basic Information'), findsOneWidget);
      expect(
        find.text('Describe the action you want people to perform.'),
        findsOneWidget,
      );
    });

    testWidgets('renders progress indicator', (tester) async {
      await pumpCreateActionScreen(tester);

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders Continue button on step 1', (tester) async {
      await pumpCreateActionScreen(tester);

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('renders app bar with step counter', (tester) async {
      await pumpCreateActionScreen(tester);

      // AppBar title is 'Create Action (1/4)' on step 1.
      expect(find.text('Create Action (1/4)'), findsOneWidget);
    });

    testWidgets('renders Action Type selection section', (tester) async {
      await pumpCreateActionScreen(tester);

      expect(find.text('Action Type'), findsOneWidget);
      expect(find.text('One-Off'), findsOneWidget);
      expect(find.text('Sequential'), findsOneWidget);
    });

    testWidgets('renders action type descriptions', (tester) async {
      await pumpCreateActionScreen(tester);

      expect(
        find.text('A single action completed in one video'),
        findsOneWidget,
      );
      expect(
        find.text('Multi-step action completed over time'),
        findsOneWidget,
      );
    });

    testWidgets('renders back arrow button', (tester) async {
      await pumpCreateActionScreen(tester);

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
