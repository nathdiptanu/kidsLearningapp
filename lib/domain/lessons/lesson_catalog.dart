import '../models/age_band.dart';
import '../models/content_pack.dart';
import '../models/game_category.dart';
import '../models/readiness.dart';
import '../regional/regional_availability.dart';
import '../settings/local_settings.dart';
import '../games/play/activity_definition.dart';
import 'development_pack.dart';
import 'lesson_models.dart';

class LessonCatalog {
  LessonCatalog({LanguagePack? pack})
    : pack =
          pack ??
          (includeDevelopmentSamples()
              ? developmentLanguagePack()
              : emptyLanguagePack());

  final LanguagePack pack;

  LessonRecord? byId(String id) {
    for (final lesson in pack.lessons) {
      if (lesson.id == id) {
        return lesson;
      }
    }
    return null;
  }

  StrokeTemplate? templateFor(LessonRecord lesson) {
    final id = lesson.strokeTemplateId;
    if (id == null) {
      return null;
    }
    return pack.templates[id];
  }

  CuratedWord? wordFor(LessonRecord lesson) {
    for (final word in pack.words.values) {
      if (word.text == lesson.displayText ||
          word.wordAudioId == lesson.wordAudioId) {
        if (word.id.contains(lesson.displayText.toLowerCase()) ||
            lesson.displayText == word.text) {
          return word;
        }
      }
    }
    for (final word in pack.words.values) {
      if (word.text == lesson.displayText) {
        return word;
      }
    }
    return null;
  }

  NarrationClip? clip(String id) => pack.clips[id];

  LessonToken? token(String id) => pack.tokens[id];

  List<LessonRecord> visible({
    required LocalSettings settings,
    required AgeBand band,
    Readiness readiness = Readiness.steady,
    required bool includeDrafts,
  }) {
    return [
      for (final lesson in pack.lessons)
        if (_allowed(lesson, settings, includeDrafts) &&
            lesson.offeredFor(band, readiness))
          lesson,
    ];
  }

  List<LessonRecord> forModule({
    required RegionalModule module,
    required LocalSettings settings,
    required AgeBand band,
    Readiness readiness = Readiness.steady,
    required bool includeDrafts,
  }) {
    return [
      for (final lesson in visible(
        settings: settings,
        band: band,
        readiness: readiness,
        includeDrafts: includeDrafts,
      ))
        if (lesson.module == module) lesson,
    ];
  }

  List<LessonRecord> englishLetters({
    required AgeBand band,
    Readiness readiness = Readiness.steady,
    required bool includeDrafts,
  }) {
    return [
      for (final lesson in pack.lessons)
        if (lesson.category == GameCategory.vocabulary &&
            lesson.module == null &&
            _releaseOk(lesson, includeDrafts) &&
            lesson.offeredFor(band, readiness))
          lesson,
    ];
  }

  ActivityDefinition definition(LessonRecord lesson, AgeBand band) {
    return ActivityDefinition(
      id: lesson.id,
      category: lesson.category,
      band: band,
      variant: _variant(lesson.id),
      seed: lesson.id.hashCode.abs() % 100000,
      title: lesson.title,
      questionCount: 1,
    );
  }

  ActivityDefinition? definitionById(String id, AgeBand band) {
    final lesson = byId(id);
    if (lesson == null) {
      return null;
    }
    return definition(lesson, band);
  }

  bool _allowed(
    LessonRecord lesson,
    LocalSettings settings,
    bool includeDrafts,
  ) {
    if (!_releaseOk(lesson, includeDrafts)) {
      return false;
    }
    if (lesson.module != null) {
      return RegionalAvailability.isAvailable(settings, lesson.module!);
    }
    return true;
  }

  bool _releaseOk(LessonRecord lesson, bool includeDrafts) {
    if (lesson.releaseReady) {
      return true;
    }
    return includeDrafts && lesson.reviewStatus != ReviewStatus.rejected;
  }

  int _variant(String id) {
    var hash = 0;
    for (final code in id.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash % 50;
  }
}
