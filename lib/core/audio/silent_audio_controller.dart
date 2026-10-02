import 'audio_controller.dart';

/// Used only when a test replaces the audio provider.
class SilentAudioController implements AudioController {
  bool _effects = true;
  bool _music = false;
  bool _narration = true;

  @override
  bool get effectsEnabled => _effects;

  @override
  bool get musicEnabled => _music;

  @override
  bool get narrationEnabled => _narration;

  @override
  Future<void> playEffect(SoundEffect effect) async {}

  @override
  String? get lastNarrationId => null;

  @override
  Future<NarrationPlayResult> playNarration(
    String clipId, {
    String? assetPath,
  }) async {
    return NarrationPlayResult.missing;
  }

  @override
  Future<NarrationPlayResult> replayNarration() async {
    return NarrationPlayResult.missing;
  }

  @override
  Future<void> stopNarration() async {}

  @override
  Future<void> applySettings({
    required bool effectsEnabled,
    required bool musicEnabled,
    required bool narrationEnabled,
  }) async {
    _effects = effectsEnabled;
    _music = musicEnabled;
    _narration = narrationEnabled;
  }

  @override
  Future<void> pauseForLifecycle() async {}

  @override
  Future<void> resumeForLifecycle() async {}

  @override
  Future<void> dispose() async {}
}
