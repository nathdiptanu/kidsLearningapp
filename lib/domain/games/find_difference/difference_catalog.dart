import 'dart:ui';

import '../../models/age_band.dart';

class DifferenceSpot {
  const DifferenceSpot({required this.id, required this.region});

  final String id;
  final Rect region;
}

class DifferenceScene {
  const DifferenceScene({
    required this.id,
    required this.title,
    required this.spots,
  });

  final String id;
  final String title;
  final List<DifferenceSpot> spots;
}

class DifferenceHit {
  const DifferenceHit({required this.spotId, required this.alreadyMarked});

  final String? spotId;
  final bool alreadyMarked;

  bool get missed => spotId == null;
}

/// Original scene pairs drawn in the app. Not production-final artwork.
const differenceScenes = <DifferenceScene>[
  DifferenceScene(
    id: 'garden',
    title: 'Garden',
    spots: [
      DifferenceSpot(
        id: 'cloud',
        region: Rect.fromLTWH(0.06, 0.08, 0.16, 0.14),
      ),
      DifferenceSpot(id: 'bird', region: Rect.fromLTWH(0.76, 0.08, 0.16, 0.14)),
      DifferenceSpot(
        id: 'flower',
        region: Rect.fromLTWH(0.06, 0.74, 0.16, 0.14),
      ),
      DifferenceSpot(
        id: 'butterfly',
        region: Rect.fromLTWH(0.42, 0.42, 0.14, 0.14),
      ),
      DifferenceSpot(id: 'can', region: Rect.fromLTWH(0.76, 0.74, 0.16, 0.14)),
    ],
  ),
  DifferenceScene(
    id: 'room',
    title: 'Room',
    spots: [
      DifferenceSpot(id: 'lamp', region: Rect.fromLTWH(0.08, 0.1, 0.14, 0.16)),
      DifferenceSpot(id: 'book', region: Rect.fromLTWH(0.76, 0.12, 0.14, 0.14)),
      DifferenceSpot(id: 'ball', region: Rect.fromLTWH(0.1, 0.72, 0.14, 0.14)),
      DifferenceSpot(
        id: 'picture',
        region: Rect.fromLTWH(0.44, 0.18, 0.14, 0.14),
      ),
      DifferenceSpot(id: 'plant', region: Rect.fromLTWH(0.74, 0.7, 0.16, 0.16)),
    ],
  ),
  DifferenceScene(
    id: 'park',
    title: 'Park',
    spots: [
      DifferenceSpot(id: 'kite', region: Rect.fromLTWH(0.08, 0.1, 0.14, 0.16)),
      DifferenceSpot(id: 'apple', region: Rect.fromLTWH(0.74, 0.1, 0.14, 0.14)),
      DifferenceSpot(
        id: 'bench',
        region: Rect.fromLTWH(0.08, 0.72, 0.18, 0.12),
      ),
      DifferenceSpot(id: 'ball', region: Rect.fromLTWH(0.44, 0.46, 0.12, 0.12)),
      DifferenceSpot(id: 'dog', region: Rect.fromLTWH(0.74, 0.7, 0.16, 0.16)),
    ],
  ),
  DifferenceScene(
    id: 'kitchen',
    title: 'Kitchen',
    spots: [
      DifferenceSpot(id: 'cup', region: Rect.fromLTWH(0.08, 0.16, 0.14, 0.16)),
      DifferenceSpot(
        id: 'fruit',
        region: Rect.fromLTWH(0.74, 0.14, 0.16, 0.14),
      ),
      DifferenceSpot(
        id: 'clock',
        region: Rect.fromLTWH(0.42, 0.08, 0.14, 0.14),
      ),
      DifferenceSpot(id: 'towel', region: Rect.fromLTWH(0.1, 0.7, 0.12, 0.18)),
      DifferenceSpot(
        id: 'spoon',
        region: Rect.fromLTWH(0.74, 0.68, 0.14, 0.16),
      ),
    ],
  ),
  DifferenceScene(
    id: 'beach',
    title: 'Beach',
    spots: [
      DifferenceSpot(id: 'shell', region: Rect.fromLTWH(0.08, 0.7, 0.14, 0.12)),
      DifferenceSpot(id: 'boat', region: Rect.fromLTWH(0.7, 0.28, 0.18, 0.14)),
      DifferenceSpot(
        id: 'umbrella',
        region: Rect.fromLTWH(0.1, 0.36, 0.16, 0.16),
      ),
      DifferenceSpot(id: 'fish', region: Rect.fromLTWH(0.46, 0.62, 0.14, 0.12)),
      DifferenceSpot(id: 'crab', region: Rect.fromLTWH(0.74, 0.72, 0.14, 0.12)),
    ],
  ),
  DifferenceScene(
    id: 'farm',
    title: 'Farm',
    spots: [
      DifferenceSpot(id: 'sun', region: Rect.fromLTWH(0.08, 0.08, 0.14, 0.14)),
      DifferenceSpot(
        id: 'window',
        region: Rect.fromLTWH(0.46, 0.22, 0.12, 0.12),
      ),
      DifferenceSpot(
        id: 'chicken',
        region: Rect.fromLTWH(0.1, 0.7, 0.16, 0.14),
      ),
      DifferenceSpot(id: 'wheel', region: Rect.fromLTWH(0.7, 0.48, 0.14, 0.14)),
      DifferenceSpot(id: 'post', region: Rect.fromLTWH(0.78, 0.72, 0.1, 0.16)),
    ],
  ),
];

class DifferenceCatalog {
  const DifferenceCatalog();

  static const masterWidth = 1600;
  static const masterHeight = 1200;

  int countFor(AgeBand band) {
    return switch (band) {
      AgeBand.a => 2,
      AgeBand.b => 3,
      AgeBand.c => 4,
      AgeBand.d => 5,
    };
  }

  double padFor(AgeBand band) {
    return switch (band) {
      AgeBand.a => 0.04,
      AgeBand.b => 0.03,
      AgeBand.c => 0.025,
      AgeBand.d => 0.02,
    };
  }

  DifferenceScene sceneFor(int variant) {
    return differenceScenes[variant % differenceScenes.length];
  }

  List<DifferenceSpot> activeSpots(AgeBand band, int variant) {
    final scene = sceneFor(variant);
    return scene.spots.take(countFor(band)).toList();
  }

  DifferenceHit hitTest({
    required Offset point,
    required List<DifferenceSpot> active,
    required Set<String> marked,
    required double pad,
  }) {
    for (final spot in active) {
      if (spot.region.inflate(pad).contains(point)) {
        return DifferenceHit(
          spotId: spot.id,
          alreadyMarked: marked.contains(spot.id),
        );
      }
    }
    return const DifferenceHit(spotId: null, alreadyMarked: false);
  }

  bool regionsStaySeparate(List<DifferenceSpot> spots, double pad) {
    for (var left = 0; left < spots.length; left++) {
      for (var right = left + 1; right < spots.length; right++) {
        final a = spots[left].region.inflate(pad);
        final b = spots[right].region.inflate(pad);
        if (a.overlaps(b)) {
          return false;
        }
      }
    }
    return true;
  }
}
