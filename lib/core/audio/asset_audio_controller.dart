import 'dart:async';

import 'audio_controller.dart';
import 'audio_playback.dart';

/// One effects player, one quieter music player, and one narration player.
/// A new clip stops the previous clip so speech cannot overlap.
class AssetAudioController implements AudioController {
  AssetAudioController(this._playback) {
    final player = _playback;
    if (player is NarrationLifecycle) {
      _completion = (player as NarrationLifecycle).narrationCompleted.listen(
        (_) => unawaited(_restoreMusic()),
      );
    }
  }
  StreamSubscription<void>? _completion;
  int _narrationGeneration = 0;

  static const musicVolume = 0.22;
  static const duckedMusicVolume = 0.06;
  static const debounce = Duration(milliseconds: 280);

  final AudioPlayback _playback;
  bool _disposed = false;
  bool _effects = true;
  bool _music = false;
  bool _narration = true;
  bool _paused = false;
  bool _musicRunning = false;
  bool _musicStarting = false;
  bool _musicDucked = false;
  String? _lastClip;
  String? _lastPath;
  DateTime? _lastStarted;

  @override
  bool get effectsEnabled => _effects;

  @override
  bool get musicEnabled => _music;

  @override
  bool get narrationEnabled => _narration;

  @override
  String? get lastNarrationId => _lastClip;

  Future<void> refreshMusicLevel() =>
      _playback.setMusicVolume(_musicDucked ? duckedMusicVolume : musicVolume);

  @override
  Future<void> playEffect(SoundEffect effect) async {
    if (_disposed || !_effects || _paused) {
      return;
    }
    _narrationGeneration++;
    await _playback.stopNarration();
    await _restoreMusic();
    await _playback.playEffect(_asset(effect));
  }

  @override
  Future<NarrationPlayResult> playNarration(
    String clipId, {
    String? assetPath,
  }) async {
    if (_disposed || _paused) {
      return NarrationPlayResult.paused;
    }
    if (!_narration) {
      return NarrationPlayResult.muted;
    }
    final path = assetPath;
    if (path == null || path.isEmpty) {
      return NarrationPlayResult.missing;
    }
    final now = DateTime.now();
    if (_lastClip == clipId &&
        _lastStarted != null &&
        now.difference(_lastStarted!) < debounce) {
      return NarrationPlayResult.debounced;
    }
    final generation = ++_narrationGeneration;
    await _playback.stopNarration();
    await _playback.stopEffects();
    if (generation != _narrationGeneration ||
        _disposed ||
        _paused ||
        !_narration) {
      return NarrationPlayResult.paused;
    }
    if (_musicRunning && !_musicDucked) {
      await _playback.setMusicVolume(duckedMusicVolume);
      _musicDucked = true;
    }
    try {
      await _playback.playNarration(path);
    } catch (_) {
      if (generation == _narrationGeneration) await _restoreMusic();
      return NarrationPlayResult.missing;
    }
    if (generation != _narrationGeneration ||
        _disposed ||
        _paused ||
        !_narration) {
      return NarrationPlayResult.paused;
    }
    _lastClip = clipId;
    _lastPath = path;
    _lastStarted = now;
    return NarrationPlayResult.played;
  }

  @override
  Future<NarrationPlayResult> replayNarration() async {
    final clip = _lastClip;
    if (clip == null) {
      return NarrationPlayResult.missing;
    }
    _lastStarted = null;
    return playNarration(clip, assetPath: _lastPath);
  }

  @override
  Future<void> stopNarration() async {
    _narrationGeneration++;
    await _playback.stopNarration();
    await _restoreMusic();
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
    if (!_narration) {
      await _playback.stopNarration();
      await _restoreMusic();
    }
    if (_music && !_paused) {
      if (!_musicRunning && !_musicStarting) {
        _musicStarting = true;
        try {
          _musicRunning = await _playback.startMusic(
            'audio/music.wav',
            musicVolume,
          );
          if (!_music || _paused || _disposed) {
            await _playback.stopMusic();
            _musicRunning = false;
          }
        } finally {
          _musicStarting = false;
        }
      }
      return;
    }
    if (_musicRunning) {
      await _playback.stopMusic();
      _musicRunning = false;
      _musicDucked = false;
    }
  }

  @override
  Future<void> pauseForLifecycle() async {
    _narrationGeneration++;
    _paused = true;
    await _playback.stopNarration();
    if (_musicRunning) {
      await _playback.pauseMusic();
    }
    await _restoreMusic();
  }

  @override
  Future<void> resumeForLifecycle() async {
    _paused = false;
    if (!_music) {
      return;
    }
    if (_musicRunning) {
      await _playback.resumeMusic();
      return;
    }
    _musicRunning = await _playback.startMusic('audio/music.wav', musicVolume);
  }

  @override
  Future<void> dispose() async {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _narrationGeneration++;
    await _completion?.cancel();
    await _playback.dispose();
  }

  Future<void> _restoreMusic() async {
    if (_musicDucked && _musicRunning && _music && !_paused) {
      await _playback.setMusicVolume(musicVolume);
    }
    _musicDucked = false;
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
