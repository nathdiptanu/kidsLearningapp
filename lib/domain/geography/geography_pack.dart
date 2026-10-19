import '../lessons/lesson_models.dart';
import '../models/age_band.dart';
import '../models/content_pack.dart';
import 'geography_models.dart';
import 'geography_places.dart';

const geographyDevPackId = 'geography_dev_slice';
const knowIndiaDirectory = 'https://knowindia.india.gov.in/states-uts/';
const knowIndiaRajasthan =
    'https://knowindia.india.gov.in/states-uts/rajasthan.php';
const knowIndiaKerala = 'https://knowindia.india.gov.in/states-uts/kerala.php';
const knowIndiaGoa = 'https://knowindia.india.gov.in/states-uts/goa.php';
const knowIndiaDelhi =
    'https://knowindia.india.gov.in/states-uts/government-of-nct-of-delhi.php';
const nagpurDistrict = 'https://nagpur.gov.in/';
const verifiedOn = '2026-10-03';

const _knowIndia = 'Know India, National Portal of India';

const developmentPlaces = <String, PlaceRecord>{
  'in-rajasthan': PlaceRecord(
    id: 'in-rajasthan',
    name: 'Rajasthan',
    hindiName: 'राजस्थान',
    adminType: AdminType.state,
    geometryId: 'in-rajasthan',
    fact: SourcedFact(
      id: 'fact-rajasthan-west',
      text: 'Rajasthan is a state in western India.',
      sourceName: _knowIndia,
      sourceUrl: knowIndiaRajasthan,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    capitals: [
      CapitalSeat(
        name: 'Jaipur',
        hindiName: 'जयपुर',
        role: CapitalRole.sole,
        sourceName: _knowIndia,
        sourceUrl: knowIndiaRajasthan,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [knowIndiaRajasthan, knowIndiaDirectory],
    narrationId: 'clip_geo_rajasthan',
  ),
  'in-kerala': PlaceRecord(
    id: 'in-kerala',
    name: 'Kerala',
    hindiName: 'केरल',
    adminType: AdminType.state,
    geometryId: 'in-kerala',
    fact: SourcedFact(
      id: 'fact-kerala-coast',
      text: 'Kerala is a state on the southwest coast of India.',
      sourceName: _knowIndia,
      sourceUrl: knowIndiaKerala,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    capitals: [
      CapitalSeat(
        name: 'Thiruvananthapuram',
        hindiName: 'तिरुवनंतपुरम',
        role: CapitalRole.sole,
        sourceName: _knowIndia,
        sourceUrl: knowIndiaKerala,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [knowIndiaKerala, knowIndiaDirectory],
    narrationId: 'clip_geo_kerala',
  ),
  'in-goa': PlaceRecord(
    id: 'in-goa',
    name: 'Goa',
    hindiName: 'गोवा',
    adminType: AdminType.state,
    geometryId: 'in-goa',
    fact: SourcedFact(
      id: 'fact-goa-west',
      text: 'Goa is a state on the west coast of India.',
      sourceName: _knowIndia,
      sourceUrl: knowIndiaGoa,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    capitals: [
      CapitalSeat(
        name: 'Panaji',
        hindiName: 'पणजी',
        role: CapitalRole.sole,
        sourceName: _knowIndia,
        sourceUrl: knowIndiaDirectory,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [knowIndiaGoa, knowIndiaDirectory],
    narrationId: 'clip_geo_goa',
    smallTarget: true,
  ),
  'in-delhi': PlaceRecord(
    id: 'in-delhi',
    name: 'Delhi',
    hindiName: 'दिल्ली',
    adminType: AdminType.unionTerritory,
    geometryId: 'in-delhi',
    fact: SourcedFact(
      id: 'fact-delhi-ut',
      text: 'Delhi is a union territory. It is not a state.',
      sourceName: _knowIndia,
      sourceUrl: knowIndiaDelhi,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    capitals: [
      CapitalSeat(
        name: 'Delhi',
        hindiName: 'दिल्ली',
        role: CapitalRole.sole,
        sourceName: _knowIndia,
        sourceUrl: knowIndiaDelhi,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [knowIndiaDelhi, knowIndiaDirectory],
    narrationId: 'clip_geo_delhi',
    smallTarget: true,
  ),
  'in-maharashtra': PlaceRecord(
    id: 'in-maharashtra',
    name: 'Maharashtra',
    hindiName: 'महाराष्ट्र',
    adminType: AdminType.state,
    geometryId: 'in-maharashtra',
    fact: SourcedFact(
      id: 'fact-maharashtra-west',
      text: 'Maharashtra is a state in western India.',
      sourceName: _knowIndia,
      sourceUrl: knowIndiaDirectory,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    capitals: [
      CapitalSeat(
        name: 'Mumbai',
        hindiName: 'मुंबई',
        role: CapitalRole.summer,
        sourceName: _knowIndia,
        sourceUrl: knowIndiaDirectory,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
      CapitalSeat(
        name: 'Nagpur',
        hindiName: 'नागपुर',
        role: CapitalRole.winter,
        sourceName: 'District Nagpur, Government of Maharashtra',
        sourceUrl: nagpurDistrict,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [knowIndiaDirectory, nagpurDistrict],
    narrationId: 'clip_geo_maharashtra',
  ),
};

const developmentGeoClips = <String, NarrationClip>{
  'clip_geo_rajasthan': NarrationClip(
    id: 'clip_geo_rajasthan',
    kind: AudioKind.word,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed geography recording is bundled yet.',
  ),
  'clip_geo_kerala': NarrationClip(
    id: 'clip_geo_kerala',
    kind: AudioKind.word,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed geography recording is bundled yet.',
  ),
  'clip_geo_goa': NarrationClip(
    id: 'clip_geo_goa',
    kind: AudioKind.word,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed geography recording is bundled yet.',
  ),
  'clip_geo_delhi': NarrationClip(
    id: 'clip_geo_delhi',
    kind: AudioKind.word,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed geography recording is bundled yet.',
  ),
  'clip_geo_maharashtra': NarrationClip(
    id: 'clip_geo_maharashtra',
    kind: AudioKind.word,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed geography recording is bundled yet.',
  ),
};

const _bandsAll = [AgeBand.a, AgeBand.b, AgeBand.c, AgeBand.d];
const _bandsMatch = [AgeBand.c, AgeBand.d];
const _bandsCapital = [AgeBand.c, AgeBand.d];

const developmentGeoActivities = <GeographyActivity>[
  GeographyActivity(
    id: 'geo:india:explore',
    mode: GeographyMode.explore,
    title: 'My India',
    prompt: 'Look at the map. Tap a coloured place to hear its name.',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
  ),
  GeographyActivity(
    id: 'geo:india:learn:rajasthan',
    mode: GeographyMode.learn,
    title: 'Meet Rajasthan',
    prompt: 'This is Rajasthan',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-rajasthan',
    narrationId: 'clip_geo_rajasthan',
  ),
  GeographyActivity(
    id: 'geo:india:learn:kerala',
    mode: GeographyMode.learn,
    title: 'Meet Kerala',
    prompt: 'This is Kerala',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-kerala',
    narrationId: 'clip_geo_kerala',
  ),
  GeographyActivity(
    id: 'geo:india:learn:goa',
    mode: GeographyMode.learn,
    title: 'Meet Goa',
    prompt: 'This is Goa. It is small, so we also show a closer view.',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-goa',
    narrationId: 'clip_geo_goa',
  ),
  GeographyActivity(
    id: 'geo:india:learn:delhi',
    mode: GeographyMode.learn,
    title: 'Meet Delhi',
    prompt: 'Delhi is a union territory',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-delhi',
    narrationId: 'clip_geo_delhi',
  ),
  GeographyActivity(
    id: 'geo:india:match:rajasthan',
    mode: GeographyMode.matchName,
    title: 'Find Rajasthan',
    prompt: 'Which name matches this place?',
    ageBands: _bandsMatch,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-rajasthan',
  ),
  GeographyActivity(
    id: 'geo:india:locate:kerala',
    mode: GeographyMode.matchLocation,
    title: 'Where is Kerala?',
    prompt: 'Tap Kerala on the map, or pick it from the list.',
    ageBands: _bandsMatch,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-kerala',
  ),
  GeographyActivity(
    id: 'geo:india:locate:goa',
    mode: GeographyMode.matchLocation,
    title: 'Where is Goa?',
    prompt: 'Goa is small. Use the closer view or the list.',
    ageBands: _bandsMatch,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-goa',
  ),
  GeographyActivity(
    id: 'geo:india:capital:rajasthan',
    mode: GeographyMode.capital,
    title: 'Capital of Rajasthan',
    prompt: 'What is the capital of Rajasthan?',
    ageBands: _bandsCapital,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-rajasthan',
  ),
  GeographyActivity(
    id: 'geo:india:capital:kerala',
    mode: GeographyMode.capital,
    title: 'Capital of Kerala',
    prompt: 'What is the capital of Kerala?',
    ageBands: _bandsCapital,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-kerala',
  ),
  GeographyActivity(
    id: 'geo:india:capital:goa',
    mode: GeographyMode.capital,
    title: 'Capital of Goa',
    prompt: 'What is the capital of Goa?',
    ageBands: _bandsCapital,
    reviewStatus: ReviewStatus.placeholder,
    placeId: 'in-goa',
  ),
  GeographyActivity(
    id: 'geo:india:review',
    mode: GeographyMode.review,
    title: 'Remember a place',
    prompt: 'This is a place you already met.',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
  ),
];

GeographyPack developmentGeographyPack() {
  return GeographyPack(
    packId: geographyDevPackId,
    schemaVersion: 1,
    contentVersion: 2,
    reviewStatus: ReviewStatus.placeholder,
    places: {...developmentPlaces, ...extraPlaces},
    activities: [
      ...developmentGeoActivities,
      for (final place in extraPlaces.values)
        GeographyActivity(
          id: 'geo:india:learn:${place.id.substring(3)}',
          mode: GeographyMode.learn,
          title: 'Meet ${place.name}',
          prompt: 'Meet a place in India',
          placeId: place.id,
          narrationId: place.narrationId,
          ageBands: const [AgeBand.a, AgeBand.b, AgeBand.c, AgeBand.d],
          reviewStatus: ReviewStatus.placeholder,
        ),
    ],
    clips: {...developmentGeoClips, ...extraGeoClips},
  );
}

GeographyPack emptyGeographyPack() {
  return const GeographyPack(
    packId: 'geography_release_empty',
    schemaVersion: 1,
    contentVersion: 0,
    reviewStatus: ReviewStatus.placeholder,
    places: {},
    activities: [],
    clips: {},
  );
}
