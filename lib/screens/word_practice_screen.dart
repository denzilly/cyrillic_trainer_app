import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/practice_prompt.dart';
import '../data/vocabulary.dart';
import '../widgets/category_picker_sheet.dart';
import 'practice_screen.dart';

class WordPracticeScreen extends StatefulWidget {
  const WordPracticeScreen({super.key});

  @override
  State<WordPracticeScreen> createState() => _WordPracticeScreenState();
}

class _WordPracticeScreenState extends State<WordPracticeScreen> {
  static const _prefsKey = 'word_practice_selected_categories';

  Set<String> _selected = vocabCategories.toSet();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSelection();
  }

  Future<void> _loadSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey);
    if (!mounted) return;
    setState(() {
      if (saved != null && saved.isNotEmpty) {
        _selected = saved.toSet();
      }
      _loaded = true;
    });
  }

  Future<void> _saveSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _selected.toList());
  }

  Future<void> _openCategoryPicker() async {
    final result = await showCategoryPicker(context, _selected);
    if (!mounted || result == null) return;
    setState(() => _selected = result);
    _saveSelection();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PracticeScreen(
      key: ValueKey(_selected),
      title: 'Word Practice',
      prompts: promptsFromWords(wordsInCategories(_selected)),
      onOpenWordList: _openCategoryPicker,
      submitToLeaderboard: true,
    );
  }
}
