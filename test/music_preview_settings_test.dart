import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/app/session_providers.dart';
import 'package:sproutlab/core/audio/silent_audio_controller.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/features/parent/speech_settings_card.dart';

void main() {
  testWidgets(
    'leaving a music preview preserves newly saved music preference',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final audio = SilentAudioController();
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
            databaseProvider.overrideWith((ref) => db),
            audioControllerProvider.overrideWith((ref) => audio),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ValueListenableBuilder<bool>(
                valueListenable: visible,
                builder: (_, show, _) =>
                    show ? const SpeechSettingsCard() : const Text('Home'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(SpeechSettingsCard)),
      );
      final session = await tester.runAsync(
        () => container.read(sessionProvider.future),
      );
      await tester.tap(find.text('Preview music for 4 seconds'));
      await tester.pump();
      expect(audio.musicEnabled, true);
      await tester.runAsync(
        () => container
            .read(sessionProvider.notifier)
            .saveSettings(session!.settings.copyWith(musicEnabled: true)),
      );
      visible.value = false;
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      expect(audio.musicEnabled, true);
      expect(tester.takeException(), isNull);
    },
  );
}
