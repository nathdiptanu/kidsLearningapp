import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/app/bootstrap_state.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/data/repositories/drift_reward_repository.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/parent/parent_report.dart';
import 'package:sproutlab/domain/rewards/reward_catalog.dart';
import 'package:sproutlab/domain/rewards/reward_snapshot.dart';
import 'package:sproutlab/features/parent/grown_up_settings_screen.dart';
import 'package:sproutlab/features/parent/parent_dashboard_screen.dart';

void main() {
  test('catalog has 24 stickers and the required badges', () {
    final stickers = [
      for (final reward in rewardCatalog)
        if (reward.kind == RewardKind.sticker) reward.id,
    ];
    expect(stickers.toSet(), hasLength(24));
    expect(stickers, hasLength(24));
    expect(
      rewardCatalog.map((reward) => reward.id).toSet(),
      hasLength(rewardCatalog.length),
    );
    expect(
      rewardCatalog.where((reward) => reward.kind == RewardKind.badge).length,
      8,
    );
  });

  test('badge thresholds are exact below, at and above the line', () {
    void boundary({
      required String id,
      required int target,
      required RewardSnapshot Function(int value) at,
    }) {
      expect(earnedRewardIds(at(target - 1)), isNot(contains(id)));
      expect(earnedRewardIds(at(target)), contains(id));
      expect(earnedRewardIds(at(target + 1)), contains(id));
    }

    boundary(
      id: 'badge_first_adventure',
      target: 1,
      at: (value) => RewardSnapshot(completedJourneys: value),
    );
    boundary(
      id: 'badge_maze_explorer',
      target: 10,
      at: (value) => RewardSnapshot(
        completionsByEngine: {GameCategory.maze.storageKey: value},
      ),
    );
    boundary(
      id: 'badge_number_star',
      target: 20,
      at: (value) => RewardSnapshot(
        completionsByEngine: {GameCategory.maths.storageKey: value},
      ),
    );
    boundary(
      id: 'badge_word_wizard',
      target: 20,
      at: (value) => RewardSnapshot(
        completionsByEngine: {GameCategory.vocabulary.storageKey: value},
      ),
    );
    boundary(
      id: 'badge_pattern_detective',
      target: 15,
      at: (value) => RewardSnapshot(
        completionsByEngine: {GameCategory.pattern.storageKey: value},
      ),
    );
    boundary(
      id: 'badge_observation_hero',
      target: 10,
      at: (value) => RewardSnapshot(
        completionsByEngine: {GameCategory.findDifference.storageKey: value},
      ),
    );
    boundary(
      id: 'badge_matching_master',
      target: 15,
      at: (value) => RewardSnapshot(
        completionsByEngine: {GameCategory.matching.storageKey: value},
      ),
    );
    boundary(
      id: 'badge_five_day_learner',
      target: 5,
      at: (value) => RewardSnapshot(distinctDays: value),
    );
    expect(
      earnedRewardIds(const RewardSnapshot(completionsByEngine: {'maze': 15})),
      isNot(contains('badge_pattern_detective')),
    );
  });

  test(
    'practice days keep gaps and ignore a second session on the same day',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final profile = await DriftProfileRepository(database)
          .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
      final rewards = DriftRewardRepository(database);
      final days = [
        DateTime(2026, 1, 1, 9),
        DateTime(2026, 1, 1, 18),
        DateTime(2026, 1, 3, 9),
        DateTime(2026, 1, 4, 9),
        DateTime(2026, 1, 8, 9),
        DateTime(2026, 1, 9, 9),
      ];
      for (final day in days) {
        await rewards.notePracticeDay(
          profileId: profile.id,
          playedAtMillis: day.millisecondsSinceEpoch,
        );
      }
      final snapshot = await rewards.snapshot(profile.id);
      expect(snapshot.distinctDays, 5);
      expect(earnedRewardIds(snapshot), contains('badge_five_day_learner'));
      final first = await rewards.reconcile(profile.id, nowMillis: 100);
      final second = await rewards.reconcile(profile.id, nowMillis: 200);
      expect(first, contains('badge_five_day_learner'));
      expect(second, isEmpty);
      final stored = await rewards.listRewards(profile.id);
      final badge = stored.singleWhere(
        (row) => row.rewardId == 'badge_five_day_learner',
      );
      expect(badge.unlockedAt, 100);
    },
  );

  test('replay does not add a reward or another completion', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profile = await DriftProfileRepository(database)
        .createProfile(avatarId: 'sprout', ageBand: AgeBand.b);
    final progress = DriftProgressRepository(database);
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:B:0',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
      nowMillis: 10,
    );
    final firstAwards = progress.rewardsAwardedByLastSave.toSet();
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:B:0',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      premiumActive: false,
      nowMillis: 20,
    );
    expect(progress.rewardsAwardedByLastSave, isEmpty);
    final record = (await progress.listForProfile(profile.id)).single;
    expect(record.completions, 1);
    expect(record.attempts, 2);
    final rewards = await DriftRewardRepository(database)
        .listRewards(profile.id);
    expect(rewards.map((row) => row.rewardId).toSet(), firstAwards);
    expect(
      rewards
          .singleWhere((row) => row.rewardId == 'sticker_maths_one')
          .unlockedAt,
      10,
    );
    final changed = await DriftProfileRepository(database)
        .updateActiveProfile(avatarId: 'sprout', ageBand: AgeBand.d);
    expect(changed.ageBand, AgeBand.d);
    final kept = await DriftRewardRepository(database).listRewards(profile.id);
    expect(kept, hasLength(rewards.length));
  });

  test(
    'dashboard counts match a known history and stay empty without one',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final profiles = DriftProfileRepository(database);
      final profile = await profiles.createProfile(
        avatarId: 'fox',
        ageBand: AgeBand.c,
      );
      final rewards = DriftRewardRepository(database);
      final empty = await rewards.parentReport(
        profile.id,
        DateTime(2026, 9, 30, 12),
      );
      expect(empty.finishedActivities, 0);
      expect(empty.recent, isEmpty);
      expect(
        skillSummary(
          const SkillPractice(
            skillId: 'maths',
            attempts: 0,
            firstTry: 0,
            hintAssisted: 0,
            incorrect: 0,
            difficulty: 1,
            recentOutcomes: '',
          ),
        ),
        'No finished practice yet.',
      );

      final progress = DriftProgressRepository(database);
      await progress.saveCompletion(
        profileId: profile.id,
        activityId: 'maths:v1:C:0',
        category: GameCategory.maths,
        hintsUsed: 1,
        firstAttemptCorrect: false,
        stars: 1,
        premiumActive: false,
        nowMillis: DateTime(2026, 9, 28, 10).millisecondsSinceEpoch,
      );
      await progress.saveCompletion(
        profileId: profile.id,
        activityId: 'maths:v1:A:1',
        category: GameCategory.maths,
        hintsUsed: 0,
        firstAttemptCorrect: true,
        stars: 3,
        premiumActive: false,
        nowMillis: DateTime(2026, 9, 30, 10).millisecondsSinceEpoch,
      );
      await progress.saveCompletion(
        profileId: profile.id,
        activityId: 'maths:v1:A:1',
        category: GameCategory.maths,
        hintsUsed: 0,
        firstAttemptCorrect: true,
        stars: 3,
        premiumActive: false,
        nowMillis: DateTime(2026, 9, 30, 11).millisecondsSinceEpoch,
      );
      final report = await rewards.parentReport(
        profile.id,
        DateTime(2026, 9, 30, 12),
      );
      expect(report.finishedActivities, 2);
      expect(report.timesPlayed, 3);
      expect(report.practicedToday, 1);
      expect(report.practicedThisWeek, 2);
      expect(report.categoryCounts['maths'], 2);
      expect(report.totalStars, 4);
      expect(report.recent, hasLength(2));
      expect(report.learningDays, 2);
      final maths = report.skills.singleWhere(
        (skill) => skill.skillId == 'maths',
      );
      expect(maths.firstTry, 1);
      expect(maths.hintAssisted, 1);
      expect(maths.attempts, 2);
      expect(skillSummary(maths), contains('1 were correct on the first try'));
      expect(skillSummary(maths), contains('1 used a hint'));
      expect(skillSummary(maths), isNot(contains('%')));
    },
  );

  testWidgets('the learning summary stays behind the hold', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ParentDashboardScreen())),
    );
    expect(find.text('Parents: press and hold for 3 seconds.'), findsOneWidget);
    expect(find.text('No finished activities yet.'), findsNothing);
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: GrownUpSettingsScreen())),
    );
    expect(find.text('Open learning summary'), findsNothing);
    expect(find.text('Parents: press and hold for 3 seconds.'), findsOneWidget);
    expect(find.textContaining('199'), findsNothing);
  });

  testWidgets('holding for 3 seconds opens grown-up settings', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapStateProvider.overrideWithValue(const BootstrapReady()),
          databaseProvider.overrideWith((ref) => database),
        ],
        child: const MaterialApp(home: ParentDashboardScreen()),
      ),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Hold')),
    );
    await tester.pump(const Duration(seconds: 4));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.text('No finished activities yet.'), findsOneWidget);
    expect(find.text(ParentReport.disclaimer), findsOneWidget);
  });
}
