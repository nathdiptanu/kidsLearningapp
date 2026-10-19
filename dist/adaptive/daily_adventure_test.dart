import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_journey_repository.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/domain/adaptive/daily_journey_planner.dart';
import 'package:sproutlab/domain/adaptive/local_date.dart';
import 'package:sproutlab/domain/adaptive/skill_adaptation.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/games/play/activity_skill.dart';
import 'package:sproutlab/domain/games/play/play_checkpoint.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/monetization/free_entitlement_policy.dart';
import 'package:sproutlab/domain/progress/activity_record.dart';

void main() {
  const planner = DailyJourneyPlanner();
  const adaptation = SkillAdaptation();
  const catalog = ActivityCatalog();

  ActivityRecord completed(
    String id,
    String engine, {
    required int playedAt,
    int stars = 2,
  }) {
    return ActivityRecord(
      activityId: id,
      engineType: engine,
      attempts: 1,
      completions: 1,
      bestStars: stars,
      hintsUsed: 0,
      lastPlayedAt: playedAt,
      countedAsFree: true,
    );
  }

  LevelAccess accessFor(
    ActivityDefinitionId activity,
    List<ActivityRecord> records,
  ) {
    final definition = catalog.byId(activity.id)!;
    final free = records
        .where(
          (record) =>
              record.engineType == definition.category.storageKey &&
              record.countedAsFree &&
              record.completed,
        )
        .length;
    return const FreeEntitlementPolicy().decide(
      premiumActive: false,
      alreadyStarted: false,
      alreadyCompleted: records.any(
        (record) => record.activityId == definition.id && record.completed,
      ),
      uniqueFreeLevelsCompleted: free,
    );
  }

  test('the same day plans the same mixed journey', () {
    const date = '2026-09-30';
    final first = planner.plan(
      dateKey: date,
      band: AgeBand.a,
      records: const [],
      difficultyBySkill: const {},
    );
    final second = planner.plan(
      dateKey: date,
      band: AgeBand.a,
      records: const [],
      difficultyBySkill: const {},
    );
    expect(
      first.map((item) => item.activity.id),
      second.map((item) => item.activity.id),
    );
    expect(first, hasLength(5));
    expect(
      first.where((item) => item.role == JourneyRole.review),
      hasLength(1),
    );
    expect(
      first.where((item) => item.role == JourneyRole.stretch).length,
      lessThanOrEqualTo(1),
    );
    final categories = first.map((item) => item.activity.category).toSet();
    expect(categories, contains(GameCategory.maths));
    expect(categories, contains(GameCategory.vocabulary));
    expect(
      categories.contains(GameCategory.pattern) ||
          categories.contains(GameCategory.maze),
      isTrue,
    );
    expect(
      categories.contains(GameCategory.matching) ||
          categories.contains(GameCategory.findDifference),
      isTrue,
    );
    expect(first.map((item) => item.activity.id).toSet(), hasLength(5));
  });

  test('an exhausted category stays on unlocked review content', () {
    final maths = catalog.forBand(GameCategory.maths, AgeBand.a);
    final records = [
      for (var index = 0; index < 5; index++)
        completed(maths[index].id, 'maths', playedAt: 1000 + index * 50),
    ];
    final plan = planner.plan(
      dateKey: '2026-09-30',
      band: AgeBand.a,
      records: records,
      difficultyBySkill: const {},
    );
    final mathsSlots = plan.where(
      (item) => item.activity.category == GameCategory.maths,
    );
    expect(mathsSlots, isNotEmpty);
    for (final slot in plan) {
      expect(
        accessFor(_Id(slot.activity.id), records),
        isNot(LevelAccess.locked),
      );
    }
    for (final slot in mathsSlots) {
      expect(
        records.map((record) => record.activityId),
        contains(slot.activity.id),
      );
    }
    final review = plan.firstWhere((item) => item.role == JourneyRole.review);
    expect(review.activity.id, maths[1].id);
  });

  test('difficulty moves by one step only after a full window', () {
    var state = SkillState.starting('maths', AgeBand.b);
    state = adaptation.recordCompletion(
      state,
      activityId: 'one',
      firstAttemptCorrect: true,
      hintsUsed: 0,
      wrongCount: 0,
      nowMillis: 1,
    );
    expect(state.difficulty, 2);
    expect(state.correctFirstTry, 1);

    for (var index = 0; index < 7; index++) {
      state = adaptation.recordCompletion(
        state,
        activityId: 'ok-$index',
        firstAttemptCorrect: true,
        hintsUsed: 0,
        wrongCount: 0,
        nowMillis: index + 2,
      );
    }
    expect(state.difficulty, 3);
    expect(state.recentOutcomes, hasLength(8));

    var hinted = SkillState.starting('logic', AgeBand.b);
    for (var index = 0; index < 8; index++) {
      hinted = adaptation.recordCompletion(
        hinted,
        activityId: 'hint-$index',
        firstAttemptCorrect: false,
        hintsUsed: 1,
        wrongCount: 2,
        nowMillis: index,
      );
    }
    expect(hinted.difficulty, 1);
    expect(hinted.correctAfterHint, 8);
    expect(hinted.incorrect, 16);

    var held = SkillState.starting('english', AgeBand.c);
    const letters = ['F', 'F', 'F', 'F', 'F', 'R', 'H', 'H'];
    for (var index = 0; index < letters.length; index++) {
      final letter = letters[index];
      held = adaptation.recordCompletion(
        held,
        activityId: 'mix-$index',
        firstAttemptCorrect: letter == 'F',
        hintsUsed: letter == 'H' ? 1 : 0,
        wrongCount: letter == 'F' ? 0 : 1,
        nowMillis: index,
      );
    }
    expect(held.difficulty, 3);

    var floor = SkillState.starting('observation', AgeBand.a);
    for (var index = 0; index < 8; index++) {
      floor = adaptation.recordCompletion(
        floor,
        activityId: 'low-$index',
        firstAttemptCorrect: false,
        hintsUsed: 2,
        wrongCount: 3,
        nowMillis: index,
      );
    }
    expect(floor.difficulty, 1);

    var ceiling = SkillState.starting('maths', AgeBand.d);
    for (var round = 0; round < 3; round++) {
      for (var index = 0; index < 8; index++) {
        ceiling = adaptation.recordCompletion(
          ceiling,
          activityId: 'top-$round-$index',
          firstAttemptCorrect: true,
          hintsUsed: 0,
          wrongCount: 0,
          nowMillis: round * 10 + index,
        );
      }
    }
    expect(ceiling.difficulty, 4);
  });

  test('a stored journey resumes and a new local day keeps history', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profiles = DriftProfileRepository(database);
    final progress = DriftProgressRepository(database);
    final journeys = DriftJourneyRepository(database);
    final profile = await profiles.createProfile(
      avatarId: 'fox',
      ageBand: AgeBand.a,
    );
    final morning = DateTime(2026, 9, 30, 9);
    final first = await journeys.ensure(
      profile: profile,
      records: const [],
      now: morning,
    );
    final again = await journeys.ensure(
      profile: profile,
      records: const [],
      now: DateTime(2026, 9, 30, 21),
    );
    expect(again.dateKey, first.dateKey);
    expect(
      again.slots.map((slot) => slot.activityId),
      first.slots.map((slot) => slot.activityId),
    );
    final activity = catalog.byId(first.slots.first.activityId)!;
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: activity.id,
      category: activity.category,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
      journeyDate: first.dateKey,
      nowMillis: 50,
    );
    final partial = await journeys.ensure(
      profile: profile,
      records: await progress.listForProfile(profile.id),
      now: DateTime(2026, 9, 30, 22),
    );
    expect(partial.finishedCount, 1);
    expect(partial.slots.first.done, isTrue);
    expect(partial.slots.first.stars, 3);

    final nextDay = await journeys.ensure(
      profile: profile,
      records: await progress.listForProfile(profile.id),
      now: DateTime(2026, 10, 1, 8),
    );
    expect(nextDay.dateKey, partial.dateKey);
    expect(nextDay.finishedCount, 1);
    final yesterday = await journeys.ensure(
      profile: profile,
      records: await progress.listForProfile(profile.id),
      now: morning,
    );
    expect(yesterday.slots.first.done, isTrue);
    expect(yesterday.slots.first.stars, 3);

    final changed = await profiles.updateActiveProfile(
      avatarId: 'fox',
      ageBand: AgeBand.d,
    );
    final kept = await journeys.ensure(
      profile: changed,
      records: await progress.listForProfile(profile.id),
      now: morning,
    );
    expect(
      kept.slots.map((slot) => slot.activityId),
      yesterday.slots.map((slot) => slot.activityId),
    );
    final future = planner.plan(
      dateKey: '2026-10-02',
      band: AgeBand.d,
      records: const [],
      difficultyBySkill: {skillForCategory(GameCategory.maths): 1},
    );
    final maths = future.firstWhere(
      (item) => item.activity.category == GameCategory.maths,
    );
    if (maths.role == JourneyRole.stretch) {
      expect(maths.activity.band, AgeBand.b);
    } else {
      expect(maths.activity.band, AgeBand.a);
    }
    final fresh = planner.plan(
      dateKey: '2026-10-02',
      band: AgeBand.d,
      records: const [],
      difficultyBySkill: const {},
    );
    expect(
      fresh
          .firstWhere(
            (item) => item.activity.category == GameCategory.vocabulary,
          )
          .activity
          .band,
      AgeBand.d,
    );
    expect(localDateKey(DateTime(2026, 9, 30, 23, 59)), '2026-09-30');
  });

  test('replays do not raise mastery and completion is written once', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profile = await DriftProfileRepository(database)
        .createProfile(avatarId: 'sprout', ageBand: AgeBand.b);
    final progress = DriftProgressRepository(database);
    final journeys = DriftJourneyRepository(database);
    final journey = await journeys.ensure(
      profile: profile,
      records: const [],
      now: DateTime(2026, 9, 30, 12),
    );
    final activity = catalog.byId(journey.slots.first.activityId)!;
    await progress.writeCheckpoint(
      profileId: profile.id,
      activityId: activity.id,
      payload: 'v=1;kind=choices;seed=1;gen=maths:v1;index=1;wrongOn=0;totalWrong=0;hints=0;accepted=0',
    );
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: activity.id,
      category: activity.category,
      hintsUsed: 1,
      firstAttemptCorrect: false,
      stars: 1,
      premiumActive: false,
      wrongCount: 2,
      journeyDate: journey.dateKey,
      nowMillis: 10,
    );
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: activity.id,
      category: activity.category,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
      wrongCount: 0,
      journeyDate: journey.dateKey,
      nowMillis: 20,
    );
    final record = (await progress.listForProfile(profile.id)).single;
    expect(record.completions, 1);
    expect(record.countedAsFree, isTrue);
    expect(record.bestStars, 3);
    expect(record.attempts, 2);
    final skill = await (database.select(
      database.skillProgress,
    )..where((table) => table.profileId.equals(profile.id))).getSingle();
    expect(skill.attemptCount, 1);
    expect(skill.correctAfterHint, 1);
    expect(skill.correctFirstTry, 0);
    expect(skill.incorrectCount, 2);
    expect(skill.currentDifficulty, profile.ageBand.index + 1);
    final reloaded = await journeys.ensure(
      profile: profile,
      records: await progress.listForProfile(profile.id),
      now: DateTime(2026, 9, 30, 18),
    );
    final slot = reloaded.slots.firstWhere(
      (item) => item.activityId == activity.id,
    );
    expect(slot.done, isTrue);
    expect(slot.stars, 3);
    final journeyRow = await (database.select(
      database.dailyJourneys,
    )..where((table) => table.profileId.equals(profile.id))).getSingle();
    expect(journeyRow.completedCount, 1);
    expect(await progress.readCheckpoint(profile.id, activity.id), isNull);
  });

  test('a bad checkpoint restarts without a failure or a free level', () {
    const good = ChoiceCheckpoint(
      index: 1,
      wrongOnQuestion: 1,
      totalWrong: 1,
      hintsShown: 0,
      acceptedCurrent: false,
    );
    final payload = choiceCheckpointPayload(
      seed: 101,
      generatorVersion: 'maths:v1',
      state: good,
    );
    expect(
      parseChoiceCheckpoint(
        payload,
        seed: 101,
        generatorVersion: 'maths:v1',
        questionCount: 3,
      )?.index,
      1,
    );
    expect(
      parseChoiceCheckpoint(
        payload,
        seed: 202,
        generatorVersion: 'maths:v1',
        questionCount: 3,
      ),
      isNull,
    );
    expect(
      parseChoiceCheckpoint(
        'v=9;kind=choices;seed=101;gen=maths:v1;index=0;wrongOn=0;totalWrong=0;hints=0;accepted=0',
        seed: 101,
        generatorVersion: 'maths:v1',
        questionCount: 3,
      ),
      isNull,
    );
    expect(
      parseBoardCheckpoint(
        'v=1;kind=maze;seed=4;gen=maze:v1;row=-1;col=0;marked=;wrong=0;hints=0',
        seed: 4,
        generatorVersion: 'maze:v1',
        kind: 'maze',
      ),
      isNull,
    );
    expect(
      parseBoardCheckpoint(
        'not a checkpoint',
        seed: 4,
        generatorVersion: 'maze:v1',
        kind: 'maze',
      ),
      isNull,
    );
  });
}

class _Id {
  const _Id(this.id);
  final String id;
}

typedef ActivityDefinitionId = _Id;
