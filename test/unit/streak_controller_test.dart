import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/logic/streak_controller.dart';

void main() {
  group('StreakController', () {
    test('starts at zero', () {
      final streak = StreakController();
      expect(streak.current, 0);
      expect(streak.sessionBest, 0);
    });

    test('increments current streak on correct answers', () {
      final streak = StreakController()
        ..recordCorrect()
        ..recordCorrect()
        ..recordCorrect();
      expect(streak.current, 3);
      expect(streak.sessionBest, 3);
    });

    test('resets current streak on an incorrect answer', () {
      final streak = StreakController()
        ..recordCorrect()
        ..recordCorrect()
        ..recordIncorrect();
      expect(streak.current, 0);
    });

    test('keeps sessionBest after a streak is broken', () {
      final streak = StreakController()
        ..recordCorrect()
        ..recordCorrect()
        ..recordCorrect()
        ..recordIncorrect();
      expect(streak.current, 0);
      expect(streak.sessionBest, 3);
    });

    test('sessionBest tracks the highest of multiple streaks', () {
      final streak = StreakController()
        ..recordCorrect()
        ..recordCorrect()
        ..recordIncorrect()
        ..recordCorrect();
      expect(streak.current, 1);
      expect(streak.sessionBest, 2);
    });

    test('startingStreak resumes a carried-over streak', () {
      final streak = StreakController(startingStreak: 5);
      expect(streak.current, 5);
      expect(streak.sessionBest, 5);

      streak.recordCorrect();
      expect(streak.current, 6);
      expect(streak.sessionBest, 6);
    });

    test('a resumed streak still resets to zero on a wrong answer', () {
      final streak = StreakController(startingStreak: 5)..recordIncorrect();
      expect(streak.current, 0);
      expect(streak.sessionBest, 5);
    });

    test('reset clears both current and sessionBest', () {
      final streak = StreakController()
        ..recordCorrect()
        ..recordCorrect()
        ..reset();
      expect(streak.current, 0);
      expect(streak.sessionBest, 0);
    });
  });
}
