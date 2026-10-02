enum CountGlyph { leaf, star, pebble }

enum PatternSymbol { circle, square, triangle, star }

enum PatternScale { small, large }

enum PatternHeading { up, right, down, left }

enum PictureId {
  apple,
  banana,
  mango,
  car,
  cat,
  dog,
  bird,
  spoon,
  sun,
  moon,
  skyStar,
  shoe,
  bus,
  train,
  rose,
  tulip,
  sunflower,
  bicycle,
  hat,
  shirt,
  sock,
  chair,
}

enum PictureKind { fruit, animal, vehicle, sky, clothing, home, flower }

class PictureItem {
  const PictureItem({
    required this.id,
    required this.label,
    required this.kind,
  });

  final PictureId id;
  final String label;
  final PictureKind kind;
}

const pictureCatalog = <PictureItem>[
  PictureItem(id: PictureId.apple, label: 'Apple', kind: PictureKind.fruit),
  PictureItem(id: PictureId.banana, label: 'Banana', kind: PictureKind.fruit),
  PictureItem(id: PictureId.mango, label: 'Mango', kind: PictureKind.fruit),
  PictureItem(id: PictureId.car, label: 'Car', kind: PictureKind.vehicle),
  PictureItem(id: PictureId.cat, label: 'Cat', kind: PictureKind.animal),
  PictureItem(id: PictureId.dog, label: 'Dog', kind: PictureKind.animal),
  PictureItem(id: PictureId.bird, label: 'Bird', kind: PictureKind.animal),
  PictureItem(id: PictureId.spoon, label: 'Spoon', kind: PictureKind.home),
  PictureItem(id: PictureId.sun, label: 'Sun', kind: PictureKind.sky),
  PictureItem(id: PictureId.moon, label: 'Moon', kind: PictureKind.sky),
  PictureItem(id: PictureId.skyStar, label: 'Star', kind: PictureKind.sky),
  PictureItem(id: PictureId.shoe, label: 'Shoe', kind: PictureKind.clothing),
  PictureItem(id: PictureId.bus, label: 'Bus', kind: PictureKind.vehicle),
  PictureItem(id: PictureId.train, label: 'Train', kind: PictureKind.vehicle),
  PictureItem(id: PictureId.rose, label: 'Rose', kind: PictureKind.flower),
  PictureItem(id: PictureId.tulip, label: 'Tulip', kind: PictureKind.flower),
  PictureItem(
    id: PictureId.sunflower,
    label: 'Sunflower',
    kind: PictureKind.flower,
  ),
  PictureItem(
    id: PictureId.bicycle,
    label: 'Bicycle',
    kind: PictureKind.vehicle,
  ),
  PictureItem(id: PictureId.hat, label: 'Hat', kind: PictureKind.clothing),
  PictureItem(id: PictureId.shirt, label: 'Shirt', kind: PictureKind.clothing),
  PictureItem(id: PictureId.sock, label: 'Sock', kind: PictureKind.clothing),
  PictureItem(id: PictureId.chair, label: 'Chair', kind: PictureKind.home),
];

PictureItem pictureById(PictureId id) {
  return pictureCatalog.firstWhere((item) => item.id == id);
}

sealed class ChoiceVisual {
  const ChoiceVisual();
}

class NumeralVisual extends ChoiceVisual {
  const NumeralVisual(this.value);

  final int value;
}

class CountGroupVisual extends ChoiceVisual {
  const CountGroupVisual({required this.count, required this.glyph});

  final int count;
  final CountGlyph glyph;
}

class SymbolVisual extends ChoiceVisual {
  const SymbolVisual(
    this.symbol, {
    this.scale = PatternScale.large,
    this.heading = PatternHeading.up,
  });

  final PatternSymbol symbol;
  final PatternScale scale;
  final PatternHeading heading;

  String get instanceKey => '${symbol.name}_${scale.name}_${heading.name}';
}

class PictureVisual extends ChoiceVisual {
  const PictureVisual(this.id);

  final PictureId id;
}

class WordPictureVisual extends ChoiceVisual {
  const WordPictureVisual(this.wordId);

  final String wordId;
}

class LetterVisual extends ChoiceVisual {
  const LetterVisual(this.letter);

  final String letter;
}

class PlayChoice {
  const PlayChoice({
    required this.id,
    required this.label,
    required this.visual,
    this.showText = true,
  });

  final String id;
  final String label;
  final ChoiceVisual visual;
  final bool showText;
}

class PlayQuestion {
  const PlayQuestion({
    required this.prompt,
    required this.choices,
    required this.correctId,
    required this.firstHint,
    required this.strongerHint,
    required this.explanation,
    this.promptVisuals = const [],
  });

  final String prompt;
  final List<PlayChoice> choices;
  final String correctId;
  final String firstHint;
  final String strongerHint;
  final String explanation;
  final List<ChoiceVisual> promptVisuals;

  bool get isValid {
    if (choices.length < 2) {
      return false;
    }
    final ids = choices.map((choice) => choice.id).toSet();
    final labels = choices.map((choice) => choice.label).toSet();
    if (ids.length != choices.length || labels.length != choices.length) {
      return false;
    }
    final matches = choices.where((choice) => choice.id == correctId).length;
    return matches == 1;
  }
}
