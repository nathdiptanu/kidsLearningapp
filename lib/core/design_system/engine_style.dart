import 'package:flutter/material.dart';

import '../../domain/models/game_category.dart';
import 'sprout_tokens.dart';

Color engineColor(GameCategory category) {
  return switch (category) {
    GameCategory.maths => SproutColors.maths,
    GameCategory.vocabulary => SproutColors.english,
    GameCategory.pattern => SproutColors.logic,
    GameCategory.matching => SproutColors.observation,
    GameCategory.maze => SproutColors.maze,
    GameCategory.findDifference => SproutColors.difference,
    GameCategory.findObjects => SproutColors.observation,
    GameCategory.connectDots => SproutColors.observation,
    GameCategory.knowledge => SproutColors.knowledge,
    GameCategory.ticTacToe => SproutColors.logic,
    GameCategory.hindi => SproutColors.hindi,
    GameCategory.discoverIndia => SproutColors.india,
  };
}

Color sectionSurface(GameCategory category) {
  return switch (category) {
    GameCategory.maths => SproutColors.mathsSurface,
    GameCategory.vocabulary => SproutColors.englishSurface,
    GameCategory.pattern ||
    GameCategory.maze ||
    GameCategory.ticTacToe => SproutColors.logicSurface,
    GameCategory.matching ||
    GameCategory.findDifference ||
    GameCategory.findObjects ||
    GameCategory.connectDots => SproutColors.observationSurface,
    GameCategory.knowledge => SproutColors.knowledgeSurface,
    GameCategory.hindi => SproutColors.hindiSurface,
    GameCategory.discoverIndia => SproutColors.indiaSurface,
  };
}

class EngineMark extends StatelessWidget {
  const EngineMark({required this.category, this.size = 36, super.key});

  final GameCategory category;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = engineColor(category);
    return CustomPaint(
      size: Size.square(size),
      painter: _EngineMarkPainter(category, color),
    );
  }
}

class _EngineMarkPainter extends CustomPainter {
  _EngineMarkPainter(this.category, this.color);

  final GameCategory category;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    switch (category) {
      case GameCategory.maths:
        canvas.drawLine(
          rect.centerLeft + Offset(size.width * 0.22, 0),
          rect.centerRight - Offset(size.width * 0.22, 0),
          stroke,
        );
        canvas.drawLine(
          rect.topCenter + Offset(0, size.height * 0.22),
          rect.bottomCenter - Offset(0, size.height * 0.22),
          stroke,
        );
      case GameCategory.vocabulary:
        final bubble = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            size.width * 0.12,
            size.height * 0.16,
            size.width * 0.76,
            size.height * 0.52,
          ),
          Radius.circular(size.width * 0.16),
        );
        canvas.drawRRect(bubble, paint);
      case GameCategory.pattern:
        for (var i = 0; i < 3; i++) {
          canvas.drawCircle(
            Offset(size.width * (0.22 + i * 0.28), size.height * 0.5),
            size.width * 0.08,
            paint,
          );
        }
      case GameCategory.matching:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * 0.12,
              size.height * 0.22,
              size.width * 0.32,
              size.height * 0.56,
            ),
            Radius.circular(size.width * 0.08),
          ),
          paint,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * 0.56,
              size.height * 0.22,
              size.width * 0.32,
              size.height * 0.56,
            ),
            Radius.circular(size.width * 0.08),
          ),
          stroke,
        );
      case GameCategory.maze:
        final path = Path()
          ..moveTo(size.width * 0.2, size.height * 0.2)
          ..lineTo(size.width * 0.2, size.height * 0.75)
          ..lineTo(size.width * 0.8, size.height * 0.75);
        canvas.drawPath(path, stroke);
      case GameCategory.findDifference:
        canvas.drawCircle(
          Offset(size.width * 0.36, size.height * 0.5),
          size.width * 0.18,
          stroke,
        );
        canvas.drawCircle(
          Offset(size.width * 0.66, size.height * 0.5),
          size.width * 0.18,
          stroke,
        );
        canvas.drawCircle(
          Offset(size.width * 0.78, size.height * 0.32),
          size.width * 0.05,
          paint,
        );
      case GameCategory.findObjects:
      case GameCategory.connectDots:
        canvas.drawCircle(
          Offset(size.width * 0.32, size.height * 0.38),
          size.width * 0.1,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.58, size.height * 0.54),
          size.width * 0.1,
          paint,
        );
        canvas.drawCircle(
          Offset(size.width * 0.74, size.height * 0.32),
          size.width * 0.08,
          stroke,
        );
      case GameCategory.knowledge:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * 0.22,
              size.height * 0.16,
              size.width * 0.56,
              size.height * 0.68,
            ),
            Radius.circular(size.width * 0.08),
          ),
          stroke,
        );
      case GameCategory.hindi:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              size.width * 0.18,
              size.height * 0.22,
              size.width * 0.64,
              size.height * 0.56,
            ),
            Radius.circular(size.width * 0.1),
          ),
          stroke,
        );
      case GameCategory.discoverIndia:
        canvas.drawCircle(
          Offset(size.width * 0.5, size.height * 0.5),
          size.width * 0.28,
          stroke,
        );
      case GameCategory.ticTacToe:
        canvas.drawLine(
          Offset(size.width * 0.38, size.height * 0.18),
          Offset(size.width * 0.38, size.height * 0.82),
          stroke,
        );
        canvas.drawLine(
          Offset(size.width * 0.62, size.height * 0.18),
          Offset(size.width * 0.62, size.height * 0.82),
          stroke,
        );
        canvas.drawLine(
          Offset(size.width * 0.18, size.height * 0.38),
          Offset(size.width * 0.82, size.height * 0.38),
          stroke,
        );
        canvas.drawLine(
          Offset(size.width * 0.18, size.height * 0.62),
          Offset(size.width * 0.82, size.height * 0.62),
          stroke,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _EngineMarkPainter oldDelegate) {
    return oldDelegate.category != category || oldDelegate.color != color;
  }
}
