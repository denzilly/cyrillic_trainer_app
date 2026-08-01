import 'package:flutter/material.dart';

import '../data/vocabulary.dart';
import '../theme/app_theme.dart';
import 'tactile_button.dart';

/// Shows the "Word List" category picker as a modal bottom sheet. Returns
/// the updated set of selected categories, or null if dismissed unchanged.
Future<Set<String>?> showCategoryPicker(BuildContext context, Set<String> selected) {
  return showModalBottomSheet<Set<String>>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (context) => _CategoryPickerSheet(initialSelected: selected),
  );
}

class _CategoryPickerSheet extends StatefulWidget {
  final Set<String> initialSelected;

  const _CategoryPickerSheet({required this.initialSelected});

  @override
  State<_CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<_CategoryPickerSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.of(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Word List', style: Theme.of(context).textTheme.headlineMedium),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _selected = vocabCategories.toSet()),
                      child: const Text('All'),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selected = {}),
                      child: const Text('None'),
                    ),
                  ],
                ),
              ],
            ),
            for (final category in vocabCategories)
              CheckboxListTile(
                title: Text(category),
                value: _selected.contains(category),
                onChanged: (checked) {
                  setState(() {
                    if (checked ?? false) {
                      _selected.add(category);
                    } else {
                      _selected.remove(category);
                    }
                  });
                },
              ),
            const SizedBox(height: AppSpacing.gutter),
            TactileButton(
              onPressed: _selected.isEmpty ? null : () => Navigator.of(context).pop(_selected),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
