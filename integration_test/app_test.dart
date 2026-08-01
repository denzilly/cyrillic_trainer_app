import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cyrillic_trainer_app/data/cyrillic_alphabet.dart';
import 'package:cyrillic_trainer_app/data/vocabulary.dart';
import 'package:cyrillic_trainer_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('golden path: landing -> letter practice -> word practice -> category filter',
      (tester) async {
    await tester.pumpWidget(const CyrillicTrainerApp());
    await tester.pumpAndSettle();

    expect(find.text('Cyrillic Trainer'), findsOneWidget);

    // --- Single Letter Practice: wrong answer, then correct ---
    await tester.tap(find.text('Single Letter Practice'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'zzz-not-a-real-answer');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Incorrect'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    final shownLetter = tester.widget<Text>(find.byKey(const Key('practicePromptText'))).data!;
    final letter = cyrillicAlphabet.firstWhere((l) => l.lower == shownLetter);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), letter.accepted.first);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('1'), findsOneWidget); // streak badge

    // Back to landing.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Cyrillic Trainer'), findsOneWidget);

    // --- Word Practice: correct answer shows the English meaning ---
    await tester.tap(find.text('Word Practice'));
    await tester.pumpAndSettle();

    final shownWord = tester.widget<Text>(find.byKey(const Key('practicePromptText'))).data!;
    final word = vocabulary.firstWhere((w) => w.cyrillic == shownWord);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), word.accepted.first);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Correct!'), findsOneWidget);
    expect(find.text('Meaning: ${word.english}'), findsOneWidget);

    // --- Category filtering: restrict to Numbers, confirm it's respected ---
    await tester.tap(find.byIcon(Icons.checklist));
    await tester.pumpAndSettle();
    await tester.tap(find.text('None'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Numbers'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    final numberWords = wordsInCategories(['Numbers']).map((w) => w.cyrillic).toSet();
    final filteredWord = tester.widget<Text>(find.byKey(const Key('practicePromptText'))).data!;
    expect(numberWords, contains(filteredWord));
  });
}
