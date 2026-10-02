import 'package:drift/drift.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    ChildProfiles,
    ActivityProgress,
    SkillProgress,
    DailyJourneys,
    DailyJourneyItems,
    Rewards,
    PracticeDays,
    EntitlementCacheEntries,
    LocalSettings,
    RecentGeneratedLevels,
    ActivityCheckpoints,
    LevelBadges,
    LearningItemProgress,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(localSettings);
      }
      if (from < 3) {
        await migrator.addColumn(
          activityProgress,
          activityProgress.generatorType,
        );
        await migrator.addColumn(
          activityProgress,
          activityProgress.generatorVersion,
        );
        await migrator.addColumn(activityProgress, activityProgress.seed);
        await migrator.addColumn(activityProgress, activityProgress.skillId);
        await migrator.addColumn(
          activityProgress,
          activityProgress.resultSummary,
        );
      }
      if (from < 4) {
        await migrator.addColumn(skillProgress, skillProgress.correctFirstTry);
        await migrator.addColumn(skillProgress, skillProgress.correctAfterHint);
        await migrator.addColumn(skillProgress, skillProgress.incorrectCount);
        await migrator.addColumn(skillProgress, skillProgress.recentOutcomes);
        await migrator.addColumn(
          skillProgress,
          skillProgress.recentActivityIds,
        );
        await migrator.addColumn(dailyJourneyItems, dailyJourneyItems.role);
        await migrator.addColumn(dailyJourneyItems, dailyJourneyItems.done);
        await migrator.createTable(activityCheckpoints);
      }
      if (from < 5) {
        await migrator.createTable(practiceDays);
      }
      if (from < 6) {
        await migrator.addColumn(localSettings, localSettings.remindersEnabled);
        await migrator.addColumn(localSettings, localSettings.reminderMinutes);
      }
      if (from < 7) {
        await migrator.addColumn(activityProgress, activityProgress.bestScore);
        await migrator.addColumn(localSettings, localSettings.reducedMotion);
        await migrator.addColumn(
          localSettings,
          localSettings.sessionLimitMinutes,
        );
        await migrator.createTable(levelBadges);
      }
      if (from < 8) {
        await migrator.addColumn(childProfiles, childProfiles.readiness);
        await migrator.addColumn(localSettings, localSettings.learningRegion);
        await migrator.addColumn(
          localSettings,
          localSettings.interfaceLanguage,
        );
        await migrator.addColumn(localSettings, localSettings.teachingLanguage);
        await migrator.addColumn(localSettings, localSettings.hindiEnabled);
        await migrator.addColumn(
          localSettings,
          localSettings.discoverIndiaEnabled,
        );
      }
      if (from < 9) {
        await migrator.createTable(learningItemProgress);
      }
      if (to > 9) {
        throw StateError(
          'No migration is defined from schema $from to $to. Progress must not be erased.',
        );
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
