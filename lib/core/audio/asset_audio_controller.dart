import 'audio_controller.dart';
import 'audio_playback.dart';

/// One effects player and one quieter music player. A new effect stops the
/// previous effect so taps cannot stack.
class AssetAudioController implements AudioController {
  AssetAudioController(this._playback);

  static const musicVolume = 0.22;

  final AudioPlayback _playback;
  bool _disposed = false;
  bool _effects = true;
  bool _music = false;
  bool _narration = true;
  bool _paused = false;
  bool _musicRunning = false;

  @override
  bool get effectsEnabled => _effects;

  @override
  bool get musicEnabled => _music;

  @override
  bool get narrationEnabled => _narration;

  @override
  Future<void> playEffect(SoundEffect effect) async {
    if (_disposed || !_effects || _paused) {
      return;
    }
    await _playback.playEffect(_asset(effect));
  }

  @override
  Future<void> playNarration(String clipId) async {
    // No reviewed pronunciation clips are bundled.
  }

  @override
  Future<void> applySettings({
    required bool effectsEnabled,
    required bool musicEnabled,
    required bool narrationEnabled,
  }) async {
    _effects = effectsEnabled;
    _narration = narrationEnabled;
    _music = musicEnabled;
    if (_disposed) {
      return;
    }
    if (_music && !_paused) {
      if (!_musicRunning) {
        await _playback.startMusic('audio/music.wav', musicVolume);
        _musicRunning = true;
      }
      return;
    }
    if (_musicRunning) {
      await _playback.stopMusic();
      _musicRunning = false;
    }
  }

  @override
  Future<void> pauseForLifecycle() async {
    _paused = true;
    if (_musicRunning) {
      await _playback.pauseMusic();
    }
  }

  @override
  Future<void> resumeForLifecycle() async {
    _paused = false;
    if (_music && _musicRunning) {
      await _playback.resumeMusic();
    }
  }

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    await _playback.dispose();
  }

  String _asset(SoundEffect effect) {
    return switch (effect) {
      SoundEffect.tap => 'audio/tap.wav',
      SoundEffect.correct => 'audio/correct.wav',
      SoundEffect.retry => 'audio/retry.wav',
      SoundEffect.complete => 'audio/complete.wav',
      SoundEffect.reward => 'audio/reward.wav',
    };
  }
}
