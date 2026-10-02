import 'package:drift/drift.dart';

import '../../../domain/models/age_band.dart';
import '../../../domain/regional/learning_preferences.dart';
import '../../../domain/repositories/settings_repository.dart';
import '../../../domain/settings/local_settings.dart';
import '../local/database/app_database.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<LocalSettings> load() async {
    final row = await (_database.select(
      _database.localSettings,
    )..where((table) => table.id.equals(1))).getSingleOrNull();
    if (row == null) {
      await _database
          .into(_database.localSettings)
          .insert(LocalSettingsCompanion.insert(id: const Value(1)));
      return LocalSettings.defaults;
    }
    return LocalSettings(
      soundEffectsEnabled: row.soundEffectsEnabled,
      musicEnabled: row.musicEnabled,
      narrationEnabled: row.narrationEnabled,
      onboardingComplete: row.onboardingComplete,
      onboardingStep: row.onboardingStep,
      draftAgeBand: row.draftAgeBand == null
          ? null
          : AgeBand.fromStorage(row.draftAgeBand!),
      draftAvatarId: row.draftAvatarId,
      draftNickname: row.draftNickname,
      remindersEnabled: row.remindersEnabled,
      reminderMinutes: row.reminderMinutes,
      reducedMotion: row.reducedMotion,
      sessionLimitMinutes: row.sessionLimitMinutes,
      learningRegion: LearningRegion.fromStorage(row.learningRegion),
      interfaceLanguage: InterfaceLanguage.fromStorage(row.interfaceLanguage),
      teachingLanguage: TeachingLanguage.fromStorage(row.teachingLanguage),
      hindiEnabled: row.hindiEnabled,
      discoverIndiaEnabled: row.discoverIndiaEnabled,
    );
  }

  @override
  Future<void> save(LocalSettings settings) async {
    await _database
        .into(_database.localSettings)
        .insert(
          LocalSettingsCompanion.insert(
            id: const Value(1),
            soundEffectsEnabled: Value(settings.soundEffectsEnabled),
            musicEnabled: Value(settings.musicEnabled),
            narrationEnabled: Value(settings.narrationEnabled),
            onboardingComplete: Value(settings.onboardingComplete),
            onboardingStep: Value(settings.onboardingStep),
            draftAgeBand: Value(settings.draftAgeBand?.storageKey),
            draftAvatarId: Value(settings.draftAvatarId),
            draftNickname: Value(settings.draftNickname),
            remindersEnabled: Value(settings.remindersEnabled),
            reminderMinutes: Value(settings.reminderMinutes),
            reducedMotion: Value(settings.reducedMotion),
            sessionLimitMinutes: Value(settings.sessionLimitMinutes),
            learningRegion: Value(settings.learningRegion?.storageKey),
            interfaceLanguage: Value(settings.interfaceLanguage.storageKey),
            teachingLanguage: Value(settings.teachingLanguage.storageKey),
            hindiEnabled: Value(settings.hindiEnabled),
            discoverIndiaEnabled: Value(settings.discoverIndiaEnabled),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}
