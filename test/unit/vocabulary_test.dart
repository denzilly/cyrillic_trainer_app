import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/data/vocabulary.dart';
import 'package:cyrillic_trainer_app/data/cyrillic_alphabet.dart';

void main() {
  group('vocabulary data', () {
    test('every word belongs to a known category', () {
      for (final word in vocabulary) {
        expect(vocabCategories, contains(word.category));
      }
    });

    test('every word has at least one accepted transliteration', () {
      for (final word in vocabulary) {
        expect(word.accepted, isNotEmpty);
        expect(word.primary, word.accepted.first);
      }
    });

    test('wordsInCategories filters to only the requested categories', () {
      final result = wordsInCategories(['Numbers']);
      expect(result, isNotEmpty);
      expect(result.every((w) => w.category == 'Numbers'), isTrue);
    });

    test('wordsInCategories with multiple categories unions the results', () {
      final result = wordsInCategories(['Numbers', 'Colors']);
      expect(result.any((w) => w.category == 'Numbers'), isTrue);
      expect(result.any((w) => w.category == 'Colors'), isTrue);
      expect(result.every((w) => w.category == 'Numbers' || w.category == 'Colors'), isTrue);
    });

    test('wordsInCategories with no categories returns nothing', () {
      expect(wordsInCategories([]), isEmpty);
    });
  });

  group('cyrillic alphabet data', () {
    test('has all 33 letters of the Russian alphabet', () {
      expect(cyrillicAlphabet.length, 33);
    });

    test('every letter has at least one accepted transliteration', () {
      for (final letter in cyrillicAlphabet) {
        expect(letter.accepted, isNotEmpty);
      }
    });

    test('lower-case letters are all unique', () {
      final letters = cyrillicAlphabet.map((l) => l.lower).toSet();
      expect(letters.length, cyrillicAlphabet.length);
    });
  });
}
