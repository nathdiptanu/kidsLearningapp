import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/domain/learning/item_progress.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';

void main() {
  test('item progress and one badge survive a replay', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profiles = DriftProfileRepository(database);
    final progress = DriftProgressRepository(database);
    final profile = await profiles.createProfile(
      nickname: 'Asha',
      avatarId: 'fox',
      ageBand: AgeBand.c,
    );

    Future<void> save({required int hints, required int now}) {
      return progress.saveCompletion(
        profileId: profile.id,
        activityId: 'lesson:hindi:listen:a',
        category: GameCategory.hindi,
        hintsUsed: hints,
        firstAttemptCorrect: hints == 0,
        stars: 3,
        premiumActive: false,
        countTowardFree: false,
        nowMillis: now,
        recordSkill: false,
      );
    }

    await save(hints: 0, now: 10);
    await save(hints: 0, now: 20);
    final items = await progress.listItemProgress(profile.id);
    expect(items, hasLength(1));
    expect(items.single.itemId, 'letter-hi-a');
    expect(items.single.mode, PracticeMode.listen);
    expect(items.single.correct, 2);
    expect(items.single.status, ItemPracticeStatus.readyToReview);
    expect(await progress.levelBadgeCount(profile.id), 1);
    final free = await progress.uniqueFreeCompleted(
      profile.id,
      GameCategory.maths,
    );
    expect(free, 0);
  });
}
