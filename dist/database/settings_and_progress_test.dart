import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_settings_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('sound defaults and onboarding survive a new repository', () async {
    final first = DriftSettingsRepository(database);
    final loaded = await first.load();
    expect(loaded.soundEffectsEnabled, isTrue);
    expect(loaded.musicEnabled, isFalse);
    expect(loaded.narrationEnabled, isTrue);
    expect(loaded.onboardingComplete, isFalse);
    await first.save(
      loaded.copyWith(
        musicEnabled: true,
        onboardingStep: 3,
        draftAgeBand: AgeBand.c,
        onboardingComplete: false,
      ),
    );
    final second = DriftSettingsRepository(database);
    final again = await second.load();
    expect(again.musicEnabled, isTrue);
    expect(again.onboardingStep, 3);
    expect(again.draftAgeBand, AgeBand.c);
    expect(again, isA<LocalSettings>());
  });

  test(
    'a completion is stored once and a replay does not add another',
    () async {
      final profiles = DriftProfileRepository(database);
      final profile = await profiles.createProfile(
        avatarId: 'sprout',
        ageBand: AgeBand.a,
      );
      final progress = DriftProgressRepository(database);
      final first = await progress.saveCompletion(
        profileId: profile.id,
        activityId: 'maths:v1:A:0',
        category: GameCategory.maths,
        hintsUsed: 1,
        firstAttemptCorrect: false,
        stars: 1,
        premiumActive: false,
        nowMillis: 10,
      );
      expect(first.completions, 1);
      expect(first.countedAsFree, isTrue);
      final replay = await progress.saveCompletion(
        profileId: profile.id,
        activityId: 'maths:v1:A:0',
        category: GameCategory.maths,
        hintsUsed: 0,
        firstAttemptCorrect: true,
        stars: 3,
        premiumActive: false,
        nowMillis: 20,
      );
      expect(replay.completions, 1);
      expect(replay.lastPlayedAt, 20);
      expect(
        await progress.uniqueFreeCompleted(profile.id, GameCategory.maths),
        1,
      );
      final rows = await progress.listForProfile(profile.id);
      expect(rows, hasLength(1));
    },
  );

  test(
    'the sixth new maths completion is not counted as another free level',
    () async {
      final profiles = DriftProfileRepository(database);
      final profile = await profiles.createProfile(
        avatarId: 'sprout',
        ageBand: AgeBand.b,
      );
      final progress = DriftProgressRepository(database);
      for (var index = 0; index < 5; index++) {
        await progress.saveCompletion(
          profileId: profile.id,
          activityId: 'maths:v1:B:$index',
          category: GameCategory.maths,
          hintsUsed: 0,
          firstAttemptCorrect: true,
          stars: 3,
          premiumActive: false,
          nowMillis: index,
        );
      }
      final sixth = await progress.saveCompletion(
        profileId: profile.id,
        activityId: 'maths:v1:B:5',
        category: GameCategory.maths,
        hintsUsed: 0,
        firstAttemptCorrect: true,
        stars: 3,
        premiumActive: false,
        nowMillis: 6,
      );
      expect(sixth.countedAsFree, isFalse);
      expect(
        await progress.uniqueFreeCompleted(profile.id, GameCategory.maths),
        5,
      );
    },
  );

  test('changing the learning band keeps finished activities', () async {
    final profiles = DriftProfileRepository(database);
    final profile = await profiles.createProfile(
      avatarId: 'owl',
      ageBand: AgeBand.a,
      nickname: 'Mini',
    );
    final progress = DriftProgressRepository(database);
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'pattern:v1:A:0',
      category: GameCategory.pattern,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
    );
    final updated = await profiles.updateActiveProfile(
      avatarId: 'owl',
      ageBand: AgeBand.d,
      nickname: 'Mini',
    );
    expect(updated.ageBand, AgeBand.d);
    final rows = await progress.listForProfile(profile.id);
    expect(rows.single.completions, 1);
  });

  test('a new seed does not replace history or add a free level', () async {
    final profiles = DriftProfileRepository(database);
    final profile = await profiles.createProfile(
      avatarId: 'star',
      ageBand: AgeBand.c,
    );
    final progress = DriftProgressRepository(database);
    final first = await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:C:0',
      category: GameCategory.maths,
      hintsUsed: 1,
      firstAttemptCorrect: false,
      stars: 1,
      premiumActive: false,
      nowMillis: 20,
      generatorType: 'maths',
      generatorVersion: 'maths:v1',
      seed: 101,
      skillId: 'maths',
    );
    expect(first.seed, 101);
    expect(
      first.resultSummary,
      'stars=1;hints=1;first=false;score=0;outcome=complete',
    );
    final replay = await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:C:0',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
      nowMillis: 30,
      generatorType: 'maths',
      generatorVersion: 'maths:v2',
      seed: 999,
      skillId: 'maths',
    );
    expect(replay.completions, 1);
    expect(replay.seed, 101);
    expect(replay.generatorVersion, 'maths:v1');
    expect(
      replay.resultSummary,
      'stars=1;hints=1;first=false;score=0;outcome=complete',
    );
    expect(
      await progress.uniqueFreeCompleted(profile.id, GameCategory.maths),
      1,
    );
    final listed = await progress.listForProfile(profile.id);
    expect(listed.single.resultSummary, isNotNull);
  });
}
