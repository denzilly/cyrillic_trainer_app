import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/main.dart';
import 'package:cyrillic_trainer_app/screens/help_screen.dart';
import 'package:cyrillic_trainer_app/screens/leaderboard_screen.dart';
import 'package:cyrillic_trainer_app/screens/letter_practice_screen.dart';
import 'package:cyrillic_trainer_app/screens/word_practice_screen.dart';

/// Not pumpAndSettle: CyrillicTrainerApp wraps every screen in
/// AmbientBackground, whose drift animation repeats forever (same reason
/// LeaderboardScreen's indeterminate spinner can't use it below) — so
/// pumpAndSettle would never see zero scheduled frames and time out. Pump a
/// fixed, generous duration instead.
Future<void> settle(
  WidgetTester tester, [
  Duration duration = const Duration(milliseconds: 1200),
]) async {
  await tester.pump();
  await tester.pump(duration);
}

void main() {
  group('LandingScreen', () {
    testWidgets('shows the title and all four navigation buttons', (
      tester,
    ) async {
      await tester.pumpWidget(const CyrillicTrainerApp());

      expect(find.text('Cyrillic Trainer'), findsOneWidget);
      expect(find.text('Single Letter Practice'), findsOneWidget);
      expect(find.text('Word Practice'), findsOneWidget);
      expect(find.text('High Scores'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
    });

    testWidgets('Single Letter Practice navigates to LetterPracticeScreen', (
      tester,
    ) async {
      await tester.pumpWidget(const CyrillicTrainerApp());
      await settle(tester); // let the landing intro animation finish

      await tester.tap(find.text('Single Letter Practice'));
      await settle(
        tester,
        const Duration(milliseconds: 350),
      ); // page transition

      expect(find.byType(LetterPracticeScreen), findsOneWidget);
    });

    testWidgets('Word Practice navigates to WordPracticeScreen', (
      tester,
    ) async {
      await tester.pumpWidget(const CyrillicTrainerApp());
      await settle(tester); // let the landing intro animation finish

      await tester.tap(find.text('Word Practice'));
      await settle(
        tester,
        const Duration(milliseconds: 350),
      ); // page transition

      expect(find.byType(WordPracticeScreen), findsOneWidget);
    });

    testWidgets('High Scores navigates to LeaderboardScreen', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());
      await settle(tester); // let the landing intro animation finish

      await tester.tap(find.text('High Scores'));
      // Also not pumpAndSettle: LeaderboardScreen shows an indeterminate
      // CircularProgressIndicator while it loads.
      await settle(tester, const Duration(milliseconds: 300));

      expect(find.byType(LeaderboardScreen), findsOneWidget);
    });

    testWidgets('Help navigates to HelpScreen', (tester) async {
      await tester.pumpWidget(const CyrillicTrainerApp());
      await settle(tester); // let the landing intro animation finish

      await tester.tap(find.text('Help'));
      await settle(
        tester,
        const Duration(milliseconds: 350),
      ); // page transition

      expect(find.byType(HelpScreen), findsOneWidget);
    });
  });
}
