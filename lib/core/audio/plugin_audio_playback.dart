import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'audio_playback.dart';

/// Two long-lived players. Playback failures stay silent so a missing plugin
/// never blocks a game. Widget tests skip the plugin entirely.
class PluginAudioPlayback implements AudioPlayback {
  PluginAudioPlayback({this._effects, this._music});

  AudioPlayer? _effects;
  AudioPlayer? _music;

  bool get _skipPlugin => Platform.environment['FLUTTER_TEST'] == 'true';

  AudioPlayer get _effectsPlayer => _effects ??= AudioPlayer();

  AudioPlayer get _musicPlayer => _music ??= AudioPlayer();

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
  Future<void> dispose() {
    final effects = _effects;
    final music = _music;
    _effects = null;
    _music = null;
    if (_skipPlugin || (effects == null && music == null)) {
      return Future<void>.value();
    }
    return _guard(() async {
      await effects?.dispose();
      await music?.dispose();
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
