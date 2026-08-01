import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/screens/help_screen.dart';
import 'package:cyrillic_trainer_app/widgets/alphabet_grid.dart';

void main() {
  group('HelpScreen', () {
    testWidgets('shows instructions and the alphabet grid', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HelpScreen()));

      expect(find.text('How to play'), findsOneWidget);
      expect(find.text('Cyrillic Alphabet'), findsOneWidget);
      expect(find.byType(AlphabetGrid), findsOneWidget);
    });
  });
}
