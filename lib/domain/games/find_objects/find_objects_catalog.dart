import 'dart:ui';

import '../../models/age_band.dart';

class FindObjectTarget {
  const FindObjectTarget({
    required this.id,
    required this.label,
    required this.region,
  });

  final String id;
  final String label;
  final Rect region;
}

class FindObjectScene {
  const FindObjectScene({
    required this.id,
    required this.title,
    required this.objects,
  });

  final String id;
  final String title;
  final List<FindObjectTarget> objects;
}

class FindObjectHit {
  const FindObjectHit({required this.objectId, required this.alreadyFound});

  final String? objectId;
  final bool alreadyFound;

  bool get missed => objectId == null;
}

List<FindObjectTarget> _spread(List<(String, String)> items) {
  const boxes = [
    Rect.fromLTWH(0.06, 0.08, 0.16, 0.16),
    Rect.fromLTWH(0.76, 0.08, 0.16, 0.16),
    Rect.fromLTWH(0.42, 0.42, 0.16, 0.16),
    Rect.fromLTWH(0.06, 0.74, 0.16, 0.16),
    Rect.fromLTWH(0.76, 0.74, 0.16, 0.16),
  ];
  return [
    for (var i = 0; i < items.length; i++)
      FindObjectTarget(id: items[i].$1, label: items[i].$2, region: boxes[i]),
  ];
}

final findObjectScenes = <FindObjectScene>[
  FindObjectScene(
    id: 'shelf',
    title: 'On the shelf',
    objects: _spread(const [
      ('book', 'Book'),
      ('cup', 'Cup'),
      ('ball', 'Ball'),
      ('hat', 'Hat'),
      ('shoe', 'Shoe'),
    ]),
  ),
  FindObjectScene(
    id: 'garden-find',
    title: 'In the garden',
    objects: _spread(const [
      ('sun', 'Sun'),
      ('bird', 'Bird'),
      ('tree', 'Tree'),
      ('flower', 'Flower'),
      ('can', 'Can'),
    ]),
  ),
  FindObjectScene(
    id: 'table',
    title: 'On the table',
    objects: _spread(const [
      ('apple', 'Apple'),
      ('cup', 'Cup'),
      ('book', 'Book'),
      ('spoon', 'Spoon'),
      ('banana', 'Banana'),
    ]),
  ),
  FindObjectScene(
    id: 'park-find',
    title: 'At the park',
    objects: _spread(const [
      ('kite', 'Kite'),
      ('tree', 'Tree'),
      ('ball', 'Ball'),
      ('bench', 'Bench'),
      ('dog', 'Dog'),
    ]),
  ),
  FindObjectScene(
    id: 'room-find',
    title: 'In the room',
    objects: _spread(const [
      ('lamp', 'Lamp'),
      ('plant', 'Plant'),
      ('book', 'Book'),
      ('ball', 'Ball'),
      ('chair', 'Chair'),
    ]),
  ),
  FindObjectScene(
    id: 'beach-find',
    title: 'At the beach',
    objects: _spread(const [
      ('umbrella', 'Umbrella'),
      ('boat', 'Boat'),
      ('fish', 'Fish'),
      ('shell', 'Shell'),
      ('crab', 'Crab'),
    ]),
  ),
  FindObjectScene(
    id: 'kitchen-find',
    title: 'In the kitchen',
    objects: _spread(const [
      ('clock', 'Clock'),
      ('fruit', 'Fruit'),
      ('cup', 'Cup'),
      ('towel', 'Towel'),
      ('spoon', 'Spoon'),
    ]),
  ),
  FindObjectScene(
    id: 'farm-find',
    title: 'On the farm',
    objects: _spread(const [
      ('sun', 'Sun'),
      ('tree', 'Tree'),
      ('wheel', 'Wheel'),
      ('chicken', 'Chicken'),
      ('flower', 'Flower'),
    ]),
  ),
  FindObjectScene(
    id: 'shop',
    title: 'At the shop',
    objects: _spread(const [
      ('apple', 'Apple'),
      ('cup', 'Cup'),
      ('banana', 'Banana'),
      ('hat', 'Hat'),
      ('book', 'Book'),
    ]),
  ),
  FindObjectScene(
    id: 'class',
    title: 'In class',
    objects: _spread(const [
      ('clock', 'Clock'),
      ('book', 'Book'),
      ('pencil', 'Pencil'),
      ('ball', 'Ball'),
      ('bag', 'Bag'),
    ]),
  ),
  FindObjectScene(
    id: 'zoo',
    title: 'At the zoo',
    objects: _spread(const [
      ('bird', 'Bird'),
      ('sun', 'Sun'),
      ('dog', 'Dog'),
      ('ball', 'Ball'),
      ('tree', 'Tree'),
    ]),
  ),
  FindObjectScene(
    id: 'river',
    title: 'By the river',
    objects: _spread(const [
      ('bird', 'Bird'),
      ('boat', 'Boat'),
      ('tree', 'Tree'),
      ('flower', 'Flower'),
      ('fish', 'Fish'),
    ]),
  ),
  FindObjectScene(
    id: 'play',
    title: 'On the playground',
    objects: _spread(const [
      ('kite', 'Kite'),
      ('bench', 'Bench'),
      ('ball', 'Ball'),
      ('shoe', 'Shoe'),
      ('hat', 'Hat'),
    ]),
  ),
  FindObjectScene(
    id: 'bakery',
    title: 'At the bakery',
    objects: _spread(const [
      ('clock', 'Clock'),
      ('apple', 'Apple'),
      ('cup', 'Cup'),
      ('spoon', 'Spoon'),
      ('bag', 'Bag'),
    ]),
  ),
  FindObjectScene(
    id: 'market',
    title: 'At the market',
    objects: _spread(const [
      ('mango', 'Mango'),
      ('flower', 'Flower'),
      ('banana', 'Banana'),
      ('hat', 'Hat'),
      ('bag', 'Bag'),
    ]),
  ),
  FindObjectScene(
    id: 'snow',
    title: 'In the snow',
    objects: _spread(const [
      ('bird', 'Bird'),
      ('tree', 'Tree'),
      ('hat', 'Hat'),
      ('shoe', 'Shoe'),
      ('ball', 'Ball'),
    ]),
  ),
  FindObjectScene(
    id: 'desert',
    title: 'In the sand',
    objects: _spread(const [
      ('sun', 'Sun'),
      ('hat', 'Hat'),
      ('cup', 'Cup'),
      ('ball', 'Ball'),
      ('shell', 'Shell'),
    ]),
  ),
  FindObjectScene(
    id: 'forest',
    title: 'In the forest',
    objects: _spread(const [
      ('bird', 'Bird'),
      ('tree', 'Tree'),
      ('flower', 'Flower'),
      ('leaf', 'Leaf'),
      ('mushroom', 'Mushroom'),
    ]),
  ),
  FindObjectScene(
    id: 'station',
    title: 'At the station',
    objects: _spread(const [
      ('clock', 'Clock'),
      ('train', 'Train'),
      ('bag', 'Bag'),
      ('bench', 'Bench'),
      ('hat', 'Hat'),
    ]),
  ),
  FindObjectScene(
    id: 'harbour',
    title: 'At the harbour',
    objects: _spread(const [
      ('sun', 'Sun'),
      ('bird', 'Bird'),
      ('boat', 'Boat'),
      ('shell', 'Shell'),
      ('fish', 'Fish'),
    ]),
  ),
];

class FindObjectsCatalog {
  const FindObjectsCatalog();

  static const generatorVersion = 'find_objects:v1';

  int countFor(AgeBand band) {
    return switch (band) {
      AgeBand.a || AgeBand.toddler => 2,
      AgeBand.b => 3,
      AgeBand.c => 4,
      AgeBand.d => 5,
    };
  }

  double padFor(AgeBand band) {
    return switch (band) {
      AgeBand.a || AgeBand.toddler => 0.04,
      AgeBand.b => 0.03,
      AgeBand.c => 0.025,
      AgeBand.d => 0.02,
    };
  }

  FindObjectScene sceneFor(int variant) {
    return findObjectScenes[variant % findObjectScenes.length];
  }

  List<FindObjectTarget> targetsFor(AgeBand band, int variant) {
    final scene = sceneFor(variant);
    return scene.objects.take(countFor(band)).toList();
  }

  FindObjectHit hitTest({
    required Offset point,
    required List<FindObjectTarget> targets,
    required Set<String> found,
    required double pad,
  }) {
    for (final target in targets) {
      if (target.region.inflate(pad).contains(point)) {
        return FindObjectHit(
          objectId: target.id,
          alreadyFound: found.contains(target.id),
        );
      }
    }
    return const FindObjectHit(objectId: null, alreadyFound: false);
  }

  bool regionsStaySeparate(List<FindObjectTarget> targets, double pad) {
    for (var left = 0; left < targets.length; left++) {
      for (var right = left + 1; right < targets.length; right++) {
        if (targets[left].region
            .inflate(pad)
            .overlaps(targets[right].region.inflate(pad))) {
          return false;
        }
      }
    }
    return true;
  }
}
