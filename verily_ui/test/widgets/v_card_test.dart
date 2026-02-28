import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('VCard', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VCard(child: Text('Card Content'))),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      // VCard uses Material widget internally
      expect(find.byType(Material), findsWidgets);
    });

    testWidgets('applies padding when provided', (tester) async {
      const testPadding = EdgeInsets.all(20);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VCard(padding: testPadding, child: Text('Padded')),
          ),
        ),
      );

      final paddingWidget = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Padded'), matching: find.byType(Padding))
            .first,
      );
      expect(paddingWidget.padding, equals(testPadding));
    });

    testWidgets('onTap callback fires', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VCard(onTap: () => tapped = true, child: const Text('Tap')),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('without onTap does not have InkWell', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VCard(child: Text('No Tap'))),
        ),
      );

      // VCard should not wrap in InkWell when onTap is null.
      final vCardElement = find.byType(VCard).evaluate().first;
      var foundInkWellWrapper = false;
      vCardElement.visitChildElements((child) {
        if (child.widget is InkWell) {
          foundInkWellWrapper = true;
        }
      });
      expect(foundInkWellWrapper, isFalse);
    });
  });
}
