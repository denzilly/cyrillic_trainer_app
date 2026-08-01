import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/main.dart';
import 'package:cyrillic_trainer_app/screens/leaderboard_screen.dart';
import 'package:cyrillic_trainer_app/screens/letter_practice_screen.dart';
import 'package:cyrillic_trainer_app/screens/word_practice_screen.dart';

void main() {
  group('LandingScreen', () {
    testWidgets('shows the title and all three navigation buttons', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());

      expect(find.text('Cyrillic Trainer'), findsOneWidget);
      expect(find.text('Single Letter Practice'), findsOneWidget);
      expect(find.text('Word Practice'), findsOneWidget);
      expect(find.text('High Scores'), findsOneWidget);
    });

    testWidgets('Single Letter Practice navigates to LetterPracticeScreen', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());

      await tester.tap(find.text('Single Letter Practice'));
      await tester.pumpAndSettle();

      expect(find.byType(LetterPracticeScreen), findsOneWidget);
    });

    testWidgets('Word Practice navigates to WordPracticeScreen', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());

      await tester.tap(find.text('Word Practice'));
      await tester.pumpAndSettle();

      expect(find.byType(WordPracticeScreen), findsOneWidget);
    });

    testWidgets('High Scores navigates to LeaderboardScreen', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());

      await tester.tap(find.text('High Scores'));
      await tester.pumpAndSettle();

      expect(find.byType(LeaderboardScreen), findsOneWidget);
    });
  });
}
