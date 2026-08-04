import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/scrollable_centered_content.dart';
import '../widgets/tactile_button.dart';
import 'help_screen.dart';
import 'leaderboard_screen.dart';
import 'letter_practice_screen.dart';
import 'word_practice_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

/// Intro sequence: the title fades in large and centered, the rest of the
/// content (subtitle + buttons) then grows in below it — pushing the title
/// up towards its resting position, since the column stays vertically
/// centered — and finally that content fades into view.
class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _contentSize;
  late final Animation<double> _contentOpacity;
  bool _introStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    );
    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _contentSize = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeInOut),
    );
    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.65, 1.0, curve: Curves.easeIn),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_introStarted) return;
    _introStarted = true;
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: ScrollableCenteredContent(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _titleOpacity,
                child: Text(
                  'Cyrillic Trainer',
                  style: textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              SizeTransition(
                sizeFactor: _contentSize,
                alignment: Alignment.topLeft,
                child: FadeTransition(
                  opacity: _contentOpacity,
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.base),
                      Text(
                        'Кириллический тренажёр',
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.gutter * 3),
                      SizedBox(
                        width: double.infinity,
                        child: TactileButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LetterPracticeScreen(),
                            ),
                          ),
                          child: const Text('Single Letter Practice'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                      SizedBox(
                        width: double.infinity,
                        child: TactileButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const WordPracticeScreen(),
                            ),
                          ),
                          child: const Text('Word Practice'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                      SizedBox(
                        width: double.infinity,
                        child: TactileButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LeaderboardScreen(),
                            ),
                          ),
                          child: const Text('High Scores'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.gutter),
                      SizedBox(
                        width: double.infinity,
                        child: TactileButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HelpScreen()),
                          ),
                          child: const Text('Help'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
