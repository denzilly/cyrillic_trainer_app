import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/screens/leaderboard_screen.dart';

/// See test/unit/leaderboard_service_test.dart — same two `games_services`
/// channels, stubbed here to drive the screen end to end.
const _channel = MethodChannel('games_services');
const _playerChannel = EventChannel('games_services.player');

const _playerJson = '{"playerID":"me","displayName":"Me"}';
const _playerScoreJson =
    '{"rank":2,"displayScore":"9","rawScore":9,"timestampMillis":0,'
    '"scoreHolder":{"playerID":"me","displayName":"Me"}}';

String _scoresJson(List<String> entries) => '[${entries.join(',')}]';

const _friendScore =
    '{"rank":1,"displayScore":"12","rawScore":12,"timestampMillis":0,'
    '"scoreHolder":{"playerID":"friend","displayName":"Friend"}}';
const _ownScore =
    '{"rank":2,"displayScore":"9","rawScore":9,"timestampMillis":0,'
    '"scoreHolder":{"playerID":"me","displayName":"Me"}}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  void stubScores(String scoresJson) {
    messenger.setMockStreamHandler(
      _playerChannel,
      MockStreamHandler.inline(
        onListen: (_, events) => events.success(_playerJson),
      ),
    );
    messenger.setMockMethodCallHandler(_channel, (call) async {
      return switch (call.method) {
        'loadLeaderboardScores' => scoresJson,
        'getPlayerScoreObject' => _playerScoreJson,
        _ => null,
      };
    });
  }

  tearDown(() {
    messenger.setMockMethodCallHandler(_channel, null);
    messenger.setMockStreamHandler(_playerChannel, null);
  });

  testWidgets('shows every player on the board, not just the current one',
      (tester) async {
    stubScores(_scoresJson([_friendScore, _ownScore]));

    await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Friend'), findsOneWidget);
    expect(find.text('Me'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
  });

  testWidgets('still shows the player when the global list comes back empty',
      (tester) async {
    // Play Games' global rankings can lag a just-submitted score.
    stubScores('[]');

    await tester.pumpWidget(const MaterialApp(home: LeaderboardScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Me'), findsOneWidget);
    expect(find.text('No scores yet — be the first!'), findsNothing);
  });
}
