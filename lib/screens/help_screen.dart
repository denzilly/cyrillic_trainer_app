import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/alphabet_grid.dart';
import '../widgets/scrollable_centered_content.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: SafeArea(
        child: ScrollableCenteredContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('How to play', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.base),
              Text(
                "You'll be shown a Cyrillic letter or word — type its Latin "
                'transliteration and press Submit (or hit Enter).',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                'Correct answers build your streak; a wrong answer resets '
                'it back to zero. In Word Practice you also see the English '
                'meaning after each answer, and can use the checklist '
                'button to focus on specific word categories.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                'Use the music-note button to toggle sound effects, and '
                'check High Scores to see how your best streak compares.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.gutter * 2),
              Text('Cyrillic Alphabet', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.base),
              const AlphabetGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
