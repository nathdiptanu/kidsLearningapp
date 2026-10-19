import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_system/sprout_tokens.dart';
import '../../domain/geography/geography_models.dart';
import '../../domain/geography/map_geometry.dart';
import '../../domain/models/content_pack.dart';

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
    if (atlas.reviewStatus != ReviewStatus.approved) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Map activities are temporarily unavailable while we verify the learning material.',
        ),
      );
    }
    return Semantics(
      label: 'Map of India. Coloured places can be chosen.',
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final transform = CanvasMapTransform.fit(
              Size(constraints.maxWidth, constraints.maxHeight),
              atlas.contentBounds,
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
    final transform = CanvasMapTransform.fit(size, atlas.contentBounds);
    final origin = Offset(
      (size.width - transform.width) / 2,
      (size.height - transform.height) / 2,
    );
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.clipRect(Rect.fromLTWH(0, 0, transform.width, transform.height));
    final fill = Paint()..color = land;
    final outline = Paint()
      ..color = ink.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final stroke = Paint()
      ..color = ink.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    for (final ring in atlas.country) {
      canvas.drawPath(_path(ring, transform), fill);
      canvas.drawPath(_path(ring, transform), stroke);
    }
    for (final region in atlas.regions) {
      final active =
          highlightedIds.contains(region.id) || region.id == selectedId;
      if (active) {
        final color = region.id == selectedId ? selected : highlight;
        final paint = Paint()..color = color.withValues(alpha: 0.72);
        for (final ring in region.rings) {
          canvas.drawPath(_path(ring, transform), paint);
          canvas.drawPath(_path(ring, transform), stroke);
        }
      } else {
        for (final ring in region.rings) {
          canvas.drawPath(_path(ring, transform), outline);
        }
      }
    }
    canvas.restore();
    if (insetId != null) {
      final region = atlas.byId(insetId!);
      if (region != null) {
        _paintInset(canvas, size, region);
      }
    }
  }

  void _paintInset(Canvas canvas, Size size, RegionOutline region) {
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
    final inner = box.deflate(16);
    final width = region.width == 0 ? 0.1 : region.width;
    final height = region.height == 0 ? 0.1 : region.height;
    final scale = math.min(inner.width / width, inner.height / height);
    final drawW = width * scale;
    final drawH = height * scale;
    final left = inner.left + (inner.width - drawW) / 2;
    final top = inner.top + (inner.height - drawH) / 2;
    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(inner, const Radius.circular(12)));
    for (final ring in region.rings) {
      final path = Path();
      for (var i = 0; i < ring.points.length; i++) {
        final point = ring.points[i];
        final x = left + (point.x - region.minX) * scale;
        final y = top + (point.y - region.minY) * scale;
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
