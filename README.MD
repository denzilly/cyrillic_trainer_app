# Cyrillic Trainer

A gamified Flutter app for learning the Russian Cyrillic alphabet and vocabulary
through transliteration practice, with streaks to keep it fun.

## Features

- **Single Letter Practice** — drills all 33 letters of the Russian alphabet.
- **Word Practice** — drills a starter vocabulary list (Greetings, Numbers,
  Animals, Food, Colors), showing the English meaning after each answer.
  A "Word List" picker lets you restrict practice to specific categories.
- **Streaks** — a running streak counter that resets on a wrong answer.
- **Sound effects** — a toggle for correct/incorrect audio feedback.
- High Scores / leaderboard screen exists but isn't wired up yet — see
  [Status](#status).

## Tech stack

- [Flutter](https://flutter.dev) (Android target; iOS is not currently
  built/tested — see [Status](#status))
- `flutter_riverpod`, `shared_preferences`, `audioplayers`, `games_services`
- Local (non-Google-Fonts-fetched) Quicksand + Be Vietnam Pro fonts, bundled
  under `assets/fonts/`

## Getting started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install)
   (stable channel) and the Android SDK/an emulator or device.
2. Fetch dependencies:
   ```
   flutter pub get
   ```
3. Run it:
   ```
   flutter run
   ```

## Testing

```
flutter analyze
flutter test                                    # unit + widget tests
flutter test integration_test/app_test.dart -d <device>   # golden-path, needs a real device/emulator
```

## Project structure

```
lib/
  data/         Cyrillic alphabet + vocabulary data, and the models for both
  logic/        Pure Dart logic: transliteration checking, streak tracking
  services/     SoundService (sfx + persisted on/off preference)
  theme/        Design tokens and ThemeData (Vibrant Scholastic design system)
  widgets/      Shared widgets (tactile button, streak badge, category picker, ...)
  screens/      Landing, practice (shared by letters/words), leaderboard
test/
  unit/         Logic + data tests
  widget/       Widget tests (flutter_test)
integration_test/
  app_test.dart Golden-path test driven on a real device/emulator
```

## Status

Actively developed, Android-first:

- ✅ Core practice loop (letters + words), streaks, category picker, sound
  toggle, theming — built, tested, and manually verified on an emulator.
- ⏸️ **Leaderboard** (Play Games Services) is deferred — it needs a Google
  Play Console developer account (one-time fee) to configure and test, which
  hasn't been set up yet.
- ⏸️ **iOS** is tabled for now — this is developed on Windows, and building/
  testing for iOS needs a Mac.
