import '../../models/game_result.dart';
import '../hints/hint_stage.dart';
import '../maths/maths_generator.dart';
import '../matching/matching_generator.dart';
import '../pattern/pattern_generator.dart';
import '../vocabulary/vocabulary_generator.dart';
import 'activity_definition.dart';
import 'play_checkpoint.dart';
import 'play_question.dart';

class ActivitySession {
  ActivitySession({required this.definition, required this.questions});

  final ActivityDefinition definition;
  final List<PlayQuestion> questions;

  int index = 0;
  int wrongOnQuestion = 0;
  int totalWrong = 0;
  int hintsShown = 0;
  bool acceptedCurrent = false;
  bool finished = false;
  bool instructionPulsed = false;

  void restore(ChoiceCheckpoint checkpoint) {
    index = checkpoint.index;
    wrongOnQuestion = checkpoint.wrongOnQuestion;
    totalWrong = checkpoint.totalWrong;
    hintsShown = checkpoint.hintsShown;
    acceptedCurrent = checkpoint.acceptedCurrent;
    finished = false;
    instructionPulsed = false;
  }

  ChoiceCheckpoint get choiceCheckpoint {
    return ChoiceCheckpoint(
      index: index,
      wrongOnQuestion: wrongOnQuestion,
      totalWrong: totalWrong,
      hintsShown: hintsShown,
      acceptedCurrent: acceptedCurrent,
    );
  }

  PlayQuestion get current => questions[index];

  HintStage get hintStage => hintStageForWrongCount(wrongOnQuestion);

  bool submit(String choiceId) {
    if (finished || acceptedCurrent) {
      return false;
    }
    instructionPulsed = false;
    if (choiceId == current.correctId) {
      acceptedCurrent = true;
      return true;
    }
    wrongOnQuestion += 1;
    totalWrong += 1;
    if (wrongOnQuestion == 2) {
      hintsShown += 1;
    } else if (wrongOnQuestion == 3) {
      hintsShown += 1;
    }
    return false;
  }

  /// Moves to the next question after a correct answer. Returns true when the
  /// activity is finished.
  bool advance() {
    if (!acceptedCurrent || finished) {
      return finished;
    }
    if (index + 1 >= questions.length) {
      finished = true;
      return true;
    }
    index += 1;
    wrongOnQuestion = 0;
    acceptedCurrent = false;
    return false;
  }

  void noteInactivity() {
    if (!finished) {
      instructionPulsed = true;
    }
  }

  String get generatorVersion {
    return switch (definition.category.storageKey) {
      'maths' => MathsGenerator.generatorVersion,
      'pattern' => PatternGenerator.generatorVersion,
      'matching' => MatchingGenerator.generatorVersion,
      'vocabulary' => VocabularyGenerator.generatorVersion,
      'knowledge' => 'knowledge:v1',
      _ => definition.category.storageKey,
    };
  }

  GameResult result() {
    final correctFirst = totalWrong == 0 && hintsShown == 0;
    final stars = !finished
        ? 0
        : correctFirst
        ? 3
        : hintsShown == 0
        ? 2
        : 1;
    return GameResult(
      activityId: definition.id,
      engineType: definition.category.storageKey,
      completed: finished,
      firstAttemptCorrect: correctFirst,
      hintsUsed: hintsShown,
      stars: stars,
      seed: definition.seed,
      generatorVersion: generatorVersion,
    );
  }
}
