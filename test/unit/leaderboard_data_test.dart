import 'package:flutter_test/flutter_test.dart';
import 'package:games_services/games_services.dart';
import 'package:cyrillic_trainer_app/services/leaderboard_service.dart';

LeaderboardScoreData _entry(int rank, {String name = 'Player'}) {
  return LeaderboardScoreData(
    rank: rank,
    displayScore: '$rank',
    rawScore: rank,
    timestampMillis: 0,
    scoreHolder: PlayerData(playerID: 'p$rank', displayName: name),
  );
}

void main() {
  group('LeaderboardData.playerInTop', () {
    test('is false when there is no player entry', () {
      final data = LeaderboardData(top: [_entry(1), _entry(2)]);
      expect(data.playerInTop, isFalse);
    });

    test('is true when the player\'s rank appears in the top list', () {
      final data = LeaderboardData(top: [_entry(1), _entry(2)], player: _entry(2));
      expect(data.playerInTop, isTrue);
    });

    test('is false when the player is ranked outside the top list', () {
      final data = LeaderboardData(top: [_entry(1), _entry(2)], player: _entry(225));
      expect(data.playerInTop, isFalse);
    });
  });
}
