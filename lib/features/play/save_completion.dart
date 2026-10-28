import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/audio_controller.dart';

import '../../app/session_providers.dart';
import '../../domain/games/find_objects/find_objects_catalog.dart';
import '../../domain/games/knowledge/knowledge_bank.dart';
import '../../domain/games/matching/matching_generator.dart';
import '../../domain/games/maths/maths_generator.dart';
import '../../domain/games/maze/maze_generator.dart';
import '../../domain/games/pattern/pattern_generator.dart';
import '../../domain/games/play/activity_definition.dart';
import '../../domain/games/play/activity_skill.dart';
import '../../domain/games/tictactoe/tic_tac_toe.dart';
import '../../domain/games/vocabulary/vocabulary_generator.dart';
import '../../domain/models/game_category.dart';
import '../../domain/scoring/activity_score.dart';

Future<void> saveFinishedActivity(
  WidgetRef ref, {
  required ActivityDefinition activity,
  required int hintsUsed,
  required bool firstAttemptCorrect,
  required int stars,
  int wrongCount = 0,
  String? journeyDate,
  RoundOutcome outcome = RoundOutcome.complete,
}) async {
  final profile = (await ref.read(sessionProvider.future)).profile;
  if (profile == null) {
    return;
  }
  final version = switch (activity.category) {
    GameCategory.maths => MathsGenerator.generatorVersion,
    GameCategory.pattern => PatternGenerator.generatorVersion,
    GameCategory.matching => MatchingGenerator.generatorVersion,
    GameCategory.vocabulary => VocabularyGenerator.generatorVersion,
    GameCategory.maze => MazeGenerator.generatorVersion,
    GameCategory.findDifference => 'find_difference:v1',
    GameCategory.findObjects => FindObjectsCatalog.generatorVersion,
    GameCategory.connectDots => 'connect_dots:v1',
    GameCategory.knowledge => KnowledgeGenerator.generatorVersion,
    GameCategory.ticTacToe => TicTacToeEngine.generatorVersion,
    GameCategory.hindi => 'hindi:v1',
    GameCategory.discoverIndia => 'discover_india:v1',
  };
  final scored = scoreRound(
    category: activity.category,
    wrongCount: wrongCount,
    hintsUsed: hintsUsed,
    outcome: outcome,
  );
  await ref
      .read(progressRepositoryProvider)
      .saveCompletion(
        profileId: profile.id,
        activityId: activity.id,
        category: activity.category,
        hintsUsed: hintsUsed,
        firstAttemptCorrect: firstAttemptCorrect,
        stars: stars,
        score: scored.points,
        outcome: scored.outcome.name,
        recordSkill: activity.category != GameCategory.ticTacToe,
        countTowardFree:
            activity.category != GameCategory.hindi &&
            activity.category != GameCategory.discoverIndia &&
            !activity.id.startsWith('lesson:') &&
            !activity.id.startsWith('geo:') &&
            !activity.id.startsWith('heritage:'),
        premiumActive: ref.read(premiumActiveProvider),
        generatorType: activity.category.storageKey,
        generatorVersion: version,
        seed: activity.seed,
        skillId: skillForCategory(activity.category),
        wrongCount: wrongCount,
        journeyDate: journeyDate,
      );
  ref.invalidate(progressListProvider);
  ref.invalidate(itemProgressProvider);
  ref.invalidate(dailyJourneyProvider);
  ref.invalidate(rewardShelfProvider);
  ref.invalidate(parentReportProvider);
  final rewards = ref.read(progressRepositoryProvider).rewardsAwardedByLastSave;
  ref.read(freshRewardIdsProvider.notifier).replace(rewards);
  final effect = rewards.isEmpty ? SoundEffect.complete : SoundEffect.reward;
  unawaited(ref.read(audioControllerProvider).playEffect(effect));
}

Future<String?> loadCheckpoint(WidgetRef ref, String activityId) async {
  final profile = (await ref.read(sessionProvider.future)).profile;
  if (profile == null) {
    return null;
  }
  return ref
      .read(progressRepositoryProvider)
      .readCheckpoint(profile.id, activityId);
}

Future<void> skipJourneyActivity(
  WidgetRef ref,
  String activityId,
  String? journeyDate,
) async {
  if (journeyDate == null) return;
  final profile = ref.read(sessionProvider).value?.profile;
  if (profile == null) return;
  await ref
      .read(journeyRepositoryProvider)
      .markSkipped(
        profileId: profile.id,
        dateKey: journeyDate,
        activityId: activityId,
      );
  ref.invalidate(dailyJourneyProvider);
}

Future<void> storeCheckpoint(
  WidgetRef ref,
  String activityId,
  String payload,
) async {
  final profile = (await ref.read(sessionProvider.future)).profile;
  if (profile == null) {
    return;
  }
  await ref
      .read(progressRepositoryProvider)
      .writeCheckpoint(
        profileId: profile.id,
        activityId: activityId,
        payload: payload,
      );
}

Future<void> deleteCheckpoint(WidgetRef ref, String activityId) async {
  final profile = (await ref.read(sessionProvider.future)).profile;
  if (profile == null) {
    return;
  }
  await ref
      .read(progressRepositoryProvider)
      .deleteCheckpoint(profile.id, activityId);
}

int starsForPlay({required int wrongCount, required int hintsUsed}) {
  if (wrongCount == 0 && hintsUsed == 0) {
    return 3;
  }
  if (hintsUsed == 0) {
    return 2;
  }
  return 1;
}
