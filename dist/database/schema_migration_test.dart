import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/data/repositories/drift_settings_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/readiness.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/regional/regional_availability.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'schema 5 keeps a completion written before the adventure columns',
    () async {
      final raw = sqlite3.openInMemory();
      raw.execute('''
      CREATE TABLE child_profiles (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        nickname TEXT,
        avatar_id TEXT NOT NULL,
        age_band TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        active INTEGER NOT NULL DEFAULT 1
      )
    ''');
      raw.execute('''
      CREATE TABLE activity_progress (
        profile_id INTEGER NOT NULL REFERENCES child_profiles (id),
        activity_id TEXT NOT NULL,
        engine_type TEXT NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0,
        completions INTEGER NOT NULL DEFAULT 0,
        best_stars INTEGER NOT NULL DEFAULT 0,
        hints_used INTEGER NOT NULL DEFAULT 0,
        last_played_at INTEGER NOT NULL,
        mastery_contribution REAL NOT NULL DEFAULT 0,
        counted_as_free INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY (profile_id, activity_id)
      )
    ''');
      raw.execute('''
      CREATE TABLE skill_progress (
        profile_id INTEGER NOT NULL,
        skill_id TEXT NOT NULL,
        mastery REAL NOT NULL DEFAULT 0,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        last_updated_at INTEGER NOT NULL,
        current_difficulty INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (profile_id, skill_id)
      )
    ''');
      raw.execute('''
      CREATE TABLE daily_journeys (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        profile_id INTEGER NOT NULL,
        local_date_key TEXT NOT NULL,
        current_index INTEGER NOT NULL DEFAULT 0,
        completed_count INTEGER NOT NULL DEFAULT 0,
        stars_earned INTEGER NOT NULL DEFAULT 0
      )
    ''');
      raw.execute('''
      CREATE TABLE daily_journey_items (
        journey_id INTEGER NOT NULL,
        position INTEGER NOT NULL,
        activity_id TEXT NOT NULL,
        PRIMARY KEY (journey_id, position)
      )
    ''');
      raw.execute(
        "INSERT INTO child_profiles (id, avatar_id, age_band, created_at, active) VALUES (1, 'fox', 'C', 1, 1)",
      );
      raw.execute(
        "INSERT INTO activity_progress (profile_id, activity_id, engine_type, attempts, completions, best_stars, hints_used, last_played_at, mastery_contribution, counted_as_free) VALUES (1, 'maths:v1:C:0', 'maths', 1, 1, 2, 0, 10, 3, 1)",
      );
      raw.execute('''
      CREATE TABLE local_settings (
        id INTEGER NOT NULL PRIMARY KEY,
        sound_effects_enabled INTEGER NOT NULL DEFAULT 1,
        music_enabled INTEGER NOT NULL DEFAULT 0,
        narration_enabled INTEGER NOT NULL DEFAULT 1,
        onboarding_complete INTEGER NOT NULL DEFAULT 0,
        onboarding_step INTEGER NOT NULL DEFAULT 0,
        draft_age_band TEXT,
        draft_avatar_id TEXT,
        draft_nickname TEXT
      )
    ''');
      raw.execute('PRAGMA user_version = 2');
      final database = AppDatabase(NativeDatabase.opened(raw));
      addTearDown(database.close);
      expect(database.schemaVersion, 9);
      final rows = await DriftProgressRepository(database).listForProfile(1);
      expect(rows, hasLength(1));
      expect(rows.single.activityId, 'maths:v1:C:0');
      expect(rows.single.completions, 1);
      expect(rows.single.bestStars, 2);
      expect(rows.single.countedAsFree, isTrue);
      expect(rows.single.generatorVersion, isNull);
      expect(rows.single.resultSummary, isNull);
    },
  );

  test('schema 8 keeps version 7 profiles, progress and settings and adds defaults', () async {
    final raw = sqlite3.openInMemory();
    final seed = AppDatabase(
      NativeDatabase.opened(raw, closeUnderlyingOnClose: false),
    );
    await seed.customStatement('SELECT 1');
    await seed.close();
    // Rebuild the two changed tables in their exact version 7 shape.
    raw.execute('DROP TABLE child_profiles');
    raw.execute('''
      CREATE TABLE child_profiles (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        nickname TEXT,
        avatar_id TEXT NOT NULL,
        age_band TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        active INTEGER NOT NULL DEFAULT 1
      )
    ''');
    raw.execute('DROP TABLE local_settings');
    raw.execute('''
      CREATE TABLE local_settings (
        id INTEGER NOT NULL PRIMARY KEY,
        sound_effects_enabled INTEGER NOT NULL DEFAULT 1,
        music_enabled INTEGER NOT NULL DEFAULT 0,
        narration_enabled INTEGER NOT NULL DEFAULT 1,
        onboarding_complete INTEGER NOT NULL DEFAULT 0,
        onboarding_step INTEGER NOT NULL DEFAULT 0,
        draft_age_band TEXT,
        draft_avatar_id TEXT,
        draft_nickname TEXT,
        reminders_enabled INTEGER NOT NULL DEFAULT 0,
        reminder_minutes INTEGER NOT NULL DEFAULT 960,
        reduced_motion INTEGER NOT NULL DEFAULT 0,
        session_limit_minutes INTEGER NOT NULL DEFAULT 0
      )
    ''');
    raw.execute(
      "INSERT INTO child_profiles (id, nickname, avatar_id, age_band, created_at, active) VALUES (1, 'Asha', 'fox', 'C', 1, 1)",
    );
    raw.execute(
      "INSERT INTO activity_progress (profile_id, activity_id, engine_type, attempts, completions, best_stars, hints_used, last_played_at, mastery_contribution, counted_as_free, best_score) VALUES (1, 'maths:v1:C:3', 'maths', 2, 1, 3, 0, 10, 3, 1, 90)",
    );
    raw.execute(
      'INSERT INTO local_settings (id, music_enabled, onboarding_complete, onboarding_step, reduced_motion, session_limit_minutes) VALUES (1, 1, 1, 5, 1, 15)',
    );
    raw.execute('PRAGMA user_version = 7');

    final database = AppDatabase(NativeDatabase.opened(raw));
    addTearDown(database.close);
    final profile = await DriftProfileRepository(database).getActiveProfile();
    expect(profile?.nickname, 'Asha');
    expect(profile?.ageBand, AgeBand.c);
    expect(profile?.readiness, Readiness.steady);
    final rows = await DriftProgressRepository(database).listForProfile(1);
    expect(rows.single.activityId, 'maths:v1:C:3');
    expect(rows.single.bestStars, 3);
    final settings = await DriftSettingsRepository(database).load();
    expect(settings.onboardingComplete, isTrue);
    expect(settings.musicEnabled, isTrue);
    expect(settings.reducedMotion, isTrue);
    expect(settings.sessionLimitMinutes, 15);
    expect(settings.learningRegion, isNull);
    expect(settings.interfaceLanguage, InterfaceLanguage.english);
    expect(settings.teachingLanguage, TeachingLanguage.english);
    expect(settings.hindiEnabled, isTrue);
    expect(settings.discoverIndiaEnabled, isTrue);
    expect(RegionalAvailability.available(settings), isEmpty);
  });

  test('schema 9 keeps version 8 rows and adds learning item progress', () async {
    final raw = sqlite3.openInMemory();
    final seed = AppDatabase(
      NativeDatabase.opened(raw, closeUnderlyingOnClose: false),
    );
    await seed.customStatement('SELECT 1');
    await seed.close();
    raw.execute('DROP TABLE IF EXISTS learning_item_progress');
    raw.execute(
      "INSERT INTO child_profiles (id, nickname, avatar_id, age_band, created_at, active, readiness) VALUES (1, 'Asha', 'fox', 'C', 1, 1, 'steady')",
    );
    raw.execute(
      "INSERT INTO activity_progress (profile_id, activity_id, engine_type, attempts, completions, best_stars, hints_used, last_played_at, mastery_contribution, counted_as_free, best_score) VALUES (1, 'maths:v1:C:3', 'maths', 2, 1, 3, 0, 10, 3, 1, 90)",
    );
    raw.execute('PRAGMA user_version = 8');

    final database = AppDatabase(NativeDatabase.opened(raw));
    addTearDown(database.close);
    expect(database.schemaVersion, 9);
    final rows = await DriftProgressRepository(database).listForProfile(1);
    expect(rows.single.activityId, 'maths:v1:C:3');
    expect(rows.single.bestStars, 3);
    expect(await DriftProgressRepository(database).listItemProgress(1), isEmpty);
    final tables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'learning_item_progress'",
        )
        .get();
    expect(tables, isNotEmpty);
  });
}
