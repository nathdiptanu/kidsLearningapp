import '../models/age_band.dart';
import '../models/content_pack.dart';
import '../models/game_category.dart';
import '../models/readiness.dart';
import '../monetization/monetization_config.dart';
import '../regional/learning_preferences.dart';
import '../regional/regional_availability.dart';

/// How a letter or mark is taught. Conjuncts are never stored as
/// ordinary consonants.
enum ConceptType { vowel, consonant, matra, nasal, conjunct, letter, word }

enum LessonMode { listen, find, match, trace, build, review }

enum AudioKind { letterName, letterSound, word, phrase, explanation }

enum SpeechFallbackKind { none, explanationOnly }

class LessonToken {
  const LessonToken({
    required this.id,
    required this.text,
    required this.concept,
  });

  final String id;
  final String text;
  final ConceptType concept;
}

class StrokePoint {
  const StrokePoint(this.x, this.y);

  final double x;
  final double y;
}

class StrokePath {
  const StrokePath(this.points);

  final List<StrokePoint> points;
}

class StrokeTemplate {
  const StrokeTemplate({
    required this.id,
    required this.glyph,
    required this.strokes,
    required this.reviewStatus,
    this.shirorekhaStrokeIndex,
    this.sourceNote = 'Pedagogical polyline for development. Not a font outline and not an approved stroke-order curriculum.',
  });

  final String id;
  final String glyph;
  final List<StrokePath> strokes;
  final ReviewStatus reviewStatus;
  final int? shirorekhaStrokeIndex;
  final String sourceNote;

  bool get releaseReady => reviewStatus == ReviewStatus.approved;
}

class NarrationClip {
  const NarrationClip({
    required this.id,
    required this.kind,
    required this.reviewStatus,
    this.assetPath,
    this.accent,
    this.note,
  });

  final String id;
  final AudioKind kind;
  final ReviewStatus reviewStatus;
  final String? assetPath;
  final String? accent;
  final String? note;

  bool get hasReviewedFile =>
      reviewStatus == ReviewStatus.approved &&
      assetPath != null &&
      assetPath!.isNotEmpty;
}

class LessonRecord {
  const LessonRecord({
    required this.id,
    required this.packId,
    required this.packVersion,
    required this.mode,
    required this.category,
    required this.title,
    required this.prompt,
    required this.displayText,
    required this.ageBands,
    required this.reviewStatus,
    required this.rightsStatus,
    this.region,
    this.module,
    this.concept,
    this.pictureId,
    this.meaning,
    this.phrase,
    this.bilingualNote,
    this.tokens = const [],
    this.bankTokenIds = const [],
    this.correctTokenIds = const [],
    this.options = const [],
    this.correctOptionIds = const [],
    this.narrationIds = const [],
    this.wordAudioId,
    this.strokeTemplateId,
    this.sources = const [],
  });

  final String id;
  final String packId;
  final int packVersion;
  final LessonMode mode;
  final GameCategory category;
  final String title;
  final String prompt;
  final String displayText;
  final List<AgeBand> ageBands;
  final ReviewStatus reviewStatus;
  final String rightsStatus;
  final LearningRegion? region;
  final RegionalModule? module;
  final ConceptType? concept;
  final String? pictureId;
  final String? meaning;
  final String? phrase;
  final String? bilingualNote;
  final List<LessonToken> tokens;
  final List<String> bankTokenIds;
  final List<String> correctTokenIds;
  final List<LessonChoice> options;
  final List<String> correctOptionIds;
  final List<String> narrationIds;
  final String? wordAudioId;
  final String? strokeTemplateId;
  final List<String> sources;

  bool get releaseReady =>
      reviewStatus == ReviewStatus.approved && rightsStatus == 'cleared';

  bool offeredFor(AgeBand band, Readiness readiness) {
    if (!ageBands.contains(band)) {
      return false;
    }
    if (readiness == Readiness.gentle &&
        (mode == LessonMode.build || mode == LessonMode.trace) &&
        band == AgeBand.a) {
      return mode == LessonMode.trace;
    }
    return true;
  }
}

class LessonChoice {
  const LessonChoice({required this.id, required this.label, this.pictureId});

  final String id;
  final String label;
  final String? pictureId;
}

class LanguagePack {
  const LanguagePack({
    required this.packId,
    required this.schemaVersion,
    required this.contentVersion,
    required this.reviewStatus,
    required this.lessons,
    required this.tokens,
    required this.templates,
    required this.clips,
    required this.words,
  });

  final String packId;
  final int schemaVersion;
  final int contentVersion;
  final ReviewStatus reviewStatus;
  final List<LessonRecord> lessons;
  final Map<String, LessonToken> tokens;
  final Map<String, StrokeTemplate> templates;
  final Map<String, NarrationClip> clips;
  final Map<String, CuratedWord> words;
}

class CuratedWord {
  const CuratedWord({
    required this.id,
    required this.text,
    required this.tokenIds,
    required this.pictureId,
    required this.meaning,
    required this.reviewStatus,
    this.wordAudioId,
    this.bilingualNote,
    this.phrase,
  });

  final String id;
  final String text;
  final List<String> tokenIds;
  final String pictureId;
  final String meaning;
  final ReviewStatus reviewStatus;
  final String? wordAudioId;
  final String? bilingualNote;
  final String? phrase;
}

/// Draft records load in debug and tests only. Release packs stay empty
/// until a reviewer marks both the lesson and its media approved.
/// An unlocked sideload (`UNLOCK_ALL_GAMES`) also loads the drafts.
bool includeDevelopmentSamples() {
  if (MonetizationConfig.unlockAllGames) {
    return true;
  }
  var include = false;
  assert(() {
    include = true;
    return true;
  }());
  return include;
}
