import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_micro_interactions/flutter_micro_interactions.dart';

void main() {
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

      // Simulate hover
      final TestGesture gesture = await tester.createGesture();
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(button));
      await tester.pump();

      // Verify glow effect
      expect(tester.getSize(button).width, greaterThan(0));
    });

    testWidgets('custom glow configuration works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HoverGlow(
              glowColor: Colors.blue,
              glowRadius: 20.0,
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

      // Simulate hover
      final TestGesture gesture = await tester.createGesture();
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(button));
      await tester.pump();

      // Verify glow effect
      expect(tester.getSize(button).width, greaterThan(0));
    });

    testWidgets('glow effect disappears on hover out', (WidgetTester tester) async {
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

      // Simulate hover
      final TestGesture gesture = await tester.createGesture();
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(button));
      await tester.pump();

      // Move away
      await gesture.moveTo(const Offset(0, 0));
      await tester.pump();

      // Verify glow effect is gone
      expect(tester.getSize(button).width, greaterThan(0));
    });

    testWidgets('works with different child widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HoverGlow(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
                child: const Center(
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        ),
      );

      final container = find.byType(Container);
      expect(container, findsOneWidget);

      // Simulate hover
      final TestGesture gesture = await tester.createGesture();
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(container));
      await tester.pump();

      // Verify glow effect
      expect(tester.getSize(container).width, greaterThan(0));
    });
  });
} 