import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily_ui/verily_ui.dart';

void main() {
  group('VTextField', () {
    testWidgets('renders with hint text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VTextField(hintText: 'Enter email')),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter email'), findsOneWidget);
    });

    testWidgets('renders with label text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VTextField(labelText: 'Email')),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('accepts input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VTextField())),
      );

      await tester.enterText(find.byType(TextField), 'hello@test.com');
      await tester.pump();

      expect(find.text('hello@test.com'), findsOneWidget);
    });

    testWidgets('onChanged callback fires', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VTextField(onChanged: (value) => changedValue = value),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'new text');
      await tester.pump();

      expect(changedValue, equals('new text'));
    });

    testWidgets('obscureText hides text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: VTextField(obscureText: true)),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('with validator renders TextFormField', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VTextField(
              hintText: 'Validated',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      // TextField should not be found as a direct VTextField output;
      // TextFormField contains a TextField internally, but the widget type
      // pumped by VTextField is TextFormField.
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}
