import 'dart:math' as math;
import 'dart:ui';

import '../models/content_pack.dart';
import 'geography_models.dart';

class CanvasMapTransform {
  const CanvasMapTransform(
    this.width,
    this.height, {
    this.minX = 0,
    this.minY = 0,
    this.maxX = 1,
    this.maxY = 1,
  });

  final double width;
  final double height;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  double get sourceWidth => maxX - minX;

  double get sourceHeight => maxY - minY;

  Offset toLocal(OffsetPoint point) {
    if (sourceWidth <= 0 || sourceHeight <= 0) {
      return Offset.zero;
    }
    return Offset(
      ((point.x - minX) / sourceWidth) * width,
      ((point.y - minY) / sourceHeight) * height,
    );
  }

  OffsetPoint toNormalized(Offset local) {
    if (width <= 0 || height <= 0 || sourceWidth <= 0 || sourceHeight <= 0) {
      return const OffsetPoint(0, 0);
    }
    return OffsetPoint(
      minX + (local.dx / width).clamp(0, 1) * sourceWidth,
      minY + (local.dy / height).clamp(0, 1) * sourceHeight,
    );
  }

  /// Letterbox [content] into [size] without stretching borders.
  static CanvasMapTransform fit(
    Size size, [
    Rect content = const Rect.fromLTWH(0, 0, 1, 1),
  ]) {
    final sourceW = content.width <= 0 ? 1.0 : content.width;
    final sourceH = content.height <= 0 ? 1.0 : content.height;
    final scale = math.min(size.width / sourceW, size.height / sourceH);
    return CanvasMapTransform(
      sourceW * scale,
      sourceH * scale,
      minX: content.left,
      minY: content.top,
      maxX: content.right,
      maxY: content.bottom,
    );
  }
}

class MapHit {
  const MapHit({required this.regionId, required this.useListAlternative});

  final String regionId;
  final bool useListAlternative;
}

class MapInteractor {
  const MapInteractor(this.atlas, {this.minSpan = 0.055});

  final IndiaMapAtlas atlas;
  final double minSpan;

  bool contains(RegionOutline region, OffsetPoint point) {
    for (final ring in region.rings) {
      if (_inRing(ring.points, point)) {
        return true;
      }
    }
    return false;
  }

  MapHit? hit(OffsetPoint point) {
    for (final region in atlas.regions) {
      if (contains(region, point)) {
        return MapHit(
          regionId: region.id,
          useListAlternative: needsListAlternative(region),
        );
      }
    }
    return null;
  }

  bool needsListAlternative(RegionOutline region) {
    return region.smallTarget ||
        region.width < minSpan ||
        region.height < minSpan;
  }

  Rect insetBounds(RegionOutline region, {double pad = 0.08}) {
    final width = math.max(region.width, minSpan);
    final height = math.max(region.height, minSpan);
    final cx = (region.minX + region.maxX) / 2;
    final cy = (region.minY + region.maxY) / 2;
    final world = atlas.contentBounds.inflate(0.02);
    return Rect.fromCenter(
      center: Offset(cx, cy),
      width: width + pad,
      height: height + pad,
    ).intersect(world);
  }

  static bool _inRing(List<OffsetPoint> ring, OffsetPoint point) {
    if (ring.length < 3) {
      return false;
    }
    var inside = false;
    for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final a = ring[i];
      final b = ring[j];
      final intersects =
          (a.y > point.y) != (b.y > point.y) &&
          point.x <
              (b.x - a.x) *
                      (point.y - a.y) /
                      ((b.y - a.y) == 0 ? 1 : (b.y - a.y)) +
                  a.x;
      if (intersects) {
        inside = !inside;
      }
    }
    return inside;
  }
}

IndiaMapAtlas atlasFromJson(Map<String, dynamic> json) {
  final source = Map<String, dynamic>.from(json['source'] as Map);
  final country = _rings(json['country'] as Map<String, dynamic>);
  final regions = [
    for (final item in json['regions'] as List<dynamic>)
      _region(Map<String, dynamic>.from(item as Map)),
  ];
  return IndiaMapAtlas(
    packId: json['packId'] as String,
    sourceName: source['name'] as String,
    sourceUrl: source['url'] as String,
    license: source['license'] as String,
    retrievedAt: source['retrievedAt'] as String,
    modifications: source['modifications'] as String,
    reviewStatus:
        ReviewStatus.fromStorage(json['reviewStatus'] as String) ??
        ReviewStatus.placeholder,
    country: country,
    regions: regions,
    contentBounds: _contentBounds(country, regions),
  );
}

Rect _contentBounds(List<MapRing> country, List<RegionOutline> regions) {
  var minX = 0.0;
  var minY = 0.0;
  var maxX = 1.0;
  var maxY = 1.0;
  var seen = false;
  void consider(OffsetPoint point) {
    if (!seen) {
      minX = maxX = point.x;
      minY = maxY = point.y;
      seen = true;
      return;
    }
    minX = math.min(minX, point.x);
    minY = math.min(minY, point.y);
    maxX = math.max(maxX, point.x);
    maxY = math.max(maxY, point.y);
  }

  for (final ring in country) {
    for (final point in ring.points) {
      consider(point);
    }
  }
  for (final region in regions) {
    for (final ring in region.rings) {
      for (final point in ring.points) {
        consider(point);
      }
    }
  }
  if (!seen) {
    return const Rect.fromLTWH(0, 0, 1, 1);
  }
  return Rect.fromLTRB(minX, minY, maxX, maxY);
}

List<MapRing> _rings(Map<String, dynamic> json) {
  return [
    for (final ring in json['rings'] as List<dynamic>)
      MapRing([
        for (final point in ring as List<dynamic>)
          OffsetPoint(
            (point[0] as num).toDouble(),
            (point[1] as num).toDouble(),
          ),
      ]),
  ];
}

RegionOutline _region(Map<String, dynamic> json) {
  final box = json['bbox'] as List<dynamic>;
  final centroid = json['centroid'] as List<dynamic>;
  return RegionOutline(
    id: json['id'] as String,
    name: json['name'] as String,
    rings: _rings(json),
    centroid: OffsetPoint(
      (centroid[0] as num).toDouble(),
      (centroid[1] as num).toDouble(),
    ),
    minX: (box[0] as num).toDouble(),
    minY: (box[1] as num).toDouble(),
    maxX: (box[2] as num).toDouble(),
    maxY: (box[3] as num).toDouble(),
    smallTarget: json['smallTarget'] as bool,
  );
}
