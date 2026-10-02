import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../domain/rewards/reward_catalog.dart';

/// Original sticker drawings. See assets/content/sticker_provenance.json.
class StickerGlyph extends StatelessWidget {
  const StickerGlyph({required this.rewardId, required this.earned, super.key});

  final String rewardId;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    final stickers = [
      for (final reward in rewardCatalog)
        if (reward.kind == RewardKind.sticker) reward.id,
    ];
    final index = stickers.indexOf(rewardId);
    return CustomPaint(
      size: const Size.square(56),
      painter: _StickerPainter(index: index < 0 ? 0 : index, earned: earned),
    );
  }
}

class _StickerPainter extends CustomPainter {
  const _StickerPainter({required this.index, required this.earned});

  final int index;
  final bool earned;

  static const _fills = <Color>[
    SproutColors.seed,
    SproutColors.accent,
    Color(0xFF3D6B8C),
    Color(0xFF8C4A6F),
    Color(0xFF5C6B32),
    Color(0xFF8A5A2B),
    Color(0xFF2F6B62),
    Color(0xFF6B4E8C),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = earned ? 1.0 : 0.38;
    final center = Offset(size.width / 2, size.height / 2);
    final fill = Paint()
      ..color = _fills[index % _fills.length].withValues(alpha: alpha);
    canvas.drawCircle(center, size.width / 2 - 2, fill);
    final line = Paint()
      ..color = SproutColors.background.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final shape = index % 8;
    switch (shape) {
      case 0:
        canvas.drawCircle(center, 12, line);
      case 1:
        _star(canvas, center, 16, line);
      case 2:
        canvas.drawOval(
          Rect.fromCenter(center: center, width: 30, height: 16),
          line,
        );
      case 3:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: 26, height: 20),
            const Radius.circular(4),
          ),
          line,
        );
      case 4:
        canvas.drawLine(
          center.translate(-12, 10),
          center.translate(0, -12),
          line,
        );
        canvas.drawLine(
          center.translate(0, -12),
          center.translate(12, 10),
          line,
        );
      case 5:
        canvas.drawArc(
          Rect.fromCenter(center: center, width: 28, height: 28),
          0.5,
          2.4,
          false,
          line,
        );
      case 6:
        canvas.drawLine(
          center.translate(-14, 0),
          center.translate(14, 0),
          line,
        );
        canvas.drawLine(
          center.translate(0, -14),
          center.translate(0, 14),
          line,
        );
      default:
        canvas.drawCircle(center.translate(-8, 0), 7, line);
        canvas.drawCircle(center.translate(8, 0), 7, line);
    }
    final dots = index ~/ 8;
    final dot = Paint()
      ..color = SproutColors.background.withValues(alpha: alpha);
    for (var mark = 0; mark < dots; mark++) {
      canvas.drawCircle(center.translate(-8.0 + mark * 8, 16), 2.5, dot);
    }
  }

  void _star(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var point = 0; point < 5; point++) {
      final angle = -math.pi / 2 + point * math.pi * 4 / 5;
      final spot = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      if (point == 0) {
        path.moveTo(spot.dx, spot.dy);
      } else {
        path.lineTo(spot.dx, spot.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StickerPainter oldDelegate) {
    return oldDelegate.index != index || oldDelegate.earned != earned;
  }
}
