import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_journey_repository.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/data/repositories/drift_settings_repository.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';

void main() {
  test('completing a Hindi Home slot marks that slot done', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profile = await DriftProfileRepository(
      database,
    ).createProfile(avatarId: 'fox', ageBand: AgeBand.c);
    final settings = LocalSettings.defaults.copyWith(
      onboardingComplete: true,
      learningRegion: LearningRegion.india,
    );
    await DriftSettingsRepository(database).save(settings);
    final now = DateTime(2026, 10, 3, 10);
    final journeys = DriftJourneyRepository(database);
    final first = await journeys.ensure(
      profile: profile,
      records: const [],
      now: now,
      settings: settings,
    );
    const catalog = ActivityCatalog();
    const hindiId = 'lesson:hindi:listen:a';
    expect(catalog.byId(hindiId), isNotNull);
    if (!first.slots.any((slot) => slot.activityId == hindiId)) {
      await database
          .into(database.dailyJourneyItems)
          .insert(
            DailyJourneyItemsCompanion.insert(
              journeyId: first.id,
              position: first.slots.length,
              activityId: hindiId,
            ),
          );
    }
    final progress = DriftProgressRepository(database);
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: hindiId,
      category: GameCategory.hindi,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
      countTowardFree: false,
      journeyDate: first.dateKey,
      nowMillis: now.millisecondsSinceEpoch,
      recordSkill: false,
    );
    final view = await journeys.ensure(
      profile: profile,
      records: await progress.listForProfile(profile.id),
      now: now,
      settings: settings,
    );
    expect(
      view.slots.any(
        (slot) => slot.activityId == hindiId && slot.done && slot.stars == 3,
      ),
      isTrue,
    );
    expect(await progress.levelBadgeCount(profile.id), 1);
    expect(await progress.uniqueFreeCompleted(profile.id, GameCategory.hindi), 0);
  });
}
