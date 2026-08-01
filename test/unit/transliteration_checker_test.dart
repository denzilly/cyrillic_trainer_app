import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/logic/transliteration_checker.dart';

void main() {
  group('TransliterationChecker.isCorrect', () {
    test('matches the primary accepted answer exactly', () {
      expect(TransliterationChecker.isCorrect('privet', ['privet']), isTrue);
    });

    test('is case-insensitive', () {
      expect(TransliterationChecker.isCorrect('PriVet', ['privet']), isTrue);
    });

    test('ignores surrounding whitespace', () {
      expect(TransliterationChecker.isCorrect('  privet  ', ['privet']), isTrue);
    });

    test('accepts any listed alternate spelling', () {
      expect(TransliterationChecker.isCorrect('ja', ['ya', 'ja', 'ia']), isTrue);
    });

    test('rejects input not in the accepted list', () {
      expect(TransliterationChecker.isCorrect('nyet', ['net']), isFalse);
    });

    test('treats curly and straight apostrophes as equivalent', () {
      expect(TransliterationChecker.isCorrect('pyat’', ["pyat'"]), isTrue);
    });

    test('matches multi-word phrases including internal spaces', () {
      expect(TransliterationChecker.isCorrect('dobroe utro', ['dobroe utro']), isTrue);
    });

    test('does not match if internal spacing differs', () {
      expect(TransliterationChecker.isCorrect('dobroeutro', ['dobroe utro']), isFalse);
    });

    test('accepts empty input when empty string is an accepted answer', () {
      expect(TransliterationChecker.isCorrect('', ['', "'"]), isTrue);
    });
  });
}
