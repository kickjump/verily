// Smoke test for the Verily app root widget.

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_app/main.dart';

void main() {
  testWidgets('VerilyApp renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: VerilyApp()));

    // Just verify the widget tree built without throwing.
    expect(find.byType(VerilyApp), findsOneWidget);
  });
}
