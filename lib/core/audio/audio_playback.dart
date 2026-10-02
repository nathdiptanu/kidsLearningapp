/// The only place that talks to a platform audio player.
abstract interface class AudioPlayback {
  Future<void> playEffect(String assetPath);

  Future<void> startMusic(String assetPath, double volume);

  Future<void> pauseMusic();

  Future<void> resumeMusic();

  Future<void> stopMusic();

  Future<void> dispose();
}
