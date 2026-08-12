import 'package:shared_preferences/shared_preferences.dart';

/// Tracks one-off "first time" hints so each is shown only once ever,
/// persisted across app restarts.
class HintService {
  HintService._();
  static final HintService instance = HintService._();

  static const _alphabetGridHintKey = 'seen_alphabet_grid_hint';

  /// Returns true the first time this is called (and immediately marks the
  /// hint as seen so it never returns true again); false on every call
  /// after. Fails safe to "already seen" if the preference store can't be
  /// read/written, rather than risk showing the hint on every visit.
  Future<bool> consumeAlphabetGridHint() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool(_alphabetGridHintKey) ?? false;
      if (seen) return false;
      await prefs.setBool(_alphabetGridHintKey, true);
      return true;
    } catch (_) {
      return false;
    }
  }
}
