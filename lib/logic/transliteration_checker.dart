/// Checks user-typed transliteration input against a set of accepted answers.
class TransliterationChecker {
  const TransliterationChecker._();

  /// Whether [input] matches any of the [accepted] transliterations, after
  /// normalizing for case, surrounding whitespace, and apostrophe style
  /// (straight `'` vs curly `'`).
  static bool isCorrect(String input, List<String> accepted) {
    final normalizedInput = _normalize(input);
    return accepted.any((a) => _normalize(a) == normalizedInput);
  }

  static String _normalize(String s) {
    return s.trim().toLowerCase().replaceAll('’', "'");
  }
}
