import 'dart:ui';

import '../lessons/lesson_models.dart';
import '../models/age_band.dart';
import '../models/content_pack.dart';
import '../models/readiness.dart';

enum AdminType { state, unionTerritory }

enum GeographyMode { explore, learn, matchName, matchLocation, capital, review }

enum CapitalRole { sole, summer, winter, second }

class SourcedFact {
  const SourcedFact({
    required this.id,
    required this.text,
    required this.sourceName,
    required this.sourceUrl,
    required this.verifiedAt,
    required this.reviewStatus,
  });

  final String id;
  final String text;
  final String sourceName;
  final String sourceUrl;
  final String verifiedAt;
  final ReviewStatus reviewStatus;

  bool get releaseReady => reviewStatus == ReviewStatus.approved;
}

class CapitalSeat {
  const CapitalSeat({
    required this.name,
    required this.role,
    required this.sourceName,
    required this.sourceUrl,
    required this.verifiedAt,
    required this.reviewStatus,
    this.hindiName,
  });

  final String name;
  final CapitalRole role;
  final String sourceName;
  final String sourceUrl;
  final String verifiedAt;
  final ReviewStatus reviewStatus;
  final String? hindiName;

  bool get isSeasonal =>
      role == CapitalRole.summer || role == CapitalRole.winter;
}

class PlaceRecord {
  const PlaceRecord({
    required this.id,
    required this.name,
    required this.adminType,
    required this.geometryId,
    required this.fact,
    required this.reviewStatus,
    required this.rightsStatus,
    required this.sources,
    this.hindiName,
    this.capitals = const [],
    this.narrationId,
    this.smallTarget = false,
  });

  final String id;
  final String name;
  final String? hindiName;
  final AdminType adminType;
  final String geometryId;
  final SourcedFact fact;
  final List<CapitalSeat> capitals;
  final ReviewStatus reviewStatus;
  final String rightsStatus;
  final List<String> sources;
  final String? narrationId;
  final bool smallTarget;

  String get typeLabel =>
      adminType == AdminType.state ? 'State' : 'Union territory';

  bool get hasSeasonalOrMultipleCapitals {
    if (capitals.length != 1) {
      return capitals.length > 1;
    }
    return capitals.first.role != CapitalRole.sole;
  }

  bool get allowsSingleAnswerCapital {
    return capitals.length == 1 &&
        capitals.first.role == CapitalRole.sole &&
        capitals.first.reviewStatus != ReviewStatus.rejected &&
        capitals.first.name != name;
  }

  String? get soleCapitalName =>
      allowsSingleAnswerCapital ? capitals.first.name : null;

  bool get releaseReady =>
      reviewStatus == ReviewStatus.approved &&
      rightsStatus == 'cleared' &&
      fact.releaseReady;
}

class GeographyActivity {
  const GeographyActivity({
    required this.id,
    required this.mode,
    required this.title,
    required this.prompt,
    required this.ageBands,
    required this.reviewStatus,
    this.placeId,
    this.narrationId,
  });

  final String id;
  final GeographyMode mode;
  final String title;
  final String prompt;
  final List<AgeBand> ageBands;
  final ReviewStatus reviewStatus;
  final String? placeId;
  final String? narrationId;

  bool offeredFor(AgeBand band, Readiness readiness) {
    if (!ageBands.contains(band)) {
      return false;
    }
    if (mode == GeographyMode.capital &&
        band == AgeBand.c &&
        readiness == Readiness.gentle) {
      return false;
    }
    return true;
  }

  bool get releaseReady => reviewStatus == ReviewStatus.approved;
}

class GeographyPack {
  const GeographyPack({
    required this.packId,
    required this.schemaVersion,
    required this.contentVersion,
    required this.reviewStatus,
    required this.places,
    required this.activities,
    required this.clips,
  });

  final String packId;
  final int schemaVersion;
  final int contentVersion;
  final ReviewStatus reviewStatus;
  final Map<String, PlaceRecord> places;
  final List<GeographyActivity> activities;
  final Map<String, NarrationClip> clips;
}

class MapRing {
  const MapRing(this.points);

  final List<OffsetPoint> points;
}

class OffsetPoint {
  const OffsetPoint(this.x, this.y);

  final double x;
  final double y;
}

class RegionOutline {
  const RegionOutline({
    required this.id,
    required this.name,
    required this.rings,
    required this.centroid,
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
    required this.smallTarget,
  });

  final String id;
  final String name;
  final List<MapRing> rings;
  final OffsetPoint centroid;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;
  final bool smallTarget;

  double get width => maxX - minX;
  double get height => maxY - minY;
}

class IndiaMapAtlas {
  const IndiaMapAtlas({
    required this.packId,
    required this.sourceName,
    required this.sourceUrl,
    required this.license,
    required this.retrievedAt,
    required this.modifications,
    required this.reviewStatus,
    required this.country,
    required this.regions,
    this.contentBounds = const Rect.fromLTWH(0, 0, 1, 1),
  });

  final String packId;
  final String sourceName;
  final String sourceUrl;
  final String license;
  final String retrievedAt;
  final String modifications;
  final ReviewStatus reviewStatus;
  final List<MapRing> country;
  final List<RegionOutline> regions;

  /// Inclusive bounds of every stored ring, including islands past 0–1.
  final Rect contentBounds;

  RegionOutline? byId(String id) {
    for (final region in regions) {
      if (region.id == id) {
        return region;
      }
    }
    return null;
  }
}
