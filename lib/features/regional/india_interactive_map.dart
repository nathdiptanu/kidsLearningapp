import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SourceMapRegion {
  SourceMapRegion(this.name, this.path, this.anchor);
  final String name;
  final Path path;
  final Offset anchor;
}

class IndiaSourceMap {
  IndiaSourceMap(this.regions, this.outline);
  final List<SourceMapRegion> regions;
  final Path outline;
  static Future<IndiaSourceMap>? _pending;
  static Future<IndiaSourceMap> load() => _pending ??= rootBundle
      .loadString('assets/content/geography/india_source_interaction.json')
      .then((raw) => fromJson(jsonDecode(raw) as Map<String, dynamic>));
  static IndiaSourceMap fromJson(Map<String, dynamic> json) {
    Offset point(dynamic p) =>
        Offset((p[0] as num).toDouble(), (p[1] as num).toDouble());
    final regions = <SourceMapRegion>[];
    for (final r in json['regions'] as List) {
      final path = Path()..fillType = PathFillType.evenOdd;
      for (final ring in r['rings'] as List) {
        final first = point(ring.first);
        path.moveTo(first.dx, first.dy);
        for (final p in ring.skip(1)) {
          final v = point(p);
          path.lineTo(v.dx, v.dy);
        }
        path.close();
      }
      regions.add(
        SourceMapRegion(r['name'] as String, path, point(r['anchor'])),
      );
    }
    final outline = Path();
    for (final segment in json['segments'] as List) {
      final a = point(segment[0]), b = point(segment[1]);
      outline.moveTo(a.dx, a.dy);
      outline.lineTo(b.dx, b.dy);
    }
    return IndiaSourceMap(regions, outline);
  }

  String? hit(Offset source) {
    for (final r in regions) {
      if (r.path.contains(source)) return r.name;
    }
    return null;
  }
}

/// One uniform fit is shared by paint, highlights and hit testing.
class IndiaMapFit {
  IndiaMapFit(Size size)
    : scale = math.min(size.width / 705, size.height / 805),
      offset = Offset(
        (size.width - math.min(size.width / 705, size.height / 805) * 705) / 2,
        (size.height - math.min(size.width / 705, size.height / 805) * 805) / 2,
      );
  final double scale;
  final Offset offset;
  Offset toSource(Offset p) => (p - offset) / scale + const Offset(45, 145);
  Offset toLocal(Offset p) => (p - const Offset(45, 145)) * scale + offset;
}

class IndiaInteractiveMap extends StatelessWidget {
  const IndiaInteractiveMap({
    super.key,
    this.highlight,
    this.onSelect,
    this.showSelectedName = true,
  });
  final String? highlight;
  final ValueChanged<String>? onSelect;
  final bool showSelectedName;
  @override
  Widget build(BuildContext context) => FutureBuilder<IndiaSourceMap>(
    future: IndiaSourceMap.load(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'Map could not load. Use the place list and try again.',
            ),
          ),
        );
      }
      if (!snapshot.hasData) {
        return const SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        );
      }
      final map = snapshot.data!;
      return AspectRatio(
        aspectRatio: 705 / 805,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 8,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return Semantics(
                  label: 'India map. Pinch to zoom. State names are also available in the list.',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: onSelect == null
                        ? null
                        : (details) {
                            final name = map.hit(
                              IndiaMapFit(size).toSource(details.localPosition),
                            );
                            if (name != null) onSelect!(name);
                          },
                    child: RepaintBoundary(
                      child: CustomPaint(
                        size: size,
                        painter: _SourcePainter(
                          map,
                          highlight,
                          showSelectedName,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class _SourcePainter extends CustomPainter {
  _SourcePainter(this.map, this.highlight, this.showName);
  final IndiaSourceMap map;
  final String? highlight;
  final bool showName;
  static const colors = [
    Color(0xFFF9D77F),
    Color(0xFFB5DFBD),
    Color(0xFFB9D4F4),
    Color(0xFFF5B6C1),
    Color(0xFFD1B9ED),
    Color(0xFFA8DED7),
    Color(0xFFF2C49F),
  ];
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEDF8FC),
    );
    final fit = IndiaMapFit(size);
    canvas.save();
    canvas.translate(fit.offset.dx, fit.offset.dy);
    canvas.scale(fit.scale);
    canvas.translate(-45, -145);
    for (var i = 0; i < map.regions.length; i++) {
      final r = map.regions[i];
      canvas.drawPath(
        r.path,
        Paint()
          ..color = r.name == highlight
              ? const Color(0xFF7652D7)
              : colors[i % colors.length],
      );
    }
    canvas.drawPath(
      map.outline,
      Paint()
        ..color = const Color(0xFF334E5C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 / fit.scale
        ..strokeJoin = StrokeJoin.round,
    );
    final selected = map.regions.where((r) => r.name == highlight).firstOrNull;
    if (selected != null) {
      canvas.drawPath(
        selected.path,
        Paint()
          ..color = const Color(0xFF3B237D)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 / fit.scale,
      );
    }
    canvas.restore();
    final compass = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
          color: Color(0xFF334E5C),
          fontSize: 16,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    compass.paint(canvas, const Offset(12, 12));
    final arrow = Paint()
      ..color = const Color(0xFF334E5C)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(35, 30), const Offset(35, 14), arrow);
    canvas.drawLine(const Offset(35, 14), const Offset(31, 20), arrow);
    canvas.drawLine(const Offset(35, 14), const Offset(39, 20), arrow);
    if (selected != null && showName) {
      final t = TextPainter(
        text: TextSpan(
          text: selected.name,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Nunito',
            color: Color(0xFF21133F),
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: size.width - 20);
      final p = fit.toLocal(selected.anchor);
      final x = (p.dx - t.width / 2).clamp(
        5.0,
        math.max(5.0, size.width - t.width - 5),
      );
      final y = (p.dy - t.height / 2).clamp(
        35.0,
        math.max(35.0, size.height - t.height - 5),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 4, y - 3, t.width + 8, t.height + 6),
          const Radius.circular(6),
        ),
        Paint()..color = Colors.white,
      );
      t.paint(canvas, Offset(x.toDouble(), y.toDouble()));
    }
  }

  @override
  bool shouldRepaint(_SourcePainter old) =>
      old.highlight != highlight || old.map != map || old.showName != showName;
}
