import 'package:drift/drift.dart';

import '../../domain/adaptive/local_date.dart';
import '../../domain/games/play/activity_catalog.dart';
import '../../domain/learning/learning_notes.dart';
import '../../domain/parent/parent_report.dart';
import '../../domain/rewards/reward_catalog.dart';
import '../../domain/rewards/reward_snapshot.dart';
import '../local/database/app_database.dart';
import 'drift_progress_repository.dart';

class DriftRewardRepository {
  DriftRewardRepository(this._database);

  final AppDatabase _database;
  final ActivityCatalog _catalog = const ActivityCatalog();

  List<String> rewardsAwardedByLastSave = const [];

  Future<void> notePracticeDay({
    required int profileId,
    required int playedAtMillis,
  }) {
    final key = localDateKey(
      DateTime.fromMillisecondsSinceEpoch(playedAtMillis),
    );
    return _database
        .into(_database.practiceDays)
        .insert(
          PracticeDaysCompanion.insert(profileId: profileId, localDateKey: key),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> backfillPracticeDays(int profileId) async {
    final rows =
        await (_database.select(_database.activityProgress)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.completions.isBiggerOrEqualValue(1),
            ))
            .get();
    for (final row in rows) {
      await notePracticeDay(
        profileId: profileId,
        playedAtMillis: row.lastPlayedAt,
      );
    }
  }

  Future<RewardSnapshot> snapshot(int profileId) async {
    final rows = await _database
        .customSelect(
          '''
          SELECT engine_type AS engine,
                 SUM(completions) AS finished,
                 SUM(best_stars) AS stars,
                 MAX(best_stars) AS best
          FROM activity_progress
          WHERE profile_id = ? AND completions >= 1
          GROUP BY engine_type
          ''',
          variables: [Variable.withInt(profileId)],
        )
        .get();
    final completions = <String, int>{};
    var stars = 0;
    var best = 0;
    for (final row in rows) {
      completions[row.read<String>('engine')] = row.read<int>('finished');
      stars += row.read<int>('stars');
      final rowBest = row.read<int>('best');
      if (rowBest > best) {
        best = rowBest;
      }
    }
    final days = await (_database.select(
      _database.practiceDays,
    )..where((table) => table.profileId.equals(profileId))).get();
    final journeys =
        await (_database.select(_database.dailyJourneys)..where(
              (table) =>
                  table.profileId.equals(profileId) &
                  table.completedCount.isBiggerOrEqualValue(5),
            ))
            .get();
    return RewardSnapshot(
      completionsByEngine: completions,
      totalStars: stars,
      bestSingleStars: best,
      completedJourneys: journeys.length,
      distinctDays: days.length,
    );
  }

  Future<List<Reward>> listRewards(int profileId) {
    return (_database.select(_database.rewards)
          ..where((table) => table.profileId.equals(profileId))
          ..orderBy([(table) => OrderingTerm.asc(table.unlockedAt)]))
        .get();
  }

  /// Inserts missing awards. Existing rows keep their original unlock time.
  Future<List<String>> reconcile(int profileId, {int? nowMillis}) async {
    await backfillPracticeDays(profileId);
    final current = await snapshot(profileId);
    final wanted = earnedRewardIds(current);
    final existing = await listRewards(profileId);
    final have = existing.map((row) => row.rewardId).toSet();
    final missing = wanted.difference(have).toList()..sort();
    final now = nowMillis ?? DateTime.now().millisecondsSinceEpoch;
    for (final id in missing) {
      await _database
          .into(_database.rewards)
          .insert(
            RewardsCompanion.insert(
              profileId: profileId,
              rewardId: id,
              unlockedAt: now,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
    rewardsAwardedByLastSave = missing;
    return missing;
  }

  Future<ParentReport> parentReport(int profileId, DateTime now) async {
    final startToday = DateTime(now.year, now.month, now.day);
    final startWeek = startToday.subtract(const Duration(days: 6));
    final totals = await _database
        .customSelect(
          '''
          SELECT COUNT(*) AS finished,
                 COALESCE(SUM(attempts), 0) AS played,
                 COALESCE(SUM(best_stars), 0) AS stars
          FROM activity_progress
          WHERE profile_id = ? AND completions >= 1
          ''',
          variables: [Variable.withInt(profileId)],
        )
        .getSingle();
    final today = await _countSince(
      profileId,
      startToday.millisecondsSinceEpoch,
    );
    final week = await _countSince(profileId, startWeek.millisecondsSinceEpoch);
    final byEngine = await _database
        .customSelect(
          '''
          SELECT engine_type AS engine, SUM(completions) AS finished
          FROM activity_progress
          WHERE profile_id = ? AND completions >= 1
          GROUP BY engine_type
          ''',
          variables: [Variable.withInt(profileId)],
        )
        .get();
    final days = await (_database.select(
      _database.practiceDays,
    )..where((table) => table.profileId.equals(profileId))).get();
    final skills = await (_database.select(
      _database.skillProgress,
    )..where((table) => table.profileId.equals(profileId))).get();
    final recent =
        await (_database.select(_database.activityProgress)
              ..where(
                (table) =>
                    table.profileId.equals(profileId) &
                    table.completions.isBiggerOrEqualValue(1),
              )
              ..orderBy([(table) => OrderingTerm.desc(table.lastPlayedAt)])
              ..limit(20))
            .get();
    return ParentReport(
      practicedToday: today,
      practicedThisWeek: week,
      finishedActivities: totals.read<int>('finished'),
      timesPlayed: totals.read<int>('played'),
      learningDays: days.length,
      totalStars: totals.read<int>('stars'),
      categoryCounts: {
        for (final row in byEngine)
          row.read<String>('engine'): row.read<int>('finished'),
      },
      skills: [
        for (final skill in skills)
          SkillPractice(
            skillId: skill.skillId,
            attempts: skill.attemptCount,
            firstTry: skill.correctFirstTry,
            hintAssisted: skill.correctAfterHint,
            incorrect: skill.incorrectCount,
            difficulty: skill.currentDifficulty,
            recentOutcomes: skill.recentOutcomes,
          ),
      ],
      recent: [
        for (final row in recent)
          RecentPractice(
            activityId: row.activityId,
            title: _catalog.byId(row.activityId)?.title ?? row.activityId,
            engine: row.engineType,
            attempts: row.attempts,
            stars: row.bestStars,
            playedAt: row.lastPlayedAt,
          ),
      ],
      learningNotes: factualLearningNotes(
        await DriftProgressRepository(_database).listItemProgress(profileId),
      ),
    );
  }

  Future<int> _countSince(int profileId, int fromMillis) async {
    final row = await _database
        .customSelect(
          '''
          SELECT COUNT(*) AS total
          FROM activity_progress
          WHERE profile_id = ? AND completions >= 1 AND last_played_at >= ?
          ''',
          variables: [
            Variable.withInt(profileId),
            Variable.withInt(fromMillis),
          ],
        )
        .getSingle();
    return row.read<int>('total');
  }
}
