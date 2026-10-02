class ActivityRecord {
  const ActivityRecord({
    required this.activityId,
    required this.engineType,
    required this.attempts,
    required this.completions,
    required this.bestStars,
    required this.hintsUsed,
    required this.lastPlayedAt,
    required this.countedAsFree,
    this.generatorType,
    this.generatorVersion,
    this.seed,
    this.skillId,
    this.resultSummary,
    this.bestScore = 0,
  });

  final String activityId;
  final String engineType;
  final int attempts;
  final int completions;
  final int bestStars;
  final int hintsUsed;
  final int lastPlayedAt;
  final bool countedAsFree;
  final String? generatorType;
  final String? generatorVersion;
  final int? seed;
  final String? skillId;
  final String? resultSummary;
  final int bestScore;

  bool get completed => completions > 0;
}
