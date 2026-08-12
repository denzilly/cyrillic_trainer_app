import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A compact circular back button for use as an AppBar's `leading` widget,
/// replacing Material's flat default back arrow with something that matches
/// the design system's rounded, tactile look.
class RoundBackButton extends StatelessWidget {
  const RoundBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Material(
        color: AppColors.surfaceContainer,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.arrow_back, color: AppColors.onSurface, size: 20),
          ),
        ),
      ),
    );
  }
}
