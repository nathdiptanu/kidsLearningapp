import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/find_objects/find_objects_catalog.dart';
import 'package:sproutlab/domain/games/maze/maze_generator.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';

void main() {
  test('find-object scenes keep separate hit regions', () {
    const catalog = FindObjectsCatalog();
    expect(findObjectScenes, hasLength(20));
    for (final band in AgeBand.values) {
      for (var variant = 0; variant < findObjectScenes.length; variant++) {
        final targets = catalog.targetsFor(band, variant);
        expect(targets, isNotEmpty);
        expect(catalog.regionsStaySeparate(targets, catalog.padFor(band)), isTrue);
        final first = targets.first;
        final hit = catalog.hitTest(
          point: first.region.center,
          targets: targets,
          found: {},
          pad: catalog.padFor(band),
        );
        expect(hit.objectId, first.id);
        expect(hit.alreadyFound, isFalse);
        final again = catalog.hitTest(
          point: first.region.center,
          targets: targets,
          found: {first.id},
          pad: catalog.padFor(band),
        );
        expect(again.alreadyFound, isTrue);
      }
    }
  });

  test('maze seeds stay solvable and record path metrics', () {
    const mazes = MazeGenerator();
    for (final band in AgeBand.values) {
      for (var variant = 0; variant < activitiesInBand(GameCategory.maze); variant++) {
        final level = mazes.generate(
          band: band,
          seed: seedFor(band, variant),
          variant: variant,
        );
        expect(mazes.validate(level).isValid, isTrue);
        expect(level.metrics.shortestPathLength, greaterThan(0));
        expect(level.metrics.cells, level.rows * level.cols);
      }
    }
  });
}
