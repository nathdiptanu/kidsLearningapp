import 'dart:collection';
import 'dart:math';

import '../../models/age_band.dart';
import '../common/level_generator.dart';

class MazePoint {
  const MazePoint(this.row, this.col);

  final int row;
  final int col;

  int key(int cols) => row * cols + col;

  @override
  bool operator ==(Object other) =>
      other is MazePoint && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);
}

class MazeCell {
  bool north = true;
  bool east = true;
  bool south = true;
  bool west = true;
}

class MazeMetrics {
  const MazeMetrics({
    required this.shortestPathLength,
    required this.deadEndCount,
    required this.cells,
  });

  final int shortestPathLength;
  final int deadEndCount;
  final int cells;
}

class MazeLevel {
  MazeLevel({
    required this.rows,
    required this.cols,
    required this.cells,
    required this.nextTowardGoal,
    this.metrics = const MazeMetrics(
      shortestPathLength: 0,
      deadEndCount: 0,
      cells: 0,
    ),
  });

  final int rows;
  final int cols;
  final List<MazeCell> cells;
  final Map<int, MazePoint> nextTowardGoal;
  final MazeMetrics metrics;

  MazePoint get start => const MazePoint(0, 0);

  MazePoint get goal => MazePoint(rows - 1, cols - 1);

  MazeCell cell(MazePoint point) => cells[point.key(cols)];

  bool contains(MazePoint point) =>
      point.row >= 0 && point.col >= 0 && point.row < rows && point.col < cols;

  bool canStep(MazePoint from, MazePoint to) {
    if (!contains(from) || !contains(to)) {
      return false;
    }
    final dRow = to.row - from.row;
    final dCol = to.col - from.col;
    if (dRow.abs() + dCol.abs() != 1) {
      return false;
    }
    final here = cell(from);
    if (dRow == -1) {
      return !here.north;
    }
    if (dRow == 1) {
      return !here.south;
    }
    if (dCol == 1) {
      return !here.east;
    }
    return !here.west;
  }

  List<MazePoint> openNeighbors(MazePoint point) {
    return [
      for (final next in [
        MazePoint(point.row - 1, point.col),
        MazePoint(point.row + 1, point.col),
        MazePoint(point.row, point.col - 1),
        MazePoint(point.row, point.col + 1),
      ])
        if (canStep(point, next)) next,
    ];
  }

  /// Cached steps toward the goal. This does not search again.
  List<MazePoint> stepsTowardGoal(MazePoint from, int count) {
    final steps = <MazePoint>[];
    var cursor = from;
    for (var index = 0; index < count; index++) {
      final next = nextTowardGoal[cursor.key(cols)];
      if (next == null) {
        break;
      }
      steps.add(next);
      cursor = next;
    }
    return steps;
  }

  bool get solvable => identical(start, goal) || nextTowardGoal.containsKey(0);
}

class MazeGenerator {
  const MazeGenerator();

  static const generatorVersion = 'maze:v1';

  (int, int) sizeFor(AgeBand band, int variant) {
    return switch (band) {
      AgeBand.a || AgeBand.toddler => variant.isEven ? (4, 4) : (5, 5),
      AgeBand.b => variant.isEven ? (5, 5) : (6, 6),
      AgeBand.c => variant.isEven ? (6, 6) : (8, 8),
      AgeBand.d => variant.isEven ? (8, 8) : (10, 10),
    };
  }

  MazeLevel generate({
    required AgeBand band,
    required int seed,
    required int variant,
  }) {
    final size = sizeFor(band, variant);
    final carved = _carve(size.$1, size.$2, Random(seed));
    final checked = carved.solvable && validate(carved).isValid
        ? carved
        : _corridor(size.$1, size.$2);
    return _withMetrics(checked);
  }

  /// Checks bounds, border walls, reciprocal openings and the cached path.
  /// The path was computed once during generation.
  ValidationResult validate(MazeLevel level) {
    if (level.rows < 2 ||
        level.cols < 2 ||
        level.cells.length != level.rows * level.cols) {
      return const ValidationResult.invalid('bounds');
    }
    const supported = {4, 5, 6, 8, 10};
    if (!supported.contains(level.rows) || level.rows != level.cols) {
      return const ValidationResult.invalid('size');
    }
    if (!level.contains(level.start) || !level.contains(level.goal)) {
      return const ValidationResult.invalid('ends');
    }
    for (var row = 0; row < level.rows; row++) {
      for (var col = 0; col < level.cols; col++) {
        final cell = level.cell(MazePoint(row, col));
        if (row == 0 && !cell.north) {
          return const ValidationResult.invalid('border');
        }
        if (col == 0 && !cell.west) {
          return const ValidationResult.invalid('border');
        }
        if (row == level.rows - 1 && !cell.south) {
          return const ValidationResult.invalid('border');
        }
        if (col == level.cols - 1 && !cell.east) {
          return const ValidationResult.invalid('border');
        }
        if (row > 0) {
          final above = level.cell(MazePoint(row - 1, col));
          if (cell.north != above.south) {
            return const ValidationResult.invalid('reciprocal');
          }
        }
        if (col > 0) {
          final left = level.cell(MazePoint(row, col - 1));
          if (cell.west != left.east) {
            return const ValidationResult.invalid('reciprocal');
          }
        }
      }
    }
    var cursor = level.start;
    final seen = <MazePoint>{cursor};
    var guard = 0;
    while (cursor != level.goal) {
      final next = level.nextTowardGoal[cursor.key(level.cols)];
      if (next == null || !level.canStep(cursor, next) || !seen.add(next)) {
        return const ValidationResult.invalid('path');
      }
      guard++;
      if (guard > level.rows * level.cols) {
        return const ValidationResult.invalid('path');
      }
      cursor = next;
    }
    return const ValidationResult.valid();
  }

  MazeLevel _carve(int rows, int cols, Random random) {
    final cells = List.generate(rows * cols, (_) => MazeCell());
    final stack = <MazePoint>[const MazePoint(0, 0)];
    final seen = <int>{0};
    while (stack.isNotEmpty) {
      final current = stack.last;
      final options = <MazePoint>[
        for (final next in [
          MazePoint(current.row - 1, current.col),
          MazePoint(current.row + 1, current.col),
          MazePoint(current.row, current.col - 1),
          MazePoint(current.row, current.col + 1),
        ])
          if (next.row >= 0 &&
              next.col >= 0 &&
              next.row < rows &&
              next.col < cols &&
              !seen.contains(next.row * cols + next.col))
            next,
      ];
      if (options.isEmpty) {
        stack.removeLast();
        continue;
      }
      options.shuffle(random);
      final next = options.first;
      _open(cells, cols, current, next);
      seen.add(next.row * cols + next.col);
      stack.add(next);
    }
    return MazeLevel(
      rows: rows,
      cols: cols,
      cells: cells,
      nextTowardGoal: _guide(rows, cols, cells),
    );
  }

  void _open(List<MazeCell> cells, int cols, MazePoint from, MazePoint to) {
    final dRow = to.row - from.row;
    final dCol = to.col - from.col;
    final here = cells[from.row * cols + from.col];
    final there = cells[to.row * cols + to.col];
    if (dRow == -1) {
      here.north = false;
      there.south = false;
    } else if (dRow == 1) {
      here.south = false;
      there.north = false;
    } else if (dCol == 1) {
      here.east = false;
      there.west = false;
    } else if (dCol == -1) {
      here.west = false;
      there.east = false;
    }
  }

  Map<int, MazePoint> _guide(int rows, int cols, List<MazeCell> cells) {
    final level = MazeLevel(
      rows: rows,
      cols: cols,
      cells: cells,
      nextTowardGoal: const {},
    );
    final goal = level.goal;
    final next = <int, MazePoint>{};
    final queue = Queue<MazePoint>()..add(goal);
    final seen = <int>{goal.key(cols)};
    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      for (final neighbor in level.openNeighbors(current)) {
        final key = neighbor.key(cols);
        if (seen.add(key)) {
          next[key] = current;
          queue.add(neighbor);
        }
      }
    }
    return next;
  }

  MazeLevel _withMetrics(MazeLevel level) {
    var cursor = level.start;
    var length = 0;
    final seen = <MazePoint>{cursor};
    while (cursor != level.goal) {
      final next = level.nextTowardGoal[cursor.key(level.cols)];
      if (next == null || !seen.add(next)) {
        break;
      }
      length += 1;
      cursor = next;
    }
    var deadEnds = 0;
    for (var row = 0; row < level.rows; row++) {
      for (var col = 0; col < level.cols; col++) {
        final point = MazePoint(row, col);
        if (point == level.start || point == level.goal) {
          continue;
        }
        if (level.openNeighbors(point).length == 1) {
          deadEnds += 1;
        }
      }
    }
    return MazeLevel(
      rows: level.rows,
      cols: level.cols,
      cells: level.cells,
      nextTowardGoal: level.nextTowardGoal,
      metrics: MazeMetrics(
        shortestPathLength: length,
        deadEndCount: deadEnds,
        cells: level.rows * level.cols,
      ),
    );
  }

  MazeLevel _corridor(int rows, int cols) {
    final cells = List.generate(rows * cols, (_) => MazeCell());
    for (var col = 0; col < cols - 1; col++) {
      _open(cells, cols, MazePoint(0, col), MazePoint(0, col + 1));
    }
    for (var row = 0; row < rows - 1; row++) {
      _open(
        cells,
        cols,
        MazePoint(row, cols - 1),
        MazePoint(row + 1, cols - 1),
      );
    }
    return MazeLevel(
      rows: rows,
      cols: cols,
      cells: cells,
      nextTowardGoal: _guide(rows, cols, cells),
    );
  }
}
