import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/data/vocabulary.dart';
import 'package:cyrillic_trainer_app/screens/word_practice_screen.dart';

void main() {
  // Derived from the data, not hardcoded: the Numbers category's word count
  // (and every other category's) is expected to keep growing over time.
  final numberWords = wordsInCategories(['Numbers']).map((w) => w.cyrillic).toList();

  group('WordPracticeScreen', () {
    testWidgets('shows a Word List button that opens the category picker', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: WordPracticeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.checklist));
      await tester.pumpAndSettle();

      for (final category in vocabCategories) {
        expect(find.text(category), findsOneWidget);
      }
    });

    testWidgets('restricting to one category only ever prompts words from it', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: WordPracticeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.checklist));
      await tester.pumpAndSettle();
      await tester.tap(find.text('None'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Numbers'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      // Cycle through every prompt in the Numbers pool and check each one
      // is actually a number word.
      for (var i = 0; i < numberWords.length; i++) {
        final shown = numberWords.where((w) => find.text(w).evaluate().isNotEmpty);
        expect(shown, isNotEmpty, reason: 'displayed word should be one of the Numbers words');

        await tester.enterText(find.byType(TextField), 'skip');
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }
    });
  });
}
