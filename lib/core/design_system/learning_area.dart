import 'package:flutter/widgets.dart';

import '../../domain/games/play/activity_definition.dart';
import '../../domain/models/game_category.dart';
import 'sprout_tokens.dart';

/// Explore groups. Each group lists the existing engines it opens, so
/// activity ids and free counts stay per engine.
enum LearningArea {
  maths(
    title: 'Maths',
    subtitle: 'Numbers and counting',
    art: SproutArt.maths,
    tint: SproutColors.mathsSurface,
    categories: [GameCategory.maths],
  ),
  english(
    title: 'English',
    subtitle: 'Pictures and words',
    art: SproutArt.english,
    tint: SproutColors.englishSurface,
    categories: [GameCategory.vocabulary],
  ),
  logic(
    title: 'Logic',
    subtitle: 'Patterns and paths',
    art: SproutArt.logic,
    tint: SproutColors.logicSurface,
    categories: [GameCategory.pattern, GameCategory.maze],
  ),
  observation(
    title: 'Observation',
    subtitle: 'Look and discover',
    art: SproutArt.observation,
    tint: SproutColors.observationSurface,
    categories: [GameCategory.matching, GameCategory.findDifference],
  ),
  knowledge(
    title: 'Knowledge',
    subtitle: 'Explore your world',
    art: SproutArt.knowledge,
    tint: SproutColors.knowledgeSurface,
    categories: [GameCategory.knowledge],
  ),
  ticTacToe(
    title: 'Tic-Tac-Toe',
    subtitle: 'Think and play',
    art: SproutArt.ticTacToe,
    tint: SproutColors.ticTacToeSurface,
    categories: [GameCategory.ticTacToe],
  );

  const LearningArea({
    required this.title,
    required this.subtitle,
    required this.art,
    required this.tint,
    required this.categories,
  });

  final String title;
  final String subtitle;
  final String art;
  final Color tint;
  final List<GameCategory> categories;

  static LearningArea forCategory(GameCategory category) {
    for (final area in LearningArea.values) {
      if (area.categories.contains(category)) {
        return area;
      }
    }
    return LearningArea.logic;
  }
}

/// Name of one game inside a learning area.
String gameKindLabel(GameCategory category) {
  return switch (category) {
    GameCategory.maths => 'Number play',
    GameCategory.vocabulary => 'Picture words',
    GameCategory.pattern => 'Pattern puzzle',
    GameCategory.maze => 'Find the path',
    GameCategory.matching => 'Odd one out',
    GameCategory.findDifference => 'Spot the difference',
    GameCategory.knowledge => 'Quiz',
    GameCategory.ticTacToe => 'Tic-Tac-Toe',
    GameCategory.hindi => 'Hindi',
    GameCategory.discoverIndia => 'Discover India',
  };
}

String gameKindDetail(GameCategory category) {
  return switch (category) {
    GameCategory.maths => 'Build number skills',
    GameCategory.vocabulary => 'Match pictures and words',
    GameCategory.pattern => 'Spot what comes next',
    GameCategory.maze => 'Trace a way through',
    GameCategory.matching => 'Find the one that does not belong',
    GameCategory.findDifference => 'Find what is not the same',
    GameCategory.knowledge => 'Questions about the world',
    GameCategory.ticTacToe => 'Three in a row',
    GameCategory.hindi => 'Letters and words',
    GameCategory.discoverIndia => 'Places and heritage',
  };
}

String artFor(GameCategory category) {
  return switch (category) {
    GameCategory.maze => SproutArt.maze,
    GameCategory.hindi => SproutArt.hindi,
    GameCategory.discoverIndia => SproutArt.discoverIndia,
    _ => LearningArea.forCategory(category).art,
  };
}

Color tintFor(GameCategory category) {
  return switch (category) {
    GameCategory.maze => SproutColors.mazeSurface,
    GameCategory.hindi => SproutColors.hindiSurface,
    GameCategory.discoverIndia => SproutColors.indiaSurface,
    _ => LearningArea.forCategory(category).tint,
  };
}

String levelLabel(ActivityDefinition activity) {
  return 'Level ${activity.variant + 1}';
}

/// Short bar title. Long quiz prompts stay in the question card, not here.
String activityHeaderTitle(ActivityDefinition activity) {
  if (activity.category == GameCategory.knowledge ||
      activity.title.length > 34) {
    return '${gameKindLabel(activity.category)} · ${levelLabel(activity)}';
  }
  return activity.title;
}

bool containsDevanagari(String value) {
  return value.runes.any((code) => code >= 0x0900 && code <= 0x097F);
}
