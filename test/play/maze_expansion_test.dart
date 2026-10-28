import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/games/maze/maze_generator.dart';
import 'package:sproutlab/domain/games/play/activity_catalog.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/game_category.dart';

void main() {
  test('100 solvable mazes per older band with fresh additions and stable IDs', () {
    const catalog = ActivityCatalog();
    const generator = MazeGenerator();
    for (final band in [AgeBand.a, AgeBand.b, AgeBand.c, AgeBand.d]) {
      final activities = catalog.forBand(GameCategory.maze, band);
      expect(activities, hasLength(100));
      final layouts = <String>{};
      for (final activity in activities) {
        expect(activity.id, 'maze:v1:${band.storageKey}:${activity.variant}');
        expect(catalog.byId(activity.id)?.seed, activity.seed);
        final maze = generator.generate(
          band: band,
          seed: activity.seed,
          variant: activity.variant,
        );
        expect(generator.validate(maze).isValid, true);
        expect(maze.solvable, true);
        final walls = maze.cells
            .map(
              (cell) =>
                  '${cell.north ? 1 : 0}${cell.east ? 1 : 0}${cell.south ? 1 : 0}${cell.west ? 1 : 0}',
            )
            .join();
        final fresh = layouts.add('${maze.rows}:$walls');
        if (activity.variant < 38 || activity.variant >= 50) continue;
        expect(fresh, true, reason: 'Duplicate maze ${activity.id}');
      }
    }
    expect(catalog.forBand(GameCategory.maze, AgeBand.toddler), isEmpty);
  });
}
