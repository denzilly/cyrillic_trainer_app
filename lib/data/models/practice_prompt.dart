import 'cyrillic_letter.dart';
import 'vocab_word.dart';

/// A single prompt shown in a practice session, unifying letters and words
/// behind one shape so [PracticeScreen] doesn't need to know which it is.
class PracticePrompt {
  final String displayText;
  final List<String> accepted;

  /// English meaning, shown alongside the answer. Null for single letters,
  /// which have no meaning of their own.
  final String? meaning;

  const PracticePrompt({
    required this.displayText,
    required this.accepted,
    this.meaning,
  });

  String get primary => accepted.first;

  factory PracticePrompt.fromLetter(CyrillicLetter letter) {
    return PracticePrompt(displayText: letter.lower, accepted: letter.accepted);
  }

  factory PracticePrompt.fromWord(VocabWord word) {
    return PracticePrompt(
      displayText: word.cyrillic,
      accepted: word.accepted,
      meaning: word.english,
    );
  }
}

List<PracticePrompt> promptsFromLetters(List<CyrillicLetter> letters) =>
    letters.map(PracticePrompt.fromLetter).toList();

List<PracticePrompt> promptsFromWords(List<VocabWord> words) =>
    words.map(PracticePrompt.fromWord).toList();
