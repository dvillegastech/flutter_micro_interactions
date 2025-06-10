import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';

void main() {
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
      expect(find.text('Test'), findsOneWidget);

      // Loading state
      buttonStates.setLoading();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);

      // Success state
      buttonStates.setSuccess();
      await tester.pump();
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Error state
      buttonStates.setError();
      await tester.pump();
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);

      // Reset state
      buttonStates.reset();
      await tester.pump();
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('handles rapid state changes correctly', (WidgetTester tester) async {
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

      // Rapid state changes
      buttonStates.setLoading();
      buttonStates.setSuccess();
      buttonStates.setError();
      buttonStates.reset();

      await tester.pump();
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('maintains state when maintainState is true', (WidgetTester tester) async {
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

      // Change state and rebuild
      buttonStates.setLoading();
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Rebuild widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: buttonStates,
          ),
        ),
      );

      // State should be maintained
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
} 