import '../games/play/activity_catalog.dart';
import '../games/play/activity_definition.dart';
import '../geography/geography_catalog.dart';
import '../geography/geography_models.dart';
import '../heritage/heritage_catalog.dart';
import '../heritage/heritage_models.dart';
import '../lessons/lesson_catalog.dart';
import '../lessons/lesson_models.dart';
import '../models/age_band.dart';
import '../models/content_pack.dart';
import '../models/game_category.dart';
import '../models/readiness.dart';
import '../regional/regional_availability.dart';
import '../settings/local_settings.dart';
import 'item_progress.dart';
import 'learning_candidate.dart';
import 'learning_ids.dart';

/// Maps every regional activity to a stable item id and a practice mode.
class LearningIndex {
  LearningIndex({
    LessonCatalog? lessons,
    GeographyCatalog? geography,
    HeritageCatalog? heritage,
  }) : lessons = lessons ?? LessonCatalog(),
       geography = geography ?? GeographyCatalog(),
       heritage = heritage ?? HeritageCatalog();

  final LessonCatalog lessons;
  final GeographyCatalog geography;
  final HeritageCatalog heritage;

  LearningCandidate? candidate(String activityId, AgeBand band) {
    final lesson = lessons.byId(activityId);
    if (lesson != null) {
      return _lesson(lesson, band);
    }
    final place = geography.byId(activityId);
    if (place != null) {
      return _geo(place, band);
    }
    final site = heritage.byId(activityId);
    if (site != null) {
      return _heritage(site, band);
    }
    return null;
  }

  List<LearningCandidate> visible({
    required LocalSettings settings,
    required AgeBand band,
    Readiness readiness = Readiness.steady,
    required bool includeDrafts,
    required Set<String> introducedItemIds,
  }) {
    final out = <LearningCandidate>[];
    for (final lesson in lessons.visible(
      settings: settings,
      band: band,
      readiness: readiness,
      includeDrafts: includeDrafts,
    )) {
      final item = _lesson(lesson, band);
      if (_ready(item, introducedItemIds)) {
        out.add(item);
      }
    }
    if (RegionalAvailability.isAvailable(
      settings,
      RegionalModule.discoverIndia,
    )) {
      for (final activity in geography.visible(
        settings: settings,
        band: band,
        readiness: readiness,
        includeDrafts: includeDrafts,
        introducedPlaceIds: {
          for (final id in introducedItemIds)
            if (id.startsWith('in-')) id,
        },
      )) {
        final item = _geo(activity, band);
        if (_ready(item, introducedItemIds)) {
          out.add(item);
        }
      }
      final identified = {
        for (final id in introducedItemIds)
          if (id.startsWith('site-')) id,
      };
      for (final activity in heritage.visible(
        settings: settings,
        band: band,
        readiness: readiness,
        includeDrafts: includeDrafts,
        introducedSiteIds: identified,
        introducedStoryIds: identified,
      )) {
        final item = _heritage(activity, band);
        if (_ready(item, introducedItemIds)) {
          out.add(item);
        }
      }
    }
    return out;
  }

  CatalogueCensus census({required bool includeDrafts}) {
    final itemReview = <String, bool>{};
    var templates = 0;
    var playable = 0;
    for (final lesson in lessons.pack.lessons) {
      if (!includeDrafts && !lesson.releaseReady) {
        continue;
      }
      playable += 1;
      itemReview[itemIdForLesson(lesson)] = lesson.releaseReady;
    }
    templates += lessons.pack.templates.length;
    for (final place in geography.pack.places.values) {
      itemReview[place.id] =
          place.reviewStatus == ReviewStatus.approved &&
          place.rightsStatus == 'cleared';
    }
    for (final activity in geography.pack.activities) {
      if (includeDrafts || activity.releaseReady) {
        playable += 1;
      }
    }
    templates += 1;
    for (final site in heritage.pack.sites.values) {
      itemReview[site.id] = site.releaseReady;
    }
    for (final activity in heritage.pack.activities) {
      if (includeDrafts || activity.releaseReady) {
        playable += 1;
      }
    }
    templates += heritage.pack.sites.length;
    var reviewed = 0;
    var draft = 0;
    for (final ready in itemReview.values) {
      if (ready) {
        reviewed += 1;
      } else {
        draft += 1;
      }
    }
    var generated = 0;
    for (final category in GameCategory.values) {
      if (category == GameCategory.hindi ||
          category == GameCategory.discoverIndia) {
        continue;
      }
      for (final band in AgeBand.values) {
        generated += const ActivityCatalog().forBand(category, band).length;
      }
    }
    return CatalogueCensus(
      reviewedItems: reviewed,
      draftItems: draft,
      activityTemplates: templates,
      generatedVariants: generated,
      playableActivities: playable,
    );
  }

  LearningCandidate _lesson(LessonRecord lesson, AgeBand band) {
    final itemId = itemIdForLesson(lesson);
    return LearningCandidate(
      activity: lessons.definition(lesson, band),
      itemId: itemId,
      mode: practiceModeForLesson(lesson.mode),
      introduces: lessonIntroduces(lesson.mode),
      family: lesson.module == RegionalModule.hindi ? 'hindi' : 'english',
      requiresItemIds: lessonIntroduces(lesson.mode) ? const {} : {itemId},
    );
  }

  LearningCandidate _geo(GeographyActivity activity, AgeBand band) {
    final itemId = activity.placeId ?? 'india-map';
    final mode = switch (activity.mode) {
      GeographyMode.explore ||
      GeographyMode.learn ||
      GeographyMode.matchName => PracticeMode.recognize,
      GeographyMode.matchLocation => PracticeMode.locate,
      GeographyMode.capital || GeographyMode.review => PracticeMode.recall,
    };
    final introduces =
        activity.mode == GeographyMode.learn ||
        activity.mode == GeographyMode.explore;
    return LearningCandidate(
      activity: geography.definition(activity, band),
      itemId: itemId,
      mode: mode,
      introduces: introduces,
      family: 'geography',
      requiresItemIds: introduces || activity.placeId == null
          ? const {}
          : {activity.placeId!},
    );
  }

  LearningCandidate _heritage(HeritageActivity activity, AgeBand band) {
    final itemId = activity.siteId ?? 'heritage-review';
    final mode = switch (activity.mode) {
      HeritageMode.identify || HeritageMode.match => PracticeMode.recognize,
      HeritageMode.story => PracticeMode.listen,
      HeritageMode.locate => PracticeMode.locate,
      HeritageMode.recall => PracticeMode.recall,
    };
    final introduces =
        activity.mode == HeritageMode.identify ||
        activity.mode == HeritageMode.story;
    return LearningCandidate(
      activity: heritage.definition(activity, band),
      itemId: itemId,
      mode: mode,
      introduces: introduces,
      family: 'heritage',
      requiresItemIds: activity.mode == HeritageMode.recall
          ? const {}
          : activity.mode == HeritageMode.locate && activity.siteId != null
          ? {activity.siteId!}
          : const {},
    );
  }

  bool _ready(LearningCandidate item, Set<String> introduced) {
    if (item.requiresItemIds.isEmpty) {
      return true;
    }
    return item.requiresItemIds.every(introduced.contains);
  }
}

ActivityDefinition? definitionForRegional(String id, AgeBand band) {
  return LessonCatalog().definitionById(id, band) ??
      GeographyCatalog().definitionById(id, band) ??
      HeritageCatalog().definitionById(id, band);
}
