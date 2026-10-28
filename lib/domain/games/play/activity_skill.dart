import '../../models/game_category.dart';

String skillForCategory(GameCategory category) {
  return switch (category) {
    GameCategory.maths => 'maths',
    GameCategory.vocabulary => 'english',
    GameCategory.pattern || GameCategory.maze => 'logic',
    GameCategory.matching ||
    GameCategory.findDifference ||
    GameCategory.findObjects ||
    GameCategory.connectDots => 'observation',
    GameCategory.knowledge => 'knowledge',
    GameCategory.ticTacToe => 'tic_tac_toe',
    GameCategory.hindi => 'hindi',
    GameCategory.discoverIndia => 'discover_india',
  };
}

/// Learning-library section. Tic-Tac-Toe is kept out of those totals.
String learningSectionFor(GameCategory category) {
  return switch (category) {
    GameCategory.maths => 'maths',
    GameCategory.vocabulary => 'english',
    GameCategory.pattern || GameCategory.maze => 'logic',
    GameCategory.matching ||
    GameCategory.findDifference ||
    GameCategory.findObjects ||
    GameCategory.connectDots => 'observation',
    GameCategory.knowledge => 'knowledge',
    GameCategory.ticTacToe => 'tic_tac_toe',
    GameCategory.hindi => 'hindi',
    GameCategory.discoverIndia => 'discover_india',
  };
}
