import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/ambient_background.dart';
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
/// the screen; it slides up to its resting spot above the buttons; the
/// subtitle fades in below it; only once that text has settled does the
/// card frame fade in behind/around it; finally the buttons fade in.
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
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _cardOpacity;
  late final Animation<double> _buttonsOpacity;
  bool _introStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
    );
    _titleSlide = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.5, curve: Curves.easeInOut),
    );
    _subtitleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.68, curve: Curves.easeIn),
    );
    _cardOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.68, 0.85, curve: Curves.easeOut),
    );
    _buttonsOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.85, 1.0, curve: Curves.easeIn),
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
      // The landing screen inverts the app's usual palette: solid purple with
      // its own lighter drifting letters, painted over (not through) the
      // shared surface-colored AmbientBackground.
      body: Stack(
        children: [
          const Positioned.fill(
            child: DriftingLetterField(palette: AmbientPalette.purple),
          ),
          SafeArea(
            child: ScrollableCenteredContent(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // The card frame's own fade-in (_cardOpacity) is separate
                  // from the title/subtitle animations passed in as `child`,
                  // so the text isn't re-faded by the card's opacity on top
                  // of its own — it only fades the background/border/shadow
                  // in behind text that has already finished landing.
                  AnimatedBuilder(
                    animation: _cardOpacity,
                    builder: (context, child) => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.gutter * 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow.withValues(
                          alpha: _cardOpacity.value,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(
                          color: AppColors.outlineVariant.withValues(
                            alpha: _cardOpacity.value,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.onSurface.withValues(
                              alpha: 0.08 * _cardOpacity.value,
                            ),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: child,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                            'CYRILLIC TRAINER',
                            style: textTheme.displayLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.base),
                        FadeTransition(
                          opacity: _subtitleOpacity,
                          child: Text(
                            '(Кириллический тренажёр)',
                            style: textTheme.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter * 3),
                  FadeTransition(
                    opacity: _buttonsOpacity,
                    child: Column(
                      children: [
                        _MenuButton(
                          label: 'Single Letter Practice',
                          destination: (_) => const LetterPracticeScreen(),
                        ),
                        const SizedBox(height: AppSpacing.gutter),
                        _MenuButton(
                          label: 'Word Practice',
                          destination: (_) => const WordPracticeScreen(),
                        ),
                        const SizedBox(height: AppSpacing.gutter),
                        _MenuButton(
                          label: 'High Scores',
                          destination: (_) => const LeaderboardScreen(),
                        ),
                        const SizedBox(height: AppSpacing.gutter),
                        _MenuButton(
                          label: 'Help',
                          destination: (_) => const HelpScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One of the landing screen's navigation buttons: gold-on-purple — the
/// inverse of the purple [TactileButton] used on every other screen, since
/// here purple is the background rather than the accent.
class _MenuButton extends StatelessWidget {
  final String label;
  final WidgetBuilder destination;

  const _MenuButton({required this.label, required this.destination});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TactileButton(
        color: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: destination)),
        child: Text(label),
      ),
    );
  }
}
