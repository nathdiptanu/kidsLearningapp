import '../geography/geography_models.dart';
import '../geography/geography_validator.dart';
import '../heritage/heritage_models.dart';
import '../heritage/heritage_validator.dart';
import '../lessons/language_pack_validator.dart';
import '../lessons/lesson_models.dart';
import '../models/content_pack.dart';
import 'learning_ids.dart';

/// Cross-pack checks for missing media, duplicate ids, invalid answers,
/// draft-in-release, missing sources/licences and broken prerequisites.
class ContentSchemaValidator {
  const ContentSchemaValidator();

  List<String> validateLanguage(LanguagePack pack, {required bool release}) {
    final issues = const LanguagePackValidator().validate(pack, release: release);
    issues.addAll(_languageExtras(pack, release: release));
    return issues;
  }

  List<String> validateGeography(
    GeographyPack pack,
    IndiaMapAtlas atlas, {
    required bool release,
  }) {
    final issues = const GeographyPackValidator().validate(
      pack,
      atlas,
      release: release,
    );
    issues.addAll(_clipIssues(pack.clips, prefix: pack.packId, release: release));
    issues.addAll(_duplicateActivityIds([
      for (final activity in pack.activities) activity.id,
    ]));
    for (final place in pack.places.values) {
      if (place.sources.isEmpty) {
        issues.add('${place.id} missing sources');
      }
      if (place.rightsStatus.trim().isEmpty) {
        issues.add('${place.id} missing licence or rights status');
      }
    }
    final learned = {
      for (final activity in pack.activities)
        if (activity.mode == GeographyMode.learn && activity.placeId != null)
          activity.placeId,
    };
    for (final activity in pack.activities) {
      if ((activity.mode == GeographyMode.matchName ||
              activity.mode == GeographyMode.matchLocation ||
              activity.mode == GeographyMode.capital) &&
          activity.placeId != null &&
          !learned.contains(activity.placeId)) {
        issues.add('${activity.id} has no learn activity for ${activity.placeId}');
      }
    }
    return issues;
  }

  List<String> validateHeritage(HeritagePack pack, {required bool release}) {
    final issues = const HeritagePackValidator().validate(
      pack,
      release: release,
    );
    issues.addAll(_clipIssues(pack.clips, prefix: pack.packId, release: release));
    issues.addAll(_duplicateActivityIds([
      for (final activity in pack.activities) activity.id,
    ]));
    final identified = {
      for (final activity in pack.activities)
        if (activity.mode == HeritageMode.identify && activity.siteId != null)
          activity.siteId,
    };
    final stories = {
      for (final activity in pack.activities)
        if (activity.mode == HeritageMode.story && activity.siteId != null)
          activity.siteId,
    };
    for (final site in pack.sites.values) {
      if (site.sources.isEmpty) {
        issues.add('${site.id} missing sources');
      }
      if (site.rightsStatus.trim().isEmpty) {
        issues.add('${site.id} missing licence or rights status');
      }
    }
    for (final activity in pack.activities) {
      if (activity.mode == HeritageMode.locate &&
          activity.siteId != null &&
          !identified.contains(activity.siteId)) {
        issues.add('${activity.id} locate has no identify activity');
      }
      if (activity.mode == HeritageMode.recall && stories.isEmpty) {
        issues.add('${activity.id} recall has no story prerequisite');
      }
    }
    return issues;
  }

  List<String> _languageExtras(LanguagePack pack, {required bool release}) {
    final issues = <String>[];
    issues.addAll(_duplicateActivityIds([
      for (final lesson in pack.lessons) lesson.id,
    ]));
    issues.addAll(_clipIssues(pack.clips, prefix: pack.packId, release: release));
    final introduced = <String>{};
    for (final lesson in pack.lessons) {
      if (lessonIntroduces(lesson.mode)) {
        introduced.add(itemIdForLesson(lesson));
      }
      if (lesson.sources.isEmpty) {
        issues.add('${lesson.id} missing sources');
      }
      if (lesson.rightsStatus.trim().isEmpty) {
        issues.add('${lesson.id} missing licence or rights status');
      }
      if (lesson.mode == LessonMode.find ||
          lesson.mode == LessonMode.match ||
          lesson.mode == LessonMode.review) {
        if (lesson.correctOptionIds.isEmpty) {
          issues.add('${lesson.id} missing a correct answer');
        }
        final optionIds = {for (final option in lesson.options) option.id};
        for (final id in lesson.correctOptionIds) {
          if (!optionIds.contains(id)) {
            issues.add('${lesson.id} correct answer $id is not an option');
          }
        }
      }
      if (release &&
          lesson.reviewStatus != ReviewStatus.approved) {
        issues.add('${lesson.id} draft content cannot ship');
      }
    }
    for (final lesson in pack.lessons) {
      if ((lesson.mode == LessonMode.review || lesson.mode == LessonMode.trace) &&
          !introduced.contains(itemIdForLesson(lesson))) {
        issues.add('${lesson.id} has no introduce activity');
      }
    }
    return issues;
  }

  List<String> _clipIssues(
    Map<String, NarrationClip> clips, {
    required String prefix,
    required bool release,
  }) {
    final issues = <String>[];
    final ids = <String>{};
    for (final clip in clips.values) {
      if (!ids.add(clip.id)) {
        issues.add('$prefix duplicate clip ${clip.id}');
      }
      if (clip.reviewStatus == ReviewStatus.approved &&
          (clip.assetPath == null || clip.assetPath!.isEmpty)) {
        issues.add('${clip.id} approved clip is missing a media file');
      }
      if (release &&
          clip.reviewStatus == ReviewStatus.approved &&
          !clip.hasReviewedFile) {
        issues.add('${clip.id} approved clip is missing a media file');
      }
    }
    return issues;
  }

  List<String> _duplicateActivityIds(List<String> ids) {
    final seen = <String>{};
    final issues = <String>[];
    for (final id in ids) {
      if (id.trim().isEmpty || !seen.add(id)) {
        issues.add('duplicate or missing activity id $id');
      }
    }
    return issues;
  }
}
