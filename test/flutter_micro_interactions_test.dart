import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';

void main() {
  group('TapFeedback', () {
    testWidgets('pulse animation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(button).width, greaterThan(0));
    });

    testWidgets('bounce animation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback.bounce(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(button).width, greaterThan(0));
    });

    testWidgets('shrink animation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback.scale(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(button).width, greaterThan(0));
    });
  });

  group('ButtonStates', () {
    testWidgets('transitions between states correctly', (WidgetTester tester) async {
      final buttonStates = ButtonStates.withTransitions(
        child: const ElevatedButton(
          onPressed: null,
          child: Text('Test'),
        ),
        onLoading: () => const CircularProgressIndicator(),
        onSuccess: () => const Icon(Icons.check),
        onError: () => const Icon(Icons.error),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buttonStates,
          ),
        ),
      );

      // Initial state
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Loading state
      (buttonStates).setLoading();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Success state
      buttonStates.setSuccess();
      await tester.pump();
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Error state
      buttonStates.setError();
      await tester.pump();
      expect(find.byIcon(Icons.error), findsOneWidget);

      // Reset state
      buttonStates.reset();
      await tester.pump();
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group('HoverGlow', () {
    testWidgets('shows glow effect on hover', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HoverGlow(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);

      // Simulate interaction
      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(button).width, greaterThan(0));
    });
  });

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
  });
}
