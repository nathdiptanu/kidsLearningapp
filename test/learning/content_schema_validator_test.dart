import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/geography/geography_pack.dart';
import 'package:sproutlab/domain/geography/map_geometry.dart';
import 'package:sproutlab/domain/heritage/heritage_pack.dart';
import 'package:sproutlab/domain/learning/content_schema_validator.dart';
import 'package:sproutlab/domain/learning/learning_index.dart';
import 'package:sproutlab/domain/lessons/development_pack.dart';
import 'package:sproutlab/domain/lessons/lesson_models.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/content_pack.dart';
import 'package:sproutlab/domain/models/game_category.dart';

void main() {
  const validator = ContentSchemaValidator();

  test('development packs pass debug checks and fail release checks', () {
    final language = developmentLanguagePack();
    expect(validator.validateLanguage(language, release: false), isEmpty);
    expect(validator.validateLanguage(language, release: true), isNotEmpty);
    final atlas = atlasFromJson(
      jsonDecode(
        File('assets/content/geography/slice_geometry.json').readAsStringSync(),
      ) as Map<String, dynamic>,
    );
    expect(
      validator.validateGeography(
        developmentGeographyPack(),
        atlas,
        release: false,
      ),
      isEmpty,
    );
    expect(validator.validateHeritage(developmentHeritagePack(), release: false), isEmpty);
  });

  test('rejects duplicate ids, missing media, invalid answers, drafts and sources', () {
    final bad = LanguagePack(
      packId: 'bad',
      schemaVersion: 1,
      contentVersion: 1,
      reviewStatus: ReviewStatus.approved,
      lessons: [
        LessonRecord(
          id: 'lesson:bad:find:x',
          packId: 'bad',
          packVersion: 1,
          mode: LessonMode.find,
          category: GameCategory.hindi,
          title: 'Bad',
          prompt: 'Find',
          displayText: 'X',
          ageBands: [AgeBand.a],
          reviewStatus: ReviewStatus.placeholder,
          rightsStatus: '',
          sources: const [],
          options: const [LessonChoice(id: 'a', label: 'A')],
          correctOptionIds: const ['missing'],
          narrationIds: const ['gone'],
        ),
        LessonRecord(
          id: 'lesson:bad:find:x',
          packId: 'bad',
          packVersion: 1,
          mode: LessonMode.find,
          category: GameCategory.hindi,
          title: 'Bad copy',
          prompt: 'Find',
          displayText: 'X',
          ageBands: const [AgeBand.a],
          reviewStatus: ReviewStatus.approved,
          rightsStatus: 'cleared',
          sources: const ['source'],
        ),
        LessonRecord(
          id: 'lesson:bad:review:z',
          packId: 'bad',
          packVersion: 1,
          mode: LessonMode.review,
          category: GameCategory.hindi,
          title: 'Review',
          prompt: 'Remember',
          displayText: 'Z',
          ageBands: const [AgeBand.a],
          reviewStatus: ReviewStatus.approved,
          rightsStatus: 'cleared',
          sources: const ['source'],
          options: const [LessonChoice(id: 'a', label: 'A')],
          correctOptionIds: const ['a'],
        ),
      ],
      tokens: const {},
      templates: const {},
      clips: const {
        'clip': NarrationClip(
          id: 'clip',
          kind: AudioKind.letterName,
          reviewStatus: ReviewStatus.approved,
        ),
      },
      words: const {},
    );
    final issues = validator.validateLanguage(bad, release: true).join(' ');
    expect(issues, contains('duplicate'));
    expect(issues, contains('missing a media file'));
    expect(issues, contains('correct answer missing is not an option'));
    expect(issues, contains('missing sources'));
    expect(issues, contains('draft content cannot ship'));
    expect(issues, contains('has no introduce activity'));
    expect(issues, contains('missing licence'));
  });

  test('reviewed item counts stay zero until editorial approval', () {
    final census = LearningIndex().census(includeDrafts: true);
    expect(census.reviewedItems, 0);
    expect(census.draftItems, greaterThan(0));
    expect(census.playableActivities, greaterThan(census.draftItems));
    expect(census.generatedVariants, greaterThan(census.playableActivities));
    expect(census.reviewedItems, isNot(census.playableActivities));
    expect(census.activityTemplates, greaterThan(0));
  });
}
