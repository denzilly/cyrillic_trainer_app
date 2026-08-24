import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/screens/letter_practice_screen.dart';
import 'package:cyrillic_trainer_app/widgets/alphabet_grid.dart';
import 'package:cyrillic_trainer_app/widgets/streak_badge.dart';

void main() {
  group('LetterPracticeScreen', () {
    testWidgets('shows a Guide button that opens the reference sheet', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LetterPracticeScreen()));

      expect(find.text('Guide'), findsOneWidget);
      // Single Letter Practice has no categories, so no Word List button.
      expect(find.byIcon(Icons.checklist), findsNothing);

      await tester.tap(find.text('Guide'));
      await tester.pumpAndSettle();

      expect(find.text('Cyrillic Alphabet'), findsOneWidget);
      expect(find.byType(AlphabetGrid), findsOneWidget);
    });

    testWidgets('has no streak badge — single-letter mode has no streaks', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LetterPracticeScreen()));

      expect(find.byType(StreakBadge), findsNothing);
    });
  });
}
