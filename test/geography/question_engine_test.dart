import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sproutlab/domain/geography/geography_catalog.dart';
import 'package:sproutlab/domain/geography/geography_pack.dart';
import 'package:sproutlab/domain/geography/geography_validator.dart';
import 'package:sproutlab/domain/geography/map_geometry.dart';
import 'package:sproutlab/domain/geography/question_engine.dart';
import 'package:sproutlab/domain/models/age_band.dart';
import 'package:sproutlab/domain/models/readiness.dart';
import 'package:sproutlab/domain/regional/learning_preferences.dart';
import 'package:sproutlab/domain/settings/local_settings.dart';

void main() {
  final pack = developmentGeographyPack();
  final atlas = atlasFromJson(
    jsonDecode(
      File('assets/content/geography/slice_geometry.json').readAsStringSync(),
    ) as Map<String, dynamic>,
  );
  const engine = GeographyQuestionEngine();

  test('states and union territories stay distinct and sourced', () {
    expect(pack.places['in-rajasthan']!.adminType.name, 'state');
    expect(pack.places['in-delhi']!.adminType.name, 'unionTerritory');
    expect(pack.places['in-rajasthan']!.fact.sourceUrl, contains('knowindia'));
    expect(pack.places['in-rajasthan']!.fact.verifiedAt, '2026-10-03');
    expect(
      pack.places['in-maharashtra']!.hasSeasonalOrMultipleCapitals,
      isTrue,
    );
    expect(pack.places['in-maharashtra']!.allowsSingleAnswerCapital, isFalse);
    expect(pack.places['in-delhi']!.allowsSingleAnswerCapital, isFalse);
    expect(pack.places['in-kerala']!.soleCapitalName, 'Thiruvananthapuram');
  });

  test('review and capitals only use already introduced places', () {
    expect(
      engine.reviewQuestion(
        pack: pack,
        introducedPlaceIds: const {},
        band: AgeBand.d,
        readiness: Readiness.steady,
      ),
      isNull,
    );
    final review = engine.reviewQuestion(
      pack: pack,
      introducedPlaceIds: const {'in-rajasthan'},
      band: AgeBand.c,
      readiness: Readiness.steady,
    );
    expect(review, isNotNull);
    expect(review!.placeId, 'in-rajasthan');
    expect(
      review.choices.every(
        (choice) =>
            choice.id == 'in-rajasthan' ||
            pack.places.containsKey(choice.id) ||
            choice.label == 'Rajasthan' ||
            choice.id == 'state' ||
            choice.id == 'unionTerritory',
      ),
      isTrue,
    );
    final capital = engine.capitalQuestion(
      pack: pack,
      place: pack.places['in-rajasthan']!,
      introducedPlaceIds: const {'in-rajasthan', 'in-kerala'},
      band: AgeBand.d,
      readiness: Readiness.steady,
    );
    expect(capital, isNotNull);
    expect(capital!.kind.name, 'capital');
    expect(engine.accepts(capital, 'Jaipur'), isTrue);
    expect(engine.accepts(capital, 'Panaji'), isFalse);
    final early = engine.capitalQuestion(
      pack: pack,
      place: pack.places['in-rajasthan']!,
      introducedPlaceIds: const {'in-rajasthan'},
      band: AgeBand.d,
      readiness: Readiness.steady,
    );
    expect(early!.kind.name, 'type');
    expect(
      engine.capitalQuestion(
        pack: pack,
        place: pack.places['in-maharashtra']!,
        introducedPlaceIds: const {'in-maharashtra'},
        band: AgeBand.d,
        readiness: Readiness.steady,
      ),
      isNull,
    );
  });

  test('younger learners get two choices and no gentle capital on band C', () {
    expect(engine.choiceCount(band: AgeBand.c, readiness: Readiness.gentle), 2);
    expect(engine.choiceCount(band: AgeBand.d, readiness: Readiness.more), 3);
    final catalog = GeographyCatalog();
    final hidden = catalog.visible(
      settings: const LocalSettings(
        soundEffectsEnabled: true,
        musicEnabled: false,
        narrationEnabled: true,
        onboardingComplete: true,
        onboardingStep: 6,
        draftAgeBand: null,
        draftAvatarId: null,
        draftNickname: null,
        learningRegion: LearningRegion.india,
      ),
      band: AgeBand.a,
      includeDrafts: true,
    );
    expect(hidden.any((item) => item.mode.name == 'capital'), isFalse);
    expect(
      hidden.any((item) => item.id == 'geo:india:learn:rajasthan'),
      isTrue,
    );
    expect(hidden.any((item) => item.id == 'geo:india:review'), isFalse);
  });

  test('release loader drops the unreviewed slice and ambiguous capitals', () {
    final validator = const GeographyPackValidator();
    expect(validator.validate(pack, atlas, release: false), isEmpty);
    final release = validator.validate(pack, atlas, release: true);
    expect(release.join(' '), contains('not approved'));
    expect(validator.playable(pack, release: true), isEmpty);
    expect(
      pack.activities.any(
        (activity) =>
            activity.mode.name == 'capital' &&
            activity.placeId == 'in-maharashtra',
      ),
      isFalse,
    );
    expect(
      pack.activities.any(
        (activity) =>
            activity.mode.name == 'capital' && activity.placeId == 'in-delhi',
      ),
      isFalse,
    );
  });

  test('introduced places come from completed learn ids only', () {
    expect(
      introducedPlacesFrom(const [
        'geo:india:learn:rajasthan',
        'geo:india:capital:rajasthan',
        'lesson:hindi:build:anar',
      ]),
      {'in-rajasthan'},
    );
  });
}
