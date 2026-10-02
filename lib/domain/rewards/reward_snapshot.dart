/// Counts taken from saved completions. Replays do not increase these.
class RewardSnapshot {
  const RewardSnapshot({
    this.completionsByEngine = const {},
    this.totalStars = 0,
    this.bestSingleStars = 0,
    this.completedJourneys = 0,
    this.distinctDays = 0,
  });

  final Map<String, int> completionsByEngine;
  final int totalStars;
  final int bestSingleStars;
  final int completedJourneys;
  final int distinctDays;

  int count(String engine) => completionsByEngine[engine] ?? 0;

  int get categoriesPracticed =>
      completionsByEngine.values.where((count) => count > 0).length;
}
