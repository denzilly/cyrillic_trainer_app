import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/tactile_button.dart';
import 'leaderboard_screen.dart';
import 'letter_practice_screen.dart';
import 'word_practice_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                    'Cyrillic Trainer',
                    style: textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
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
                        MaterialPageRoute(builder: (_) => const LetterPracticeScreen()),
                      ),
                      child: const Text('Single Letter Practice'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  SizedBox(
                    width: double.infinity,
                    child: TactileButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const WordPracticeScreen()),
                      ),
                      child: const Text('Word Practice'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  SizedBox(
                    width: double.infinity,
                    child: TactileButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                      ),
                      child: const Text('High Scores'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
