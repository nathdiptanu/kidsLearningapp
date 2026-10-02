import '../models/age_band.dart';
import 'adaptive_config.dart';

class SkillState {
  const SkillState({
    required this.skillId,
    required this.difficulty,
    this.attempts = 0,
    this.correctFirstTry = 0,
    this.correctAfterHint = 0,
    this.incorrect = 0,
    this.recentOutcomes = const [],
    this.recentActivityIds = const [],
    this.lastPlayedAt,
    this.mastery = 0,
  });

  final String skillId;
  final int difficulty;
  final int attempts;
  final int correctFirstTry;
  final int correctAfterHint;
  final int incorrect;
  final List<String> recentOutcomes;
  final List<String> recentActivityIds;
  final int? lastPlayedAt;
  final double mastery;

  static SkillState starting(String skillId, AgeBand band) {
    return SkillState(skillId: skillId, difficulty: band.index + 1);
  }
}

class SkillAdaptation {
  const SkillAdaptation();

  /// Records one finished attempt. Callers must not call this for a replay.
  SkillState recordCompletion(
    SkillState current, {
    required String activityId,
    required bool firstAttemptCorrect,
    required int hintsUsed,
    required int wrongCount,
    required int nowMillis,
  }) {
    final letter = firstAttemptCorrect
        ? 'F'
        : hintsUsed == 0
        ? 'R'
        : 'H';
    final outcomes = _tail([
      ...current.recentOutcomes,
      letter,
    ], AdaptiveConfig.recentWindow);
    final ids = _tail([
      ...current.recentActivityIds.where((id) => id != activityId),
      activityId,
    ], AdaptiveConfig.recentWindow);
    var difficulty = current.difficulty;
    if (outcomes.length >= AdaptiveConfig.recentWindow) {
      final successes = outcomes
          .where((item) => item == 'F' || item == 'R')
          .length;
      final hints = outcomes.where((item) => item == 'H').length;
      final rate = successes / outcomes.length;
      if (rate >= AdaptiveConfig.promoteSuccessRate) {
        difficulty += 1;
      } else if (rate <= AdaptiveConfig.demoteSuccessRate && hints >= 2) {
        difficulty -= 1;
      }
    }
    final raw = outcomes.fold<double>(0, (sum, item) {
      return sum +
          switch (item) {
            'F' => AdaptiveConfig.firstTryCorrectWeight,
            'R' => AdaptiveConfig.correctAfterRetryWeight,
            'H' => AdaptiveConfig.hintRequiredWeight,
            _ => 0,
          };
    });
    final penalty = wrongCount.clamp(0, 3).toDouble();
    final mastery =
        ((raw - penalty) /
                (outcomes.length * AdaptiveConfig.firstTryCorrectWeight) *
                100)
            .clamp(0, 100)
            .toDouble();
    return SkillState(
      skillId: current.skillId,
      difficulty: difficulty.clamp(1, 4),
      attempts: current.attempts + 1,
      correctFirstTry: current.correctFirstTry + (letter == 'F' ? 1 : 0),
      correctAfterHint: current.correctAfterHint + (letter == 'H' ? 1 : 0),
      incorrect: current.incorrect + wrongCount,
      recentOutcomes: outcomes,
      recentActivityIds: ids,
      lastPlayedAt: nowMillis,
      mastery: mastery,
    );
  }

  List<String> _tail(List<String> values, int limit) {
    if (values.length <= limit) {
      return values;
    }
    return values.sublist(values.length - limit);
  }
}
