import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/content/authored_content_validator.dart';
import 'package:sproutlab/domain/games/maze/maze_generator.dart';
import 'package:sproutlab/domain/games/maths/maths_generator.dart';
import 'package:sproutlab/domain/games/pattern/pattern_generator.dart';
import 'package:sproutlab/domain/games/play/play_question.dart';
import 'package:sproutlab/domain/models/age_band.dart';

void main() {
  const casesPerEngine = 1008;

  test('maths stress: 1000+ cases stay inside the learning rules', () {
    const generator = MathsGenerator();
    final seen = <String>{};
    var count = 0;
    for (final band in AgeBand.values.where((band) => band != AgeBand.toddler)) {
      for (var variant = 0; variant < 6; variant++) {
        for (var seed = 0; seed < 42; seed++) {
          final questions = generator.generate(
            band: band,
            seed: seed,
            variant: variant,
            count: 1,
          );
          final question = questions.single;
          expect(
            generator.validate(question, band: band).isValid,
            isTrue,
            reason: '${band.name} $variant $seed ${question.explanation}',
          );
          expect(question.explanation.startsWith('fallback'), isFalse);
          _expectMathsArithmetic(question);
          if (band == AgeBand.a && variant >= 4) {
            expect(question.explanation.startsWith('numeral='), isTrue);
          }
          seen.add(question.explanation);
          count++;
        }
      }
    }
    expect(count, casesPerEngine);
    expect(count, greaterThanOrEqualTo(1000));
    expect(seen.length, greaterThan(20));
  });

  test('pattern stress: 1000+ cases have one visible continuation', () {
    const generator = PatternGenerator();
    final rules = <String>{};
    var count = 0;
    for (final band in AgeBand.values.where((band) => band != AgeBand.toddler)) {
      for (var variant = 0; variant < 6; variant++) {
        for (var seed = 0; seed < 42; seed++) {
          final question = generator
              .generate(band: band, seed: seed, variant: variant, count: 1)
              .single;
          expect(
            generator.validate(question, band: band).isValid,
            isTrue,
            reason: '${band.name} $variant $seed ${question.explanation}',
          );
          expect(question.explanation.startsWith('fallback'), isFalse);
          _expectPatternContinuation(question);
          rules.add(question.explanation.split(' ').first);
          count++;
        }
      }
    }
    expect(count, casesPerEngine);
    expect(rules, contains('rule=ab'));
    expect(rules, contains('rule=alternatingSize'));
    expect(rules, contains('rule=alternatingDirection'));
    expect(rules, contains('rule=multiAttribute'));
  });

  test('maze stress: 1000+ mazes stay bounded and solvable', () {
    const generator = MazeGenerator();
    var count = 0;
    for (final band in AgeBand.values.where((band) => band != AgeBand.toddler)) {
      for (var variant = 0; variant < 6; variant++) {
        for (var seed = 0; seed < 42; seed++) {
          final maze = generator.generate(
            band: band,
            seed: seed,
            variant: variant,
          );
          final again = generator.generate(
            band: band,
            seed: seed,
            variant: variant,
          );
          expect(generator.validate(maze).isValid, isTrue);
          expect(
            maze.stepsTowardGoal(maze.start, maze.rows * maze.cols),
            again.stepsTowardGoal(again.start, again.rows * again.cols),
          );
          expect(maze.stepsTowardGoal(maze.start, 1), isNotEmpty);
          count++;
        }
      }
    }
    expect(count, casesPerEngine);
  });

  test('authored matching, vocabulary and differences pass review', () {
    expect(const AuthoredContentValidator().validate(), isEmpty);
  });
}

void _expectMathsArithmetic(PlayQuestion question) {
  final sum = RegExp(r'^(\d+)\+(\d+)=(\d+)$').firstMatch(question.explanation);
  if (sum != null) {
    final left = int.parse(sum.group(1)!);
    final right = int.parse(sum.group(2)!);
    final answer = int.parse(sum.group(3)!);
    expect(left + right, answer);
    expect(question.correctId, 'n$answer');
  }
  final difference = RegExp(r'^(\d+)-(\d+)=(\d+)$')
      .firstMatch(question.explanation);
  if (difference != null) {
    final left = int.parse(difference.group(1)!);
    final right = int.parse(difference.group(2)!);
    final answer = int.parse(difference.group(3)!);
    expect(left - right, answer);
    expect(answer, greaterThanOrEqualTo(0));
  }
  final labels = question.choices.map((choice) => choice.label).toSet();
  expect(labels, hasLength(question.choices.length));
}

void _expectPatternContinuation(PlayQuestion question) {
  if (question.explanation.startsWith('rule=ab ')) {
    final first = question.promptVisuals.whereType<SymbolVisual>().first;
    expect(question.correctId, first.symbol.name);
  }
  if (question.explanation.startsWith('rule=numeric ')) {
    final shown = question.prompt
        .replaceAll(', ?', '')
        .split(', ')
        .map(int.parse)
        .toList();
    final step = shown[1] - shown[0];
    expect(int.parse(question.correctId.substring(1)), shown.last + step);
  }
  if (question.explanation.startsWith('rule=alternatingSize ') ||
      question.explanation.startsWith('rule=multiAttribute ')) {
    final visuals = question.promptVisuals.whereType<SymbolVisual>().toList();
    expect(visuals.first.scale, isNot(visuals[1].scale));
    expect(question.correctId.startsWith('large_'), isTrue);
  }
  if (question.explanation.startsWith('rule=alternatingDirection ')) {
    final visuals = question.promptVisuals.whereType<SymbolVisual>().toList();
    expect(visuals.first.heading, isNot(visuals[1].heading));
    expect(question.correctId, 'up');
  }
}
