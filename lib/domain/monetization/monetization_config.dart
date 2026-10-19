/// One source for the free allowance. Store price is never a constant here.
abstract final class MonetizationConfig {
  static const freeCompletedLevelsPerGame = 5;

  /// Sideload / engineering builds only. Pass
  /// `--dart-define=UNLOCK_ALL_GAMES=true` so every activity is playable.
  /// Default stays false so tests and a store build keep the 5-free lock.
  static const unlockAllGames = bool.fromEnvironment('UNLOCK_ALL_GAMES');
}
