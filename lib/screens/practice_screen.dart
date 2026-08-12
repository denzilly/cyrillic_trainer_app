import 'dart:math';

import 'package:flutter/material.dart';

import '../data/models/practice_prompt.dart';
import '../logic/streak_controller.dart';
import '../logic/transliteration_checker.dart';
import '../services/hint_service.dart';
import '../services/leaderboard_service.dart';
import '../services/sound_service.dart';
import '../theme/app_theme.dart';
import '../widgets/round_back_button.dart';
import '../widgets/scrollable_centered_content.dart';
import '../widgets/sound_toggle_button.dart';
import '../widgets/streak_badge.dart';
import '../widgets/tactile_button.dart';

enum _Feedback { none, correct, incorrect }

/// Shared practice loop for both Single Letter Practice and Word Practice:
/// shows a prompt, takes a transliteration guess, gives correct/incorrect
/// feedback (with the answer and meaning), and tracks the answer streak.
class PracticeScreen extends StatefulWidget {
  final String title;
  final List<PracticePrompt> prompts;

  /// When provided, shows a "Word List" button that opens the category
  /// picker. Omitted for Single Letter Practice, which has no categories.
  final VoidCallback? onOpenWordList;

  /// When provided, shows a button that opens the alphabet reference grid.
  /// Used by Single Letter Practice only.
  final VoidCallback? onOpenAlphabetGrid;

  /// Whether correct answers here count toward the Play Games Services
  /// leaderboard. On for Word Practice only — Single Letter Practice has no
  /// leaderboard presence.
  final bool submitToLeaderboard;

  const PracticeScreen({
    super.key,
    required this.title,
    required this.prompts,
    this.onOpenWordList,
    this.onOpenAlphabetGrid,
    this.submitToLeaderboard = false,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _streak = StreakController();
  final _random = Random();

  // Anchors the first-time alphabet-grid hint bubble to the grid button.
  final _alphabetGridButtonLink = LayerLink();
  OverlayEntry? _alphabetGridHintEntry;

  late final List<PracticePrompt> _queue;
  int _index = 0;
  _Feedback _feedback = _Feedback.none;
  bool _soundEnabled = SoundService.instance.enabled;

  @override
  void initState() {
    super.initState();
    _queue = List.of(widget.prompts)..shuffle(_random);
    if (widget.onOpenAlphabetGrid != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowAlphabetGridHint());
    }
  }

  @override
  void dispose() {
    _alphabetGridHintEntry?.remove();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _maybeShowAlphabetGridHint() async {
    final shouldShow = await HintService.instance.consumeAlphabetGridHint();
    if (!shouldShow || !mounted) return;

    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap anywhere outside the bubble to dismiss it.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _dismissAlphabetGridHint(entry),
            ),
          ),
          CompositedTransformFollower(
            link: _alphabetGridButtonLink,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, AppSpacing.base),
            showWhenUnlinked: false,
            child: Material(
              color: Colors.transparent,
              child: _AlphabetGridHintBubble(
                onDismiss: () => _dismissAlphabetGridHint(entry),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(entry);
    _alphabetGridHintEntry = entry;
  }

  void _dismissAlphabetGridHint(OverlayEntry entry) {
    entry.remove();
    if (identical(_alphabetGridHintEntry, entry)) _alphabetGridHintEntry = null;
  }

  PracticePrompt get _current => _queue[_index % _queue.length];

  void _submit() {
    if (_feedback != _Feedback.none) return;

    final correct = TransliterationChecker.isCorrect(
      _controller.text,
      _current.accepted,
    );
    setState(() {
      if (correct) {
        _streak.recordCorrect();
        _feedback = _Feedback.correct;
      } else {
        _streak.recordIncorrect();
        _feedback = _Feedback.incorrect;
      }
    });
    if (correct) {
      SoundService.instance.playCorrect();
      if (widget.submitToLeaderboard) {
        LeaderboardService.instance.submitStreak(_streak.current);
      }
    } else {
      SoundService.instance.playIncorrect();
    }
  }

  void _toggleSound(bool value) {
    setState(() => _soundEnabled = value);
    SoundService.instance.setEnabled(value);
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
        leading: const RoundBackButton(),
        actions: [
          if (widget.onOpenWordList != null)
            IconButton(
              icon: const Icon(Icons.checklist),
              tooltip: 'Word list',
              onPressed: widget.onOpenWordList,
            ),
          if (widget.onOpenAlphabetGrid != null)
            CompositedTransformTarget(
              link: _alphabetGridButtonLink,
              child: IconButton(
                icon: const Icon(Icons.grid_view),
                tooltip: 'Alphabet grid',
                onPressed: widget.onOpenAlphabetGrid,
              ),
            ),
          SoundToggleButton(enabled: _soundEnabled, onChanged: _toggleSound),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.gutter),
            child: Center(child: StreakBadge(streak: _streak.current)),
          ),
        ],
      ),
      body: SafeArea(
        child: ScrollableCenteredContent(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.gutter * 1.5),
            decoration: BoxDecoration(
              // Opaque, unlike the transparent scaffold: blocks the
              // AmbientBackground's drifting letters from showing through
              // the prompt/input/button, instead of just around them.
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.outlineVariant, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _current.displayText,
                    key: const Key('practicePromptText'),
                    style: practiceCharStyle(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    softWrap: false,
                  ),
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
                    child: TactileButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                    ),
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
                    child: TactileButton(
                      onPressed: _next,
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// First-time-only tip pointing at the alphabet grid button, shown via
/// [Overlay] and anchored to it with a [CompositedTransformFollower].
class _AlphabetGridHintBubble extends StatelessWidget {
  final VoidCallback onDismiss;

  const _AlphabetGridHintBubble({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Tap here anytime to see the full alphabet reference.',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: 13,
                height: 1.3,
              ),
            ),
            const SizedBox(height: AppSpacing.base / 2),
            TextButton(
              onPressed: onDismiss,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.onPrimary,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Got it',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  final bool correct;
  final String answer;
  final String? meaning;

  const _FeedbackBanner({
    required this.correct,
    required this.answer,
    this.meaning,
  });

  @override
  Widget build(BuildContext context) {
    final background = correct
        ? AppColors.successContainer
        : AppColors.errorContainer;
    final foreground = correct
        ? AppColors.onSuccessContainer
        : AppColors.onErrorContainer;

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
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
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
