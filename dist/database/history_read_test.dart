import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/data/repositories/drift_reward_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';

void main() {
  test('a long activity history still reads in one bounded query', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profile = await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.c);
    const rows = 200;
    await database.batch((batch) {
      batch.insertAll(database.activityProgress, [
        for (var index = 0; index < rows; index++)
          ActivityProgressCompanion.insert(
            profileId: profile.id,
            activityId: 'history:$index',
            engineType: 'maths',
            lastPlayedAt: 1_000 + index,
            completions: const Value(1),
            bestStars: const Value(2),
            countedAsFree: Value(index < 5),
          ),
      ]);
    });
    final progress = DriftProgressRepository(database);
    final rewards = DriftRewardRepository(database);
    final watch = Stopwatch()..start();
    final listed = await progress.listForProfile(profile.id);
    final report = await rewards.parentReport(
      profile.id,
      DateTime.fromMillisecondsSinceEpoch(2_000),
    );
    watch.stop();
    expect(listed, hasLength(rows));
    expect(report.recent, hasLength(20));
    expect(report.finishedActivities, rows);
    expect(watch.elapsedMilliseconds, lessThan(1500));
    // Local SQLite timing on the test machine. Not a device frame measurement.
    // ignore: avoid_print
    print('M10_HISTORY_MS=${watch.elapsedMilliseconds} rows=$rows');
  });
}
