import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/data/cyrillic_alphabet.dart';
import 'package:cyrillic_trainer_app/widgets/alphabet_grid.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));

void main() {
  group('AlphabetGrid', () {
    testWidgets('shows every letter with its upper+lower case', (tester) async {
      await tester.pumpWidget(wrap(const AlphabetGrid()));

      for (final letter in cyrillicAlphabet) {
        expect(find.text('${letter.upper}${letter.lower}'), findsOneWidget);
      }
    });

    testWidgets('shows the Latin transliteration for a normal letter', (tester) async {
      await tester.pumpWidget(wrap(const AlphabetGrid()));

      expect(find.text('a'), findsOneWidget); // а
      expect(find.text('sh'), findsOneWidget); // ш
    });

    testWidgets('shows "(silent)" for letters with no transliteration', (tester) async {
      await tester.pumpWidget(wrap(const AlphabetGrid()));

      final silentLetters = cyrillicAlphabet.where((l) => l.primary.isEmpty);
      expect(silentLetters.length, 2); // ъ and ь
      expect(find.text('(silent)'), findsNWidgets(2));
    });
  });
}
