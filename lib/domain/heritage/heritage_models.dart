import '../lessons/lesson_models.dart';
import '../models/age_band.dart';
import '../models/content_pack.dart';
import '../models/readiness.dart';

enum HeritageMode { identify, match, locate, story, recall }

enum HeritageStatementKind { history, legend }

class HeritageStatement {
  const HeritageStatement({
    required this.kind,
    required this.text,
    required this.sourceName,
    required this.sourceUrl,
    required this.verifiedAt,
    required this.reviewStatus,
  });

  final HeritageStatementKind kind;
  final String text;
  final String sourceName;
  final String sourceUrl;
  final String verifiedAt;
  final ReviewStatus reviewStatus;

  String get kindLabel => switch (kind) {
    HeritageStatementKind.history => 'History',
    HeritageStatementKind.legend => 'A traditional story',
  };
}

class HeritageSite {
  const HeritageSite({
    required this.id,
    required this.name,
    required this.pictureId,
    required this.locationLabel,
    required this.regionHint,
    required this.mapRegionId,
    required this.fact,
    required this.story,
    required this.reviewStatus,
    required this.rightsStatus,
    required this.sources,
    this.hindiName,
    this.narrationId,
  });

  final String id;
  final String name;
  final String? hindiName;
  final String pictureId;
  final String locationLabel;
  final String regionHint;
  final String mapRegionId;
  final HeritageStatement fact;
  final List<HeritageStatement> story;
  final ReviewStatus reviewStatus;
  final String rightsStatus;
  final List<String> sources;
  final String? narrationId;

  bool get releaseReady =>
      reviewStatus == ReviewStatus.approved &&
      rightsStatus == 'cleared' &&
      fact.reviewStatus == ReviewStatus.approved &&
      story.every((line) => line.reviewStatus == ReviewStatus.approved);
}

class HeritageActivity {
  const HeritageActivity({
    required this.id,
    required this.mode,
    required this.title,
    required this.prompt,
    required this.ageBands,
    required this.reviewStatus,
    this.siteId,
    this.narrationId,
  });

  final String id;
  final HeritageMode mode;
  final String title;
  final String prompt;
  final List<AgeBand> ageBands;
  final ReviewStatus reviewStatus;
  final String? siteId;
  final String? narrationId;

  bool offeredFor(AgeBand band, Readiness readiness) {
    if (!ageBands.contains(band)) {
      return false;
    }
    if (mode == HeritageMode.story &&
        band == AgeBand.c &&
        readiness == Readiness.gentle) {
      return false;
    }
    return true;
  }

  bool get releaseReady => reviewStatus == ReviewStatus.approved;
}

class HeritageChoice {
  const HeritageChoice({required this.id, required this.label, this.pictureId});

  final String id;
  final String label;
  final String? pictureId;
}

class HeritageQuestion {
  const HeritageQuestion({
    required this.prompt,
    required this.correctId,
    required this.choices,
    this.siteId,
  });

  final String prompt;
  final String correctId;
  final List<HeritageChoice> choices;
  final String? siteId;
}

class HeritagePack {
  const HeritagePack({
    required this.packId,
    required this.schemaVersion,
    required this.contentVersion,
    required this.reviewStatus,
    required this.sites,
    required this.activities,
    required this.clips,
  });

  final String packId;
  final int schemaVersion;
  final int contentVersion;
  final ReviewStatus reviewStatus;
  final Map<String, HeritageSite> sites;
  final List<HeritageActivity> activities;
  final Map<String, NarrationClip> clips;
}

class CreditRecord {
  const CreditRecord({
    required this.id,
    required this.title,
    required this.detail,
    required this.reviewStatus,
    this.creator,
    this.license,
    this.sourceUrl,
    this.attribution,
    this.modifications,
    this.localFile,
  });

  final String id;
  final String title;
  final String detail;
  final ReviewStatus reviewStatus;
  final String? creator;
  final String? license;
  final String? sourceUrl;
  final String? attribution;
  final String? modifications;
  final String? localFile;
}
