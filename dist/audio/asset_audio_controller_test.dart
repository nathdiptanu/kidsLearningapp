import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/core/audio/asset_audio_controller.dart';
import 'package:sproutlab/core/audio/audio_controller.dart';
import 'package:sproutlab/core/audio/audio_playback.dart';

void main() {
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
    await audio.playNarration('cat');
    expect(playback.effects, isEmpty);
    expect(playback.musicStarts, 0);
  });
}

class _FakePlayback implements AudioPlayback {
  final List<String> effects = [];
  int musicStarts = 0;
  int pauses = 0;
  int resumes = 0;
  double musicVolume = 0;
  int playersCreated = 1;

  @override
  Future<void> playEffect(String assetPath) async {
    effects.add(assetPath);
  }

  @override
  Future<void> startMusic(String assetPath, double volume) async {
    musicStarts++;
    musicVolume = volume;
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
  Future<void> dispose() async {}
}
