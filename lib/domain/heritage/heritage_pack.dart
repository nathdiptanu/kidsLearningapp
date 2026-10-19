import '../lessons/lesson_models.dart';
import '../models/age_band.dart';
import '../models/content_pack.dart';
import 'heritage_models.dart';

const heritageDevPackId = 'heritage_dev_slice';
const unescoSanchi = 'https://whc.unesco.org/en/list/524/';
const unescoKonark = 'https://whc.unesco.org/en/list/246/';
const unescoMahabalipuram = 'https://whc.unesco.org/en/list/249/';
const unescoTaj = 'https://whc.unesco.org/en/list/252/';
const unescoHampi = 'https://whc.unesco.org/en/list/241/';
const unescoAjanta = 'https://whc.unesco.org/en/list/242/';
const unescoEllora = 'https://whc.unesco.org/en/list/243/';
const asiSanchi =
    'https://asi.nic.in/pages/WorldHeritageBuddhistMonumentsatSanchi';
const asiKonark = 'https://asi.nic.in/pages/WorldHeritageKonarak';
const verifiedOn = '2026-10-03';
const _unesco = 'UNESCO World Heritage Centre';
const _asi = 'Archaeological Survey of India';

const developmentHeritageSites = <String, HeritageSite>{
  'site-sanchi': HeritageSite(
    id: 'site-sanchi',
    name: 'Sanchi',
    hindiName: 'सांची',
    pictureId: 'heritage-sanchi',
    locationLabel: 'central India',
    regionHint: 'A hill in central India, near Bhopal',
    mapRegionId: 'in-madhya-pradesh',
    fact: HeritageStatement(
      kind: HeritageStatementKind.history,
      text: 'Sanchi is a hill of Buddhist buildings in central India. The round stone buildings are called stupas.',
      sourceName: _unesco,
      sourceUrl: unescoSanchi,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    story: [
      HeritageStatement(
        kind: HeritageStatementKind.history,
        text: 'People built stupas, temples and monasteries on this hill. UNESCO records that the place was an important Buddhist centre for many centuries.',
        sourceName: _unesco,
        sourceUrl: unescoSanchi,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
      HeritageStatement(
        kind: HeritageStatementKind.history,
        text: 'A stupa is a round mound of stone. Visitors walk around it quietly. Taking care of old buildings helps everyone enjoy them later.',
        sourceName: _asi,
        sourceUrl: asiSanchi,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [unescoSanchi, asiSanchi],
    narrationId: 'clip_heritage_sanchi',
  ),
  'site-konark': HeritageSite(
    id: 'site-konark',
    name: 'Konark Sun Temple',
    hindiName: 'कोणार्क सूर्य मंदिर',
    pictureId: 'heritage-konark',
    locationLabel: 'the east coast',
    regionHint: 'Beside the sea in Odisha',
    mapRegionId: 'in-odisha',
    fact: HeritageStatement(
      kind: HeritageStatementKind.history,
      text: 'The Konark Sun Temple stands on the east coast. Builders shaped it as a stone chariot for the sun.',
      sourceName: _unesco,
      sourceUrl: unescoKonark,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    story: [
      HeritageStatement(
        kind: HeritageStatementKind.history,
        text: 'The temple was built in the 1200s. Its stone wheels and horses are part of the building. People still visit and look after the site.',
        sourceName: _unesco,
        sourceUrl: unescoKonark,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
      HeritageStatement(
        kind: HeritageStatementKind.legend,
        text: 'A traditional story says a large group of stone workers spent many years on the temple. That story is a legend. This app does not treat it as a proven fact.',
        sourceName: _unesco,
        sourceUrl: unescoKonark,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [unescoKonark, asiKonark],
    narrationId: 'clip_heritage_konark',
  ),
  'site-mahabalipuram': HeritageSite(
    id: 'site-mahabalipuram',
    name: 'Mahabalipuram',
    hindiName: 'महाबलीपुरम',
    pictureId: 'heritage-mahabalipuram',
    locationLabel: 'the southeast coast',
    regionHint: 'Rock temples beside the sea in Tamil Nadu',
    mapRegionId: 'in-tamil-nadu',
    fact: HeritageStatement(
      kind: HeritageStatementKind.history,
      text: 'At Mahabalipuram, people carved temples and pictures from rock beside the sea.',
      sourceName: _unesco,
      sourceUrl: unescoMahabalipuram,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    story: [
      HeritageStatement(
        kind: HeritageStatementKind.history,
        text: 'Pallava craftspeople cut temples from stone along the southeast coast. Some look like temple carts, called rathas. Some stand by the water.',
        sourceName: _unesco,
        sourceUrl: unescoMahabalipuram,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
      HeritageStatement(
        kind: HeritageStatementKind.legend,
        text: 'A huge rock picture is often linked with a traditional story about a river coming to earth. The carving is real. The story is a legend told beside it.',
        sourceName: _unesco,
        sourceUrl: unescoMahabalipuram,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [unescoMahabalipuram],
    narrationId: 'clip_heritage_mahabalipuram',
  ),
  'site-taj': HeritageSite(
    id: 'site-taj',
    name: 'Taj Mahal',
    hindiName: 'ताज महल',
    pictureId: 'heritage-taj',
    locationLabel: 'northern India',
    regionHint: 'Beside a river in Agra, in northern India',
    mapRegionId: 'in-uttar-pradesh',
    fact: HeritageStatement(
      kind: HeritageStatementKind.history,
      text: 'The Taj Mahal is a white marble building in Agra. It was built in the 1600s as a tomb.',
      sourceName: _unesco,
      sourceUrl: unescoTaj,
      verifiedAt: verifiedOn,
      reviewStatus: ReviewStatus.placeholder,
    ),
    story: [
      HeritageStatement(
        kind: HeritageStatementKind.history,
        text: 'A Mughal emperor asked builders to make this marble tomb for his wife. Gardens and water sit in front of it. People still visit and look after the place.',
        sourceName: _unesco,
        sourceUrl: unescoTaj,
        verifiedAt: verifiedOn,
        reviewStatus: ReviewStatus.placeholder,
      ),
    ],
    reviewStatus: ReviewStatus.placeholder,
    rightsStatus: 'development_only',
    sources: [unescoTaj],
    narrationId: 'clip_heritage_taj',
  ),
};

const developmentHeritageClips = <String, NarrationClip>{
  'clip_heritage_sanchi': NarrationClip(
    id: 'clip_heritage_sanchi',
    kind: AudioKind.explanation,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed heritage recording is bundled yet.',
  ),
  'clip_heritage_konark': NarrationClip(
    id: 'clip_heritage_konark',
    kind: AudioKind.explanation,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed heritage recording is bundled yet.',
  ),
  'clip_heritage_mahabalipuram': NarrationClip(
    id: 'clip_heritage_mahabalipuram',
    kind: AudioKind.explanation,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed heritage recording is bundled yet.',
  ),
  'clip_heritage_taj': NarrationClip(
    id: 'clip_heritage_taj',
    kind: AudioKind.explanation,
    reviewStatus: ReviewStatus.placeholder,
    note: 'No reviewed heritage recording is bundled yet.',
  ),
};

const _bandsYoung = [AgeBand.a, AgeBand.b, AgeBand.c];
const _bandsAll = [AgeBand.a, AgeBand.b, AgeBand.c, AgeBand.d];
const _bandsLocate = [AgeBand.c, AgeBand.d];
const _bandsStory = [AgeBand.c, AgeBand.d];

const developmentHeritageActivities = <HeritageActivity>[
  HeritageActivity(
    id: 'heritage:india:identify:sanchi',
    mode: HeritageMode.identify,
    title: 'Find Sanchi',
    prompt: 'Find this building',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-sanchi',
    narrationId: 'clip_heritage_sanchi',
  ),
  HeritageActivity(
    id: 'heritage:india:identify:konark',
    mode: HeritageMode.identify,
    title: 'Find the sun temple',
    prompt: 'Find this building',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-konark',
    narrationId: 'clip_heritage_konark',
  ),
  HeritageActivity(
    id: 'heritage:india:identify:mahabalipuram',
    mode: HeritageMode.identify,
    title: 'Find the sea temples',
    prompt: 'Find this building',
    ageBands: _bandsYoung,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-mahabalipuram',
    narrationId: 'clip_heritage_mahabalipuram',
  ),
  HeritageActivity(
    id: 'heritage:india:identify:taj',
    mode: HeritageMode.identify,
    title: 'Find the white tomb',
    prompt: 'Find this building',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-taj',
    narrationId: 'clip_heritage_taj',
  ),
  HeritageActivity(
    id: 'heritage:india:match:sanchi',
    mode: HeritageMode.match,
    title: 'Match the stupa',
    prompt: 'Which picture is the same place?',
    ageBands: _bandsYoung,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-sanchi',
  ),
  HeritageActivity(
    id: 'heritage:india:match:konark',
    mode: HeritageMode.match,
    title: 'Match the sun temple',
    prompt: 'Which picture is the same place?',
    ageBands: _bandsYoung,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-konark',
  ),
  HeritageActivity(
    id: 'heritage:india:match:taj',
    mode: HeritageMode.match,
    title: 'Match the white tomb',
    prompt: 'Which picture is the same place?',
    ageBands: _bandsYoung,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-taj',
  ),
  HeritageActivity(
    id: 'heritage:india:locate:sanchi',
    mode: HeritageMode.locate,
    title: 'Where is Sanchi?',
    prompt: 'This building is in central India. Which one is it?',
    ageBands: _bandsLocate,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-sanchi',
  ),
  HeritageActivity(
    id: 'heritage:india:locate:konark',
    mode: HeritageMode.locate,
    title: 'Where is the sun temple?',
    prompt: 'This building stands by the east sea. Which one is it?',
    ageBands: _bandsLocate,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-konark',
  ),
  HeritageActivity(
    id: 'heritage:india:locate:taj',
    mode: HeritageMode.locate,
    title: 'Where is the white tomb?',
    prompt: 'This building is in northern India. Which one is it?',
    ageBands: _bandsLocate,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-taj',
  ),
  HeritageActivity(
    id: 'heritage:india:story:sanchi',
    mode: HeritageMode.story,
    title: 'A hill of stupas',
    prompt: 'Listen, then look at the pictures',
    ageBands: _bandsStory,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-sanchi',
    narrationId: 'clip_heritage_sanchi',
  ),
  HeritageActivity(
    id: 'heritage:india:story:konark',
    mode: HeritageMode.story,
    title: 'A stone chariot',
    prompt: 'Listen, then look at the pictures',
    ageBands: _bandsStory,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-konark',
    narrationId: 'clip_heritage_konark',
  ),
  HeritageActivity(
    id: 'heritage:india:story:mahabalipuram',
    mode: HeritageMode.story,
    title: 'Temples from rock',
    prompt: 'Listen, then look at the pictures',
    ageBands: [AgeBand.d],
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-mahabalipuram',
    narrationId: 'clip_heritage_mahabalipuram',
  ),
  HeritageActivity(
    id: 'heritage:india:story:taj',
    mode: HeritageMode.story,
    title: 'A marble tomb',
    prompt: 'Listen, then look at the pictures',
    ageBands: _bandsStory,
    reviewStatus: ReviewStatus.placeholder,
    siteId: 'site-taj',
    narrationId: 'clip_heritage_taj',
  ),
  HeritageActivity(
    id: 'heritage:india:recall',
    mode: HeritageMode.recall,
    title: 'Remember a place',
    prompt: 'This is a place you already met.',
    ageBands: _bandsAll,
    reviewStatus: ReviewStatus.placeholder,
  ),
];

HeritagePack developmentHeritagePack() {
  return const HeritagePack(
    packId: heritageDevPackId,
    schemaVersion: 1,
    contentVersion: 1,
    reviewStatus: ReviewStatus.placeholder,
    sites: developmentHeritageSites,
    activities: developmentHeritageActivities,
    clips: developmentHeritageClips,
  );
}

const heritageIllustrationCredits = <CreditRecord>[
  CreditRecord(
    id: 'heritage-sanchi',
    title: 'Sanchi drawing',
    detail: 'Original in-app drawing of a stupa shape. It is not a photograph.',
    creator: 'SproutLab engineering',
    license: 'Original work for this project',
    attribution: 'Drawn in the app. Not copied from a photo.',
    modifications:
        'Geometric stupa, railing and harmika for child recognition.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'heritage-konark',
    title: 'Konark drawing',
    detail: 'Original in-app drawing of a chariot-temple shape. It is not a photograph.',
    creator: 'SproutLab engineering',
    license: 'Original work for this project',
    attribution: 'Drawn in the app. Not copied from a photo.',
    modifications: 'Stepped roof and one wheel for child recognition.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'heritage-mahabalipuram',
    title: 'Mahabalipuram drawing',
    detail: 'Original in-app drawing of shore temples. It is not a photograph.',
    creator: 'SproutLab engineering',
    license: 'Original work for this project',
    attribution: 'Drawn in the app. Not copied from a photo.',
    modifications: 'Two stone towers beside water.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'heritage-taj',
    title: 'Taj Mahal drawing',
    detail: 'Original in-app drawing of a dome and four towers. It is not a photograph.',
    creator: 'SproutLab engineering',
    license: 'Original work for this project',
    attribution: 'Drawn in the app. Not copied from a photo.',
    modifications: 'White dome and four thin towers for child recognition.',
    reviewStatus: ReviewStatus.placeholder,
  ),
];

const heritageResearchCredits = <CreditRecord>[
  CreditRecord(
    id: 'source-unesco-sanchi',
    title: 'UNESCO: Buddhist Monuments at Sanchi',
    detail: 'Research source for the Sanchi summaries. Text in the app is an original short paraphrase, not a copy of the UNESCO page.',
    creator: _unesco,
    license: 'UNESCO page used for facts only. Description text is CC-BY-SA IGO 3.0; it was not copied into child screens.',
    sourceUrl: unescoSanchi,
    attribution: 'Checked 2026-10-03. Inscription 1989, dossier 524.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-asi-sanchi',
    title: 'ASI: Buddhist Monuments at Sanchi',
    detail: 'Research source confirming stupas, a pillar, temples and monasteries on the hill.',
    creator: _asi,
    license: 'Official page used for facts only. No ASI photograph is bundled.',
    sourceUrl: asiSanchi,
    attribution: 'Checked 2026-10-03.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-unesco-konark',
    title: 'UNESCO: Sun Temple, Konârak',
    detail: 'Research source for the Konark summaries. Horse counts disagree between UNESCO short text (six) and the longer note / ASI (seven), so the app never asks for a number.',
    creator: _unesco,
    license: 'UNESCO page used for facts only. Description text is CC-BY-SA IGO 3.0; it was not copied into child screens.',
    sourceUrl: unescoKonark,
    attribution: 'Checked 2026-10-03. Inscription 1984, dossier 246.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-asi-konark',
    title: 'ASI: Sun Temple, Konarak',
    detail: 'Research source confirming a thirteenth-century stone chariot temple in Odisha. The worker tale is treated as a legend.',
    creator: _asi,
    license: 'Official page used for facts only. No ASI photograph is bundled.',
    sourceUrl: asiKonark,
    attribution: 'Checked 2026-10-03.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-unesco-mahabalipuram',
    title: 'UNESCO: Group of Monuments at Mahabalipuram',
    detail: 'Research source for Pallava rock temples, rathas and the shore group. The river relief is labelled as a traditional story.',
    creator: _unesco,
    license: 'UNESCO page used for facts only. Description text is CC-BY-SA IGO 3.0; it was not copied into child screens.',
    sourceUrl: unescoMahabalipuram,
    attribution: 'Checked 2026-10-03. Inscription 1984, dossier 249.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-unesco-taj',
    title: 'UNESCO: Taj Mahal',
    detail: 'Research source for the Agra marble tomb (built 1631–1648). Child copy avoids ranking language from the listing.',
    creator: _unesco,
    license: 'UNESCO page used for facts only. Description text is CC-BY-SA IGO 3.0; it was not copied into child screens.',
    sourceUrl: unescoTaj,
    attribution: 'Checked 2026-10-03. Inscription 1983, dossier 252.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-unesco-hampi-excluded',
    title: 'UNESCO: Group of Monuments at Hampi (not in this slice)',
    detail: 'Candidate from the brief. Researched, then held out of playable activities until licensed pictures and editorial review exist.',
    creator: _unesco,
    license: 'Research link only. No Hampi image or child activity is shipped.',
    sourceUrl: unescoHampi,
    attribution: 'Listing 241. Not playable in this pack.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-unesco-ajanta-excluded',
    title: 'UNESCO: Ajanta Caves (not in this slice)',
    detail: 'Candidate from the brief. Held out of playable activities until licensed pictures and editorial review exist.',
    creator: _unesco,
    license:
        'Research link only. No Ajanta image or child activity is shipped.',
    sourceUrl: unescoAjanta,
    attribution: 'Listing 242. Not playable in this pack.',
    reviewStatus: ReviewStatus.placeholder,
  ),
  CreditRecord(
    id: 'source-unesco-ellora-excluded',
    title: 'UNESCO: Ellora Caves (not in this slice)',
    detail: 'Candidate from the brief. Held out of playable activities until licensed pictures and editorial review exist.',
    creator: _unesco,
    license:
        'Research link only. No Ellora image or child activity is shipped.',
    sourceUrl: unescoEllora,
    attribution: 'Listing 243. Not playable in this pack.',
    reviewStatus: ReviewStatus.placeholder,
  ),
];

HeritagePack emptyHeritagePack() {
  return const HeritagePack(
    packId: 'heritage_release_empty',
    schemaVersion: 1,
    contentVersion: 0,
    reviewStatus: ReviewStatus.placeholder,
    sites: {},
    activities: [],
    clips: {},
  );
}

List<CreditRecord> parentVisibleCredits() {
  return [...heritageIllustrationCredits, ...heritageResearchCredits];
}
