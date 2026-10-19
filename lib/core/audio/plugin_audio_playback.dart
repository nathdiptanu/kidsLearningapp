import 'dart:io';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'audio_playback.dart';

/// Two long-lived players. Playback failures stay silent so a missing plugin
/// never blocks a game. Widget tests skip the plugin entirely.
class PluginAudioPlayback implements AudioPlayback, NarrationLifecycle {
  PluginAudioPlayback({this._effects, this._music, this._narration});

  AudioPlayer? _effects;
  AudioPlayer? _music;
  AudioPlayer? _narration;
  static const speechChannel = MethodChannel('sproutlab/speech');
  final _speechCompleted = StreamController<void>.broadcast();
  int _speechGeneration = 0;
  Future<double> _level() async {
    try {
      return (await speechChannel.invokeMethod<double>('musicLevel') ?? 0.7)
          .clamp(0.0, 1.0);
    } catch (_) {
      return 0.7;
    }
  }

  bool get _skipPlugin => Platform.environment['FLUTTER_TEST'] == 'true';

  AudioPlayer get _effectsPlayer => _effects ??= AudioPlayer();

  AudioPlayer get _musicPlayer => _music ??= AudioPlayer();

  AudioPlayer get _narrationPlayer => _narration ??= AudioPlayer();

  @override
  Stream<void> get narrationCompleted => Stream<void>.multi((events) {
    final recorded = _narrationPlayer.onPlayerComplete.listen(events.add);
    final spoken = _speechCompleted.stream.listen(events.add);
    events.onCancel = () async {
      await recorded.cancel();
      await spoken.cancel();
    };
  });

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
  Future<bool> startMusic(String assetPath, double volume) async {
    if (_skipPlugin) {
      return true;
    }
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      final target = volume * await _level();
      await _musicPlayer.setVolume(0);
      await _musicPlayer.play(AssetSource(assetPath));
      for (var step = 1; step <= 8; step++) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
        if (_musicPlayer.state != PlayerState.playing) break;
        await _musicPlayer.setVolume(target * step / 8);
      }
      return true;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
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
    return (() async {
      await stopEffects();
      await _narrationPlayer.stop();
      if (assetPath.startsWith('speech:')) {
        final generation = ++_speechGeneration;
        final payload = Uri.parse(assetPath);
        await speechChannel
            .invokeMethod<void>('speak', {
              'language': payload.queryParameters['language'] ?? 'hi-IN',
              'text': payload.queryParameters['text'] ?? '',
            })
            .timeout(const Duration(seconds: 20));
        if (generation == _speechGeneration && !_speechCompleted.isClosed) {
          _speechCompleted.add(null);
        }
        return;
      }
      await _narrationPlayer.setReleaseMode(ReleaseMode.release);
      await _narrationPlayer.setVolume(1);
      await _narrationPlayer.play(AssetSource(assetPath));
    })();
  }

  @override
  Future<void> stopEffects() {
    if (_skipPlugin || _effects == null) {
      return Future<void>.value();
    }
    return _guard(_effectsPlayer.stop);
  }

  @override
  Future<void> stopNarration() async {
    _speechGeneration++;
    if (_skipPlugin) return;
    await _guard(() => speechChannel.invokeMethod<void>('stop'));
    if (_narration != null) await _guard(_narrationPlayer.stop);
  }

  @override
  Future<void> setMusicVolume(double volume) {
    if (_skipPlugin || _music == null) {
      return Future<void>.value();
    }
    return _guard(() async => _musicPlayer.setVolume(volume * await _level()));
  }

  @override
  Future<void> dispose() async {
    await stopNarration();
    await _speechCompleted.close();
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
