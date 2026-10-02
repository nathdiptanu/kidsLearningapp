import 'package:drift/drift.dart';

class ChildProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nickname => text().nullable()();

  TextColumn get avatarId => text()();

  TextColumn get ageBand => text()();

  IntColumn get createdAt => integer()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

class ActivityProgress extends Table {
  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get activityId => text()();

  TextColumn get engineType => text()();

  IntColumn get attempts => integer().withDefault(const Constant(0))();

  IntColumn get completions => integer().withDefault(const Constant(0))();

  IntColumn get bestStars => integer().withDefault(const Constant(0))();

  IntColumn get hintsUsed => integer().withDefault(const Constant(0))();

  IntColumn get lastPlayedAt => integer()();

  RealColumn get masteryContribution => real().withDefault(const Constant(0))();

  BoolColumn get countedAsFree =>
      boolean().withDefault(const Constant(false))();

  TextColumn get generatorType => text().nullable()();

  TextColumn get generatorVersion => text().nullable()();

  IntColumn get seed => integer().nullable()();

  TextColumn get skillId => text().nullable()();

  TextColumn get resultSummary => text().nullable()();

  IntColumn get bestScore => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {profileId, activityId};
}

class SkillProgress extends Table {
  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get skillId => text()();

  RealColumn get mastery => real().withDefault(const Constant(0))();

  IntColumn get attemptCount => integer().withDefault(const Constant(0))();

  IntColumn get lastUpdatedAt => integer()();

  IntColumn get currentDifficulty => integer().withDefault(const Constant(1))();

  IntColumn get correctFirstTry => integer().withDefault(const Constant(0))();

  IntColumn get correctAfterHint => integer().withDefault(const Constant(0))();

  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();

  TextColumn get recentOutcomes => text().withDefault(const Constant(''))();

  TextColumn get recentActivityIds => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {profileId, skillId};
}

class DailyJourneys extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get localDateKey => text()();

  IntColumn get currentIndex => integer().withDefault(const Constant(0))();

  IntColumn get completedCount => integer().withDefault(const Constant(0))();

  IntColumn get starsEarned => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {profileId, localDateKey},
  ];
}

class DailyJourneyItems extends Table {
  IntColumn get journeyId => integer().references(DailyJourneys, #id)();

  IntColumn get position => integer()();

  TextColumn get activityId => text()();

  TextColumn get role => text().withDefault(const Constant('current'))();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {journeyId, position};
}

class ActivityCheckpoints extends Table {
  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get activityId => text()();

  IntColumn get payloadVersion => integer()();

  TextColumn get payload => text()();

  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {profileId, activityId};
}

class PracticeDays extends Table {
  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get localDateKey => text()();

  @override
  Set<Column> get primaryKey => {profileId, localDateKey};
}

class Rewards extends Table {
  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get rewardId => text()();

  IntColumn get unlockedAt => integer()();

  @override
  Set<Column> get primaryKey => {profileId, rewardId};
}

class EntitlementCacheEntries extends Table {
  IntColumn get id => integer()();

  TextColumn get productId => text().nullable()();

  TextColumn get status => text()();

  IntColumn get expiryMillis => integer().nullable()();

  IntColumn get lastReconciledAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row for this device. Onboarding progress and sound choices live here.
class LocalSettings extends Table {
  IntColumn get id => integer()();

  BoolColumn get soundEffectsEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get musicEnabled => boolean().withDefault(const Constant(false))();

  BoolColumn get narrationEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();

  IntColumn get onboardingStep => integer().withDefault(const Constant(0))();

  TextColumn get draftAgeBand => text().nullable()();

  TextColumn get draftAvatarId => text().nullable()();

  TextColumn get draftNickname => text().nullable()();

  BoolColumn get remindersEnabled =>
      boolean().withDefault(const Constant(false))();

  /// Minutes after local midnight. The reminder stays off until a grown-up
  /// turns it on.
  IntColumn get reminderMinutes => integer().withDefault(const Constant(960))();

  BoolColumn get reducedMotion =>
      boolean().withDefault(const Constant(false))();

  /// 0 means no gentle stop. This is an in-app suggestion, not device screen time.
  IntColumn get sessionLimitMinutes =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LevelBadges extends Table {
  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get activityId => text()();

  TextColumn get engineType => text()();

  IntColumn get score => integer()();

  IntColumn get stars => integer()();

  TextColumn get outcome => text()();

  IntColumn get earnedAt => integer()();

  @override
  Set<Column> get primaryKey => {profileId, activityId};
}

class RecentGeneratedLevels extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get profileId => integer().references(ChildProfiles, #id)();

  TextColumn get engineType => text()();

  TextColumn get instanceId => text()();

  IntColumn get playedAt => integer()();
}
