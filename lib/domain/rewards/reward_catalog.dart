import '../models/game_category.dart';
import 'reward_snapshot.dart';

enum RewardKind { badge, sticker }

class RewardDefinition {
  const RewardDefinition({
    required this.id,
    required this.kind,
    required this.title,
    required this.detail,
    required this.target,
    required this.progress,
  });

  final String id;
  final RewardKind kind;
  final String title;
  final String detail;
  final int target;
  final int Function(RewardSnapshot snapshot) progress;

  bool isEarned(RewardSnapshot snapshot) => progress(snapshot) >= target;
}

/// Pattern Detective counts pattern activities. Maze completions use Maze Explorer.
const rewardCatalog = <RewardDefinition>[
  RewardDefinition(
    id: 'badge_first_adventure',
    kind: RewardKind.badge,
    title: 'First Adventure',
    detail: 'Finish one daily adventure',
    target: 1,
    progress: _journeys,
  ),
  RewardDefinition(
    id: 'badge_maze_explorer',
    kind: RewardKind.badge,
    title: 'Maze Explorer',
    detail: 'Finish 10 mazes',
    target: 10,
    progress: _maze,
  ),
  RewardDefinition(
    id: 'badge_number_star',
    kind: RewardKind.badge,
    title: 'Number Star',
    detail: 'Finish 20 maths activities',
    target: 20,
    progress: _maths,
  ),
  RewardDefinition(
    id: 'badge_word_wizard',
    kind: RewardKind.badge,
    title: 'Word Wizard',
    detail: 'Finish 20 word activities',
    target: 20,
    progress: _words,
  ),
  RewardDefinition(
    id: 'badge_pattern_detective',
    kind: RewardKind.badge,
    title: 'Pattern Detective',
    detail: 'Finish 15 pattern activities',
    target: 15,
    progress: _patterns,
  ),
  RewardDefinition(
    id: 'badge_observation_hero',
    kind: RewardKind.badge,
    title: 'Observation Hero',
    detail: 'Finish 10 spot-the-difference activities',
    target: 10,
    progress: _differences,
  ),
  RewardDefinition(
    id: 'badge_matching_master',
    kind: RewardKind.badge,
    title: 'Matching Master',
    detail: 'Finish 15 matching activities',
    target: 15,
    progress: _matching,
  ),
  RewardDefinition(
    id: 'badge_five_day_learner',
    kind: RewardKind.badge,
    title: 'Five-Day Learner',
    detail: 'Practice on 5 different days',
    target: 5,
    progress: _days,
  ),
  RewardDefinition(
    id: 'sticker_sprout',
    kind: RewardKind.sticker,
    title: 'First sprout',
    detail: 'Finish 1 activity',
    target: 1,
    progress: _any,
  ),
  RewardDefinition(
    id: 'sticker_star',
    kind: RewardKind.sticker,
    title: 'First star',
    detail: 'Earn 1 star',
    target: 1,
    progress: _stars,
  ),
  RewardDefinition(
    id: 'sticker_star_ten',
    kind: RewardKind.sticker,
    title: 'Star bunch',
    detail: 'Earn 10 stars',
    target: 10,
    progress: _stars,
  ),
  RewardDefinition(
    id: 'sticker_star_thirty',
    kind: RewardKind.sticker,
    title: 'Star garden',
    detail: 'Earn 30 stars',
    target: 30,
    progress: _stars,
  ),
  RewardDefinition(
    id: 'sticker_bright',
    kind: RewardKind.sticker,
    title: 'Bright finish',
    detail: 'Earn 3 stars on one activity',
    target: 3,
    progress: _bestStars,
  ),
  RewardDefinition(
    id: 'sticker_maths_one',
    kind: RewardKind.sticker,
    title: 'Number seed',
    detail: 'Finish 1 maths activity',
    target: 1,
    progress: _maths,
  ),
  RewardDefinition(
    id: 'sticker_maths_five',
    kind: RewardKind.sticker,
    title: 'Number leaf',
    detail: 'Finish 5 maths activities',
    target: 5,
    progress: _maths,
  ),
  RewardDefinition(
    id: 'sticker_maths_ten',
    kind: RewardKind.sticker,
    title: 'Number bloom',
    detail: 'Finish 10 maths activities',
    target: 10,
    progress: _maths,
  ),
  RewardDefinition(
    id: 'sticker_word_one',
    kind: RewardKind.sticker,
    title: 'Word seed',
    detail: 'Finish 1 word activity',
    target: 1,
    progress: _words,
  ),
  RewardDefinition(
    id: 'sticker_word_five',
    kind: RewardKind.sticker,
    title: 'Word leaf',
    detail: 'Finish 5 word activities',
    target: 5,
    progress: _words,
  ),
  RewardDefinition(
    id: 'sticker_word_ten',
    kind: RewardKind.sticker,
    title: 'Word bloom',
    detail: 'Finish 10 word activities',
    target: 10,
    progress: _words,
  ),
  RewardDefinition(
    id: 'sticker_maze_one',
    kind: RewardKind.sticker,
    title: 'Path seed',
    detail: 'Finish 1 maze',
    target: 1,
    progress: _maze,
  ),
  RewardDefinition(
    id: 'sticker_maze_five',
    kind: RewardKind.sticker,
    title: 'Path leaf',
    detail: 'Finish 5 mazes',
    target: 5,
    progress: _maze,
  ),
  RewardDefinition(
    id: 'sticker_pattern_one',
    kind: RewardKind.sticker,
    title: 'Pattern seed',
    detail: 'Finish 1 pattern activity',
    target: 1,
    progress: _patterns,
  ),
  RewardDefinition(
    id: 'sticker_pattern_five',
    kind: RewardKind.sticker,
    title: 'Pattern leaf',
    detail: 'Finish 5 pattern activities',
    target: 5,
    progress: _patterns,
  ),
  RewardDefinition(
    id: 'sticker_match_one',
    kind: RewardKind.sticker,
    title: 'Match seed',
    detail: 'Finish 1 matching activity',
    target: 1,
    progress: _matching,
  ),
  RewardDefinition(
    id: 'sticker_match_five',
    kind: RewardKind.sticker,
    title: 'Match leaf',
    detail: 'Finish 5 matching activities',
    target: 5,
    progress: _matching,
  ),
  RewardDefinition(
    id: 'sticker_spot_one',
    kind: RewardKind.sticker,
    title: 'Spot seed',
    detail: 'Finish 1 spot-the-difference activity',
    target: 1,
    progress: _differences,
  ),
  RewardDefinition(
    id: 'sticker_spot_five',
    kind: RewardKind.sticker,
    title: 'Spot leaf',
    detail: 'Finish 5 spot-the-difference activities',
    target: 5,
    progress: _differences,
  ),
  RewardDefinition(
    id: 'sticker_day_two',
    kind: RewardKind.sticker,
    title: 'Two days',
    detail: 'Practice on 2 different days',
    target: 2,
    progress: _days,
  ),
  RewardDefinition(
    id: 'sticker_day_three',
    kind: RewardKind.sticker,
    title: 'Three days',
    detail: 'Practice on 3 different days',
    target: 3,
    progress: _days,
  ),
  RewardDefinition(
    id: 'sticker_journey',
    kind: RewardKind.sticker,
    title: 'Adventure sprout',
    detail: 'Finish 1 daily adventure',
    target: 1,
    progress: _journeys,
  ),
  RewardDefinition(
    id: 'sticker_journeys_three',
    kind: RewardKind.sticker,
    title: 'Adventure garden',
    detail: 'Finish 3 daily adventures',
    target: 3,
    progress: _journeys,
  ),
  RewardDefinition(
    id: 'sticker_six_games',
    kind: RewardKind.sticker,
    title: 'Whole garden',
    detail: 'Finish one activity in every game',
    target: 6,
    progress: _categories,
  ),
];

int _maths(RewardSnapshot snapshot) =>
    snapshot.count(GameCategory.maths.storageKey);

int _words(RewardSnapshot snapshot) =>
    snapshot.count(GameCategory.vocabulary.storageKey);

int _patterns(RewardSnapshot snapshot) =>
    snapshot.count(GameCategory.pattern.storageKey);

int _maze(RewardSnapshot snapshot) =>
    snapshot.count(GameCategory.maze.storageKey);

int _matching(RewardSnapshot snapshot) =>
    snapshot.count(GameCategory.matching.storageKey);

int _differences(RewardSnapshot snapshot) =>
    snapshot.count(GameCategory.findDifference.storageKey);

int _days(RewardSnapshot snapshot) => snapshot.distinctDays;

int _journeys(RewardSnapshot snapshot) => snapshot.completedJourneys;

int _stars(RewardSnapshot snapshot) => snapshot.totalStars;

int _bestStars(RewardSnapshot snapshot) => snapshot.bestSingleStars;

int _categories(RewardSnapshot snapshot) {
  var count = 0;
  for (final category in GameCategory.originalEngines) {
    if (snapshot.count(category.storageKey) > 0) {
      count += 1;
    }
  }
  return count;
}

int _any(RewardSnapshot snapshot) =>
    snapshot.completionsByEngine.values.fold(0, (sum, count) => sum + count);

RewardDefinition? rewardById(String id) {
  for (final reward in rewardCatalog) {
    if (reward.id == id) {
      return reward;
    }
  }
  return null;
}

Set<String> earnedRewardIds(RewardSnapshot snapshot) {
  return {
    for (final reward in rewardCatalog)
      if (reward.isEarned(snapshot)) reward.id,
  };
}
