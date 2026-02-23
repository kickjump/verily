import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('VBadgeChip', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VBadgeChip(label: 'Verified')),
        ),
      );

      expect(find.text('Verified'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VBadgeChip(label: 'Badge', icon: Icons.star),
          ),
        ),
      );

      expect(find.text('Badge'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('does not render icon when not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VBadgeChip(label: 'No Icon')),
        ),
      );

      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('uses custom colors', (tester) async {
      const customBg = Colors.red;
      const customFg = Colors.white;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VBadgeChip(
              label: 'Custom',
              icon: Icons.check,
              backgroundColor: customBg,
              foregroundColor: customFg,
            ),
          ),
        ),
      );

      // Verify the container decoration uses the custom background color
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, equals(customBg));

      // Verify the icon uses the custom foreground color
      final icon = tester.widget<Icon>(find.byIcon(Icons.check));
      expect(icon.color, equals(customFg));
    });

    testWidgets('applies correct spacing and radius tokens', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VBadgeChip(label: 'Tokens')),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;

      // RadiusTokens.xl = 24
      expect(
        decoration.borderRadius,
        equals(BorderRadius.circular(RadiusTokens.xl)),
      );

      // SpacingTokens.sm horizontal, SpacingTokens.xs vertical
      expect(
        container.padding,
        equals(
          const EdgeInsets.symmetric(
            horizontal: SpacingTokens.sm,
            vertical: SpacingTokens.xs,
          ),
        ),
      );
    });
  });
}
