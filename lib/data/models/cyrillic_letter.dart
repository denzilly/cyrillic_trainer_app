/// A single Cyrillic letter and the Latin transliterations accepted for it.
///
/// [accepted] is ordered; the first entry is the canonical transliteration
/// shown to the user as the "correct answer" (e.g. in feedback), while the
/// rest are alternate spellings that should also be marked correct.
class CyrillicLetter {
  final String lower;
  final String upper;
  final List<String> accepted;

  const CyrillicLetter(this.lower, this.upper, this.accepted);

  String get primary => accepted.first;
}
