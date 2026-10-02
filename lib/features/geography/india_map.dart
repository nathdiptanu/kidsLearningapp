import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../domain/geography/geography_models.dart';
import '../../domain/geography/map_geometry.dart';

class IndiaMapView extends StatelessWidget {
  const IndiaMapView({
    required this.atlas,
    required this.highlightedIds,
    this.selectedId,
    this.onRegionTap,
    this.insetId,
    this.height = 280,
    super.key,
  });

  final IndiaMapAtlas atlas;
  final Set<String> highlightedIds;
  final String? selectedId;
  final ValueChanged<MapHit>? onRegionTap;
  final String? insetId;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Map of India. Coloured places can be chosen.',
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final transform = CanvasMapTransform.fit(
              Size(constraints.maxWidth, constraints.maxHeight),
            );
            final interactor = MapInteractor(atlas);
            return GestureDetector(
              onTapDown: onRegionTap == null
                  ? null
                  : (details) {
                      final box = context.findRenderObject() as RenderBox;
                      final local = box.globalToLocal(details.globalPosition);
                      final dx = (constraints.maxWidth - transform.width) / 2;
                      final dy = (constraints.maxHeight - transform.height) / 2;
                      final point = transform.toNormalized(
                        Offset(local.dx - dx, local.dy - dy),
                      );
                      final hit = interactor.hit(point);
                      if (hit != null) {
                        onRegionTap!(hit);
                      }
                    },
              child: CustomPaint(
                painter: _IndiaMapPainter(
                  atlas: atlas,
                  highlightedIds: highlightedIds,
                  selectedId: selectedId,
                  insetId: insetId,
                  ink: SproutColors.ink,
                  land: SproutColors.indiaSurface,
                  highlight: SproutColors.india,
                  selected: SproutColors.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IndiaMapPainter extends CustomPainter {
  const _IndiaMapPainter({
    required this.atlas,
    required this.highlightedIds,
    required this.selectedId,
    required this.insetId,
    required this.ink,
    required this.land,
    required this.highlight,
    required this.selected,
  });

  final IndiaMapAtlas atlas;
  final Set<String> highlightedIds;
  final String? selectedId;
  final String? insetId;
  final Color ink;
  final Color land;
  final Color highlight;
  final Color selected;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final origin = Offset((size.width - side) / 2, (size.height - side) / 2);
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    final transform = CanvasMapTransform(side, side);
    final fill = Paint()..color = land;
    final stroke = Paint()
      ..color = ink.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    for (final ring in atlas.country) {
      canvas.drawPath(_path(ring, transform), fill);
      canvas.drawPath(_path(ring, transform), stroke);
    }
    for (final region in atlas.regions) {
      if (!highlightedIds.contains(region.id) && region.id != selectedId) {
        continue;
      }
      final color = region.id == selectedId ? selected : highlight;
      final paint = Paint()..color = color.withValues(alpha: 0.72);
      for (final ring in region.rings) {
        canvas.drawPath(_path(ring, transform), paint);
        canvas.drawPath(_path(ring, transform), stroke);
      }
    }
    canvas.restore();
    if (insetId != null) {
      final region = atlas.byId(insetId!);
      if (region != null) {
        _paintInset(canvas, size, region, transform, origin);
      }
    }
  }

  void _paintInset(
    Canvas canvas,
    Size size,
    RegionOutline region,
    CanvasMapTransform transform,
    Offset origin,
  ) {
    final box = Rect.fromLTWH(size.width - 132, 8, 124, 124);
    final bg = Paint()..color = const Color(0xFFFFFFFF);
    final edge = Paint()
      ..color = ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(box, const Radius.circular(16)),
      bg,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(box, const Radius.circular(16)),
      edge,
    );
    final pad = 16.0;
    final inner = box.deflate(pad);
    final width = region.width == 0 ? 0.1 : region.width;
    final height = region.height == 0 ? 0.1 : region.height;
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(inner, const Radius.circular(12)));
    for (final ring in region.rings) {
      final path = Path();
      for (var i = 0; i < ring.points.length; i++) {
        final point = ring.points[i];
        final x = inner.left + ((point.x - region.minX) / width) * inner.width;
        final y = inner.top + ((point.y - region.minY) / height) * inner.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, Paint()..color = selected.withValues(alpha: 0.85));
      canvas.drawPath(
        path,
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
    canvas.restore();
  }

  Path _path(MapRing ring, CanvasMapTransform transform) {
    final path = Path();
    if (ring.points.isEmpty) {
      return path;
    }
    final first = transform.toLocal(ring.points.first);
    path.moveTo(first.dx, first.dy);
    for (final point in ring.points.skip(1)) {
      final local = transform.toLocal(point);
      path.lineTo(local.dx, local.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _IndiaMapPainter oldDelegate) {
    return oldDelegate.selectedId != selectedId ||
        oldDelegate.insetId != insetId ||
        oldDelegate.highlightedIds != highlightedIds;
  }
}
