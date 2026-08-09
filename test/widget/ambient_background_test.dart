import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/widgets/ambient_background.dart';

void main() {
  group('AmbientBackground', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AmbientBackground(child: const Text('Screen content')),
        ),
      );

      expect(find.text('Screen content'), findsOneWidget);
    });

    testWidgets('does not intercept taps meant for its child', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: AmbientBackground(
            child: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => tapped = true,
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Go'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('keeps animating across several frames without throwing', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AmbientBackground(child: const Text('Screen content')),
        ),
      );

      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 10));

      expect(find.text('Screen content'), findsOneWidget);
    });
  });
}
