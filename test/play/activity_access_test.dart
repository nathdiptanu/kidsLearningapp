import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/games/vocabulary/vocabulary_generator.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';
import 'package:sproutlab/domain/monetization/free_entitlement_policy.dart';
import 'package:sproutlab/domain/monetization/monetization_config.dart';
import 'package:sproutlab/domain/progress/activity_record.dart';
import 'package:sproutlab/features/play/activity_access.dart';

void main() {
  const catalog = ActivityCatalog();

  ActivityRecord finished(String id, String engine) {
    return ActivityRecord(
      activityId: id,
      engineType: engine,
      attempts: 1,
      completions: 1,
      bestStars: 3,
      hintsUsed: 0,
      lastPlayedAt: 1,
      countedAsFree: true,
    );
  }

  test('catalog engines open the next level only after the previous finish', () {
    expect(MonetizationConfig.unlockAllGames, isFalse);
    for (final category in [
      GameCategory.maths,
      GameCategory.vocabulary,
      GameCategory.knowledge,
      GameCategory.pattern,
      GameCategory.maze,
      GameCategory.matching,
      GameCategory.connectDots,
    ]) {
      final first = catalog.forBand(category, AgeBand.c).first;
      final second = catalog.forBand(category, AgeBand.c)[1];
      expect(first.variant, 0);
      expect(
        accessFor(activity: first, records: const [], premiumActive: true).access,
        LevelAccess.playNew,
      );
      expect(
        accessFor(activity: second, records: const [], premiumActive: true)
            .sequential,
        isTrue,
      );
      expect(
        accessFor(activity: second, records: const [], premiumActive: true)
            .access,
        LevelAccess.locked,
      );
      final opened = accessFor(
        activity: second,
        records: [finished(first.id, category.storageKey)],
        premiumActive: true,
      );
      expect(opened.sequential, isFalse);
      expect(opened.access, LevelAccess.playNew);
    }
  });

  test('grammar choices keep one answer id after rotation', () {
    const generator = VocabularyGenerator();
    for (var variant = 38; variant < 88; variant++) {
      for (var seed = 0; seed < 6; seed++) {
        final question = generator
            .generate(
              band: AgeBand.c,
              seed: seed,
              variant: variant,
              count: 1,
            )
            .single;
        expect(question.isValid, isTrue, reason: question.prompt);
        expect(
          question.choices.where((choice) => choice.id == 'answer'),
          hasLength(1),
        );
      }
    }
  });
}
