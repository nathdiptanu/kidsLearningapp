import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../sprout_tokens.dart';

const avatarIds = <String>[
  'sprout',
  'sun',
  'fox',
  'owl',
  'fish',
  'star',
  'turtle',
  'butterfly',
];

String avatarName(String avatarId) {
  return switch (avatarId) {
    'sprout' => 'Sprout',
    'sun' => 'Sun',
    'fox' => 'Fox',
    'owl' => 'Owl',
    'fish' => 'Fish',
    'star' => 'Star',
    'turtle' => 'Turtle',
    'butterfly' => 'Butterfly',
    _ => 'Sprout',
  };
}

class AvatarBadge extends StatelessWidget {
  const AvatarBadge({
    required this.avatarId,
    super.key,
    this.size = 72,
    this.button = false,
  });

  final String avatarId;
  final double size;
  final bool button;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: button,
      label: avatarName(avatarId),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _AvatarPainter(avatarId)),
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  _AvatarPainter(this.avatarId);

  final String avatarId;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final background = Paint()..color = const Color(0xFFE7F3EA);
    canvas.drawCircle(center, radius, background);
    final fill = Paint()..color = SproutColors.seed;
    final accent = Paint()..color = SproutColors.accent;
    final cream = Paint()..color = SproutColors.background;
    switch (avatarId) {
      case 'sun':
        canvas.drawCircle(center, radius * 0.42, accent);
        for (var ray = 0; ray < 8; ray++) {
          canvas.save();
          canvas.translate(center.dx, center.dy);
          canvas.rotate(ray * 3.14159 / 4);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset(0, -radius * 0.72),
                width: radius * 0.16,
                height: radius * 0.28,
              ),
              const Radius.circular(8),
            ),
            accent,
          );
          canvas.restore();
        }
      case 'fox':
        canvas.drawCircle(center, radius * 0.46, accent);
        _triangle(
          canvas,
          Offset(center.dx - radius * 0.28, center.dy - radius * 0.2),
          radius * 0.34,
          accent,
        );
        _triangle(
          canvas,
          Offset(center.dx + radius * 0.28, center.dy - radius * 0.2),
          radius * 0.34,
          accent,
        );
        canvas.drawCircle(
          Offset(center.dx, center.dy + radius * 0.12),
          radius * 0.16,
          cream,
        );
      case 'owl':
        canvas.drawCircle(center, radius * 0.5, fill);
        canvas.drawCircle(
          Offset(center.dx - radius * 0.18, center.dy - radius * 0.05),
          radius * 0.16,
          cream,
        );
        canvas.drawCircle(
          Offset(center.dx + radius * 0.18, center.dy - radius * 0.05),
          radius * 0.16,
          cream,
        );
        canvas.drawCircle(
          Offset(center.dx - radius * 0.18, center.dy - radius * 0.05),
          radius * 0.06,
          fill,
        );
        canvas.drawCircle(
          Offset(center.dx + radius * 0.18, center.dy - radius * 0.05),
          radius * 0.06,
          fill,
        );
      case 'fish':
        canvas.drawOval(
          Rect.fromCenter(
            center: center,
            width: radius * 1.15,
            height: radius * 0.7,
          ),
          Paint()..color = const Color(0xFF3D7EA6),
        );
        _triangle(
          canvas,
          Offset(center.dx - radius * 0.62, center.dy),
          radius * 0.36,
          Paint()..color = const Color(0xFF3D7EA6),
        );
        canvas.drawCircle(
          Offset(center.dx + radius * 0.28, center.dy - radius * 0.06),
          radius * 0.07,
          cream,
        );
      case 'star':
        _star(canvas, center, radius * 0.62, accent);
      case 'turtle':
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + radius * 0.05),
            width: radius * 1.05,
            height: radius * 0.78,
          ),
          fill,
        );
        canvas.drawCircle(
          Offset(center.dx + radius * 0.42, center.dy - radius * 0.05),
          radius * 0.22,
          fill,
        );
      case 'butterfly':
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(center.dx - radius * 0.28, center.dy),
            width: radius * 0.55,
            height: radius * 0.8,
          ),
          accent,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(center.dx + radius * 0.28, center.dy),
            width: radius * 0.55,
            height: radius * 0.8,
          ),
          accent,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: center,
              width: radius * 0.16,
              height: radius * 0.9,
            ),
            const Radius.circular(8),
          ),
          fill,
        );
      case 'sprout':
      default:
        canvas.drawCircle(
          Offset(center.dx, center.dy + radius * 0.18),
          radius * 0.22,
          fill,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              center.dx - radius * 0.22,
              center.dy - radius * 0.12,
            ),
            width: radius * 0.48,
            height: radius * 0.32,
          ),
          fill,
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              center.dx + radius * 0.24,
              center.dy - radius * 0.16,
            ),
            width: radius * 0.48,
            height: radius * 0.32,
          ),
          Paint()..color = const Color(0xFF4E9A63),
        );
    }
  }

  void _triangle(Canvas canvas, Offset tip, double height, Paint paint) {
    final path = Path()
      ..moveTo(tip.dx, tip.dy - height * 0.55)
      ..lineTo(tip.dx - height * 0.42, tip.dy + height * 0.35)
      ..lineTo(tip.dx + height * 0.42, tip.dy + height * 0.35)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _star(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var point = 0; point < 10; point++) {
      final angle = -1.5708 + point * 3.14159 / 5;
      final distance = point.isEven ? radius : radius * 0.45;
      final offset = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );
      if (point == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) {
    return oldDelegate.avatarId != avatarId;
  }
}
