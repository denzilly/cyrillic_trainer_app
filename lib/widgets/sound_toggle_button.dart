import 'package:flutter/material.dart';

/// The musical-note button that toggles sound effects on/off.
class SoundToggleButton extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const SoundToggleButton({super.key, required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(enabled ? Icons.music_note : Icons.music_off),
      tooltip: enabled ? 'Sound on' : 'Sound off',
      onPressed: () => onChanged(!enabled),
    );
  }
}
