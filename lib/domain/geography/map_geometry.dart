import 'dart:math' as math;
import 'dart:ui';

import '../models/content_pack.dart';
import 'geography_models.dart';

class CanvasMapTransform {
  const CanvasMapTransform(this.width, this.height);

  final double width;
  final double height;

  Offset toLocal(OffsetPoint point) {
    return Offset(point.x * width, point.y * height);
  }

  OffsetPoint toNormalized(Offset local) {
    if (width <= 0 || height <= 0) {
      return const OffsetPoint(0, 0);
    }
    return OffsetPoint(
      (local.dx / width).clamp(0, 1),
      (local.dy / height).clamp(0, 1),
    );
  }

  /// Letterbox the 1:1 India canvas into [size] without stretching borders.
  static CanvasMapTransform fit(Size size) {
    final side = math.min(size.width, size.height);
    return CanvasMapTransform(side, side);
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
    return Rect.fromCenter(
      center: Offset(cx, cy),
      width: width + pad,
      height: height + pad,
    ).intersect(const Rect.fromLTWH(0, 0, 1, 1));
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
    country: _rings(json['country'] as Map<String, dynamic>),
    regions: [
      for (final item in json['regions'] as List<dynamic>)
        _region(Map<String, dynamic>.from(item as Map)),
    ],
  );
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
