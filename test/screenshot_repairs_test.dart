import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_journey_repository.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/games/tictactoe/tic_tac_toe.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/models/readiness.dart';
import 'package:sproutlab/domain/games/content/launch_manifest.dart';
import 'package:sproutlab/domain/lessons/development_pack.dart';
import 'package:sproutlab/domain/geography/geography_pack.dart';
import 'package:sproutlab/domain/heritage/heritage_pack.dart';
import 'package:sproutlab/features/play/tic_tac_toe_screen.dart';

void main() {
  test('write reproducible content and missing-media inventory', () {
    final language = developmentLanguagePack();
    final geography = developmentGeographyPack();
    final heritage = developmentHeritagePack();
    final clips = {...language.clips, ...geography.clips, ...heritage.clips};
    final entries = const LaunchManifest().entries();
    final inventory = {
      'date': '2026-10-03',
      'generatedLibraryVariants': const LaunchManifest()
          .libraryCountsBySection(),
      'releaseApprovedReviewedItems': 0,
      'generatedVariantsAreNotEditorialApproval': true,
      'draftLanguageLessons': language.lessons.length,
      'draftGeographyActivities': geography.activities.length,
      'draftHeritageActivities': heritage.activities.length,
      'draftPlaces': geography.places.length,
      'draftSites': heritage.sites.length,
      'missingReviewedAudioIds': [
        for (final clip in clips.values)
          if (!clip.hasReviewedFile) clip.id,
      ],
      'activityManifest': [for (final entry in entries) entry.toJson()],
    };
    final file = File('docs/screenshot-repair-inventory.json');
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(inventory),
    );
    expect(geography.places.length, 36);
    expect(clips.values.where((clip) => clip.hasReviewedFile), isEmpty);
  });
  test(
    'adventure persists across days and next creation is idempotent',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final profile = await DriftProfileRepository(db)
          .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
      final repo = DriftJourneyRepository(db);
      final first = await repo.ensure(
        profile: profile,
        records: [],
        now: DateTime(2026, 10, 3),
      );
      expect(first.slots.length, 5);
      for (var i = 0; i < first.slots.length; i++) {
        await repo.markDone(
          profileId: profile.id,
          dateKey: first.dateKey,
          activityId: first.slots[i].activityId,
          stars: 3,
        );
        await repo.markDone(
          profileId: profile.id,
          dateKey: first.dateKey,
          activityId: first.slots[i].activityId,
          stars: 3,
        );
        final partial = await repo.ensure(
          profile: profile,
          records: [],
          now: DateTime(2026, 10, 4),
        );
        expect(partial.id, first.id);
        expect(partial.finishedCount, i + 1);
      }
      final next = await repo.ensure(
        profile: profile,
        records: [],
        now: DateTime(2026, 10, 4),
        afterCompletedJourneyId: first.id,
      );
      expect(next.id, isNot(first.id));
      expect(next.finishedCount, 0);
      final duplicate = await repo.ensure(
        profile: profile,
        records: [],
        now: DateTime(2026, 10, 4),
        afterCompletedJourneyId: first.id,
      );
      expect(duplicate.id, next.id);
    },
  );

  test('parent-led toddler choices are short picture matching', () async {
    const catalog = ActivityCatalog();
    final activities = catalog.playableFor(AgeBand.toddler);
    expect(activities.length, 6);
    for (final activity in activities) {
      expect(activity.category, GameCategory.matching);
      expect(activity.questionCount, 1);
      final question = catalog.questionsFor(activity).single;
      expect(question.isValid, true);
      expect(question.choices.length, 2);
      expect(question.promptVisuals, isNotEmpty);
    }
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final profile = await DriftProfileRepository(db)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.toddler);
    expect(profile.readiness, Readiness.gentle);
  });

  test('pass-and-play alternates and guards occupied and terminal cells', () {
    const engine = TicTacToeEngine();
    var state = engine.create(variant: 0, seed: 1);
    for (final index in [0, 3, 1, 4, 2]) {
      state = engine.playOnDevice(state, index);
      expect(engine.playOnDevice(state, index), same(state));
    }
    expect(state.outcome, TicOutcome.childWin);
    expect(engine.playOnDevice(state, 8), same(state));
  });

  test('checkpoint serializes nine cells for restoration', () {
    const engine = TicTacToeEngine();
    final state = engine.reduce(
      engine.create(variant: 0, seed: 2),
      const TicAction.play(4),
    );
    final restored = parseTicCheckpoint(
      ticCheckpointPayload(seed: 2, variant: 0, state: state),
      seed: 2,
      variant: 0,
    );
    expect(restored, isNotNull);
    expect(restored!.cells, state.cells);
    expect(restored.childTurn, false);
  });
}
