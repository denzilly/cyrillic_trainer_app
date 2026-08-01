import 'package:flutter/material.dart';

import 'screens/landing_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CyrillicTrainerApp());
}

class CyrillicTrainerApp extends StatelessWidget {
  const CyrillicTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyrillic Trainer',
      theme: buildAppTheme(),
      home: const LandingScreen(),
    );
  }
}
