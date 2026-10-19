import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/session_providers.dart';
import '../../core/audio/asset_audio_controller.dart';

class SpeechSettingsCard extends ConsumerStatefulWidget {
  const SpeechSettingsCard({super.key});
  @override
  ConsumerState<SpeechSettingsCard> createState() => _SpeechSettingsState();
}

class _SpeechSettingsState extends ConsumerState<SpeechSettingsCard> {
  static const _channel = MethodChannel('sproutlab/speech');
  double _level = 0.7;
  String? _message;
  bool _previewing = false;
  Future<void> _preview() async {
    final audio = ref.read(audioControllerProvider);
    final container = ProviderScope.containerOf(context, listen: false);
    final priorMusic = audio.musicEnabled;
    setState(() => _previewing = true);
    try {
      await audio.applySettings(
        effectsEnabled: audio.effectsEnabled,
        musicEnabled: true,
        narrationEnabled: audio.narrationEnabled,
      );
      await Future<void>.delayed(const Duration(seconds: 4));
    } finally {
      final settings = container.read(sessionProvider).value?.settings;
      await audio.applySettings(
        effectsEnabled: settings?.soundEffectsEnabled ?? true,
        musicEnabled: settings?.musicEnabled ?? priorMusic,
        narrationEnabled: settings?.narrationEnabled ?? true,
      );
      if (mounted) setState(() => _previewing = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final value = await _channel.invokeMethod<double>('musicLevel');
      if (mounted && value != null) setState(() => _level = value.clamp(0, 1));
    } catch (_) {
      /* Non-Android tests use the quiet default. */
    }
  }

  Future<void> _saveLevel(double value) async {
    try {
      await _channel.invokeMethod<void>('setMusicLevel', {'level': value});
      final audio = ref.read(audioControllerProvider);
      if (audio is AssetAudioController) await audio.refreshMusicLevel();
    } catch (_) {
      if (mounted) {
        setState(
          () => _message = 'Music volume is unavailable on this device.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text('Music volume', style: TextStyle(fontWeight: FontWeight.w800)),
      const Text('Quiet maximum. Volume changes are saved immediately.'),
      Slider(
        value: _level,
        min: 0,
        max: 1,
        divisions: 10,
        label: '${(_level * 100).round()}%',
        onChanged: (value) => setState(() => _level = value),
        onChangeEnd: _saveLevel,
      ),
      OutlinedButton.icon(
        icon: const Icon(Icons.music_note),
        label: Text(
          _previewing
              ? 'Playing a quiet preview…'
              : 'Preview music for 4 seconds',
        ),
        onPressed: _previewing ? null : _preview,
      ),
      OutlinedButton.icon(
        icon: const Icon(Icons.record_voice_over),
        label: const Text('Install or choose a device speech voice'),
        onPressed: () async {
          try {
            await _channel.invokeMethod<void>('settings');
          } catch (_) {
            if (mounted) {
              setState(
                () => _message = 'Open Android Settings → Text-to-speech. Install Hindi and English offline voices.',
              );
            }
          }
        },
      ),
      const Text(
        'Interim device pronunciation: choose offline Hindi and English voices. Native-speaker-reviewed recordings are not included yet.',
      ),
      if (_message != null) Text(_message!),
    ],
  );
}
