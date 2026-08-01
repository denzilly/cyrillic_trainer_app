import 'dart:math';

import 'package:flutter/material.dart';

import '../data/models/practice_prompt.dart';
import '../logic/streak_controller.dart';
import '../logic/transliteration_checker.dart';
import '../theme/app_theme.dart';
import '../widgets/streak_badge.dart';
import '../widgets/tactile_button.dart';

enum _Feedback { none, correct, incorrect }

/// Shared practice loop for both Single Letter Practice and Word Practice:
/// shows a prompt, takes a transliteration guess, gives correct/incorrect
/// feedback (with the answer and meaning), and tracks the answer streak.
class PracticeScreen extends StatefulWidget {
  final String title;
  final List<PracticePrompt> prompts;

  const PracticeScreen({super.key, required this.title, required this.prompts});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _streak = StreakController();
  final _random = Random();

  late final List<PracticePrompt> _queue;
  int _index = 0;
  _Feedback _feedback = _Feedback.none;

  @override
  void initState() {
    super.initState();
    _queue = List.of(widget.prompts)..shuffle(_random);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  PracticePrompt get _current => _queue[_index % _queue.length];

  void _submit() {
    if (_feedback != _Feedback.none) return;

    final correct = TransliterationChecker.isCorrect(_controller.text, _current.accepted);
    setState(() {
      if (correct) {
        _streak.recordCorrect();
        _feedback = _Feedback.correct;
      } else {
        _streak.recordIncorrect();
        _feedback = _Feedback.incorrect;
      }
    });
  }

  void _next() {
    setState(() {
      _index++;
      if (_index % _queue.length == 0) _queue.shuffle(_random);
      _controller.clear();
      _feedback = _Feedback.none;
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final answered = _feedback != _Feedback.none;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.gutter),
            child: Center(child: StreakBadge(streak: _streak.current)),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _current.displayText,
                    style: practiceCharStyle(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.gutter * 2),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: !answered,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Type the transliteration',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  if (!answered)
                    SizedBox(
                      width: double.infinity,
                      child: TactileButton(onPressed: _submit, child: const Text('Submit')),
                    )
                  else ...[
                    _FeedbackBanner(
                      correct: _feedback == _Feedback.correct,
                      answer: _current.primary,
                      meaning: _current.meaning,
                    ),
                    const SizedBox(height: AppSpacing.gutter),
                    SizedBox(
                      width: double.infinity,
                      child: TactileButton(onPressed: _next, child: const Text('Next')),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final bool correct;
  final String answer;
  final String? meaning;

  const _FeedbackBanner({required this.correct, required this.answer, this.meaning});

  @override
  Widget build(BuildContext context) {
    final background = correct ? AppColors.successContainer : AppColors.errorContainer;
    final foreground = correct ? AppColors.onSuccessContainer : AppColors.onErrorContainer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.gutter),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            correct ? 'Correct!' : 'Incorrect',
            style: TextStyle(color: foreground, fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: AppSpacing.base / 2),
          Text('Answer: $answer', style: TextStyle(color: foreground)),
          if (meaning != null) ...[
            const SizedBox(height: AppSpacing.base / 2),
            Text('Meaning: $meaning', style: TextStyle(color: foreground)),
          ],
        ],
      ),
    );
  }
}
