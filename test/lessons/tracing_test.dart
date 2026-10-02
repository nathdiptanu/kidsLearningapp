import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/lessons/development_pack.dart';
import 'package:sproutlab/domain/lessons/lesson_models.dart';
import 'package:sproutlab/domain/lessons/tracing.dart';
import 'package:sproutlab/domain/models/readiness.dart';

void main() {
  final template = developmentLanguagePack().templates['stroke_en_a']!;

  test('pointer coordinates normalise across size and orientation', () {
    final wide = const CanvasTransform(400, 200);
    final tall = const CanvasTransform(200, 400);
    expect(wide.toNormalized(200, 100).x, closeTo(0.5, 0.001));
    expect(wide.toNormalized(200, 100).y, closeTo(0.5, 0.001));
    expect(tall.toNormalized(100, 200).x, closeTo(0.5, 0.001));
    expect(tall.toNormalized(100, 200).y, closeTo(0.5, 0.001));
    final back = wide.toLocal(const StrokePoint(0.25, 0.75));
    expect(back.x, closeTo(100, 0.001));
    expect(back.y, closeTo(150, 0.001));
  });

  test('coverage and tolerance complete a generous trace', () {
    final session = TracingSession(template: template);
    final guide = template.strokes.first;
    final hit = session.scoreStroke(guide, guide.points, const TracingConfig());
    expect(hit.complete, isTrue);
    expect(hit.coverage, greaterThan(0.62));
    final miss = session.scoreStroke(guide, const [
      StrokePoint(0.9, 0.9),
      StrokePoint(0.95, 0.95),
    ], const TracingConfig());
    expect(miss.complete, isFalse);
  });

  test('tap-to-follow assists, undo and retry restore state, extra pointers are ignored', () {
    final session = TracingSession(
      template: template,
      config: TracingConfig.forReadiness(Readiness.gentle),
    );
    session.beginPointer(1, const StrokePoint(0.1, 0.1));
    session.beginPointer(2, const StrokePoint(0.9, 0.9));
    expect(session.current.last.x, closeTo(0.1, 0.001));
    session.followActiveStroke();
    expect(session.assisted, isTrue);
    expect(session.strokeIndex, 1);
    session.undo();
    expect(session.strokeIndex, 0);
    expect(session.finished, isFalse);
    session.followActiveStroke();
    session.followActiveStroke();
    session.followActiveStroke();
    expect(session.finished, isTrue);
    expect(session.summaryPayload(), contains('assisted=1'));
    expect(session.summaryPayload(), isNot(contains('path=')));
    session.retry();
    expect(session.finished, isFalse);
    expect(session.strokeIndex, 0);
    expect(session.assisted, isFalse);
  });

  test('a summary checkpoint restores stroke index without stored paths', () {
    final session = TracingSession(template: template);
    session.followActiveStroke();
    session.followActiveStroke();
    final payload = session.summaryPayload();
    expect(payload, contains('strokes=2'));
    expect(payload, isNot(contains('0.22')));
    final restored = TracingSession(template: template);
    restored.restoreSummary(
      strokesDone: 2,
      wasAssisted: true,
      undos: 1,
      retryCount: 0,
    );
    expect(restored.strokeIndex, 2);
    expect(restored.finished, isFalse);
    expect(restored.assisted, isTrue);
    expect(restored.current, isEmpty);
    restored.followActiveStroke();
    expect(restored.finished, isTrue);
  });

  test('unreviewed Hindi templates stay out of a release pack', () {
    final hindi = developmentLanguagePack().templates['stroke_a']!;
    expect(hindi.releaseReady, isFalse);
    expect(hindi.sourceNote.toLowerCase(), contains('not a font outline'));
    expect(hindi.shirorekhaStrokeIndex, 2);
  });
}
