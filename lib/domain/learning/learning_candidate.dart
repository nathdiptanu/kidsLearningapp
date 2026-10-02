import '../games/play/activity_definition.dart';
import '../models/age_band.dart';
import '../models/game_category.dart';
import '../models/readiness.dart';
import 'item_progress.dart';

class LearningCandidate {
  const LearningCandidate({
    required this.activity,
    required this.itemId,
    required this.mode,
    required this.introduces,
    required this.family,
    this.requiresItemIds = const {},
  });

  final ActivityDefinition activity;
  final String itemId;
  final PracticeMode mode;
  final bool introduces;
  final String family;
  final Set<String> requiresItemIds;

  GameCategory get category => activity.category;

  bool offeredFor(AgeBand band, Readiness readiness) {
    return activity.band == band || activity.band.index <= band.index;
  }
}

class CatalogueCensus {
  const CatalogueCensus({
    required this.reviewedItems,
    required this.draftItems,
    required this.activityTemplates,
    required this.generatedVariants,
    required this.playableActivities,
  });

  /// Unique letters, words, places or sites marked approved.
  final int reviewedItems;

  /// Unique letters, words, places or sites still in development packs.
  final int draftItems;

  /// Shared templates (stroke paths, map geometry, drawings).
  final int activityTemplates;

  /// Existing generated game slots. Not Hindi/Discover India copies.
  final int generatedVariants;

  /// Distinct activity ids currently offered (draft or reviewed).
  final int playableActivities;
}
