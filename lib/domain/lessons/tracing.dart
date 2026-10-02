import 'dart:math' as math;

import '../models/readiness.dart';
import 'lesson_models.dart';

class TracingConfig {
  const TracingConfig({
    this.tolerance = 0.14,
    this.coverage = 0.62,
    this.sampleGap = 0.018,
  });

  /// Distance, in normalised canvas units, allowed from the guide.
  final double tolerance;

  /// Fraction of guide samples that must be visited.
  final double coverage;

  /// Minimum gap between stored pointer samples.
  final double sampleGap;

  factory TracingConfig.forReadiness(Readiness readiness) {
    return switch (readiness) {
      Readiness.gentle => const TracingConfig(tolerance: 0.2, coverage: 0.5),
      Readiness.steady => const TracingConfig(),
      Readiness.more => const TracingConfig(tolerance: 0.11, coverage: 0.72),
    };
  }
}

class CanvasTransform {
  const CanvasTransform(this.width, this.height);

  final double width;
  final double height;

  StrokePoint toNormalized(double localX, double localY) {
    if (width <= 0 || height <= 0) {
      return const StrokePoint(0, 0);
    }
    return StrokePoint(
      (localX / width).clamp(0, 1),
      (localY / height).clamp(0, 1),
    );
  }

  StrokePoint toLocal(StrokePoint point) {
    return StrokePoint(point.x * width, point.y * height);
  }
}

class StrokeScore {
  const StrokeScore({
    required this.coverage,
    required this.meanDistance,
    required this.complete,
  });

  final double coverage;
  final double meanDistance;
  final bool complete;
}

class TracingSession {
  TracingSession({required this.template, this.config = const TracingConfig()});

  final StrokeTemplate template;
  final TracingConfig config;

  int strokeIndex = 0;
  final List<StrokePoint> current = [];
  final List<List<StrokePoint>> finishedStrokes = [];
  int? activePointer;
  bool assisted = false;
  int undoCount = 0;
  int retries = 0;

  bool get finished => strokeIndex >= template.strokes.length;

  StrokePath? get activeGuide =>
      finished ? null : template.strokes[strokeIndex];

  void beginPointer(int pointer, StrokePoint point) {
    if (finished) {
      return;
    }
    if (activePointer != null && activePointer != pointer) {
      return;
    }
    activePointer = pointer;
    current
      ..clear()
      ..add(point);
  }

  void movePointer(int pointer, StrokePoint point) {
    if (activePointer != pointer || finished) {
      return;
    }
    if (current.isEmpty) {
      current.add(point);
      return;
    }
    if (_distance(current.last, point) < config.sampleGap) {
      return;
    }
    current.add(point);
  }

  bool endPointer(int pointer) {
    if (activePointer != pointer) {
      return false;
    }
    activePointer = null;
    final guide = activeGuide;
    if (guide == null) {
      current.clear();
      return false;
    }
    final score = scoreStroke(guide, current, config);
    if (!score.complete) {
      current.clear();
      return false;
    }
    _acceptCurrent();
    return true;
  }

  void cancelPointer(int pointer) {
    if (activePointer == pointer) {
      activePointer = null;
      current.clear();
    }
  }

  /// Completes the active guide as assistance. Used by tap-to-follow.
  void followActiveStroke() {
    final guide = activeGuide;
    if (guide == null) {
      return;
    }
    assisted = true;
    current
      ..clear()
      ..addAll(guide.points);
    _acceptCurrent();
  }

  void undo() {
    if (current.isNotEmpty) {
      current.clear();
      activePointer = null;
      undoCount += 1;
      return;
    }
    if (finishedStrokes.isEmpty) {
      return;
    }
    finishedStrokes.removeLast();
    strokeIndex = finishedStrokes.length;
    undoCount += 1;
  }

  void retry() {
    current.clear();
    finishedStrokes.clear();
    strokeIndex = 0;
    activePointer = null;
    assisted = false;
    retries += 1;
  }

  StrokeScore scoreStroke(
    StrokePath guide,
    List<StrokePoint> drawn,
    TracingConfig config,
  ) {
    if (guide.points.isEmpty || drawn.isEmpty) {
      return const StrokeScore(coverage: 0, meanDistance: 1, complete: false);
    }
    final samples = _resample(guide.points, 24);
    var hit = 0;
    var distanceSum = 0.0;
    for (final sample in samples) {
      final nearest = _distanceToPolyline(sample, drawn);
      distanceSum += nearest;
      if (nearest <= config.tolerance) {
        hit += 1;
      }
    }
    final coverage = hit / samples.length;
    return StrokeScore(
      coverage: coverage,
      meanDistance: distanceSum / samples.length,
      complete: coverage >= config.coverage,
    );
  }

  String summaryPayload() {
    return 'strokes=$strokeIndex;assisted=${assisted ? 1 : 0};undo=$undoCount;retry=$retries;done=${finished ? 1 : 0}';
  }

  void restoreSummary({
    required int strokesDone,
    required bool wasAssisted,
    required int undos,
    required int retryCount,
  }) {
    strokeIndex = strokesDone.clamp(0, template.strokes.length);
    finishedStrokes
      ..clear()
      ..addAll(
        template.strokes.take(strokeIndex).map((stroke) => [...stroke.points]),
      );
    assisted = wasAssisted;
    undoCount = undos;
    retries = retryCount;
    current.clear();
    activePointer = null;
  }

  void _acceptCurrent() {
    finishedStrokes.add(List<StrokePoint>.from(current));
    current.clear();
    strokeIndex += 1;
  }

  double _distanceToPolyline(StrokePoint sample, List<StrokePoint> drawn) {
    if (drawn.length == 1) {
      return _distance(sample, drawn.first);
    }
    var best = double.infinity;
    for (var index = 1; index < drawn.length; index++) {
      final distance = _distanceToSegment(sample, drawn[index - 1], drawn[index]);
      if (distance < best) {
        best = distance;
      }
    }
    return best;
  }

  double _distanceToSegment(StrokePoint point, StrokePoint a, StrokePoint b) {
    final dx = b.x - a.x;
    final dy = b.y - a.y;
    final length2 = dx * dx + dy * dy;
    if (length2 == 0) {
      return _distance(point, a);
    }
    var t = ((point.x - a.x) * dx + (point.y - a.y) * dy) / length2;
    t = t.clamp(0, 1);
    return _distance(point, StrokePoint(a.x + dx * t, a.y + dy * t));
  }

  List<StrokePoint> _resample(List<StrokePoint> points, int count) {
    if (points.length == 1 || count <= 1) {
      return [points.first];
    }
    final lengths = <double>[0];
    var total = 0.0;
    for (var index = 1; index < points.length; index++) {
      total += _distance(points[index - 1], points[index]);
      lengths.add(total);
    }
    if (total == 0) {
      return [points.first];
    }
    final samples = <StrokePoint>[];
    for (var step = 0; step < count; step++) {
      final target = total * step / (count - 1);
      var index = 1;
      while (index < lengths.length && lengths[index] < target) {
        index += 1;
      }
      final previous = points[index - 1];
      final next = points[math.min(index, points.length - 1)];
      final span =
          lengths[math.min(index, lengths.length - 1)] - lengths[index - 1];
      final t = span == 0 ? 0.0 : (target - lengths[index - 1]) / span;
      samples.add(
        StrokePoint(
          previous.x + (next.x - previous.x) * t,
          previous.y + (next.y - previous.y) * t,
        ),
      );
    }
    return samples;
  }

  double _distance(StrokePoint a, StrokePoint b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }
}
