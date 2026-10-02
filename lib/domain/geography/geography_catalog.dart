import '../games/play/activity_definition.dart';
import '../models/age_band.dart';
import '../models/content_pack.dart';
import '../models/game_category.dart';
import '../models/readiness.dart';
import '../regional/regional_availability.dart';
import '../lessons/lesson_models.dart';
import '../settings/local_settings.dart';
import 'geography_models.dart';
import 'geography_pack.dart';
import 'question_engine.dart';

class GeographyCatalog {
  GeographyCatalog({GeographyPack? pack})
    : pack = pack ??
          (includeDevelopmentSamples()
              ? developmentGeographyPack()
              : emptyGeographyPack());

  final GeographyPack pack;

  GeographyActivity? byId(String id) {
    for (final activity in pack.activities) {
      if (activity.id == id) {
        return activity;
      }
    }
    return null;
  }

  PlaceRecord? place(String? id) {
    if (id == null) {
      return null;
    }
    return pack.places[id];
  }

  List<GeographyActivity> visible({
    required LocalSettings settings,
    required AgeBand band,
    Readiness readiness = Readiness.steady,
    required bool includeDrafts,
    Set<String> introducedPlaceIds = const {},
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
            _prereq(activity, introducedPlaceIds))
          activity,
    ];
  }

  ActivityDefinition definition(GeographyActivity activity, AgeBand band) {
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

  bool _allowed(GeographyActivity activity, bool includeDrafts) {
    if (activity.releaseReady) {
      return true;
    }
    return includeDrafts && activity.reviewStatus != ReviewStatus.rejected;
  }

  bool _prereq(GeographyActivity activity, Set<String> introduced) {
    return switch (activity.mode) {
      GeographyMode.explore || GeographyMode.learn => true,
      GeographyMode.matchName ||
      GeographyMode.matchLocation ||
      GeographyMode.capital =>
        activity.placeId != null && introduced.contains(activity.placeId),
      GeographyMode.review => introduced.isNotEmpty,
    };
  }
}

Set<String> introducedPlacesFrom(Iterable<String> completedActivityIds) {
  return IntroducedPlaces.fromActivityIds(completedActivityIds);
}
