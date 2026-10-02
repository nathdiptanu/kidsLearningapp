import '../models/content_pack.dart';
import 'lesson_models.dart';
import 'word_builder.dart';

class LanguagePackValidator {
  const LanguagePackValidator();

  List<String> validate(LanguagePack pack, {required bool release}) {
    final issues = <String>[];
    final ids = <String>{};
    for (final lesson in pack.lessons) {
      if (lesson.id.trim().isEmpty || !ids.add(lesson.id)) {
        issues.add('duplicate or missing lesson ${lesson.id}');
      }
      if (lesson.ageBands.isEmpty) {
        issues.add('${lesson.id} missing age band');
      }
      if (lesson.displayText.trim().isEmpty) {
        issues.add('${lesson.id} missing display text');
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
      if (lesson.mode == LessonMode.build) {
        issues.addAll(_buildIssues(pack, lesson));
      }
      if (lesson.mode == LessonMode.trace) {
        final template = pack.templates[lesson.strokeTemplateId];
        if (template == null) {
          issues.add('${lesson.id} missing stroke template');
        } else if (template.reviewStatus == ReviewStatus.approved &&
            template.sourceNote.contains('font outline')) {
          issues.add('${lesson.id} must not use a font outline as handwriting');
        }
      }
      if (lesson.concept == ConceptType.conjunct &&
          {'क्ष', 'त्र', 'ज्ञ'}.contains(lesson.displayText) == false &&
          lesson.tokens.any(
            (token) =>
                token.concept == ConceptType.consonant &&
                {'क्ष', 'त्र', 'ज्ञ'}.contains(token.text),
          )) {
        issues.add('${lesson.id} stores a conjunct as a consonant');
      }
      if (release && !lesson.releaseReady) {
        issues.add('${lesson.id} is not approved for release');
      }
      for (final clipId in lesson.narrationIds) {
        final clip = pack.clips[clipId];
        if (clip == null) {
          issues.add('${lesson.id} missing clip $clipId');
        } else if (clip.reviewStatus == ReviewStatus.approved &&
            (clip.assetPath == null || clip.assetPath!.isEmpty)) {
          issues.add('${lesson.id} approved clip $clipId is missing a media file');
        }
      }
      if (release && lesson.strokeTemplateId != null) {
        final template = pack.templates[lesson.strokeTemplateId];
        if (template != null && !template.releaseReady) {
          issues.add('${lesson.id} stroke template is not approved');
        }
      }
    }
    if (release && pack.reviewStatus != ReviewStatus.approved) {
      issues.add('pack ${pack.packId} is not approved for release');
    }
    return issues;
  }

  List<LessonRecord> playable(LanguagePack pack, {required bool release}) {
    if (release) {
      return [
        for (final lesson in pack.lessons)
          if (lesson.releaseReady) lesson,
      ];
    }
    return pack.lessons;
  }

  List<String> _buildIssues(LanguagePack pack, LessonRecord lesson) {
    final issues = <String>[];
    CuratedWord? word;
    for (final item in pack.words.values) {
      if (item.text == lesson.displayText) {
        word = item;
        break;
      }
    }
    if (word == null) {
      issues.add('${lesson.id} has no curated word');
      return issues;
    }
    final tokens = [for (final id in word.tokenIds) pack.tokens[id]];
    if (tokens.contains(null)) {
      issues.add('${lesson.id} has an unknown token');
      return issues;
    }
    final assembled = const WordAssembler().join(tokens.cast());
    if (!const WordAssembler().sameText(assembled, word.text)) {
      issues.add('${lesson.id} tokens do not shape to ${word.text}');
    }
    return issues;
  }
}
