import 'package:shared_preferences/shared_preferences.dart';

/// Persists a practice mode's current answer streak, so it survives leaving
/// the screen, switching to another app, or the OS killing the process
/// outright while the app is backgrounded.
///
/// Written after every answer rather than on an app-lifecycle callback:
/// Android can kill a backgrounded app without ever delivering one, so the
/// only reliably-saved streak is the one already on disk.
class StreakStore {
  StreakStore._();
  static final StreakStore instance = StreakStore._();

  /// Storage key for the Word Practice streak. Single Letter Practice has
  /// no streak of its own, so it has no key here.
  static const wordPracticeKey = 'word_practice_streak';

  /// The saved streak for [key], or 0 if there is none — or if the
  /// preference store can't be read, since starting over is better than
  /// failing to open a practice screen.
  Future<int> load(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Best effort: a streak that fails to persist shouldn't interrupt
  /// practice, so write errors are swallowed.
  Future<void> save(String key, int streak) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, streak);
    } catch (_) {
      // Ignored deliberately; see above.
    }
  }
}
