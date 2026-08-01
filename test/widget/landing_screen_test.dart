import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/main.dart';
import 'package:cyrillic_trainer_app/screens/help_screen.dart';
import 'package:cyrillic_trainer_app/screens/leaderboard_screen.dart';
import 'package:cyrillic_trainer_app/screens/letter_practice_screen.dart';
import 'package:cyrillic_trainer_app/screens/word_practice_screen.dart';

void main() {
  group('LandingScreen', () {
    testWidgets('shows the title and all four navigation buttons', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());

      expect(find.text('Cyrillic Trainer'), findsOneWidget);
      expect(find.text('Single Letter Practice'), findsOneWidget);
      expect(find.text('Word Practice'), findsOneWidget);
      expect(find.text('High Scores'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
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
      // Not pumpAndSettle: LeaderboardScreen shows an indeterminate
      // CircularProgressIndicator while it loads, which animates forever
      // and would make pumpAndSettle time out.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(LeaderboardScreen), findsOneWidget);
    });

    testWidgets('Help navigates to HelpScreen', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());

      await tester.tap(find.text('Help'));
      await tester.pumpAndSettle();

      expect(find.byType(HelpScreen), findsOneWidget);
    });
  });
}
