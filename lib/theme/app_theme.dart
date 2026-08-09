import 'package:flutter/material.dart';

/// Color tokens from the "Vibrant Scholastic" Stitch design system.
abstract final class AppColors {
  static const primary = Color(0xFF6B38D4);
  static const primaryContainer = Color(0xFF8455EF);
  static const onPrimary = Color(0xFFFFFFFF);

  /// Reserved for gamification: streaks, XP, level-ups.
  static const accent = Color(0xFFFEA619);
  static const onAccent = Color(0xFF684000);

  static const success = Color(0xFF16A34A);
  static const successContainer = Color(0xFFDCFCE7);
  static const onSuccessContainer = Color(0xFF14532D);

  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  static const surface = Color(0xFFF8F9FA);
  static const surfaceContainer = Color(0xFFEDEEEF);
  static const surfaceContainerLow = Color(0xFFF3F4F5);
  static const onSurface = Color(0xFF191C1D);
  static const onSurfaceVariant = Color(0xFF494454);
  static const outlineVariant = Color(0xFFCBC3D7);
}

/// Corner radii, matching the design system's "Rounded" shape language.
abstract final class AppRadius {
  static const sm = 4.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 999.0;
}

/// The 8px spacing grid used throughout the design system.
abstract final class AppSpacing {
  static const base = 8.0;
  static const gutter = 16.0;
  static const marginMobile = 20.0;
  static const maxContentWidth = 600.0;
}

ThemeData buildAppTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.accent,
        onSecondary: AppColors.onAccent,
        error: AppColors.error,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outlineVariant: AppColors.outlineVariant,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    // Transparent, not AppColors.surface: AmbientBackground paints the real
    // surface color (plus its drifting letters) once behind every screen,
    // above MaterialApp's Navigator, so each Scaffold has to let it show
    // through rather than painting its own opaque background over it.
    scaffoldBackgroundColor: Colors.transparent,
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontFamily: 'Quicksand',
        fontSize: 40,
        fontWeight: FontWeight.w700,
        height: 48 / 40,
        color: AppColors.onSurface,
      ),
      headlineLarge: const TextStyle(
        fontFamily: 'Quicksand',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 40 / 32,
        color: AppColors.onSurface,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'Quicksand',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 34 / 28,
        color: AppColors.onSurface,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'BeVietnamPro',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurface,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'BeVietnamPro',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: AppColors.onSurfaceVariant,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'BeVietnamPro',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
        color: AppColors.onSurface,
      ),
    ),
  );
}

/// The oversized display style used for the letter/word being practiced
/// (the design system's "practice-char" role).
TextStyle practiceCharStyle() => const TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 80,
  fontWeight: FontWeight.w700,
  height: 96 / 80,
  color: AppColors.onSurface,
);
