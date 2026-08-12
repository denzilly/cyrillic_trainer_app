import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cyrillic_trainer_app/data/models/practice_prompt.dart';
import 'package:cyrillic_trainer_app/screens/practice_screen.dart';

Widget wrap(Widget child) => MaterialApp(home: child);

const _hintMessage = 'Tap here anytime to see the full alphabet reference.';

const _singlePrompt = [
  PracticePrompt(displayText: 'привет', accepted: ['privet'], meaning: 'hi (informal)'),
];

void main() {
  group('PracticeScreen', () {
    testWidgets('shows the prompt text', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen(title: 'Word Practice', prompts: _singlePrompt)));

      expect(find.text('привет'), findsOneWidget);
    });

    testWidgets('correct answer shows success feedback, meaning, and increments streak', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen(title: 'Word Practice', prompts: _singlePrompt)));

      await tester.enterText(find.byType(TextField), 'privet');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Correct!'), findsOneWidget);
      expect(find.text('Meaning: hi (informal)'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // streak badge
    });

    testWidgets('incorrect answer shows failure feedback with the correct answer', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen(title: 'Word Practice', prompts: _singlePrompt)));

      await tester.enterText(find.byType(TextField), 'wrong');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Incorrect'), findsOneWidget);
      expect(find.text('Answer: privet'), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // streak stays at zero
    });

    testWidgets('submitting via the keyboard action works the same as tapping Submit', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen(title: 'Word Practice', prompts: _singlePrompt)));

      await tester.enterText(find.byType(TextField), 'privet');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(find.text('Correct!'), findsOneWidget);
    });

    testWidgets('Next clears feedback and re-enables input for another attempt', (tester) async {
      await tester.pumpWidget(wrap(const PracticeScreen(title: 'Word Practice', prompts: _singlePrompt)));

      await tester.enterText(find.byType(TextField), 'privet');
      await tester.tap(find.text('Submit'));
      await tester.pump();
      expect(find.text('Correct!'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(find.text('Correct!'), findsNothing);
      expect(find.text('Submit'), findsOneWidget);

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, isEmpty);
    });
  });

  group('PracticeScreen alphabet grid hint', () {
    testWidgets('shows the hint pointing at the grid button the first time', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        wrap(
          PracticeScreen(
            title: 'Single Letter Practice',
            prompts: _singlePrompt,
            onOpenAlphabetGrid: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(_hintMessage), findsOneWidget);

      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();

      expect(find.text(_hintMessage), findsNothing);
    });

    testWidgets('does not show the hint once it has already been seen', (tester) async {
      SharedPreferences.setMockInitialValues({'seen_alphabet_grid_hint': true});

      await tester.pumpWidget(
        wrap(
          PracticeScreen(
            title: 'Single Letter Practice',
            prompts: _singlePrompt,
            onOpenAlphabetGrid: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(_hintMessage), findsNothing);
    });

    testWidgets('does not show a hint when no alphabet grid button is provided', (tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(wrap(const PracticeScreen(title: 'Word Practice', prompts: _singlePrompt)));
      await tester.pumpAndSettle();

      expect(find.text(_hintMessage), findsNothing);
    });
  });
}
