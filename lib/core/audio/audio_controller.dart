/// Short sounds the child can hear. Narration is a separate, optional switch.
enum SoundEffect { tap, correct, retry, complete, reward }

/// Plays bundled sounds. Implementations must stay quiet when a switch is off
/// and must not throw when the device has no audio plugin.
abstract class AudioController {
  bool get effectsEnabled;

  bool get musicEnabled;

  bool get narrationEnabled;

  Future<void> playEffect(SoundEffect effect);

  /// Reviewed pronunciation clips only. This build has none, so this returns.
  Future<void> playNarration(String clipId);

  Future<void> applySettings({
    required bool effectsEnabled,
    required bool musicEnabled,
    required bool narrationEnabled,
  });

  Future<void> pauseForLifecycle();

  Future<void> resumeForLifecycle();

  Future<void> dispose();
}
