import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/hints/hint_stage.dart';
import 'package:sproutlab/domain/games/matching/matching_generator.dart';
import 'package:sproutlab/domain/games/maths/maths_generator.dart';
import 'package:sproutlab/domain/games/pattern/pattern_generator.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/games/play/activity_session.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';

void main() {
  test('hints follow a retry, then a hint, then a stronger hint', () {
    expect(hintStageForWrongCount(0), HintStage.none);
    expect(hintStageForWrongCount(1), HintStage.retryOnly);
    expect(hintStageForWrongCount(2), HintStage.firstHint);
    expect(hintStageForWrongCount(3), HintStage.strongerHint);
    final pulse = InstructionPulse();
    pulse.noteInactivity();
    expect(pulse.pulsed, isTrue);
    expect(hintStageForWrongCount(0), HintStage.none);
  });

  test(
    'every learning band gets valid maths, pattern and matching questions',
    () {
      const catalog = ActivityCatalog();
      for (final band in AgeBand.values) {
        for (final category in const [
          GameCategory.maths,
          GameCategory.pattern,
          GameCategory.matching,
        ]) {
          final activities = catalog.forBand(category, band);
          expect(activities, hasLength(activitiesInBand(category)));
          for (final activity in activities) {
            final questions = catalog.questionsFor(activity);
            expect(questions, isNotEmpty);
            for (final question in questions) {
              expect(question.isValid, isTrue, reason: question.explanation);
              expect(question.explanation.contains('fallback'), isFalse);
              final labels = question.choices
                  .map((choice) => choice.label)
                  .toList();
              expect(labels.toSet(), hasLength(labels.length));
            }
          }
        }
      }
    },
  );

  test('maths answers are unique and young bands have no negatives', () {
    const generator = MathsGenerator();
    for (final band in AgeBand.values) {
      for (var variant = 0; variant < 6; variant++) {
        final questions = generator.generate(
          band: band,
          seed: 40 + variant,
          variant: variant,
        );
        for (final question in questions) {
          expect(
            question.choices.where((choice) => choice.id == question.correctId),
            hasLength(1),
          );
          if (band == AgeBand.a || band == AgeBand.b) {
            expect(question.explanation.contains('-'), isFalse);
          }
        }
      }
    }
  });

  test('odd-one-out templates have one clear outsider', () {
    for (final template in oddTemplates) {
      expect(template.isUnambiguous, isTrue, reason: template.id);
    }
    const generator = MatchingGenerator();
    for (final band in AgeBand.values) {
      final questions = generator.generate(band: band, variant: 0);
      expect(
        questions.first.choices.map((choice) => choice.label).toSet().length,
        questions.first.choices.length,
      );
    }
  });

  test('a wrong answer does not finish the activity and a replay result stays one completion', () {
    const catalog = ActivityCatalog();
    final activity = catalog.forBand(GameCategory.pattern, AgeBand.a).first;
    final session = ActivitySession(
      definition: activity,
      questions: catalog.questionsFor(activity),
    );
    final wrong = session.current.choices.firstWhere(
      (choice) => choice.id != session.current.correctId,
    );
    expect(session.submit(wrong.id), isFalse);
    expect(session.finished, isFalse);
    expect(session.hintStage, HintStage.retryOnly);
    expect(session.submit(session.current.correctId), isTrue);
    while (!session.finished) {
      if (!session.acceptedCurrent) {
        session.submit(session.current.correctId);
      }
      session.advance();
    }
    expect(session.result().completed, isTrue);
    expect(session.result().firstAttemptCorrect, isFalse);
  });

  test('pattern choices contain the intended answer once', () {
    const generator = PatternGenerator();
    for (final band in AgeBand.values) {
      final questions = generator.generate(
        band: band,
        seed: 7,
        variant: band.index,
      );
      for (final question in questions) {
        expect(
          question.choices.where((choice) => choice.id == question.correctId),
          hasLength(1),
        );
      }
    }
  });
}
