import '../models/age_band.dart';
import '../models/readiness.dart';
import 'geography_models.dart';

class GeographyChoice {
  const GeographyChoice({required this.id, required this.label});

  final String id;
  final String label;
}

enum GeographyPromptKind { name, type, capital, location }

class GeographyQuestion {
  const GeographyQuestion({
    required this.kind,
    required this.prompt,
    required this.correctId,
    required this.choices,
    this.placeId,
  });

  final GeographyPromptKind kind;
  final String prompt;
  final String correctId;
  final List<GeographyChoice> choices;
  final String? placeId;
}

class GeographyQuestionEngine {
  const GeographyQuestionEngine();

  int choiceCount({required AgeBand band, required Readiness readiness}) {
    if (band == AgeBand.a || band == AgeBand.b) {
      return 2;
    }
    if (readiness == Readiness.gentle || band == AgeBand.c) {
      return 2;
    }
    return 3;
  }

  List<PlaceRecord> reviewable(
    GeographyPack pack,
    Set<String> introducedPlaceIds,
  ) {
    return [
      for (final place in pack.places.values)
        if (introducedPlaceIds.contains(place.id)) place,
    ];
  }

  GeographyQuestion? reviewQuestion({
    required GeographyPack pack,
    required Set<String> introducedPlaceIds,
    required AgeBand band,
    required Readiness readiness,
    int seed = 1,
  }) {
    final known = reviewable(pack, introducedPlaceIds);
    if (known.isEmpty) {
      return null;
    }
    final target = known[seed.abs() % known.length];
    if (band.index >= AgeBand.d.index &&
        readiness != Readiness.gentle &&
        target.allowsSingleAnswerCapital) {
      return capitalQuestion(
        pack: pack,
        place: target,
        introducedPlaceIds: introducedPlaceIds,
        band: band,
        readiness: readiness,
        seed: seed,
      );
    }
    if (band.index >= AgeBand.c.index) {
      return nameQuestion(
        pack: pack,
        place: target,
        introducedPlaceIds: introducedPlaceIds,
        band: band,
        readiness: readiness,
        seed: seed,
      );
    }
    return typeQuestion(place: target);
  }

  GeographyQuestion nameQuestion({
    required GeographyPack pack,
    required PlaceRecord place,
    required Set<String> introducedPlaceIds,
    required AgeBand band,
    required Readiness readiness,
    int seed = 1,
  }) {
    final pool = [
      for (final item in pack.places.values)
        if (item.id == place.id || introducedPlaceIds.contains(item.id)) item,
    ];
    if (pool.length < 2) {
      return typeQuestion(place: place);
    }
    final choices = _pick(
      pool,
      place,
      choiceCount(band: band, readiness: readiness),
      seed,
    );
    return GeographyQuestion(
      kind: GeographyPromptKind.name,
      prompt: 'Which place is this?',
      correctId: place.id,
      placeId: place.id,
      choices: [
        for (final item in choices)
          GeographyChoice(id: item.id, label: item.name),
      ],
    );
  }

  GeographyQuestion typeQuestion({required PlaceRecord place}) {
    return GeographyQuestion(
      kind: GeographyPromptKind.type,
      prompt: 'Is ${place.name} a state or a union territory?',
      correctId: place.adminType.name,
      placeId: place.id,
      choices: const [
        GeographyChoice(id: 'state', label: 'State'),
        GeographyChoice(id: 'unionTerritory', label: 'Union territory'),
      ],
    );
  }

  GeographyQuestion? capitalQuestion({
    required GeographyPack pack,
    required PlaceRecord place,
    required Set<String> introducedPlaceIds,
    required AgeBand band,
    required Readiness readiness,
    int seed = 1,
  }) {
    if (!place.allowsSingleAnswerCapital) {
      return null;
    }
    final correct = place.soleCapitalName!;
    final names = <String>{correct};
    for (final item in pack.places.values) {
      if (item.id == place.id ||
          !item.allowsSingleAnswerCapital ||
          !introducedPlaceIds.contains(item.id)) {
        continue;
      }
      names.add(item.soleCapitalName!);
    }
    if (names.length < 2) {
      return typeQuestion(place: place);
    }
    final ordered = names.toList()
      ..sort((a, b) => (a.hashCode ^ seed).compareTo(b.hashCode ^ seed));
    final take = choiceCount(band: band, readiness: readiness);
    final picked = [
      correct,
      for (final name in ordered)
        if (name != correct) name,
    ].take(take).toList();
    return GeographyQuestion(
      kind: GeographyPromptKind.capital,
      prompt: 'What is the capital of ${place.name}?',
      correctId: correct,
      placeId: place.id,
      choices: [
        for (final name in picked) GeographyChoice(id: name, label: name),
      ],
    );
  }

  bool accepts(GeographyQuestion question, String answerId) {
    return answerId == question.correctId;
  }

  List<PlaceRecord> _pick(
    List<PlaceRecord> pool,
    PlaceRecord correct,
    int count,
    int seed,
  ) {
    final unique = <String, PlaceRecord>{correct.id: correct};
    final others = [
      for (final item in pool)
        if (item.id != correct.id) item,
    ]..sort((a, b) => (a.id.hashCode ^ seed).compareTo(b.id.hashCode ^ seed));
    for (final item in others) {
      unique[item.id] = item;
      if (unique.length >= count) {
        break;
      }
    }
    return unique.values.toList();
  }
}

class IntroducedPlaces {
  const IntroducedPlaces();

  static Set<String> fromActivityIds(Iterable<String> completedIds) {
    return {
      for (final id in completedIds)
        if (id.startsWith('geo:india:learn:')) 'in-${id.split(':').last}',
    };
  }
}
