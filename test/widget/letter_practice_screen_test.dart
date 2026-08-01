import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/screens/letter_practice_screen.dart';
import 'package:cyrillic_trainer_app/widgets/alphabet_grid.dart';

void main() {
  group('LetterPracticeScreen', () {
    testWidgets('shows an alphabet grid button that opens the reference sheet', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LetterPracticeScreen()));

      expect(find.byIcon(Icons.grid_view), findsOneWidget);
      // Single Letter Practice has no categories, so no Word List button.
      expect(find.byIcon(Icons.checklist), findsNothing);

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pumpAndSettle();

      expect(find.text('Cyrillic Alphabet'), findsOneWidget);
      expect(find.byType(AlphabetGrid), findsOneWidget);
    });
  });
}
