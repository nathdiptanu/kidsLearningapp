# SproutLab 0.1.7+9 — India learning

## How to open it

Choose India in the grown-up region setting, then **Explore → Discover India → Start my India journey**. Start with the map introduction. The journey orders map basics, neighbouring countries, finding states, capitals, then monuments. Every activity first shows and speaks teaching material; **Let’s try** opens its question. **Show me again** returns to teaching. Children can explore without answering and stop whenever they want.

## Implemented

- Uniformly fitted, zoomable, colourful India map derived from the Survey of India source, preserving the original geographic outlines and islands. All 28 states can be tapped, highlighted, named, and found in questions. Delhi, Jammu and Kashmir, and Ladakh also have selectable source polygons. Five tiny or scattered union territories use the named directory; their boundaries are not invented or enlarged into inaccurate shapes.
- Map introduction explains the outline, 28 states/8 union territories, compass directions, sea/ocean names, New Delhi, and islands.
- Seven land neighbours and two nearby island countries are introduced before state-finding questions. The full 2026 Survey of India reference map is shown, with zoom, so learners can see neighbouring countries. Questions distinguish land neighbours from nearby island countries.
- Capital facts for all 36 states and union territories. Shared, provisional, second, and seasonal capital conventions are explained. Capital quizzes are limited to ages 5–7.
- Six real monument photographs: Taj Mahal, Sanchi Stupa, Konark Sun Temple, Shore Temple, Qutb Minar, and Red Fort. Each has name recognition and state/union-territory questions.
- 91 teaching/question activities for ages 5–7: 6 map basics, 9 neighbours, 28 state locations, 36 capitals, and 12 monument questions. Ages 3–5 omit state/territory capital quizzes. Ages 2–3 use parent-led exploration, fewer map facts, and no required quizzes.
- Teaching, prompts, and tapped state information use clearly labelled installed offline English device speech, consistent with the owner's interim speech approval. A missing voice or disabled narration is reported visibly. No claim of reviewed human pronunciation recordings.
- Correct answers save durable progress and can be replayed through the existing completion routes. Wrong map taps give encouraging feedback without completing an activity. Progress from previous versions is retained.
- Earlier features remain: dedicated Mazes with at least 50 layouts per established learning band, Hindi device speech, background music, next Home adventures, age 2–3, and Tic-Tac-Toe playing second or with another person.

## Sources and transformations

Interactive boundary source: [Survey of India SVG via Wikimedia Commons](https://commons.wikimedia.org/wiki/File:States_of_India_(Survey_of_India).svg), 2023 source, public-domain dedication with VRT permission ticket 2023040810000569. The extractor polygonizes the original line segments, rounds endpoints to 0.01 original source units to close export gaps, deduplicates exact repeated segments, and preserves island lines. It does not simplify geographic borders. Pastel fills, selection outlines, and labels are presentation additions. The map is an educational rendering of the cited source, not a new government-certified map.

The detailed reference remains the [Survey of India 2026 Political Map](https://surveyofindia.gov.in/pages/political-map-of-india). Capital facts use that current reference and government updates, including:

- [Andhra Pradesh/Amaravati, 2026](https://www.pib.gov.in/PressReleasePage.aspx?PRID=2247683&lang=1&reg=1)
- [Uttarakhand capital conventions](https://cm.uk.gov.in/geography/)
- [Himachal Pradesh second capital notification](https://himachal.nic.in/WriteReadData/l892s/21_l892s/Dharamshala-50740507.pdf)
- [Nagpur and winter capital](https://nagpur.gov.in/history/)
- [Jammu and Kashmir seasonal capitals](https://jklokbhavan.nic.in/aboutjk/)
- [Ladakh gazette naming Leh](https://egazette.ladakh.gov.in/WriteReadData/2022/1175.pdf), with an explicit note that Kargil is an important administrative centre and some government services describe joint capitals.
- [Andaman and Nicobar/Sri Vijaya Puram](https://andamannicobar.gov.in/about)
- [Merged DNHDD administration](https://ddd.gov.in/faqs/)

Additional photos: [Qutb Minar](https://commons.wikimedia.org/wiki/File:Qutub_Minar_Vertical2.jpg), Fuzail Ahmad, CC BY-SA 4.0, Wikimedia 960-pixel thumbnail; [Red Fort](https://commons.wikimedia.org/wiki/File:Red_fort_new_delhi_with_indian_flag.jpg), Michael Clarke, CC BY-SA 2.0, bundled unchanged. Facts: UNESCO [Qutb complex](https://whc.unesco.org/en/list/233/) and [Red Fort](https://whc.unesco.org/en/list/231/). Attribution is displayed beneath photos and in grown-up credits. File hashes and transformations are recorded in `assets/content/explorer_asset_provenance.json`.

## Verification

Final automated results, APK package metadata, signing verification, checksum, and size are appended below after packaging. The source topology and all 31 hit-region anchors are tested, including all 28 states and uniform portrait/landscape transformations. Widget tests cover teach-before-recall, real state taps, incorrect answers, saved completion, replay routing, and English speech request text. A rendered phone screenshot was inspected against the source map.

No physical Android device or configured emulator is available in this workspace. Audible device pronunciation, speaker volume, installation/upgrade, and touch performance on a physical phone remain to be checked on the user's device. Automated speech tests verify requests and settings, not the sound produced by a phone.

## Final release results

- Full app and distribution regression suite: **345 tests passed**. Final navigation-save guard and narrow-phone 2× text verification: the three India learning tests passed again after the final source change.
- Final Flutter analysis: **No issues found**.
- Signed release build succeeded. Package `com.sproutlab.kids`, versionName `0.1.7`, versionCode `9`, minimum API 24, target API 36.
- APK signature verified, using the existing certificate SHA256 `648d888dee6a94f75c2556515e74e2c09c735e8176566b8d7e7f29e13db45e17`.
- Archive integrity passed. All 19 teaching images plus source map geometry (20 assets), music, and both provenance files match their workspace originals byte-for-byte inside the APK.
- APK: `sproutlab-0.1.7+9-india-learning-release.apk`, 132,367,974 bytes (126.2 MiB).
- APK SHA256: `7aa5524f3ebcf2591c5ff88d8174671b57bd23e5b9ee647846a3fd9ad6c89dd9`.
- Machine-readable checks: `sproutlab-0.1.7+9-verification.json`; native package metadata and signature output accompany the APK.
