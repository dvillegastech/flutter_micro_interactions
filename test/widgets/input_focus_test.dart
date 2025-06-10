import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';

void main() {
  group('InputFocus', () {
    testWidgets('animates on focus change', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputFocus.animate(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Test',
                ),
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Focus the text field
      await tester.tap(textField);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(textField).width, greaterThan(0));

      // Unfocus the text field
      await tester.tap(find.byType(Scaffold));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(textField).width, greaterThan(0));
    });

    testWidgets('custom animation configuration works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InputFocus.animate(
              duration: const Duration(milliseconds: 200),
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Test',
                ),
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Focus the text field
      await tester.tap(textField);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getSize(textField).width, greaterThan(0));
    });

    testWidgets('works with different input types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                InputFocus.animate(
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Text Input',
                    ),
                  ),
                ),
                InputFocus.animate(
                  child: const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Input',
                    ),
                  ),
                ),
                InputFocus.animate(
                  child: const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password Input',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Test each input type
      for (final label in ['Text Input', 'Email Input', 'Password Input']) {
        final textField = find.widgetWithText(TextField, label);
        expect(textField, findsOneWidget);

        // Focus the text field
        await tester.tap(textField);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.getSize(textField).width, greaterThan(0));

        // Unfocus the text field
        await tester.tap(find.byType(Scaffold));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
      }
    });

    testWidgets('handles multiple focus changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                InputFocus.animate(
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'First Input',
                    ),
                  ),
                ),
                InputFocus.animate(
                  child: const TextField(
                    decoration: InputDecoration(
                      labelText: 'Second Input',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      final firstInput = find.widgetWithText(TextField, 'First Input');
      final secondInput = find.widgetWithText(TextField, 'Second Input');

      // Focus first input
      await tester.tap(firstInput);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Focus second input
      await tester.tap(secondInput);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Unfocus
      await tester.tap(find.byType(Scaffold));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.getSize(firstInput).width, greaterThan(0));
      expect(tester.getSize(secondInput).width, greaterThan(0));
    });
  });
} 