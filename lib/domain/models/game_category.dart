/// The six original engines, plus knowledge questions on the choice engine
/// and local Tic-Tac-Toe. Tic-Tac-Toe is not part of the daily five.
enum GameCategory {
  maze('maze'),
  findDifference('find_difference'),
  maths('maths'),
  vocabulary('vocabulary'),
  pattern('pattern'),
  matching('matching'),
  knowledge('knowledge'),
  ticTacToe('tic_tac_toe'),
  hindi('hindi'),
  discoverIndia('discover_india');

  /// Milestone "every game" still means these six engines.
  static const originalEngines = <GameCategory>[
    GameCategory.maze,
    GameCategory.findDifference,
    GameCategory.maths,
    GameCategory.vocabulary,
    GameCategory.pattern,
    GameCategory.matching,
  ];

  const GameCategory(this.storageKey);

  final String storageKey;

  static GameCategory? fromStorage(String key) {
    for (final category in GameCategory.values) {
      if (category.storageKey == key) {
        return category;
      }
    }
    return null;
  }
}

enum SkillArea {
  maths('maths'),
  english('english'),
  logic('logic'),
  observation('observation'),
  knowledge('knowledge');

  const SkillArea(this.storageKey);

  final String storageKey;

  static SkillArea? fromStorage(String key) {
    for (final skill in SkillArea.values) {
      if (skill.storageKey == key) {
        return skill;
      }
    }
    return null;
  }
}
