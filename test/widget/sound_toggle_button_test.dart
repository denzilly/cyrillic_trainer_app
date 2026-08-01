import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyrillic_trainer_app/widgets/sound_toggle_button.dart';

void main() {
  group('SoundToggleButton', () {
    testWidgets('shows the music-note icon when enabled', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SoundToggleButton(enabled: true, onChanged: (_) {}),
      ));

      expect(find.byIcon(Icons.music_note), findsOneWidget);
      expect(find.byIcon(Icons.music_off), findsNothing);
    });

    testWidgets('shows the music-off icon when disabled', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: SoundToggleButton(enabled: false, onChanged: (_) {}),
      ));

      expect(find.byIcon(Icons.music_off), findsOneWidget);
      expect(find.byIcon(Icons.music_note), findsNothing);
    });

    testWidgets('tapping invokes onChanged with the flipped value', (tester) async {
      bool? newValue;
      await tester.pumpWidget(MaterialApp(
        home: SoundToggleButton(enabled: true, onChanged: (v) => newValue = v),
      ));

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(newValue, isFalse);
    });
  });
}
