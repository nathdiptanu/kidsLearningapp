/// Short sounds the child can hear. Narration is a separate, optional switch.
enum SoundEffect { tap, correct, retry, complete, reward }

enum NarrationPlayResult { played, muted, missing, debounced, paused }

/// Plays bundled sounds. Implementations must stay quiet when a switch is off
/// and must not throw when the device has no audio plugin.
abstract class AudioController {
  bool get effectsEnabled;

  bool get musicEnabled;

  bool get narrationEnabled;

  String? get lastNarrationId;

  Future<void> playEffect(SoundEffect effect);

  /// Plays a reviewed clip when one is bundled. Missing files stay silent.
  Future<NarrationPlayResult> playNarration(String clipId, {String? assetPath});

  Future<NarrationPlayResult> replayNarration();

  Future<void> stopNarration();

  Future<void> applySettings({
    required bool effectsEnabled,
    required bool musicEnabled,
    required bool narrationEnabled,
  });

  Future<void> pauseForLifecycle();

  Future<void> resumeForLifecycle();

  Future<void> dispose();
}
