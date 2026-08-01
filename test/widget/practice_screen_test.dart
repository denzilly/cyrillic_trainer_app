import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/data/models/practice_prompt.dart';
import 'package:cyrillic_trainer_app/screens/practice_screen.dart';

Widget wrap(Widget child) => MaterialApp(home: child);

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
}
