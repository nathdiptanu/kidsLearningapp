import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'audio_playback.dart';

/// Two long-lived players. Playback failures stay silent so a missing plugin
/// never blocks a game. Widget tests skip the plugin entirely.
class PluginAudioPlayback implements AudioPlayback {
  PluginAudioPlayback({this._effects, this._music, this._narration});

  AudioPlayer? _effects;
  AudioPlayer? _music;
  AudioPlayer? _narration;

  bool get _skipPlugin => Platform.environment['FLUTTER_TEST'] == 'true';

  AudioPlayer get _effectsPlayer => _effects ??= AudioPlayer();

  AudioPlayer get _musicPlayer => _music ??= AudioPlayer();

  AudioPlayer get _narrationPlayer => _narration ??= AudioPlayer();

  @override
  Future<void> playEffect(String assetPath) {
    if (_skipPlugin) {
      return Future<void>.value();
    }
    return _guard(() async {
      await _effectsPlayer.stop();
      await _effectsPlayer.setReleaseMode(ReleaseMode.release);
      await _effectsPlayer.setVolume(1);
      await _effectsPlayer.play(AssetSource(assetPath));
    });
  }

  @override
  Future<void> startMusic(String assetPath, double volume) {
    if (_skipPlugin) {
      return Future<void>.value();
    }
    return _guard(() async {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(volume);
      await _musicPlayer.play(AssetSource(assetPath));
    });
  }

  @override
  Future<void> pauseMusic() {
    if (_skipPlugin || _music == null) {
      return Future<void>.value();
    }
    return _guard(_musicPlayer.pause);
  }

  @override
  Future<void> resumeMusic() {
    if (_skipPlugin || _music == null) {
      return Future<void>.value();
    }
    return _guard(_musicPlayer.resume);
  }

  @override
  Future<void> stopMusic() {
    if (_skipPlugin || _music == null) {
      return Future<void>.value();
    }
    return _guard(_musicPlayer.stop);
  }

  @override
  Future<void> playNarration(String assetPath) {
    if (_skipPlugin) {
      return Future<void>.value();
    }
    return _guard(() async {
      await stopEffects();
      await _narrationPlayer.stop();
      await _narrationPlayer.setReleaseMode(ReleaseMode.release);
      await _narrationPlayer.setVolume(1);
      await _narrationPlayer.play(AssetSource(assetPath));
    });
  }

  @override
  Future<void> stopEffects() {
    if (_skipPlugin || _effects == null) {
      return Future<void>.value();
    }
    return _guard(_effectsPlayer.stop);
  }

  @override
  Future<void> stopNarration() {
    if (_skipPlugin || _narration == null) {
      return Future<void>.value();
    }
    return _guard(_narrationPlayer.stop);
  }

  @override
  Future<void> setMusicVolume(double volume) {
    if (_skipPlugin || _music == null) {
      return Future<void>.value();
    }
    return _guard(() => _musicPlayer.setVolume(volume));
  }

  @override
  Future<void> dispose() {
    final effects = _effects;
    final music = _music;
    final narration = _narration;
    _effects = null;
    _music = null;
    _narration = null;
    if (_skipPlugin ||
        (effects == null && music == null && narration == null)) {
      return Future<void>.value();
    }
    return _guard(() async {
      await effects?.dispose();
      await music?.dispose();
      await narration?.dispose();
    });
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on MissingPluginException {
      // Widget tests and unsupported platforms have no player.
    } catch (_) {
      // A missing file or busy player must not stop the activity.
    }
  }
}
