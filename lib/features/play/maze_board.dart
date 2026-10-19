import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../domain/games/maze/maze_generator.dart';
import 'maze_palette.dart';

class MazeBoard extends StatelessWidget {
  const MazeBoard({
    required this.maze,
    required this.player,
    required this.hintCells,
    required this.onTapCell,
    required this.onDragCell,
    this.variant = 0,
    this.visitedCells = const {},
    super.key,
  });

  final MazeLevel maze;
  final MazePoint player;
  final List<MazePoint> hintCells;
  final ValueChanged<MazePoint> onTapCell;
  final ValueChanged<MazePoint> onDragCell;
  final int variant;
  final Set<MazePoint> visitedCells;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: maze.cols / maze.rows,
      child: LayoutBuilder(
        builder: (context, constraints) {
          MazePoint cellAt(Offset local) {
            final col = (local.dx / constraints.maxWidth * maze.cols)
                .floor()
                .clamp(0, maze.cols - 1);
            final row = (local.dy / constraints.maxHeight * maze.rows)
                .floor()
                .clamp(0, maze.rows - 1);
            return MazePoint(row, col);
          }

          return Semantics(
            label: 'Maze. The smiling marker is you. The flower is the finish. Move along the open paths.',
            child: GestureDetector(
              onTapDown: (details) => onTapCell(cellAt(details.localPosition)),
              onPanUpdate: (details) =>
                  onDragCell(cellAt(details.localPosition)),
              child: SizedBox.expand(
                child: CustomPaint(
                  painter: _MazePainter(
                    maze: maze,
                    player: player,
                    hintCells: hintCells,
                    palette: MazePalette.forVariant(variant),
                    visitedCells: visitedCells,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MazePainter extends CustomPainter {
  _MazePainter({
    required this.maze,
    required this.player,
    required this.hintCells,
    required this.palette,
    required this.visitedCells,
  });

  final MazeLevel maze;
  final MazePoint player;
  final List<MazePoint> hintCells;
  final MazePalette palette;
  final Set<MazePoint> visitedCells;

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / maze.cols;
    final cellH = size.height / maze.rows;
    final fill = Paint()..color = palette.ground;
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      fill,
    );
    for (var row = 0; row < maze.rows; row++) {
      for (var col = 0; col < maze.cols; col++) {
        if ((row + col).isEven) {
          canvas.drawRect(
            Rect.fromLTWH(col * cellW, row * cellH, cellW, cellH),
            Paint()..color = palette.tile,
          );
        }
      }
    }
    for (final point in visitedCells) {
      canvas.drawCircle(
        Offset((point.col + 0.5) * cellW, (point.row + 0.5) * cellH),
        cellW * 0.09,
        Paint()..color = palette.player.withValues(alpha: 0.35),
      );
    }
    for (final hint in hintCells) {
      final rect = Rect.fromLTWH(
        hint.col * cellW,
        hint.row * cellH,
        cellW,
        cellH,
      );
      canvas.drawRect(rect, Paint()..color = const Color(0xFFF3D7B0));
      final mark = Path()
        ..moveTo(rect.center.dx, rect.top + cellH * 0.28)
        ..lineTo(rect.center.dx + cellW * 0.16, rect.center.dy)
        ..lineTo(rect.center.dx, rect.bottom - cellH * 0.28)
        ..lineTo(rect.center.dx - cellW * 0.16, rect.center.dy)
        ..close();
      canvas.drawPath(mark, Paint()..color = SproutColors.accent);
    }
    final goal = maze.goal;
    _flower(
      canvas,
      Offset((goal.col + 0.5) * cellW, (goal.row + 0.5) * cellH),
      cellW * 0.34,
    );
    _playerMark(
      canvas,
      Offset((player.col + 0.5) * cellW, (player.row + 0.5) * cellH),
      cellW * 0.38,
    );
    final wall = Paint()
      ..color = palette.wall
      ..strokeWidth = (cellW * 0.08).clamp(3, 8)
      ..strokeCap = StrokeCap.round;
    for (var row = 0; row < maze.rows; row++) {
      for (var col = 0; col < maze.cols; col++) {
        final cell = maze.cell(MazePoint(row, col));
        final left = col * cellW;
        final top = row * cellH;
        final right = left + cellW;
        final bottom = top + cellH;
        if (cell.north) {
          canvas.drawLine(Offset(left, top), Offset(right, top), wall);
        }
        if (cell.west) {
          canvas.drawLine(Offset(left, top), Offset(left, bottom), wall);
        }
        if (row == maze.rows - 1 && cell.south) {
          canvas.drawLine(Offset(left, bottom), Offset(right, bottom), wall);
        }
        if (col == maze.cols - 1 && cell.east) {
          canvas.drawLine(Offset(right, top), Offset(right, bottom), wall);
        }
      }
    }
    canvas.restore();
  }

  void _playerMark(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = palette.player);
    final face = Paint()..color = Colors.white;
    for (final side in [-1, 1]) {
      canvas.drawCircle(
        center + Offset(side * radius * 0.3, -radius * 0.18),
        radius * 0.1,
        face,
      );
    }
    canvas.drawArc(
      Rect.fromCenter(
        center: center + Offset(0, radius * 0.06),
        width: radius * 0.8,
        height: radius * 0.65,
      ),
      0.15,
      math.pi - 0.3,
      false,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.09
        ..strokeCap = StrokeCap.round,
    );
  }

  void _flower(Canvas canvas, Offset center, double radius) {
    final petal = Paint()..color = palette.flower;
    for (var index = 0; index < 5; index++) {
      final angle = index * math.pi * 2 / 5;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius * 0.75,
        radius * 0.5,
        petal,
      );
    }
    canvas.drawCircle(
      center,
      radius * 0.38,
      Paint()..color = const Color(0xFFFFE282),
    );
  }

  @override
  bool shouldRepaint(covariant _MazePainter oldDelegate) {
    return oldDelegate.maze != maze ||
        oldDelegate.palette != palette ||
        oldDelegate.visitedCells != visitedCells ||
        oldDelegate.player != player ||
        !_sameHints(oldDelegate.hintCells);
  }

  bool _sameHints(List<MazePoint> other) {
    if (other.length != hintCells.length) {
      return false;
    }
    for (var index = 0; index < other.length; index++) {
      if (other[index] != hintCells[index]) {
        return false;
      }
    }
    return true;
  }
}
