import '../games/play/activity_definition.dart';
import '../models/age_band.dart';
import '../models/content_pack.dart';
import '../models/game_category.dart';
import '../models/readiness.dart';
import '../regional/regional_availability.dart';
import '../lessons/lesson_models.dart';
import '../settings/local_settings.dart';
import 'heritage_engine.dart';
import 'heritage_models.dart';
import 'heritage_pack.dart';

class HeritageCatalog {
  HeritageCatalog({HeritagePack? pack})
    : pack =
          pack ??
          (includeDevelopmentSamples()
              ? developmentHeritagePack()
              : emptyHeritagePack());

  final HeritagePack pack;

  HeritageActivity? byId(String id) {
    for (final activity in pack.activities) {
      if (activity.id == id) {
        return activity;
      }
    }
    return null;
  }

  HeritageSite? site(String? id) {
    if (id == null) {
      return null;
    }
    return pack.sites[id];
  }

  List<HeritageActivity> visible({
    required LocalSettings settings,
    required AgeBand band,
    Readiness readiness = Readiness.steady,
    required bool includeDrafts,
    Set<String> introducedSiteIds = const {},
    Set<String> introducedStoryIds = const {},
  }) {
    if (!RegionalAvailability.isAvailable(
      settings,
      RegionalModule.discoverIndia,
    )) {
      return const [];
    }
    return [
      for (final activity in pack.activities)
        if (_allowed(activity, includeDrafts) &&
            activity.offeredFor(band, readiness) &&
            _prereq(activity, introducedSiteIds, introducedStoryIds))
          activity,
    ];
  }

  ActivityDefinition definition(HeritageActivity activity, AgeBand band) {
    return ActivityDefinition(
      id: activity.id,
      category: GameCategory.discoverIndia,
      band: band,
      variant: activity.id.hashCode.abs() % 50,
      seed: activity.id.hashCode.abs() % 100000,
      title: activity.title,
      questionCount: 1,
    );
  }

  ActivityDefinition? definitionById(String id, AgeBand band) {
    final activity = byId(id);
    if (activity == null) {
      return null;
    }
    return definition(activity, band);
  }

  bool _allowed(HeritageActivity activity, bool includeDrafts) {
    if (activity.releaseReady) {
      return true;
    }
    return includeDrafts && activity.reviewStatus != ReviewStatus.rejected;
  }

  bool _prereq(
    HeritageActivity activity,
    Set<String> identified,
    Set<String> stories,
  ) {
    return switch (activity.mode) {
      HeritageMode.identify || HeritageMode.match || HeritageMode.story => true,
      HeritageMode.locate =>
        activity.siteId != null && identified.contains(activity.siteId),
      HeritageMode.recall => stories.isNotEmpty,
    };
  }
}

Set<String> identifiedHeritageFrom(Iterable<String> completedActivityIds) {
  return IntroducedHeritage.identifiedFrom(completedActivityIds);
}

Set<String> heritageStoriesFrom(Iterable<String> completedActivityIds) {
  return IntroducedHeritage.storiesFrom(completedActivityIds);
}
