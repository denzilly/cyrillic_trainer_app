/// Tracks the current answer streak within a practice session, plus the
/// best streak reached this session (the value submitted to the leaderboard).
class StreakController {
  int _current = 0;
  int _sessionBest = 0;

  int get current => _current;
  int get sessionBest => _sessionBest;

  /// Call when the user answers correctly: extends the streak and updates
  /// the session best if this is a new high.
  void recordCorrect() {
    _current += 1;
    if (_current > _sessionBest) {
      _sessionBest = _current;
    }
  }

  /// Call when the user answers incorrectly: resets the current streak.
  /// [sessionBest] is left untouched.
  void recordIncorrect() {
    _current = 0;
  }

  /// Resets both the current streak and the session best, e.g. when
  /// starting a brand new practice session.
  void reset() {
    _current = 0;
    _sessionBest = 0;
  }
}
