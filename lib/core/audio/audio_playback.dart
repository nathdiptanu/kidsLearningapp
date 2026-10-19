/// The only place that talks to a platform audio player.
abstract interface class AudioPlayback {
  Future<void> playEffect(String assetPath);

  /// Returns false when the player could not start, so callers do not
  /// treat silence as a running loop.
  Future<bool> startMusic(String assetPath, double volume);

  Future<void> pauseMusic();

  Future<void> resumeMusic();

  Future<void> stopMusic();

  Future<void> playNarration(String assetPath);

  Future<void> stopNarration();

  Future<void> stopEffects();

  Future<void> setMusicVolume(double volume);

  Future<void> dispose();
}

abstract interface class NarrationLifecycle {
  Stream<void> get narrationCompleted;
}
