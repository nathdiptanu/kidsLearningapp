import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/audio/asset_audio_controller.dart';
import 'package:sproutlab/core/audio/audio_controller.dart';
import 'package:sproutlab/core/audio/audio_playback.dart';

void main() {
  test('failed narration is missing and restores music', () async {
    final playback = _FakePlayback()..failNarration = true;
    final audio = AssetAudioController(playback);
    addTearDown(audio.dispose);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: true,
      narrationEnabled: true,
    );
    expect(
      await audio.playNarration('broken', assetPath: 'audio/missing.wav'),
      NarrationPlayResult.missing,
    );
    expect(playback.musicVolume, AssetAudioController.musicVolume);
  });

  test('narration completion restores ducked music', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    addTearDown(audio.dispose);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: true,
      narrationEnabled: true,
    );
    await audio.playNarration('word', assetPath: 'audio/word.wav');
    expect(playback.musicVolume, AssetAudioController.duckedMusicVolume);
    playback.completed.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(playback.musicVolume, AssetAudioController.musicVolume);
  });
  test('effects stay quiet when sound is off', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    await audio.applySettings(
      effectsEnabled: false,
      musicEnabled: false,
      narrationEnabled: true,
    );
    await audio.playEffect(SoundEffect.correct);
    expect(playback.effects, isEmpty);
    expect(playback.musicStarts, 0);
  });

  test('music stays off unless the setting is on', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: false,
      narrationEnabled: false,
    );
    expect(playback.musicStarts, 0);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: true,
      narrationEnabled: false,
    );
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: true,
      narrationEnabled: false,
    );
    expect(playback.musicStarts, 1);
    expect(playback.musicVolume, AssetAudioController.musicVolume);
  });

  test('one effect replaces the previous effect on the same player', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    await audio.playEffect(SoundEffect.correct);
    await audio.playEffect(SoundEffect.retry);
    expect(playback.effects, ['audio/correct.wav', 'audio/retry.wav']);
    expect(playback.playersCreated, 1);
  });

  test('background pauses music and blocks effects', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: true,
      narrationEnabled: false,
    );
    await audio.pauseForLifecycle();
    await audio.playEffect(SoundEffect.reward);
    expect(playback.pauses, 1);
    expect(playback.effects, isEmpty);
    await audio.resumeForLifecycle();
    expect(playback.resumes, 1);
    await audio.playEffect(SoundEffect.complete);
    expect(playback.effects, ['audio/complete.wav']);
  });

  test('narration has no clip to play', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    expect(await audio.playNarration('cat'), NarrationPlayResult.missing);
    expect(playback.narration, isEmpty);
    expect(playback.musicStarts, 0);
  });

  test('narration stops the previous clip and ducks music', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: true,
      narrationEnabled: true,
    );
    expect(
      await audio.playNarration('a', assetPath: 'audio/complete.wav'),
      NarrationPlayResult.played,
    );
    expect(
      await audio.playNarration('a', assetPath: 'audio/complete.wav'),
      NarrationPlayResult.debounced,
    );
    expect(
      await audio.playNarration('b', assetPath: 'audio/reward.wav'),
      NarrationPlayResult.played,
    );
    expect(playback.narration, ['audio/complete.wav', 'audio/reward.wav']);
    expect(playback.narrationStops, greaterThan(0));
    expect(
      playback.musicVolumes,
      contains(AssetAudioController.duckedMusicVolume),
    );
    await audio.pauseForLifecycle();
    expect(
      await audio.playNarration('b', assetPath: 'audio/reward.wav'),
      NarrationPlayResult.paused,
    );
  });

  test('an effect stops speech so the two cannot overlap', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: true,
      narrationEnabled: true,
    );
    expect(
      await audio.playNarration('a', assetPath: 'audio/complete.wav'),
      NarrationPlayResult.played,
    );
    await audio.playEffect(SoundEffect.correct);
    expect(playback.narrationStops, greaterThan(0));
    expect(playback.effects, ['audio/correct.wav']);
  });

  test('mute and missing files leave the activity usable', () async {
    final playback = _FakePlayback();
    final audio = AssetAudioController(playback);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: false,
      narrationEnabled: false,
    );
    expect(
      await audio.playNarration('a', assetPath: 'audio/complete.wav'),
      NarrationPlayResult.muted,
    );
    expect(playback.narration, isEmpty);
    await audio.applySettings(
      effectsEnabled: true,
      musicEnabled: false,
      narrationEnabled: true,
    );
    expect(await audio.replayNarration(), NarrationPlayResult.missing);
  });
}

class _FakePlayback implements AudioPlayback, NarrationLifecycle {
  final completed = StreamController<void>.broadcast();
  bool failNarration = false;
  @override
  Stream<void> get narrationCompleted => completed.stream;
  final List<String> effects = [];
  final List<String> narration = [];
  final List<double> musicVolumes = [];
  int musicStarts = 0;
  int pauses = 0;
  int resumes = 0;
  int narrationStops = 0;
  double musicVolume = 0;
  int playersCreated = 1;

  @override
  Future<void> playEffect(String assetPath) async {
    effects.add(assetPath);
  }

  @override
  Future<bool> startMusic(String assetPath, double volume) async {
    musicStarts++;
    musicVolume = volume;
    return true;
  }

  @override
  Future<void> pauseMusic() async {
    pauses++;
  }

  @override
  Future<void> resumeMusic() async {
    resumes++;
  }

  @override
  Future<void> stopMusic() async {}

  @override
  Future<void> playNarration(String assetPath) async {
    if (failNarration) throw StateError('Playback failed');
    narration.add(assetPath);
  }

  @override
  Future<void> stopNarration() async {
    narrationStops++;
  }

  @override
  Future<void> stopEffects() async {}

  @override
  Future<void> setMusicVolume(double volume) async {
    musicVolumes.add(volume);
    musicVolume = volume;
  }

  @override
  Future<void> dispose() async {
    await completed.close();
  }
}
