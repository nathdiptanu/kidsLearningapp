class GameResult {
  const GameResult({
    required this.activityId,
    required this.engineType,
    required this.completed,
    required this.firstAttemptCorrect,
    required this.hintsUsed,
    required this.stars,
    required this.seed,
    this.generatorVersion,
  });

  final String activityId;
  final String engineType;
  final bool completed;
  final bool firstAttemptCorrect;
  final int hintsUsed;
  final int stars;
  final int seed;
  final String? generatorVersion;
}
