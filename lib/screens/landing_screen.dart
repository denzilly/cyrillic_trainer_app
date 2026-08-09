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

/// Intro sequence: the title fades in large, sitting low as if centered on
/// the screen; it then slides up to its resting spot above the buttons;
/// finally the subtitle + buttons fade into view.
///
/// The slide is a paint-time [Transform], not a layout/size change, so the
/// content's footprint inside the scroll view is constant from frame one —
/// letting it grow would make [SingleChildScrollView] think its content is
/// changing size under a fixed viewport and briefly report the position as
/// out of range, which the Material scroll behavior "corrects" by firing an
/// overscroll glow (the accent-orange flash at the edges).
class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _titleSlide;
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
    _titleSlide = CurvedAnimation(
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

    // How far (in px) the title starts below its resting position, so it
    // reads as centered on the screen before it slides up. Proportional to
    // screen height so it looks right across device sizes.
    final slideDistance = MediaQuery.of(context).size.height * 0.12;
    final titleOffset = Tween<double>(
      begin: slideDistance,
      end: 0.0,
    ).animate(_titleSlide);

    return Scaffold(
      body: SafeArea(
        child: ScrollableCenteredContent(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Opacity(
                  opacity: _titleOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, titleOffset.value),
                    child: child,
                  ),
                ),
                child: Text(
                  'Cyrillic Trainer',
                  style: textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              FadeTransition(
                opacity: _contentOpacity,
                child: Column(
                  children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
