import '../models/content_pack.dart';
import 'geography_models.dart';

class GeographyPackValidator {
  const GeographyPackValidator();

  List<String> validate(
    GeographyPack pack,
    IndiaMapAtlas atlas, {
    required bool release,
  }) {
    final issues = <String>[];
    final ids = <String>{};
    for (final place in pack.places.values) {
      if (!ids.add(place.id)) {
        issues.add('duplicate place ${place.id}');
      }
      if (place.fact.text.trim().isEmpty) {
        issues.add('${place.id} missing fact');
      }
      if (place.fact.sourceUrl.trim().isEmpty ||
          place.fact.verifiedAt.trim().isEmpty) {
        issues.add('${place.id} fact needs a source and verification date');
      }
      if (atlas.byId(place.geometryId) == null) {
        issues.add('${place.id} missing geometry ${place.geometryId}');
      }
      if (place.hasSeasonalOrMultipleCapitals &&
          pack.activities.any(
            (activity) =>
                activity.mode == GeographyMode.capital &&
                activity.placeId == place.id,
          )) {
        issues.add(
          '${place.id} has a seasonal or multiple capital and cannot be a single-answer question',
        );
      }
      if (place.adminType == AdminType.unionTerritory &&
          place.capitals.any((seat) => seat.name == place.name) &&
          pack.activities.any(
            (activity) =>
                activity.mode == GeographyMode.capital &&
                activity.placeId == place.id,
          )) {
        issues.add(
          '${place.id} capital name matches the territory and is too ambiguous for a single answer',
        );
      }
      if (release && !place.releaseReady) {
        issues.add('${place.id} is not approved for release');
      }
    }
    for (final activity in pack.activities) {
      if (activity.placeId != null && pack.places[activity.placeId] == null) {
        issues.add('${activity.id} points at an unknown place');
      }
      if (activity.mode == GeographyMode.capital) {
        final place = pack.places[activity.placeId];
        if (place == null || !place.allowsSingleAnswerCapital) {
          issues.add('${activity.id} is not an unambiguous capital question');
        }
      }
      if (activity.mode == GeographyMode.review) {
        final learnIds = {
          for (final item in pack.activities)
            if (item.mode == GeographyMode.learn && item.placeId != null)
              item.placeId,
        };
        if (learnIds.isEmpty) {
          issues.add('${activity.id} has no introduced content to review');
        }
      }
      if (release && !activity.releaseReady) {
        issues.add('${activity.id} is not approved for release');
      }
    }
    if (release && pack.reviewStatus != ReviewStatus.approved) {
      issues.add('pack ${pack.packId} is not approved for release');
    }
    if (release && atlas.reviewStatus != ReviewStatus.approved) {
      issues.add('map geometry is not approved for release');
    }
    return issues;
  }

  List<GeographyActivity> playable(
    GeographyPack pack, {
    required bool release,
  }) {
    if (release) {
      return [
        for (final activity in pack.activities)
          if (activity.releaseReady) activity,
      ];
    }
    return pack.activities;
  }
}
