# SproutLab 0.1.6 (8): features and verification

This build implements the requested repair features and the earlier maze expansion. It preserves package `com.sproutlab.kids`, existing signing identity, stable older game IDs, and stored progress. Device speech is included as the interim option explicitly authorized by the owner. This report distinguishes implementation and automated evidence from physical-device acceptance.

## What is included

| Request | Delivered behavior |
|---|---|
| Hindi Coming soon | Normal release opens a new playable Hindi library when India is selected and Hindi is enabled. 11 vowels, 33 consonants, and 12 illustrated words: 56 teach-and-recognize activities with saved completion and replay. Tapping a tile opens its model and speaks it; tapping the model or Hear again repeats it. |
| Discover India Coming soon | Normal release opens a searchable directory of 28 states and 8 union territories, 7 land neighbours and 2 nearby island countries, and 4 monument activities. Each entry has its name, a simple fact, and a recognition activity. |
| Distorted India map | The complete Survey of India Political Map, English 13th edition (2026), is bundled as a uniformly rendered image with pinch zoom and pan. No approximate political polygons are displayed in this release route. It is a reference map, with dense official labels, rather than a simplified tappable boundary atlas. Region learning uses the searchable cards. |
| Monuments | Locally bundled, attributed photographs of Taj Mahal, Sanchi Stupa, Konark Sun Temple and Shore Temple replace the schematic teaching images in the release library. |
| Natural object art | 12 original watercolor illustrations for Hindi picture words. Apple, banana, mango and sun also use these images in existing picture-choice games; matching teaching word IDs use the illustrations. Other existing objects retain their existing artwork. |
| At least 50 mazes | A dedicated Explore → Mazes tile lists 50 levels for each Ages 3–4, 4–5, 5–6 and 6–7 band: 200 catalogue entries. Existing access rules still distinguish free, replayable and locked games. Counts do not imply 200 free or independently educator-reviewed activities. Five garden palettes, friendly explorer, flower destination, clues and encouragement are retained. |
| After today's five games | Saved sessions survive reopening and date changes. Home offers Next adventure, Play again and a break after completion. The final-game completion panel also offers Next adventure. Double taps reuse one new session. Explicit skips resolve a session but are shown separately and do not count as completed learning. |
| Ages 2–3 | Available in onboarding and grown-up settings. Home uses a three-activity parent-led session from six simple matching activities. Hindi hides alphabet drills in this band and offers picture-word exploration with adult guidance. This is an initial activity set, not a comprehensive toddler curriculum. |
| Tic-Tac-Toe | I go first, Computer goes first (child plays O), and Two players on this device. Mode and board checkpoints persist; local play alternates humans without AI. |
| Background music | Owner-supplied 16-second WAV is the runtime loop. Music stays off until enabled and saved. Parent controls include persisted volume and a four-second preview. Music fades in, ducks for speech and pauses with the app. |
| Readable tiles | Whole-word wrapping and responsive cards are retained; narrow screens and enlarged text are covered by widget checks using bundled fonts. |
| Identify installed build | Grown-up settings shows 0.1.6 (8) and the Explorer content version. Sources, photograph authors/licences and interim speech status are visible to grown-ups. |

## How to use the new build

Install the APK over the existing SproutLab installation to retain data. In the grown-up area choose the India learning region and enable Hindi / Discover India if they were previously disabled. Open Explore to find Hindi, Discover India and Mazes.

For Hindi speech, install an offline Hindi voice in Android text-to-speech settings. The grown-up area contains a shortcut. English place names use an installed offline English voice. Missing voices produce an honest installation message instead of pretending to play. Voice quality and pronunciation depend on the device's engine; native-speaker-reviewed recordings are not included.

Turn Background music on and press Save. The separate volume slider saves immediately. Preview plays a bounded sample without permanently changing the music preference. Device media volume also affects playback.

After the five Home activities (three for Ages 2–3), choose Next adventure to start another set on the same day. Learning history remains intact. Play again revisits finished activities; a replay does not create another first-completion reward.

## Content and media evidence

- All 105 new Explorer IDs resolve to playable screens and saved replay routes. Answer sets have distinct alternatives and contain the intended answer.
- Map reference: https://surveyofindia.gov.in/UserFiles/files/POLMAP_ENGLISH-2026.pdf . Digital-map guidance is recorded at https://onlinemaps.surveyofindia.gov.in/GeospatialGuidelines.aspx . Original page content and proportions are retained; this report is not a legal certification.
- All four photograph originals were visually inspected. Wikimedia file pages, individual authors and CC BY-SA 3.0 / 4.0 licences are recorded in `assets/content/explorer_asset_provenance.json` and the grown-up credits. UNESCO records 252, 524, 246 and 249 support monument identity/location. Neighbour categories follow Ministry of Home Affairs' land-border convention; Sri Lanka and Maldives are separately labelled nearby island countries.
- The supplied music is unchanged, SHA256 `68B2F5737FCD8EE00CB26F2684ADFD7B27134F1AFD5F0974240D1D8424FBFE21`. PCM 16-bit mono, 22050 Hz, 16 seconds. Peak amplitude 0.10095 and RMS 0.02793; first and last sampled values are zero. This checks format/clipping/endpoints, not perceived loop quality.
- `assets/content/explorer_asset_provenance.json` contains file sizes and SHA256 hashes. `assets/content/audio_provenance.json` records owner-supplied music and the authorized device-speech exception. No legacy draft content has been blanket-marked approved.
- Flutter screenshots under `build/explorer-review` show Hindi, India directory, full map, pomegranate and Taj Mahal with actual bundled fonts. These are rendered widget screenshots, not physical-phone screenshots.

## Acceptance limits

No Android phone or configured emulator was connected during this work. Fresh installation, upgrading an existing installation, actual speaker/headphone playback, Hindi-speaker listening review, and real-device offline/lifecycle acceptance remain unverified. Automated tests do not establish audible pronunciation. The APK should be evaluated on the intended phone before a wider release.

The new regional pack teaches names, simple geography and recognition. It does not yet provide an educator-reviewed comprehensive syllabus, all state capitals and seasonal capitals, a tappable state-boundary atlas, or a real photograph for every state. Legacy tracing, sentence-building and approximate polygon lessons remain withheld from the normal release route. The owner's interim-device-speech authorization supersedes the handoff requirement for reviewed recordings in this build; it does not turn synthesized speech into reviewed recordings.

Final automated validation: the full suite passed all 341 tests, and one additional music-preview regression test passed after the final settings-restoration correction. Static analysis reported no issues. The tests cover content IDs and coverage, saved skips/completion/replay, same-day continuation and double-tap idempotence, responsive layouts, maze topology, Tic-Tac-Toe modes and audio lifecycle. Release signature verification confirms the existing SHA256 certificate `648d888dee6a94f75c2556515e74e2c09c735e8176566b8d7e7f29e13db45e17`; package/version are `com.sproutlab.kids`, `0.1.6`, versionCode `8`, minimum Android API 24. All 17 teaching images, music and both provenance manifests were read back from the final APK and match their source files byte-for-byte. APK archive integrity passed. The versioned checksum JSON accompanies the APK.
