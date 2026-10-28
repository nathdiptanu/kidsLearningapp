import '../games/play/activity_definition.dart';
import '../models/game_category.dart';

enum RoundOutcome { complete, win, draw, loss }

class RoundScore {
  const RoundScore({
    required this.points,
    required this.stars,
    required this.mastery,
    required this.outcome,
  });

  final int points;
  final int stars;
  final bool mastery;
  final RoundOutcome outcome;
}

/// Points live here so widgets cannot invent a score.
/// Choice activities: 10 first try, 7 after a miss without a hint, 5 with a hint.
/// Matching, mazes, spot-the-difference and Tic-Tac-Toe use their own bands.
RoundScore scoreRound({
  required GameCategory category,
  required int wrongCount,
  required int hintsUsed,
  RoundOutcome outcome = RoundOutcome.complete,
}) {
  final wrong = wrongCount < 0 ? 0 : wrongCount;
  final hints = hintsUsed < 0 ? 0 : hintsUsed;
  return switch (category) {
    GameCategory.ticTacToe => _ticTacToe(outcome, hints),
    GameCategory.maze => _banded(
      clean: 12,
      retry: 9,
      hinted: 6,
      wrong: wrong,
      hints: hints,
    ),
    GameCategory.matching => _banded(
      clean: 12,
      retry: 8,
      hinted: 6,
      wrong: wrong,
      hints: hints,
    ),
    GameCategory.findDifference ||
    GameCategory.findObjects ||
    GameCategory.connectDots => _banded(
      clean: 12,
      retry: 8,
      hinted: 5,
      wrong: wrong,
      hints: hints,
    ),
    GameCategory.maths ||
    GameCategory.vocabulary ||
    GameCategory.pattern ||
    GameCategory.knowledge ||
    GameCategory.hindi ||
    GameCategory.discoverIndia => _banded(
      clean: 10,
      retry: 7,
      hinted: 5,
      wrong: wrong,
      hints: hints,
    ),
  };
}

RoundScore _banded({
  required int clean,
  required int retry,
  required int hinted,
  required int wrong,
  required int hints,
}) {
  final points = hints > 0
      ? hinted
      : wrong > 0
      ? retry
      : clean;
  return RoundScore(
    points: points,
    stars: starsForRound(wrongCount: wrong, hintsUsed: hints),
    mastery: wrong == 0 && hints == 0,
    outcome: RoundOutcome.complete,
  );
}

int starsForRound({required int wrongCount, required int hintsUsed}) {
  if (wrongCount == 0 && hintsUsed == 0) {
    return 3;
  }
  if (hintsUsed == 0) {
    return 2;
  }
  return 1;
}

RoundScore _ticTacToe(RoundOutcome outcome, int hints) {
  final settled = switch (outcome) {
    RoundOutcome.win => 10,
    RoundOutcome.draw => 6,
    RoundOutcome.loss => 4,
    RoundOutcome.complete => 4,
  };
  final points = hints > 0 ? (settled - 2).clamp(1, settled) : settled;
  final baseStars = switch (outcome) {
    RoundOutcome.win => 3,
    RoundOutcome.draw => 2,
    _ => 1,
  };
  final stars = hints > 0 ? (baseStars - 1).clamp(1, 3) : baseStars;
  return RoundScore(
    points: points,
    stars: stars,
    mastery: outcome == RoundOutcome.win && hints == 0,
    outcome: outcome == RoundOutcome.complete ? RoundOutcome.loss : outcome,
  );
}

String levelBadgeId(String activityId) => 'level:$activityId';

String levelBadgeLabel(ActivityDefinition activity) =>
    'Level ${activity.variant + 1} complete · ${activity.title}';
