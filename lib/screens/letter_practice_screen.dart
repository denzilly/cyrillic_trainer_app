import 'package:flutter/material.dart';

import '../data/cyrillic_alphabet.dart';
import '../data/models/practice_prompt.dart';
import '../widgets/alphabet_grid_sheet.dart';
import 'practice_screen.dart';

class LetterPracticeScreen extends StatelessWidget {
  const LetterPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeScreen(
      title: 'Single Letter Practice',
      prompts: promptsFromLetters(cyrillicAlphabet),
      onOpenAlphabetGrid: () => showAlphabetGrid(context),
    );
  }
}
