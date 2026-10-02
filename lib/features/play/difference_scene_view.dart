import 'package:flutter/material.dart';

import '../../domain/games/find_difference/difference_catalog.dart';

class DifferenceSceneView extends StatelessWidget {
  const DifferenceSceneView({
    required this.sceneId,
    required this.altered,
    required this.spots,
    required this.marked,
    required this.onTapNormalized,
    this.hintSpotId,
    this.strongHint = false,
    super.key,
  });

  final String sceneId;
  final bool altered;
  final List<DifferenceSpot> spots;
  final Set<String> marked;
  final ValueChanged<Offset> onTapNormalized;
  final String? hintSpotId;
  final bool strongHint;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Semantics(
            label: altered
                ? 'Changed picture. Tap a spot that looks different.'
                : 'Original picture.',
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
                  painter: _ScenePainter(
                    sceneId: sceneId,
                    altered: altered,
                    spots: spots,
                    marked: marked,
                    hintSpotId: hintSpotId,
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

class _ScenePainter extends CustomPainter {
  _ScenePainter({
    required this.sceneId,
    required this.altered,
    required this.spots,
    required this.marked,
    required this.hintSpotId,
    required this.strongHint,
  });

  final String sceneId;
  final bool altered;
  final List<DifferenceSpot> spots;
  final Set<String> marked;
  final String? hintSpotId;
  final bool strongHint;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final background = switch (sceneId) {
      'room' => const Color(0xFFF3E6D4),
      'park' => const Color(0xFFD7EBD4),
      'kitchen' => const Color(0xFFF7E7C8),
      'beach' => const Color(0xFFD5E8F6),
      'farm' => const Color(0xFFE7D7A8),
      _ => const Color(0xFFD7E7F5),
    };
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      paint..color = background,
    );
    _ground(canvas, size, paint);
    if (altered) {
      for (final spot in spots) {
        _object(canvas, size, paint, spot);
        if (marked.contains(spot.id)) {
          _ring(
            canvas,
            size,
            spot.region,
            const Color(0xFF2F7D4A),
            3,
            found: true,
          );
        }
      }
    }
    final hint = hintSpotId;
    if (hint != null) {
      DifferenceSpot? spot;
      for (final candidate in spots) {
        if (candidate.id == hint) {
          spot = candidate;
        }
      }
      if (spot != null) {
        final region = strongHint ? spot.region : spot.region.inflate(0.03);
        _ring(
          canvas,
          size,
          region,
          const Color(0xFFC47B2B),
          strongHint ? 4 : 8,
          hint: true,
        );
      }
    }
  }

  void _ground(Canvas canvas, Size size, Paint paint) {
    paint.color = switch (sceneId) {
      'room' => const Color(0xFFCDB89A),
      'park' => const Color(0xFF7DAA6A),
      'kitchen' => const Color(0xFFD9C4A0),
      'beach' => const Color(0xFFF2D59A),
      'farm' => const Color(0xFF8FBF6A),
      _ => const Color(0xFF7DAA6A),
    };
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38),
      paint,
    );
  }

  void _object(Canvas canvas, Size size, Paint paint, DifferenceSpot spot) {
    final rect = Rect.fromLTWH(
      spot.region.left * size.width,
      spot.region.top * size.height,
      spot.region.width * size.width,
      spot.region.height * size.height,
    );
    paint.color = switch (spot.id) {
      'cloud' || 'shell' || 'towel' => const Color(0xFFFFF8F0),
      'bird' || 'fish' || 'kite' => const Color(0xFF3D7EA6),
      'flower' || 'apple' || 'crab' || 'chicken' => const Color(0xFFD64545),
      'butterfly' || 'picture' || 'umbrella' => const Color(0xFF6B4C9A),
      'can' || 'cup' || 'clock' || 'sun' => const Color(0xFFC47B2B),
      'lamp' || 'fruit' || 'ball' => const Color(0xFFE07A2F),
      'book' || 'window' => const Color(0xFF3D6FBF),
      'plant' || 'bench' => const Color(0xFF2F7D4A),
      'dog' || 'post' || 'spoon' => const Color(0xFF6B4A2B),
      'boat' || 'wheel' => const Color(0xFF2C2416),
      _ => const Color(0xFFC47B2B),
    };
    if (spot.id == 'cloud' ||
        spot.id == 'ball' ||
        spot.id == 'sun' ||
        spot.id == 'apple') {
      canvas.drawOval(rect, paint);
    } else if (spot.id == 'kite' || spot.id == 'umbrella') {
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

  void _ring(
    Canvas canvas,
    Size size,
    Rect region,
    Color color,
    double width, {
    bool found = false,
    bool hint = false,
  }) {
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
    final center = rect.center;
    if (found) {
      final mark = Paint()
        ..color = color
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        center + const Offset(-6, 0),
        center + const Offset(-2, 5),
        mark,
      );
      canvas.drawLine(
        center + const Offset(-2, 5),
        center + const Offset(7, -6),
        mark,
      );
    } else if (hint) {
      canvas.drawCircle(center, 5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) {
    return oldDelegate.altered != altered ||
        oldDelegate.marked.length != marked.length ||
        oldDelegate.hintSpotId != hintSpotId ||
        oldDelegate.strongHint != strongHint ||
        oldDelegate.sceneId != sceneId;
  }
}
