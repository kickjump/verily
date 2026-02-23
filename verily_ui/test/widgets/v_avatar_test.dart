import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('VAvatar', () {
    testWidgets('renders initials when no image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VAvatar(initials: 'JD')),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('renders "?" when no initials or image', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VAvatar())),
      );

      expect(find.text('?'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('applies custom radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VAvatar(initials: 'AB', radius: 40)),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(avatar.radius, equals(40));
    });

    testWidgets('uses default radius of 24', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VAvatar(initials: 'XY')),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(avatar.radius, equals(24));
    });
  });
}
