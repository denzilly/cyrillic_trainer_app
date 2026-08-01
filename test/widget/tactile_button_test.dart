import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/widgets/tactile_button.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('TactileButton', () {
    testWidgets('invokes onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrap(TactileButton(
        onPressed: () => tapped = true,
        child: const Text('Go'),
      )));

      await tester.tap(find.text('Go'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('does not invoke onPressed when disabled', (tester) async {
      await tester.pumpWidget(wrap(const TactileButton(
        onPressed: null,
        child: Text('Go'),
      )));

      await tester.tap(find.text('Go'));
      await tester.pump();

      // No callback provided, so nothing to assert beyond "it didn't throw".
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(wrap(TactileButton(
        onPressed: () {},
        child: const Text('Single Letter Practice'),
      )));

      expect(find.text('Single Letter Practice'), findsOneWidget);
    });
  });
}
