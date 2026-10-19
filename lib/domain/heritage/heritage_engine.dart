import '../models/age_band.dart';
import '../models/readiness.dart';
import 'heritage_models.dart';

class HeritageQuestionEngine {
  const HeritageQuestionEngine();

  int choiceCount({required AgeBand band, required Readiness readiness}) {
    if (band == AgeBand.a ||
        band == AgeBand.b ||
        readiness == Readiness.gentle ||
        band == AgeBand.c) {
      return 2;
    }
    return 3;
  }

  List<HeritageSite> reviewable(
    HeritagePack pack,
    Set<String> introducedSiteIds,
  ) {
    return [
      for (final site in pack.sites.values)
        if (introducedSiteIds.contains(site.id)) site,
    ];
  }

  HeritageQuestion identify({
    required HeritagePack pack,
    required HeritageSite site,
    required AgeBand band,
    required Readiness readiness,
    int seed = 1,
  }) {
    final choices = _sites(pack, site, band, readiness, seed);
    return HeritageQuestion(
      prompt: 'Which picture is ${site.name}?',
      correctId: site.id,
      siteId: site.id,
      choices: [
        for (final item in choices)
          HeritageChoice(
            id: item.id,
            label: item.name,
            pictureId: item.pictureId,
          ),
      ],
    );
  }

  HeritageQuestion match({
    required HeritagePack pack,
    required HeritageSite site,
    required AgeBand band,
    required Readiness readiness,
    int seed = 2,
  }) {
    final choices = _sites(pack, site, band, readiness, seed);
    return HeritageQuestion(
      prompt: 'Which picture shows the same place?',
      correctId: site.id,
      siteId: site.id,
      choices: [
        for (final item in choices)
          HeritageChoice(
            id: item.id,
            label: item.name,
            pictureId: item.pictureId,
          ),
      ],
    );
  }

  HeritageQuestion locate({
    required HeritagePack pack,
    required HeritageSite site,
    required Set<String> introducedSiteIds,
    required AgeBand band,
    required Readiness readiness,
    int seed = 3,
  }) {
    final pool = [
      for (final item in pack.sites.values)
        if (item.id == site.id || introducedSiteIds.contains(item.id)) item,
    ];
    final choices = pool.length < 2
        ? _sites(pack, site, band, readiness, seed)
        : _pick(
            pool,
            site,
            choiceCount(band: band, readiness: readiness),
            seed,
          );
    return HeritageQuestion(
      prompt: 'Which building is in ${site.locationLabel}?',
      correctId: site.id,
      siteId: site.id,
      choices: [
        for (final item in choices)
          HeritageChoice(
            id: item.id,
            label: item.name,
            pictureId: item.pictureId,
          ),
      ],
    );
  }

  HeritageQuestion? recall({
    required HeritagePack pack,
    required Set<String> introducedSiteIds,
    required AgeBand band,
    required Readiness readiness,
    int seed = 4,
  }) {
    final known = reviewable(pack, introducedSiteIds);
    if (known.isEmpty) {
      return null;
    }
    final site = known[seed.abs() % known.length];
    if (band.index >= AgeBand.c.index) {
      return locate(
        pack: pack,
        site: site,
        introducedSiteIds: introducedSiteIds,
        band: band,
        readiness: readiness,
        seed: seed,
      );
    }
    return identify(
      pack: pack,
      site: site,
      band: band,
      readiness: readiness,
      seed: seed,
    );
  }

  bool accepts(HeritageQuestion question, String answerId) {
    return answerId == question.correctId;
  }

  List<HeritageSite> _sites(
    HeritagePack pack,
    HeritageSite correct,
    AgeBand band,
    Readiness readiness,
    int seed,
  ) {
    return _pick(
      pack.sites.values.toList(),
      correct,
      choiceCount(band: band, readiness: readiness),
      seed,
    );
  }

  List<HeritageSite> _pick(
    List<HeritageSite> pool,
    HeritageSite correct,
    int count,
    int seed,
  ) {
    final unique = <String, HeritageSite>{correct.id: correct};
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

class IntroducedHeritage {
  const IntroducedHeritage();

  static Set<String> identifiedFrom(Iterable<String> completedIds) {
    return {
      for (final id in completedIds)
        if (id.startsWith('heritage:india:identify:') ||
            id.startsWith('heritage:india:story:'))
          'site-${id.split(':').last}',
    };
  }

  static Set<String> storiesFrom(Iterable<String> completedIds) {
    return {
      for (final id in completedIds)
        if (id.startsWith('heritage:india:story:'))
          'site-${id.split(':').last}',
    };
  }
}
