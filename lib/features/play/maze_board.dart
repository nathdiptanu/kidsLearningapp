import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../domain/games/maze/maze_generator.dart';

class MazeBoard extends StatelessWidget {
  const MazeBoard({
    required this.maze,
    required this.player,
    required this.hintCells,
    required this.onTapCell,
    required this.onDragCell,
    super.key,
  });

  final MazeLevel maze;
  final MazePoint player;
  final List<MazePoint> hintCells;
  final ValueChanged<MazePoint> onTapCell;
  final ValueChanged<MazePoint> onDragCell;

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
            label: 'Maze. The round marker is you. The flower is the finish. Move along the open paths.',
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
  });

  final MazeLevel maze;
  final MazePoint player;
  final List<MazePoint> hintCells;

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / maze.cols;
    final cellH = size.height / maze.rows;
    final fill = Paint()..color = const Color(0xFFFFF8F0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      fill,
    );
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
      ..color = const Color(0xFF2C2416)
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
  }

  void _playerMark(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = SproutColors.seed);
    canvas.drawCircle(
      center,
      radius * 0.42,
      Paint()..color = const Color(0xFFFFF8F0),
    );
  }

  void _flower(Canvas canvas, Offset center, double radius) {
    final petal = Paint()..color = SproutColors.accent;
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
      Paint()..color = const Color(0xFFFFF8F0),
    );
  }

  @override
  bool shouldRepaint(covariant _MazePainter oldDelegate) {
    return oldDelegate.player != player || !_sameHints(oldDelegate.hintCells);
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
