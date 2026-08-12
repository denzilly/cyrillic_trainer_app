import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Plays correct/incorrect feedback sound effects, respecting a persisted
/// on/off preference. A single shared instance since there's only ever one
/// active practice session at a time.
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  static const _prefsKey = 'sound_effects_enabled';

  final AudioPlayer _player = AudioPlayer();
  bool _enabled = true;

  bool get enabled => _enabled;

  /// Loads the persisted preference. Call once at app startup before any
  /// practice screen reads [enabled]. Falls back to sound-on if the
  /// preference store can't be read, rather than blocking app startup.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool(_prefsKey) ?? true;
    } catch (_) {
      _enabled = true;
    }
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }

  Future<void> playCorrect() => _play('sfx/correct.mp3');
  Future<void> playIncorrect() => _play('sfx/incorrect.mp3');

  Future<void> _play(String assetPath) async {
    if (!_enabled) return;
    // Playback failures (missing audio hardware, no platform channel in
    // tests, etc.) should never interrupt the practice flow.
    try {
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Ignored: sound effects are a nice-to-have, not load-bearing.
    }
  }
}
