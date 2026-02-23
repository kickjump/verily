import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('VFilledButton', () {
    testWidgets('renders child text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VFilledButton(onPressed: null, child: Text('Submit')),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('onPressed callback fires', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VFilledButton(
              onPressed: () => pressed = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('shows loading indicator when isLoading=true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VFilledButton(
              onPressed: () {},
              isLoading: true,
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('is disabled when isLoading=true', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VFilledButton(
              onPressed: () => pressed = true,
              isLoading: true,
              child: const Text('Submit'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(pressed, isFalse);

      // Verify the underlying FilledButton has null onPressed
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
  });

  group('VOutlinedButton', () {
    testWidgets('renders and handles tap', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VOutlinedButton(
              onPressed: () => pressed = true,
              child: const Text('Outlined'),
            ),
          ),
        ),
      );

      expect(find.text('Outlined'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });

  group('VTextButton', () {
    testWidgets('renders and handles tap', (tester) async {
      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VTextButton(
              onPressed: () => pressed = true,
              child: const Text('Text Btn'),
            ),
          ),
        ),
      );

      expect(find.text('Text Btn'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(pressed, isTrue);
    });
  });
}
