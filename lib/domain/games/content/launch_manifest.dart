import '../../models/game_category.dart';
import '../play/activity_catalog.dart';
import '../play/activity_definition.dart';
import '../play/activity_skill.dart';

class LaunchEntry {
  const LaunchEntry({
    required this.id,
    required this.section,
    required this.skill,
    required this.engine,
    required this.band,
    required this.difficulty,
    required this.packVersion,
    required this.seed,
    required this.generatorVersion,
    required this.reviewStatus,
    required this.countsTowardLibrary,
  });

  final String id;
  final String section;
  final String skill;
  final String engine;
  final String band;
  final int difficulty;
  final String packVersion;
  final int seed;
  final String generatorVersion;
  final String reviewStatus;
  final bool countsTowardLibrary;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'section': section,
      'skill': skill,
      'engine': engine,
      'band': band,
      'difficulty': difficulty,
      'packVersion': packVersion,
      'seed': seed,
      'generatorVersion': generatorVersion,
      'reviewStatus': reviewStatus,
      'countsTowardLibrary': countsTowardLibrary,
    };
  }
}

const launchPackVersion = 'bundled_core@2';

class LaunchManifest {
  const LaunchManifest({this.catalog = const ActivityCatalog()});

  final ActivityCatalog catalog;

  List<LaunchEntry> entries() {
    return [for (final activity in catalog.all()) _entry(activity)];
  }

  Map<String, int> libraryCountsBySection() {
    final counts = <String, int>{};
    for (final entry in entries()) {
      if (!entry.countsTowardLibrary) {
        continue;
      }
      counts[entry.section] = (counts[entry.section] ?? 0) + 1;
    }
    return counts;
  }

  LaunchEntry _entry(ActivityDefinition activity) {
    final category = activity.category;
    return LaunchEntry(
      id: activity.id,
      section: learningSectionFor(category),
      skill: skillForCategory(category),
      engine: category.storageKey,
      band: activity.band.storageKey,
      difficulty: activity.band.learningRank,
      packVersion: launchPackVersion,
      seed: activity.seed,
      generatorVersion: _version(category),
      reviewStatus: _review(category),
      countsTowardLibrary: category != GameCategory.ticTacToe,
    );
  }

  String _version(GameCategory category) {
    return switch (category) {
      GameCategory.maths => 'maths:v1',
      GameCategory.pattern => 'pattern:v1',
      GameCategory.matching => 'matching:v1',
      GameCategory.vocabulary => 'vocabulary:v1',
      GameCategory.maze => 'maze:v1',
      GameCategory.findDifference => 'find_difference:v1',
      GameCategory.findObjects => 'find_objects:v1',
      GameCategory.connectDots => 'connect_dots:v1',
      GameCategory.knowledge => 'knowledge:v1',
      GameCategory.ticTacToe => 'tic_tac_toe:v1',
      GameCategory.hindi => 'hindi:v1',
      GameCategory.discoverIndia => 'discover_india:v1',
    };
  }

  String _review(GameCategory category) {
    return switch (category) {
      GameCategory.findDifference ||
      GameCategory.findObjects => 'placeholder_artwork',
      GameCategory.knowledge => 'authored_structure_checked',
      GameCategory.ticTacToe => 'rules_checked',
      GameCategory.hindi => 'development_sample',
      GameCategory.discoverIndia => 'development_sample',
      _ => 'generator_validated',
    };
  }
}
