import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/services/leaderboard_service.dart';

/// `games_services` talks to Play Games over these two channels: the method
/// channel for the calls themselves, and an event channel carrying the signed
/// -in player (which is what `GameAuth.isSignedIn` listens to).
const _channel = MethodChannel('games_services');
const _playerChannel = EventChannel('games_services.player');

const _playerJson = '{"playerID":"me","displayName":"Me"}';
const _topScoresJson =
    '[{"rank":1,"displayScore":"12","rawScore":12,"timestampMillis":0,'
    '"scoreHolder":{"playerID":"friend","displayName":"Friend"}},'
    '{"rank":2,"displayScore":"9","rawScore":9,"timestampMillis":0,'
    '"scoreHolder":{"playerID":"me","displayName":"Me"}}]';
const _playerScoreJson =
    '{"rank":2,"displayScore":"9","rawScore":9,"timestampMillis":0,'
    '"scoreHolder":{"playerID":"me","displayName":"Me"}}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late List<MethodCall> calls;

  setUp(() {
    calls = [];
    messenger.setMockStreamHandler(
      _playerChannel,
      MockStreamHandler.inline(
        onListen: (_, events) => events.success(_playerJson),
      ),
    );
    messenger.setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      return switch (call.method) {
        'loadLeaderboardScores' => _topScoresJson,
        'getPlayerScoreObject' => _playerScoreJson,
        _ => null,
      };
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(_channel, null);
    messenger.setMockStreamHandler(_playerChannel, null);
  });

  Map<Object?, Object?> loadArgs() =>
      calls.firstWhere((c) => c.method == 'loadLeaderboardScores').arguments
          as Map<Object?, Object?>;

  group('LeaderboardService.fetchLeaderboard', () {
    test('forces a network refresh instead of accepting cached scores',
        () async {
      await LeaderboardService.instance.fetchLeaderboard();

      // Left false, the Play Games client answers from its local cache, so
      // scores other players set since the last fetch never show up.
      expect(loadArgs()['forceRefresh'], isTrue);
    });

    test('asks for the public leaderboard, all time', () async {
      await LeaderboardService.instance.fetchLeaderboard();

      final args = loadArgs();
      // 0 is COLLECTION_PUBLIC (PlayerScope.global) — 3 would scope the list
      // down to the player's own friends.
      expect(args['leaderboardCollection'], 0);
      expect(args['span'], 2); // TIME_SPAN_ALL_TIME
      expect(args['maxResults'], 10);
    });

    test('returns every score the platform hands back', () async {
      final data = await LeaderboardService.instance.fetchLeaderboard();

      expect(data, isNotNull);
      expect(data!.top.map((s) => s.scoreHolder.displayName), ['Friend', 'Me']);
      expect(data.player?.displayScore, '9');
      expect(data.playerInTop, isTrue);
    });
  });
}
