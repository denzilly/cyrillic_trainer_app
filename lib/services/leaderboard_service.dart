import 'package:flutter/foundation.dart' show debugPrint;
import 'package:games_services/games_services.dart';

/// The bundle-of-scores shown on the High Scores screen: the global top 10,
/// plus the current player's own entry (which may or may not already be one
/// of the top 10).
class LeaderboardData {
  final List<LeaderboardScoreData> top;
  final LeaderboardScoreData? player;

  const LeaderboardData({required this.top, this.player});

  /// Whether the player's own entry is already shown in [top] (so callers
  /// shouldn't render it a second time below the list).
  bool get playerInTop => player != null && top.any((s) => s.rank == player!.rank);
}

/// Wraps `games_services` (Play Games Services on Android) for the streak
/// leaderboard: sign-in, score submission, and reading back the top 10 +
/// the player's own rank.
///
/// All methods fail soft (return null / do nothing) rather than throwing,
/// since the leaderboard is a nice-to-have on top of local practice, not
/// something that should ever interrupt it.
class LeaderboardService {
  LeaderboardService._();
  static final LeaderboardService instance = LeaderboardService._();

  /// Leaderboard ID from Play Console > Play Games Services > Leaderboards.
  static const String _androidLeaderboardId = 'CgkI_p_c8N0EEAIQAQ';

  bool _signedIn = false;
  bool get signedIn => _signedIn;

  Future<bool> ensureSignedIn() async {
    if (_signedIn) return true;
    try {
      await GameAuth.signIn();
      _signedIn = await GameAuth.isSignedIn;
    } catch (e) {
      // Kept visible (not just swallowed) since a misconfigured Play
      // Games Services setup — wrong App ID, unregistered SHA-1, tester
      // not added — fails exactly like this: silently, with no other UI
      // signal beyond "Couldn't sign in".
      debugPrint('LeaderboardService.ensureSignedIn failed: $e');
      _signedIn = false;
    }
    return _signedIn;
  }

  /// Runs [action], retrying once with a forced fresh sign-in if it fails.
  /// The native Games client's connection can go stale independently of our
  /// cached [_signedIn] flag — e.g. shortly after an OAuth client is
  /// (re)registered, calls fail with "CLIENT_RECONNECT_REQUIRED" until the
  /// client reconnects. Without this, [_signedIn] being true would keep
  /// short-circuiting [ensureSignedIn] and every call would keep failing
  /// the same way until the app was force-restarted.
  Future<T> _withReconnect<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      _signedIn = false;
      if (!await ensureSignedIn()) rethrow;
      return await action();
    }
  }

  /// Submits [streak] as the player's score. Safe to call after every
  /// correct answer — Play Games Services only ever keeps a player's best
  /// submitted score, so lower submissions are simply ignored server-side.
  Future<void> submitStreak(int streak) async {
    if (streak <= 0) return;
    try {
      if (!await ensureSignedIn()) return;
      await _withReconnect(
        () => Leaderboards.submitScore(
          score: Score(androidLeaderboardID: _androidLeaderboardId, value: streak),
        ),
      );
      debugPrint('LeaderboardService.submitStreak($streak) submitted');
    } catch (e) {
      // Non-fatal: submission failures shouldn't disrupt practice.
      debugPrint('LeaderboardService.submitStreak($streak) failed: $e');
    }
  }

  /// Loads the global top 10 plus the current player's own entry. Returns
  /// null if the player isn't (or can't be) signed in, or the fetch fails.
  Future<LeaderboardData?> fetchLeaderboard() async {
    try {
      if (!await ensureSignedIn()) return null;
      final top = await _withReconnect(
        () => Leaderboards.loadLeaderboardScores(
          androidLeaderboardID: _androidLeaderboardId,
          scope: PlayerScope.global,
          timeScope: TimeScope.allTime,
          maxResults: 10,
        ),
      );
      LeaderboardScoreData? player;
      try {
        player = await _withReconnect(
          () => Leaderboards.getPlayerScoreObject(
            androidLeaderboardID: _androidLeaderboardId,
            scope: PlayerScope.global,
            timeScope: TimeScope.allTime,
          ),
        );
      } catch (_) {
        // The player may not have a score yet; that's fine, just omit it.
        player = null;
      }
      debugPrint(
        'LeaderboardService.fetchLeaderboard loaded ${top?.length ?? 0} scores, '
        'player=${player?.displayScore}',
      );
      return LeaderboardData(top: top ?? const [], player: player);
    } catch (e) {
      debugPrint('LeaderboardService.fetchLeaderboard failed: $e');
      return null;
    }
  }
}
