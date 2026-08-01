import 'package:flutter/material.dart';

import '../data/cyrillic_alphabet.dart';
import '../theme/app_theme.dart';

/// A reference grid of all 33 Cyrillic letters (upper + lower case) with
/// their Latin transliteration underneath. Used on the Help screen and as
/// a quick-reference sheet from Single Letter Practice.
class AlphabetGrid extends StatelessWidget {
  const AlphabetGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cyrillicAlphabet.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 90,
        mainAxisSpacing: AppSpacing.base,
        crossAxisSpacing: AppSpacing.base,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final letter = cyrillicAlphabet[index];
        final latin = letter.primary.isEmpty ? '(silent)' : letter.primary;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${letter.upper}${letter.lower}',
                style: textTheme.headlineMedium?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 2),
              Text(
                latin,
                style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
