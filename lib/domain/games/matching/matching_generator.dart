import '../../models/age_band.dart';
import '../play/play_question.dart';

class OddTemplate {
  const OddTemplate({
    required this.id,
    required this.itemIds,
    required this.oddIndex,
    required this.explanation,
    required this.bands,
  });

  final String id;
  final List<PictureId> itemIds;
  final int oddIndex;
  final String explanation;
  final Set<AgeBand> bands;

  bool get isUnambiguous {
    if (oddIndex < 0 || oddIndex >= itemIds.length) {
      return false;
    }
    if (itemIds.toSet().length != itemIds.length) {
      return false;
    }
    final items = itemIds.map(pictureById).toList();
    final oddKind = items[oddIndex].kind;
    final others = [
      for (var index = 0; index < items.length; index++)
        if (index != oddIndex) items[index],
    ];
    if (others.any((item) => item.kind == oddKind)) {
      return false;
    }
    final shared = others.first.kind;
    return others.every((item) => item.kind == shared);
  }
}

const oddTemplates = <OddTemplate>[
  OddTemplate(
    id: 'fruit-car',
    itemIds: [PictureId.apple, PictureId.banana, PictureId.car],
    oddIndex: 2,
    explanation: 'Apple and banana are fruit. A car is a vehicle.',
    bands: {AgeBand.a, AgeBand.b},
  ),
  OddTemplate(
    id: 'animal-spoon',
    itemIds: [PictureId.cat, PictureId.dog, PictureId.spoon],
    oddIndex: 2,
    explanation: 'Cat and dog are animals. A spoon is a home object.',
    bands: {AgeBand.a, AgeBand.b},
  ),
  OddTemplate(
    id: 'vehicle-banana',
    itemIds: [PictureId.bus, PictureId.train, PictureId.banana],
    oddIndex: 2,
    explanation: 'Bus and train are vehicles. A banana is fruit.',
    bands: {AgeBand.a, AgeBand.b},
  ),
  OddTemplate(
    id: 'sky-shoe',
    itemIds: [PictureId.sun, PictureId.moon, PictureId.shoe],
    oddIndex: 2,
    explanation: 'Sun and moon are in the sky. A shoe is clothing.',
    bands: {AgeBand.a, AgeBand.b},
  ),
  OddTemplate(
    id: 'fruit-spoon',
    itemIds: [PictureId.mango, PictureId.apple, PictureId.spoon],
    oddIndex: 2,
    explanation: 'Mango and apple are fruit. A spoon is a home object.',
    bands: {AgeBand.a, AgeBand.b},
  ),
  OddTemplate(
    id: 'animal-shoe',
    itemIds: [PictureId.bird, PictureId.cat, PictureId.shoe],
    oddIndex: 2,
    explanation: 'Bird and cat are animals. A shoe is clothing.',
    bands: {AgeBand.a, AgeBand.b},
  ),
  OddTemplate(
    id: 'flowers-bicycle',
    itemIds: [
      PictureId.rose,
      PictureId.tulip,
      PictureId.sunflower,
      PictureId.bicycle,
    ],
    oddIndex: 3,
    explanation:
        'Rose, tulip and sunflower are flowers. A bicycle is a vehicle.',
    bands: {AgeBand.c, AgeBand.d},
  ),
  OddTemplate(
    id: 'clothes-bus',
    itemIds: [PictureId.hat, PictureId.shirt, PictureId.sock, PictureId.bus],
    oddIndex: 3,
    explanation: 'Hat, shirt and sock are clothing. A bus is a vehicle.',
    bands: {AgeBand.c, AgeBand.d},
  ),
  OddTemplate(
    id: 'animals-chair',
    itemIds: [PictureId.cat, PictureId.dog, PictureId.bird, PictureId.chair],
    oddIndex: 3,
    explanation: 'Cat, dog and bird are animals. A chair is a home object.',
    bands: {AgeBand.c, AgeBand.d},
  ),
  OddTemplate(
    id: 'fruit-car-four',
    itemIds: [
      PictureId.apple,
      PictureId.banana,
      PictureId.mango,
      PictureId.car,
    ],
    oddIndex: 3,
    explanation: 'Apple, banana and mango are fruit. A car is a vehicle.',
    bands: {AgeBand.c, AgeBand.d},
  ),
  OddTemplate(
    id: 'vehicles-spoon',
    itemIds: [PictureId.bus, PictureId.car, PictureId.train, PictureId.spoon],
    oddIndex: 3,
    explanation: 'Bus, car and train are vehicles. A spoon is a home object.',
    bands: {AgeBand.c, AgeBand.d},
  ),
  OddTemplate(
    id: 'sky-shoe-four',
    itemIds: [PictureId.sun, PictureId.moon, PictureId.skyStar, PictureId.shoe],
    oddIndex: 3,
    explanation: 'Sun, moon and star are in the sky. A shoe is clothing.',
    bands: {AgeBand.c, AgeBand.d},
  ),
];

class MatchingGenerator {
  const MatchingGenerator();

  static const generatorVersion = 'matching:v1';

  List<PlayQuestion> generate({
    required AgeBand band,
    required int variant,
    int count = 2,
  }) {
    if (band == AgeBand.toddler) {
      const familiar = [
        PictureId.apple,
        PictureId.banana,
        PictureId.cat,
        PictureId.dog,
        PictureId.car,
        PictureId.spoon,
      ];
      final target = familiar[variant % familiar.length];
      final other = familiar[(variant + 1) % familiar.length];
      return [
        PlayQuestion(
          prompt: 'With a grown-up, find the same picture.',
          promptVisuals: [PictureVisual(target)],
          choices: [
            for (final id in [target, other])
              PlayChoice(
                id: id.name,
                label: pictureById(id).label,
                visual: PictureVisual(id),
              ),
          ],
          correctId: target.name,
          firstHint: 'Look at the picture together.',
          strongerHint: 'Find the picture that looks the same.',
          explanation: 'You found the same picture.',
        ),
      ];
    }
    final templates = [
      for (final template in oddTemplates)
        if (template.bands.contains(band)) template,
    ];
    return List.generate(count, (index) {
      final template = templates[(variant + index) % templates.length];
      final question = _fromTemplate(template);
      if (question.isValid && template.isUnambiguous) {
        return question;
      }
      return _fromTemplate(templates.first);
    });
  }

  PlayQuestion _fromTemplate(OddTemplate template) {
    final items = template.itemIds.map(pictureById).toList();
    final odd = items[template.oddIndex];
    return PlayQuestion(
      prompt: 'Which one does not belong?',
      choices: [
        for (final item in items)
          PlayChoice(
            id: item.id.name,
            label: item.label,
            visual: PictureVisual(item.id),
          ),
      ],
      correctId: odd.id.name,
      firstHint: 'Find the one that is a different kind of thing.',
      strongerHint: 'The highlighted picture does not belong.',
      explanation: template.explanation,
    );
  }
}
