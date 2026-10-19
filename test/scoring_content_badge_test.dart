import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/data/local/database/app_database.dart';
import 'package:sproutlab/data/repositories/drift_profile_repository.dart';
import 'package:sproutlab/data/repositories/drift_progress_repository.dart';
import 'package:sproutlab/domain/adaptive/daily_journey_planner.dart';
import 'package:sproutlab/domain/games/content/launch_manifest.dart';
import 'package:sproutlab/domain/games/knowledge/knowledge_bank.dart';
import 'package:sproutlab/domain/games/maths/maths_generator.dart';
import 'package:sproutlab/domain/games/maze/maze_generator.dart';
import 'package:sproutlab/domain/games/pattern/pattern_generator.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/scoring/activity_score.dart';

void main() {
  test('scores follow the published per-engine bands', () {
    final clean = scoreRound(
      category: GameCategory.maths,
      wrongCount: 0,
      hintsUsed: 0,
    );
    final retry = scoreRound(
      category: GameCategory.maths,
      wrongCount: 1,
      hintsUsed: 0,
    );
    final hinted = scoreRound(
      category: GameCategory.vocabulary,
      wrongCount: 1,
      hintsUsed: 1,
    );
    expect(clean.points, 10);
    expect(clean.stars, 3);
    expect(retry.points, 7);
    expect(hinted.points, 5);
    expect(
      scoreRound(
        category: GameCategory.matching,
        wrongCount: 0,
        hintsUsed: 0,
      ).points,
      12,
    );
    expect(
      scoreRound(
        category: GameCategory.maze,
        wrongCount: 2,
        hintsUsed: 0,
      ).points,
      9,
    );
    final win = scoreRound(
      category: GameCategory.ticTacToe,
      wrongCount: 0,
      hintsUsed: 0,
      outcome: RoundOutcome.win,
    );
    final draw = scoreRound(
      category: GameCategory.ticTacToe,
      wrongCount: 1,
      hintsUsed: 0,
      outcome: RoundOutcome.draw,
    );
    final loss = scoreRound(
      category: GameCategory.ticTacToe,
      wrongCount: 1,
      hintsUsed: 1,
      outcome: RoundOutcome.loss,
    );
    expect(win.mastery, isTrue);
    expect(win.points, 10);
    expect(draw.mastery, isFalse);
    expect(draw.points, 6);
    expect(loss.mastery, isFalse);
    expect(loss.points, greaterThan(0));
  });

  test('the learning library keeps 1000 generator-validated items', () {
    final manifest = const LaunchManifest().entries();
    final ids = manifest.map((entry) => entry.id).toSet();
    expect(ids, hasLength(manifest.length));
    final counts = const LaunchManifest().libraryCountsBySection();
    expect(counts['maths'], 220);
    expect(counts['english'], 152);
    expect(counts['logic'], 340);
    expect(counts['observation'], 242);
    expect(counts['knowledge'], 100);
    expect(
      counts.values.fold<int>(0, (sum, value) => sum + value),
      1054,
    );
    expect(counts.containsKey('tic_tac_toe'), isFalse);
    expect(
      manifest.where((entry) => entry.engine == 'tic_tac_toe'),
      hasLength(20),
    );
    for (final band in AgeBand.values) {
      expect(knowledgeFactsFor(band), hasLength(25));
    }
  });

  test('daily adventures do not add Tic-Tac-Toe', () {
    final plan = const DailyJourneyPlanner().plan(
      dateKey: '2026-10-02',
      band: AgeBand.b,
      records: const [],
      difficultyBySkill: const {},
    );
    expect(plan, hasLength(5));
    expect(
      plan.where((item) => item.activity.category == GameCategory.ticTacToe),
      isEmpty,
    );
  });

  test('procedural families stay valid across 1000 seeds', () {
    const maths = MathsGenerator();
    const patterns = PatternGenerator();
    const mazes = MazeGenerator();
    for (var seed = 1; seed <= 1000; seed++) {
      final band = AgeBand.values[seed % AgeBand.values.length];
      final variant = seed % 25;
      final mathsQuestion = maths
          .generate(band: band, seed: seed, variant: variant, count: 1)
          .single;
      expect(
        maths.validate(mathsQuestion, band: band).isValid,
        isTrue,
        reason: mathsQuestion.explanation,
      );
      final pattern = patterns
          .generate(band: band, seed: seed, variant: variant % 13, count: 1)
          .single;
      expect(patterns.validate(pattern, band: band).isValid, isTrue);
      final maze = mazes.generate(
        band: band,
        seed: seed,
        variant: variant % 12,
      );
      expect(maze.solvable, isTrue);
      expect(mazes.validate(maze).isValid, isTrue);
    }
    const catalog = ActivityCatalog();
    for (final activity in catalog.all()) {
      if (activity.category == GameCategory.knowledge) {
        final question = catalog.questionsFor(activity).single;
        expect(question.isValid, isTrue);
        expect(
          question.choices.where((choice) => choice.id == question.correctId),
          hasLength(1),
        );
      }
    }
  });

  test('a level badge is saved once and keeps the best score', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final profile = await DriftProfileRepository(database)
        .createProfile(avatarId: 'fox', ageBand: AgeBand.a);
    final progress = DriftProgressRepository(database);
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:A:0',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      score: 10,
      premiumActive: false,
      nowMillis: 10,
    );
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:A:0',
      category: GameCategory.maths,
      hintsUsed: 1,
      firstAttemptCorrect: false,
      stars: 1,
      score: 5,
      premiumActive: false,
      nowMillis: 20,
    );
    await progress.saveCompletion(
      profileId: profile.id,
      activityId: 'maths:v1:A:0',
      category: GameCategory.maths,
      hintsUsed: 0,
      firstAttemptCorrect: true,
      stars: 3,
      score: 10,
      premiumActive: false,
      nowMillis: 30,
    );
    expect(await progress.levelBadgeCount(profile.id), 1);
    final saved = (await progress.listForProfile(profile.id)).single;
    expect(saved.bestScore, 10);
    expect(saved.bestStars, 3);
    expect(saved.completions, 1);
    expect(saved.attempts, 3);
  });
}
