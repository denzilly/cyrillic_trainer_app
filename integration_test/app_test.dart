import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cyrillic_trainer_app/data/cyrillic_alphabet.dart';
import 'package:cyrillic_trainer_app/data/vocabulary.dart';
import 'package:cyrillic_trainer_app/main.dart';

/// Not pumpAndSettle: CyrillicTrainerApp wraps every screen in
/// AmbientBackground, whose drift animation repeats forever, so
/// pumpAndSettle would never see zero scheduled frames and time out. Pump a
/// fixed, generous duration instead — long enough to cover a
/// MaterialPageRoute transition or a bottom sheet open/close.
Future<void> settle(
  WidgetTester tester, [
  Duration duration = const Duration(milliseconds: 400),
]) async {
  await tester.pump();
  await tester.pump(duration);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'golden path: landing -> letter practice -> word practice -> category filter',
    (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());
      await settle(
        tester,
        const Duration(milliseconds: 2600),
      ); // boot + landing intro

      expect(find.text('CYRILLIC TRAINER'), findsOneWidget);

      // --- Single Letter Practice: wrong answer, then correct ---
      await tester.tap(find.text('Single Letter Practice'));
      await settle(tester);

      await tester.tap(find.byType(TextField));
      await settle(tester);
      await tester.enterText(find.byType(TextField), 'zzz-not-a-real-answer');
      await tester.tap(find.text('Submit'));
      await settle(tester);
      expect(find.text('Incorrect'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await settle(tester);

      final shownLetter = tester
          .widget<Text>(find.byKey(const Key('practicePromptText')))
          .data!;
      final letter = cyrillicAlphabet.firstWhere((l) => l.lower == shownLetter);
      await tester.tap(find.byType(TextField));
      await settle(tester);
      await tester.enterText(find.byType(TextField), letter.accepted.first);
      await tester.tap(find.text('Submit'));
      await settle(tester);
      expect(find.text('Correct!'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // streak badge

      // Back to landing.
      await tester.tap(find.byIcon(Icons.arrow_back));
      await settle(tester);
      expect(find.text('CYRILLIC TRAINER'), findsOneWidget);

      // --- Word Practice: correct answer shows the English meaning ---
      await tester.tap(find.text('Word Practice'));
      await settle(tester);

      final shownWord = tester
          .widget<Text>(find.byKey(const Key('practicePromptText')))
          .data!;
      final word = vocabulary.firstWhere((w) => w.cyrillic == shownWord);
      await tester.tap(find.byType(TextField));
      await settle(tester);
      await tester.enterText(find.byType(TextField), word.accepted.first);
      await tester.tap(find.text('Submit'));
      await settle(tester);
      expect(find.text('Correct!'), findsOneWidget);
      expect(find.text('Meaning: ${word.english}'), findsOneWidget);

      // --- Category filtering: restrict to Numbers, confirm it's respected ---
      await tester.tap(find.byIcon(Icons.checklist));
      await settle(tester);
      await tester.tap(find.text('None'));
      await settle(tester);
      await tester.tap(find.text('Numbers'));
      await settle(tester);
      await tester.tap(find.text('Apply'));
      await settle(tester);

      final numberWords = wordsInCategories([
        'Numbers',
      ]).map((w) => w.cyrillic).toSet();
      final filteredWord = tester
          .widget<Text>(find.byKey(const Key('practicePromptText')))
          .data!;
      expect(numberWords, contains(filteredWord));
    },
  );
}
