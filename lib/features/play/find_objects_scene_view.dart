import 'package:flutter/material.dart';

import '../../domain/games/find_objects/find_objects_catalog.dart';

class FindObjectsSceneView extends StatelessWidget {
  const FindObjectsSceneView({
    required this.sceneId,
    required this.targets,
    required this.found,
    required this.onTapNormalized,
    this.hintId,
    this.strongHint = false,
    super.key,
  });

  final String sceneId;
  final List<FindObjectTarget> targets;
  final Set<String> found;
  final ValueChanged<Offset> onTapNormalized;
  final String? hintId;
  final bool strongHint;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Semantics(
            label: 'A picture. Find the things on the cards.',
            child: GestureDetector(
              onTapDown: (details) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                if (width <= 0 || height <= 0) {
                  return;
                }
                onTapNormalized(
                  Offset(
                    details.localPosition.dx / width,
                    details.localPosition.dy / height,
                  ),
                );
              },
              child: SizedBox.expand(
                child: CustomPaint(
                  painter: _FindPainter(
                    sceneId: sceneId,
                    targets: targets,
                    found: found,
                    hintId: hintId,
                    strongHint: strongHint,
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

class _FindPainter extends CustomPainter {
  _FindPainter({
    required this.sceneId,
    required this.targets,
    required this.found,
    required this.hintId,
    required this.strongHint,
  });

  final String sceneId;
  final List<FindObjectTarget> targets;
  final Set<String> found;
  final String? hintId;
  final bool strongHint;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = switch (sceneId) {
      'room-find' || 'table' || 'class' => const Color(0xFFF3E6D4),
      'garden-find' || 'park-find' || 'forest' || 'farm-find' =>
        const Color(0xFFD7EBD4),
      'beach-find' || 'harbour' || 'river' => const Color(0xFFD5E8F6),
      'kitchen-find' || 'bakery' || 'shop' || 'market' =>
        const Color(0xFFF7E7C8),
      'snow' => const Color(0xFFE8F1F8),
      'desert' => const Color(0xFFF3E1B8),
      'station' || 'zoo' || 'play' || 'shelf' => const Color(0xFFE4EAF3),
      _ => const Color(0xFFE8F0E8),
    };
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      paint,
    );
    paint.color = switch (sceneId) {
      'beach-find' || 'harbour' || 'desert' => const Color(0xFFF2D59A),
      'snow' => const Color(0xFFF7FBFF),
      'river' => const Color(0xFF7EB6D4),
      _ => const Color(0xFF8FBF6A),
    };
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38),
      paint,
    );
    for (final target in targets) {
      _object(canvas, size, paint, target);
      if (found.contains(target.id)) {
        _ring(canvas, size, target.region, const Color(0xFF2F7D4A), 3);
      }
    }
    final hint = hintId;
    if (hint != null) {
      for (final target in targets) {
        if (target.id == hint) {
          _ring(
            canvas,
            size,
            strongHint ? target.region : target.region.inflate(0.03),
            const Color(0xFFC47B2B),
            strongHint ? 4 : 8,
          );
        }
      }
    }
  }

  void _object(
    Canvas canvas,
    Size size,
    Paint paint,
    FindObjectTarget target,
  ) {
    final rect = Rect.fromLTWH(
      target.region.left * size.width,
      target.region.top * size.height,
      target.region.width * size.width,
      target.region.height * size.height,
    );
    paint.color = switch (target.id) {
      'book' || 'bag' || 'train' => const Color(0xFF3D6FBF),
      'cup' || 'clock' || 'sun' || 'can' => const Color(0xFFC47B2B),
      'ball' || 'apple' || 'fruit' || 'flower' || 'crab' || 'chicken' =>
        const Color(0xFFD64545),
      'hat' || 'shoe' || 'towel' => const Color(0xFF6B4C9A),
      'tree' || 'plant' || 'leaf' || 'bench' => const Color(0xFF2F7D4A),
      'bird' || 'fish' || 'kite' || 'boat' => const Color(0xFF3D7EA6),
      'dog' || 'spoon' || 'pencil' || 'mushroom' => const Color(0xFF6B4A2B),
      _ => const Color(0xFFC47B2B),
    };
    if (target.id == 'ball' ||
        target.id == 'sun' ||
        target.id == 'apple' ||
        target.id == 'fruit') {
      canvas.drawOval(rect, paint);
    } else if (target.id == 'kite' || target.id == 'umbrella') {
      canvas.drawPath(
        Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close(),
        paint,
      );
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(6)),
        paint,
      );
    }
  }

  void _ring(Canvas canvas, Size size, Rect region, Color color, double width) {
    final rect = Rect.fromLTWH(
      region.left * size.width,
      region.top * size.height,
      region.width * size.width,
      region.height * size.height,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.inflate(4), const Radius.circular(8)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _FindPainter oldDelegate) {
    return oldDelegate.found.length != found.length ||
        oldDelegate.hintId != hintId ||
        oldDelegate.strongHint != strongHint ||
        oldDelegate.sceneId != sceneId;
  }
}
