// UuidValue construction uses experimental API.
// ignore_for_file: experimental_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_app/src/features/map/widgets/action_detail_bottom_sheet.dart';
import 'package:verily_client/verily_client.dart' as api;
import 'package:verily_test_utils/verily_test_utils.dart';

void main() {
  group('ActionDetailBottomSheet', () {
    late api.Action testAction;

    setUp(() {
      testAction = api.Action(
        title: 'Do 20 Push-ups',
        description: 'Complete 20 push-ups with proper form in a park.',
        actionType: 'one_off',
        verificationCriteria: 'Show full push-up motion',
        status: 'active',
        creatorId: api.UuidValue.fromString(
          '00000000-0000-0000-0000-000000000001',
        ),
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      );
    });

    testWidgets('renders action title', (tester) async {
      await tester.pumpApp(
        ActionDetailBottomSheet(action: testAction, onClose: () {}),
      );

      expect(find.text('Do 20 Push-ups'), findsOneWidget);
    });

    testWidgets('renders action description', (tester) async {
      await tester.pumpApp(
        ActionDetailBottomSheet(action: testAction, onClose: () {}),
      );

      expect(
        find.text('Complete 20 push-ups with proper form in a park.'),
        findsOneWidget,
      );
    });

    testWidgets('renders action type badge', (tester) async {
      await tester.pumpApp(
        ActionDetailBottomSheet(action: testAction, onClose: () {}),
      );

      expect(find.text('one_off'), findsOneWidget);
    });

    testWidgets('renders status badge', (tester) async {
      await tester.pumpApp(
        ActionDetailBottomSheet(action: testAction, onClose: () {}),
      );

      expect(find.text('active'), findsOneWidget);
    });

    testWidgets('renders View Details button', (tester) async {
      await tester.pumpApp(
        ActionDetailBottomSheet(action: testAction, onClose: () {}),
      );

      expect(find.text('View Details'), findsOneWidget);
    });

    testWidgets('renders close button', (tester) async {
      await tester.pumpApp(
        ActionDetailBottomSheet(action: testAction, onClose: () {}),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onClose when close button tapped', (tester) async {
      var closed = false;
      await tester.pumpApp(
        ActionDetailBottomSheet(
          action: testAction,
          onClose: () => closed = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(closed, isTrue);
    });
  });
}
