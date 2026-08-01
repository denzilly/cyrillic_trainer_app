import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'alphabet_grid.dart';

/// Shows the Cyrillic alphabet reference grid as a modal bottom sheet.
Future<void> showAlphabetGrid(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cyrillic Alphabet', style: Theme.of(context).textTheme.headlineMedium),
                IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            Flexible(
              child: SingleChildScrollView(child: const AlphabetGrid()),
            ),
          ],
        ),
      ),
    ),
  );
}
