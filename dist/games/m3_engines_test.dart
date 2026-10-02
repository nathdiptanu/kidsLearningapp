import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/find_difference/difference_catalog.dart';
import 'package:sproutlab/domain/games/maze/maze_generator.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/games/vocabulary/vocabulary_generator.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';

void main() {
  test('mazes are solvable and block walls for many seeds', () {
    const generator = MazeGenerator();
    for (final band in AgeBand.values) {
      for (var variant = 0; variant < 6; variant++) {
        for (final seed in [1, 7, 19, 40, 88]) {
          final first = generator.generate(
            band: band,
            seed: seed + variant,
            variant: variant,
          );
          final second = generator.generate(
            band: band,
            seed: seed + variant,
            variant: variant,
          );
          expect(first.solvable, isTrue);
          expect(first.rows, second.rows);
          expect(_wallBits(first), _wallBits(second));
          _expectWallsBlock(first);
          _expectPathReachesGoal(first);
        }
      }
    }
  });

  test('vocabulary answers are unique and reviewed', () {
    const generator = VocabularyGenerator();
    const catalog = ActivityCatalog();
    final ids = vocabWords.map((word) => word.id).toSet();
    expect(ids.length, vocabWords.length);
    for (final word in vocabWords) {
      expect(word.label.contains('color'), isFalse);
      expect(word.id, isNot(contains(' ')));
    }
    for (final band in AgeBand.values) {
      for (final activity in catalog.forBand(GameCategory.vocabulary, band)) {
        final questions = generator.generate(
          band: band,
          seed: activity.seed,
          variant: activity.variant,
          count: activity.questionCount,
        );
        expect(questions, isNotEmpty);
        for (final question in questions) {
          expect(question.isValid, isTrue);
          expect(question.explanation.contains('fallback'), isFalse);
          final labels = question.choices.map((choice) => choice.label).toSet();
          expect(labels.length, question.choices.length);
          if (question.explanation.startsWith('first-letter')) {
            expect(band, isNot(AgeBand.a));
            final answer = question.explanation.split('=').last;
            expect(question.correctId, 'letter_$answer');
          }
          if (question.explanation.startsWith('picture-to-word') ||
              question.explanation.startsWith('word-to-picture')) {
            final wordId = question.explanation.split(' ').last;
            expect(ids.contains(wordId), isTrue);
          }
        }
      }
    }
  });

  test('difference hits scale, ignore repeats, and complete once', () {
    const catalog = DifferenceCatalog();
    expect(differenceScenes.length, greaterThanOrEqualTo(5));
    final ids = differenceScenes.map((scene) => scene.id).toSet();
    expect(ids.length, differenceScenes.length);
    for (final band in AgeBand.values) {
      for (var variant = 0; variant < differenceScenes.length; variant++) {
        final active = catalog.activeSpots(band, variant);
        expect(active.length, catalog.countFor(band));
        expect(
          catalog.regionsStaySeparate(active, catalog.padFor(band)),
          isTrue,
        );
        final marked = <String>{};
        final spot = active.first;
        final inside = spot.region.center;
        final first = catalog.hitTest(
          point: inside,
          active: active,
          marked: marked,
          pad: catalog.padFor(band),
        );
        expect(first.spotId, spot.id);
        expect(first.alreadyMarked, isFalse);
        marked.add(spot.id);
        final repeat = catalog.hitTest(
          point: inside,
          active: active,
          marked: marked,
          pad: catalog.padFor(band),
        );
        expect(repeat.alreadyMarked, isTrue);
        expect(marked.length, 1);
        final outside = catalog.hitTest(
          point: const Offset(0.5, 0.02),
          active: active,
          marked: marked,
          pad: catalog.padFor(band),
        );
        expect(outside.missed, isTrue);
        for (final remaining in active.skip(1)) {
          final hit = catalog.hitTest(
            point: remaining.region.center,
            active: active,
            marked: marked,
            pad: catalog.padFor(band),
          );
          expect(hit.alreadyMarked, isFalse);
          marked.add(hit.spotId!);
        }
        expect(marked.length, active.length);
      }
    }
  });
}

String _wallBits(MazeLevel maze) {
  final buffer = StringBuffer();
  for (final cell in maze.cells) {
    buffer.write(cell.north ? 'N' : '-');
    buffer.write(cell.east ? 'E' : '-');
    buffer.write(cell.south ? 'S' : '-');
    buffer.write(cell.west ? 'W' : '-');
  }
  return buffer.toString();
}

void _expectWallsBlock(MazeLevel maze) {
  for (var row = 0; row < maze.rows; row++) {
    for (var col = 0; col < maze.cols; col++) {
      final point = MazePoint(row, col);
      final cell = maze.cell(point);
      if (cell.north) {
        expect(maze.canStep(point, MazePoint(row - 1, col)), isFalse);
      }
      if (cell.south) {
        expect(maze.canStep(point, MazePoint(row + 1, col)), isFalse);
      }
      if (cell.east) {
        expect(maze.canStep(point, MazePoint(row, col + 1)), isFalse);
      }
      if (cell.west) {
        expect(maze.canStep(point, MazePoint(row, col - 1)), isFalse);
      }
    }
  }
}

void _expectPathReachesGoal(MazeLevel maze) {
  var cursor = maze.start;
  final seen = <MazePoint>{cursor};
  while (cursor != maze.goal) {
    final next = maze.nextTowardGoal[cursor.key(maze.cols)];
    expect(next, isNotNull);
    expect(maze.canStep(cursor, next!), isTrue);
    expect(seen.add(next), isTrue);
    cursor = next;
  }
}
