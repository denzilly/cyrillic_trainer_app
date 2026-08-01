import 'package:flutter/material.dart';

import '../data/models/practice_prompt.dart';
import '../data/vocabulary.dart';
import 'practice_screen.dart';

class WordPracticeScreen extends StatelessWidget {
  const WordPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeScreen(
      title: 'Word Practice',
      // Category filtering (Phase 5) will replace this with a user-selected subset.
      prompts: promptsFromWords(vocabulary),
    );
  }
}
