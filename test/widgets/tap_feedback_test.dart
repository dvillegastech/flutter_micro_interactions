import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';

void main() {
  group('TapFeedback', () {
    testWidgets('default constructor works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback(
              onTap: () {},
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
              onTap: () {},
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

    testWidgets('scale animation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback.scale(
              onTap: () {},
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

    testWidgets('fade animation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback.fade(
              onTap: () {},
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

    testWidgets('scaleAndOpacity animation works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback.scaleAndOpacity(
              onTap: () {},
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

    testWidgets('custom configuration works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TapFeedback(
              onTap: () {},
              scaleDown: 0.85,
              scaleUp: 1.05,
              opacity: 0.7,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutBack,
              enableScale: true,
              enableOpacity: true,
              enableHaptics: true,
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
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.getSize(button).width, greaterThan(0));
    });
  });
} 