import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/geography/map_geometry.dart';
import 'package:sproutlab/domain/heritage/heritage_catalog.dart';
import 'package:sproutlab/domain/heritage/heritage_engine.dart';
import 'package:sproutlab/domain/heritage/heritage_pack.dart';
import 'package:sproutlab/domain/heritage/heritage_validator.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/readiness.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';

void main() {
  final pack = developmentHeritagePack();
  const engine = HeritageQuestionEngine();
  const settings = LocalSettings(
    soundEffectsEnabled: true,
    musicEnabled: false,
    narrationEnabled: true,
    onboardingComplete: true,
    onboardingStep: 6,
    draftAgeBand: null,
    draftAvatarId: null,
    draftNickname: null,
    learningRegion: LearningRegion.india,
  );

  test('heritage places sit on bundled map regions', () {
    final atlas = atlasFromJson(
      jsonDecode(
        File('assets/content/geography/slice_geometry.json').readAsStringSync(),
      ) as Map<String, dynamic>,
    );
    for (final site in pack.sites.values) {
      expect(atlas.byId(site.mapRegionId), isNotNull, reason: site.id);
    }
  });

  test('slice sites are sourced, dated and keep history apart from legends', () {
    expect(pack.sites.length, 4);
    expect(pack.sites['site-sanchi']!.fact.sourceUrl, unescoSanchi);
    expect(pack.sites['site-konark']!.fact.verifiedAt, verifiedOn);
    expect(pack.sites['site-mahabalipuram']!.story.any((line) => line.kind.name == 'legend'), isTrue);
    expect(pack.sites['site-konark']!.story.any((line) => line.kind.name == 'legend'), isTrue);
    expect(pack.sites['site-taj']!.story.every((line) => line.kind.name == 'history'), isTrue);
    final allText = [
      for (final site in pack.sites.values) ...[
        site.fact.text,
        for (final line in site.story) line.text,
      ],
    ].join(' ').toLowerCase();
    expect(RegExp(r'\d+\s+horses?').hasMatch(allText), isFalse);
    expect(allText.contains('greatest'), isFalse);
    expect(allText.contains('finest'), isFalse);
  });

  test('age bands keep two choices until the older more-ready band', () {
    expect(
      engine.choiceCount(band: AgeBand.a, readiness: Readiness.steady),
      2,
    );
    expect(
      engine.choiceCount(band: AgeBand.c, readiness: Readiness.more),
      2,
    );
    expect(
      engine.choiceCount(band: AgeBand.d, readiness: Readiness.more),
      3,
    );
  });

  test('identify and match accept only the taught picture', () {
    final identify = engine.identify(
      pack: pack,
      site: pack.sites['site-sanchi']!,
      band: AgeBand.b,
      readiness: Readiness.steady,
    );
    expect(identify.choices.length, 2);
    expect(engine.accepts(identify, 'site-sanchi'), isTrue);
    expect(engine.accepts(identify, 'site-konark'), isFalse);
    final match = engine.match(
      pack: pack,
      site: pack.sites['site-taj']!,
      band: AgeBand.a,
      readiness: Readiness.gentle,
    );
    expect(match.correctId, 'site-taj');
    expect(match.choices.every((choice) => choice.pictureId != null), isTrue);
  });

  test('recall stays empty until a story has been introduced', () {
    expect(
      engine.recall(
        pack: pack,
        introducedSiteIds: const {},
        band: AgeBand.d,
        readiness: Readiness.steady,
      ),
      isNull,
    );
    expect(
      IntroducedHeritage.storiesFrom(const [
        'heritage:india:identify:sanchi',
      ]),
      isEmpty,
    );
    expect(
      IntroducedHeritage.identifiedFrom(const [
        'heritage:india:identify:sanchi',
      ]),
      contains('site-sanchi'),
    );
    final recall = engine.recall(
      pack: pack,
      introducedSiteIds: const {'site-sanchi'},
      band: AgeBand.d,
      readiness: Readiness.more,
    );
    expect(recall, isNotNull);
    expect(recall!.siteId, 'site-sanchi');
  });

  test('locate and recall stay closed until the matching introduction', () {
    final catalog = HeritageCatalog(pack: pack);
    final before = catalog.visible(
      settings: settings,
      band: AgeBand.d,
      includeDrafts: true,
    );
    expect(before.any((item) => item.mode.name == 'locate'), isFalse);
    expect(before.any((item) => item.mode.name == 'recall'), isFalse);
    final afterIdentify = catalog.visible(
      settings: settings,
      band: AgeBand.d,
      includeDrafts: true,
      introducedSiteIds: const {'site-sanchi'},
    );
    expect(
      afterIdentify.any((item) => item.id == 'heritage:india:locate:sanchi'),
      isTrue,
    );
    expect(afterIdentify.any((item) => item.mode.name == 'recall'), isFalse);
    final afterStory = catalog.visible(
      settings: settings,
      band: AgeBand.d,
      includeDrafts: true,
      introducedSiteIds: const {'site-sanchi'},
      introducedStoryIds: const {'site-sanchi'},
    );
    expect(afterStory.any((item) => item.id == 'heritage:india:recall'), isTrue);
  });

  test('release validation keeps the unreviewed pack out', () {
    const validator = HeritagePackValidator();
    expect(validator.validate(pack, release: false), isEmpty);
    expect(validator.validate(pack, release: true), isNotEmpty);
    expect(validator.playable(pack, release: true), isEmpty);
    expect(validator.playable(emptyHeritagePack(), release: false), isEmpty);
    expect(
      HeritageCatalog().visible(
        settings: settings,
        band: AgeBand.d,
        includeDrafts: false,
      ),
      isEmpty,
    );
  });
}
