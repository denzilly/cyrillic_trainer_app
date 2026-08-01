/// A Russian vocabulary word used in Word Practice mode.
///
/// [accepted] is ordered; the first entry is the canonical transliteration
/// shown to the user as the "correct answer", while the rest are alternate
/// spellings that should also be marked correct.
class VocabWord {
  final String cyrillic;
  final List<String> accepted;
  final String english;
  final String category;

  const VocabWord({
    required this.cyrillic,
    required this.accepted,
    required this.english,
    required this.category,
  });

  String get primary => accepted.first;
}
