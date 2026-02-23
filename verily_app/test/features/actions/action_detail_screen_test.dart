import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/actions/action_detail_screen.dart';
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('ActionDetailScreen', () {
    Future<void> pumpActionDetailScreen(WidgetTester tester) async {
      await tester.pumpApp(
        const ActionDetailScreen(actionId: 'test_action_1'),
      );
    }

    testWidgets('renders action title placeholder', (tester) async {
      await pumpActionDetailScreen(tester);

      // The screen uses hardcoded placeholder title.
      expect(find.text('Do 20 push-ups in the park'), findsOneWidget);
    });

    testWidgets('renders Action Details app bar title', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Action Details'), findsOneWidget);
    });

    testWidgets('renders Submit Video button', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Submit Video'), findsOneWidget);
      expect(find.byIcon(Icons.videocam_outlined), findsOneWidget);
    });

    testWidgets('renders Verification Criteria section header', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Verification Criteria'), findsOneWidget);
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

      expect(find.text('Location'), findsOneWidget);
      expect(find.text('Central Park'), findsOneWidget);
      expect(find.text('Within 500m radius'), findsOneWidget);
    });

    testWidgets('renders Rewards section', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Rewards'), findsOneWidget);
      expect(find.text('100 Points'), findsOneWidget);
      expect(find.text('Push-Up Champion'), findsOneWidget);
    });

    testWidgets('renders Created By section', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Created By'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('@johndoe'), findsOneWidget);
    });

    testWidgets('renders category and type badges', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Fitness'), findsOneWidget);
      expect(find.text('One-Off'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('renders share and more actions in app bar', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.byIcon(Icons.share_outlined), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders metadata rows', (tester) async {
      await pumpActionDetailScreen(tester);

      expect(find.text('Max Performers'), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('12 / 50'), findsOneWidget);
    });
  });
}
