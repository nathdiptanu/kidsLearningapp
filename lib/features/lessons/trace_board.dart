import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../domain/lessons/lesson_models.dart';
import '../../domain/lessons/tracing.dart';

class TraceBoard extends StatelessWidget {
  const TraceBoard({
    required this.session,
    required this.transform,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
    required this.onPointerCancel,
    super.key,
  });

  final TracingSession session;
  final CanvasTransform transform;
  final void Function(int pointer, Offset local) onPointerDown;
  final void Function(int pointer, Offset local) onPointerMove;
  final void Function(int pointer) onPointerUp;
  final void Function(int pointer) onPointerCancel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Trace ${session.template.glyph}. Start at the bright dot.',
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Listener(
              onPointerDown: (event) =>
                  onPointerDown(event.pointer, event.localPosition),
              onPointerMove: (event) =>
                  onPointerMove(event.pointer, event.localPosition),
              onPointerUp: (event) => onPointerUp(event.pointer),
              onPointerCancel: (event) => onPointerCancel(event.pointer),
              child: CustomPaint(
                painter: _TracePainter(session: session),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  _TracePainter({required this.session});

  final TracingSession session;

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = SproutColors.surface;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(20)),
      fill,
    );
    Offset map(StrokePoint point) =>
        Offset(point.x * size.width, point.y * size.height);

    final faded = Paint()
      ..color = SproutColors.line.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (var index = 0; index < session.template.strokes.length; index++) {
      if (index < session.strokeIndex) {
        continue;
      }
      _stroke(canvas, session.template.strokes[index], map, faded);
    }

    final done = Paint()
      ..color = SproutColors.success
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (final stroke in session.finishedStrokes) {
      _points(canvas, stroke, map, done);
    }

    final guide = session.activeGuide;
    if (guide != null && guide.points.isNotEmpty) {
      final active = Paint()
        ..color = SproutColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      _stroke(canvas, guide, map, active);
      final start = map(guide.points.first);
      canvas.drawCircle(start, 14, Paint()..color = SproutColors.accent);
      canvas.drawCircle(start, 7, Paint()..color = SproutColors.surface);
      if (guide.points.length > 1) {
        final next = map(guide.points[1]);
        final arrow = Paint()
          ..color = SproutColors.accent
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(start, next, arrow);
      }
    }

    if (session.current.isNotEmpty) {
      final live = Paint()
        ..color = SproutColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      _points(canvas, session.current, map, live);
    }
  }

  void _stroke(
    Canvas canvas,
    StrokePath path,
    Offset Function(StrokePoint) map,
    Paint paint,
  ) {
    _points(canvas, path.points, map, paint);
  }

  void _points(
    Canvas canvas,
    List<StrokePoint> points,
    Offset Function(StrokePoint) map,
    Paint paint,
  ) {
    if (points.isEmpty) {
      return;
    }
    final draw = Path()..moveTo(map(points.first).dx, map(points.first).dy);
    for (final point in points.skip(1)) {
      final offset = map(point);
      draw.lineTo(offset.dx, offset.dy);
    }
    canvas.drawPath(draw, paint);
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
