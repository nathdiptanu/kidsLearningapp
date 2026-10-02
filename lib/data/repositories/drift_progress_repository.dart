import 'package:drift/drift.dart';

import '../../../domain/adaptive/skill_adaptation.dart';
import '../../../domain/games/play/activity_skill.dart';
import '../../../domain/games/play/play_checkpoint.dart';
import '../../../domain/geography/geography_catalog.dart';
import '../../../domain/heritage/heritage_catalog.dart';
import '../../../domain/learning/item_progress.dart';
import '../../../domain/learning/learning_index.dart';
import '../../../domain/lessons/lesson_catalog.dart';
import '../../../domain/models/age_band.dart';
import '../../../domain/models/game_category.dart';
import '../../../domain/games/play/generated_instance.dart';
import '../../../domain/monetization/free_entitlement_policy.dart';
import '../../../domain/monetization/monetization_config.dart';
import '../../../domain/progress/activity_record.dart';
import '../local/database/app_database.dart';
import 'drift_journey_repository.dart';
import 'drift_reward_repository.dart';

class DriftProgressRepository {
  DriftProgressRepository(this._database);

  final AppDatabase _database;
  final FreeEntitlementPolicy _policy = const FreeEntitlementPolicy();

  Future<List<ActivityRecord>> listForProfile(int profileId) async {
    final rows = await (_database.select(
      _database.activityProgress,
    )..where((table) => table.profileId.equals(profileId))).get();
    return rows.map(_map).toList();
  }

  Future<int> uniqueFreeCompleted(int profileId, GameCategory category) async {
    final rows =
        await (_database.select(_database.activityProgress)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.engineType.equals(category.storageKey) &
                  table.countedAsFree.equals(true) &
                  table.completions.isBiggerOrEqualValue(1),
            ))
            .get();
    return rows.length;
  }

  /// Saves a first completion once. A replay updates the time only.
  Future<ActivityRecord> saveCompletion({
    required int profileId,
    required String activityId,
    required GameCategory category,
    required int hintsUsed,
    required bool firstAttemptCorrect,
    required int stars,
    required bool premiumActive,
    bool countTowardFree = true,
    int? nowMillis,
    String? generatorType,
    String? generatorVersion,
    int? seed,
    String? skillId,
    int wrongCount = 0,
    String? journeyDate,
    int score = 0,
    String outcome = 'complete',
    bool recordSkill = true,
  }) async {
    final now = nowMillis ?? DateTime.now().millisecondsSinceEpoch;
    return _database.transaction(() async {
      final existing =
          await (_database.select(_database.activityProgress)..where(
                (table) =>
                    table.profileId.equals(profileId) &
                    table.activityId.equals(activityId),
              ))
              .getSingleOrNull();
      if (existing != null && existing.completions >= 1) {
        await (_database.update(_database.activityProgress)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.activityId.equals(activityId),
            ))
            .write(
              ActivityProgressCompanion(
                lastPlayedAt: Value(now),
                attempts: Value(existing.attempts + 1),
                bestStars: Value(
                  stars > existing.bestStars ? stars : existing.bestStars,
                ),
                bestScore: Value(
                  score > existing.bestScore ? score : existing.bestScore,
                ),
              ),
            );
        await _awardBadge(
          profileId: profileId,
          activityId: activityId,
          category: category,
          score: score > existing.bestScore ? score : existing.bestScore,
          stars: stars > existing.bestStars ? stars : existing.bestStars,
          outcome: outcome,
          now: now,
        );
        await _recordItemPractice(
          profileId: profileId,
          activityId: activityId,
          hintsUsed: hintsUsed,
          firstAttemptCorrect: firstAttemptCorrect,
          now: now,
        );
        return _finishSave(
          profileId: profileId,
          activityId: activityId,
          category: category,
          firstCompletion: false,
          firstAttemptCorrect: firstAttemptCorrect,
          hintsUsed: hintsUsed,
          wrongCount: wrongCount,
          now: now,
          journeyDate: journeyDate,
          stars: stars,
          recordSkill: recordSkill,
        );
      }
      final freeCount = await uniqueFreeCompleted(profileId, category);
      final access = _policy.decide(
        premiumActive: premiumActive,
        alreadyStarted: false,
        alreadyCompleted: false,
        uniqueFreeLevelsCompleted: freeCount,
      );
      final countsAsFree =
          countTowardFree &&
          !premiumActive &&
          access == LevelAccess.playNew &&
          freeCount < MonetizationConfig.freeCompletedLevelsPerGame;
      final contribution = firstAttemptCorrect
          ? 3.0
          : hintsUsed == 0
          ? 1.0
          : 0.5;
      final summary =
          'stars=$stars;hints=$hintsUsed;first=$firstAttemptCorrect;score=$score;outcome=$outcome';
      if (existing == null) {
        await _database
            .into(_database.activityProgress)
            .insert(
              ActivityProgressCompanion.insert(
                profileId: profileId,
                activityId: activityId,
                engineType: category.storageKey,
                lastPlayedAt: now,
                attempts: const Value(1),
                completions: const Value(1),
                bestStars: Value(stars),
                hintsUsed: Value(hintsUsed),
                masteryContribution: Value(contribution),
                countedAsFree: Value(countsAsFree),
                generatorType: Value(generatorType),
                generatorVersion: Value(generatorVersion),
                seed: Value(seed),
                skillId: Value(skillId),
                resultSummary: Value(summary),
                bestScore: Value(score),
              ),
            );
      } else {
        await (_database.update(_database.activityProgress)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.activityId.equals(activityId),
            ))
            .write(
              ActivityProgressCompanion(
                lastPlayedAt: Value(now),
                attempts: Value(existing.attempts + 1),
                completions: const Value(1),
                bestStars: Value(stars),
                hintsUsed: Value(hintsUsed),
                masteryContribution: Value(contribution),
                countedAsFree: Value(countsAsFree),
                generatorType: Value(generatorType),
                generatorVersion: Value(generatorVersion),
                seed: Value(seed),
                skillId: Value(skillId),
                resultSummary: Value(summary),
                bestScore: Value(score),
              ),
            );
      }
      await _awardBadge(
        profileId: profileId,
        activityId: activityId,
        category: category,
        score: score,
        stars: stars,
        outcome: outcome,
        now: now,
      );
      await _recordItemPractice(
        profileId: profileId,
        activityId: activityId,
        hintsUsed: hintsUsed,
        firstAttemptCorrect: firstAttemptCorrect,
        now: now,
      );
      await _rememberInstance(
        profileId: profileId,
        category: category,
        generatorType: generatorType,
        generatorVersion: generatorVersion,
        seed: seed,
        skillId: skillId,
        playedAt: now,
      );
      return _finishSave(
        profileId: profileId,
        activityId: activityId,
        category: category,
        firstCompletion: true,
        firstAttemptCorrect: firstAttemptCorrect,
        hintsUsed: hintsUsed,
        wrongCount: wrongCount,
        now: now,
        journeyDate: journeyDate,
        stars: stars,
        recordSkill: recordSkill,
      );
    });
  }

  Future<void> _awardBadge({
    required int profileId,
    required String activityId,
    required GameCategory category,
    required int score,
    required int stars,
    required String outcome,
    required int now,
  }) async {
    final existing =
        await (_database.select(_database.levelBadges)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.activityId.equals(activityId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      if (score > existing.score || stars > existing.stars) {
        await (_database.update(_database.levelBadges)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.activityId.equals(activityId),
            ))
            .write(
              LevelBadgesCompanion(
                score: Value(score > existing.score ? score : existing.score),
                stars: Value(stars > existing.stars ? stars : existing.stars),
              ),
            );
      }
      return;
    }
    await _database
        .into(_database.levelBadges)
        .insert(
          LevelBadgesCompanion.insert(
            profileId: profileId,
            activityId: activityId,
            engineType: category.storageKey,
            score: score,
            stars: stars,
            outcome: outcome,
            earnedAt: now,
          ),
        );
  }

  Future<List<LearningItemSnapshot>> listItemProgress(int profileId) async {
    final rows = await (_database.select(
      _database.learningItemProgress,
    )..where((table) => table.profileId.equals(profileId))).get();
    return rows.map(_mapItem).toList();
  }

  Future<int> levelBadgeCount(int profileId) async {
    final rows = await (_database.select(
      _database.levelBadges,
    )..where((table) => table.profileId.equals(profileId))).get();
    return rows.length;
  }

  Future<ActivityRecord> _finishSave({
    required int profileId,
    required String activityId,
    required GameCategory category,
    required bool firstCompletion,
    required bool firstAttemptCorrect,
    required int hintsUsed,
    required int wrongCount,
    required int now,
    required String? journeyDate,
    required int stars,
    required bool recordSkill,
  }) async {
    if (firstCompletion && recordSkill) {
      await _recordSkill(
        profileId: profileId,
        activityId: activityId,
        category: category,
        firstAttemptCorrect: firstAttemptCorrect,
        hintsUsed: hintsUsed,
        wrongCount: wrongCount,
        now: now,
      );
    }
    final saved = await _require(profileId, activityId);
    if (journeyDate != null) {
      await DriftJourneyRepository(_database).markDone(
        profileId: profileId,
        dateKey: journeyDate,
        activityId: activityId,
        stars: saved.bestStars,
      );
    }
    await deleteCheckpoint(profileId, activityId);
    await DriftRewardRepository(_database)
        .notePracticeDay(profileId: profileId, playedAtMillis: now);
    rewardsAwardedByLastSave = await DriftRewardRepository(_database)
        .reconcile(profileId, nowMillis: now);
    return saved;
  }

  List<String> rewardsAwardedByLastSave = const [];

  Future<void> _recordSkill({
    required int profileId,
    required String activityId,
    required GameCategory category,
    required bool firstAttemptCorrect,
    required int hintsUsed,
    required int wrongCount,
    required int now,
  }) async {
    final skillId = skillForCategory(category);
    final existing =
        await (_database.select(_database.skillProgress)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.skillId.equals(skillId),
            ))
            .getSingleOrNull();
    final profile = await (_database.select(
      _database.childProfiles,
    )..where((table) => table.id.equals(profileId))).getSingle();
    final band = AgeBand.fromStorage(profile.ageBand) ?? AgeBand.a;
    final current = existing == null
        ? SkillState.starting(skillId, band)
        : SkillState(
            skillId: skillId,
            difficulty: existing.currentDifficulty,
            mastery: existing.mastery,
            attempts: existing.attemptCount,
            correctFirstTry: existing.correctFirstTry,
            correctAfterHint: existing.correctAfterHint,
            incorrect: existing.incorrectCount,
            recentOutcomes: _csv(existing.recentOutcomes),
            recentActivityIds: _csv(existing.recentActivityIds),
            lastPlayedAt: existing.lastUpdatedAt,
          );
    final next = const SkillAdaptation().recordCompletion(
      current,
      activityId: activityId,
      firstAttemptCorrect: firstAttemptCorrect,
      hintsUsed: hintsUsed,
      wrongCount: wrongCount,
      nowMillis: now,
    );
    await _database
        .into(_database.skillProgress)
        .insertOnConflictUpdate(
          SkillProgressCompanion.insert(
            profileId: profileId,
            skillId: skillId,
            mastery: Value(next.mastery),
            attemptCount: Value(next.attempts),
            lastUpdatedAt: now,
            currentDifficulty: Value(next.difficulty),
            correctFirstTry: Value(next.correctFirstTry),
            correctAfterHint: Value(next.correctAfterHint),
            incorrectCount: Value(next.incorrect),
            recentOutcomes: Value(next.recentOutcomes.join(',')),
            recentActivityIds: Value(next.recentActivityIds.join(',')),
          ),
        );
  }

  Future<void> _recordItemPractice({
    required int profileId,
    required String activityId,
    required int hintsUsed,
    required bool firstAttemptCorrect,
    required int now,
  }) async {
    final mapped = LearningIndex().candidate(activityId, AgeBand.c);
    if (mapped == null) {
      return;
    }
    const rules = ItemPracticeRules();
    final existing =
        await (_database.select(_database.learningItemProgress)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.itemId.equals(mapped.itemId) &
                  table.mode.equals(mapped.mode.name),
            ))
            .getSingleOrNull();
    final current = existing == null
        ? rules.empty(mapped.itemId, mapped.mode)
        : _mapItem(existing);
    final unaided = firstAttemptCorrect && hintsUsed == 0;
    final next = rules.apply(
      current: current,
      attempt: ItemAttempt(
        completed: true,
        unaided: unaided,
        hinted: hintsUsed > 0,
        assisted: hintsUsed > 0,
        recalled: mapped.mode == PracticeMode.recall && unaided,
        nowMillis: now,
        contentVersion: _contentVersion(activityId),
      ),
    );
    await _database
        .into(_database.learningItemProgress)
        .insertOnConflictUpdate(
          LearningItemProgressCompanion.insert(
            profileId: profileId,
            itemId: next.itemId,
            mode: next.mode.name,
            contentVersion: Value(next.contentVersion),
            attempts: Value(next.attempts),
            correct: Value(next.correct),
            unaidedCorrect: Value(next.unaidedCorrect),
            hintsUsed: Value(next.hintsUsed),
            assisted: Value(next.assisted),
            recalledCount: Value(next.recalledCount),
            firstCompletedAt: Value(next.firstCompletedAt),
            lastCompletedAt: Value(next.lastCompletedAt),
            lastSeenAt: next.lastSeenAt,
            status: Value(next.status.name),
          ),
        );
  }

  LearningItemSnapshot _mapItem(LearningItemProgressData row) {
    return LearningItemSnapshot(
      itemId: row.itemId,
      mode: PracticeMode.values.byName(row.mode),
      contentVersion: row.contentVersion,
      attempts: row.attempts,
      correct: row.correct,
      unaidedCorrect: row.unaidedCorrect,
      hintsUsed: row.hintsUsed,
      assisted: row.assisted,
      recalledCount: row.recalledCount,
      status: ItemPracticeStatus.values.byName(row.status),
      firstCompletedAt: row.firstCompletedAt,
      lastCompletedAt: row.lastCompletedAt,
      lastSeenAt: row.lastSeenAt,
    );
  }

  int _contentVersion(String activityId) {
    final lesson = LessonCatalog().byId(activityId);
    if (lesson != null) {
      return lesson.packVersion;
    }
    if (activityId.startsWith('geo:')) {
      return GeographyCatalog().pack.contentVersion;
    }
    if (activityId.startsWith('heritage:')) {
      return HeritageCatalog().pack.contentVersion;
    }
    return 1;
  }

  List<String> _csv(String value) {
    if (value.isEmpty) {
      return const [];
    }
    return value.split(',');
  }

  Future<Set<String>> checkpointActivityIds(int profileId) async {
    final rows = await (_database.select(
      _database.activityCheckpoints,
    )..where((table) => table.profileId.equals(profileId))).get();
    return rows.map((row) => row.activityId).toSet();
  }

  Future<String?> readCheckpoint(int profileId, String activityId) async {
    final row =
        await (_database.select(_database.activityCheckpoints)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.activityId.equals(activityId),
            ))
            .getSingleOrNull();
    return row?.payload;
  }

  Future<void> writeCheckpoint({
    required int profileId,
    required String activityId,
    required String payload,
    int? nowMillis,
  }) {
    final now = nowMillis ?? DateTime.now().millisecondsSinceEpoch;
    return _database
        .into(_database.activityCheckpoints)
        .insertOnConflictUpdate(
          ActivityCheckpointsCompanion.insert(
            profileId: profileId,
            activityId: activityId,
            payloadVersion: checkpointPayloadVersion,
            payload: payload,
            updatedAt: now,
          ),
        );
  }

  Future<void> deleteCheckpoint(int profileId, String activityId) {
    return (_database.delete(_database.activityCheckpoints)..where(
          (table) =>
              table.profileId.equals(profileId) &
              table.activityId.equals(activityId),
        ))
        .go();
  }

  Future<ActivityRecord> _require(int profileId, String activityId) async {
    final row =
        await (_database.select(_database.activityProgress)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.activityId.equals(activityId),
            ))
            .getSingle();
    return _map(row);
  }

  ActivityRecord _map(ActivityProgressData row) {
    return ActivityRecord(
      activityId: row.activityId,
      engineType: row.engineType,
      attempts: row.attempts,
      completions: row.completions,
      bestStars: row.bestStars,
      hintsUsed: row.hintsUsed,
      lastPlayedAt: row.lastPlayedAt,
      countedAsFree: row.countedAsFree,
      generatorType: row.generatorType,
      generatorVersion: row.generatorVersion,
      seed: row.seed,
      skillId: row.skillId,
      resultSummary: row.resultSummary,
      bestScore: row.bestScore,
    );
  }

  Future<void> _rememberInstance({
    required int profileId,
    required GameCategory category,
    required String? generatorType,
    required String? generatorVersion,
    required int? seed,
    required String? skillId,
    required int playedAt,
  }) async {
    if (generatorType == null ||
        generatorVersion == null ||
        seed == null ||
        skillId == null) {
      return;
    }
    final instance = GeneratedInstance(
      generatorType: generatorType,
      generatorVersion: generatorVersion,
      seed: seed,
      skillId: skillId,
    );
    await _database
        .into(_database.recentGeneratedLevels)
        .insert(
          RecentGeneratedLevelsCompanion.insert(
            profileId: profileId,
            engineType: category.storageKey,
            instanceId: instance.id,
            playedAt: playedAt,
          ),
        );
    final rows =
        await (_database.select(_database.recentGeneratedLevels)
              ..where(
                (table) =>
                    table.profileId.equals(profileId) &
                    table.engineType.equals(category.storageKey),
              )
              ..orderBy([
                (table) => OrderingTerm(
                  expression: table.playedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();
    if (rows.length <= recentGeneratedLimit) {
      return;
    }
    for (final extra in rows.skip(recentGeneratedLimit)) {
      await (_database.delete(
        _database.recentGeneratedLevels,
      )..where((table) => table.id.equals(extra.id))).go();
    }
  }
}
