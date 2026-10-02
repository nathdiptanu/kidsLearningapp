# Hindi Learning and Discover India: implementation status

Brief: `docs/SproutLab_Hindi_and_Discover_India_Cursor_Brief.md` (2 October 2026).
Approved visual references: `design/reference/sproutlab-home-concept.png` and `design/reference/sproutlab-explore-concept.png`. They are not listed in `pubspec.yaml`, so they are not packaged in the app.

Audit date: 3 October 2026. Audited commit: `84bf29b` (app 0.1.2+3) on `main` of `nathdiptanu/kidsLearningapp`, plus the baseline fixes listed in section 5.3.

Status words used here:

- **Done**: implemented and covered by a test or measurement in this document.
- **Not started**: no code exists.
- **Blocked**: cannot be finished by engineering alone; the blocker is named.

- **Partly done**: some code exists and is tested; the missing part is named.

Phase A (audit and plan) is done. The shared UI foundation and parent preferences from Phase B are done and tested (section 6). Tracing, word building and sample Hindi/English letter lessons are implemented as development-only content (section 7). Discover India has a small geography slice (section 8) and a heritage slice (section 9). **No lesson, map, fact, heritage drawing or recording is approved for release.** The full state/UT catalogue is not claimed as verified.

---

## 1. Existing implementation and reusable components

### 1.1 Framework and dependencies

| Area | Finding |
|---|---|
| Framework | Flutter 3.47.5, Dart 3.13.4 (`C:\src\flutter`). `pubspec.yaml` SDK `^3.13.4` |
| State | `flutter_riverpod` 3.4.x. Providers in `lib/app/session_providers.dart` |
| Database | `drift` 2.35 + `sqlite3` 3.5.2, schema version 9, file `lib/data/local/database/app_database.dart` |
| Audio | `audioplayers` 6.5.0 behind `AudioPlayback` (`lib/core/audio/audio_playback.dart`) |
| Billing | `in_app_purchase` 3.3.0 / `in_app_purchase_android` 0.5.0 behind `BillingGateway` and `StoreBillingPort` |
| Other | `path`, `path_provider`, `url_launcher` (parent Premium screen only) |
| Localization | None. No `flutter_localizations`, no `intl`, no ARB files. All copy is English string literals in widgets |
| Fonts | Nunito 400/600/700/800 (OFL), Latin only. No Devanagari font is bundled, so Hindi would fall back to the device font |
| Tracking/ads/AI | None found. No analytics, ads, crash reporting, or cloud AI SDKs |
| Devanagari text | None anywhere in `lib/`, `assets/`, `test/` (searched U+0900–U+097F) |

### 1.2 Navigation and design system

- One route (`SproutRouter`, `/` to `RootScreen`). Everything else is `Navigator.push`. There are **no deep links and no search**, so the brief's "centralize availability including deep links and search" currently means: the Explore grid, Home journey, Play again, and Rewards must all ask one availability rule.
- `ChildShell` has bottom navigation for Home / Explore / Rewards, held in an `IndexedStack` and built lazily.
- Design system in `lib/core/design_system/`: tokens (`sprout_tokens.dart`), theme (`sprout_theme.dart`), `LearningArea` (Explore grouping), and widgets `BrandHeader`, `FoxMascot`, `ArtTile`, `CategoryCard`, `SproutCard`, `TappableCard`, `ActivityCard`, `StepCircle`, `JourneyProgress`, `StatusChip`, `PrimaryKidButton`, `SecondaryKidButton`, `GameHeader`, `ChoiceCard`, `AppPageScaffold`, `EmptyState`, `PlayInstruction`, `FinishedBanner`.
- Explore matches the reference: a 2-column grid (3 columns from 600 dp; 1 column at large text on narrow screens), category art from `assets/art/`, and a "Play again" card. Two more cards (Hindi, Discover India) fit the same grid without layout changes; they need two new licensed illustrations.

**Reusable for the new modules:** `LearningArea` (add two areas), `CategoryCard`, `CategoryScreen`/`LevelCard` pattern, `GameHeader` (progress + replay sound button), `ChoiceCard` (large answers), `PlayInstruction`, `FinishedBanner`, `ParentHoldGate`, `SproutCard`, `StatusChip`.

### 1.3 Games, profiles, age settings, parent gate

- Eight engines (`GameCategory`): maze, find_difference, maths, vocabulary, pattern, matching, knowledge, tic_tac_toe. 500 learning activities plus 20 Tic-Tac-Toe games (`ActivityCatalog`, 25 per engine per band).
- Activity id: `'<engine>:v1:<band A-D>:<variant>'`. Ids are stable and stored in progress, badges, journeys, checkpoints.
- Age bands: `AgeBand` A 3–4, B 4–5, C 5–6, D 6–7. Stored per profile. No date of birth is collected. There is no 1–2 band (correctly out of scope).
- **Child profiles:** the `child_profiles` table supports many rows with an `active` flag, but `DriftProfileRepository.createProfile` throws `ProfileAlreadyExistsFailure` when an active profile exists, and there is no list or switch API or UI. **Multiple profiles are not supported today.** All progress tables are already keyed by `profileId`, so adding switching does not need data migration.
- Parent gate: `ParentHoldGate`, 3-second press-and-hold, held in `parentGateProvider` for the session. Guards settings, learning summary, More activities (Premium), About and privacy.
- Onboarding: welcome, "saved on this device", age band, avatar, sound, finish. A parent completes it; no child forms. It has **no country step**.

### 1.4 Local database, progress, rewards, scoring, entitlements

| Table | Use | Relevant to new modules |
|---|---|---|
| `child_profiles` | nickname, avatar, band, active | profile id for all new progress |
| `activity_progress` | per profile+activity: attempts, completions, best stars/score, hints, `countedAsFree`, `skillId` | free-limit counting is per `engineType` |
| `skill_progress` | mastery, first-try/after-hint/incorrect counts, recent outcomes | adaptive difficulty for existing engines |
| `daily_journeys`, `daily_journey_items` | daily five | planner must not pull hidden region items |
| `activity_checkpoints` | resume in-progress | reusable |
| `practice_days`, `rewards`, `level_badges` | streaks, badges/stickers, one badge per activity | badge dedup already keyed by `(profileId, activityId)` |
| `entitlement_cache_entries` | device Premium state | single Premium flag; reuse |
| `local_settings` | one device row: sound, music, narration, onboarding, reminders, reduced motion, gentle stop | new region/language fields go here (device-level parent choices) |
| `recent_generated_levels` | avoid repeats | |

- Migrations 1 to 9 are additive and tested (`dist/database/schema_migration_test.dart`). Any version above 9 throws instead of erasing data.
- Scoring: `lib/domain/scoring/activity_score.dart`, documented in `docs/scoring_rules.md`. Non-punitive (no failure marks).
- Rewards: 8 badges, about 25 stickers (`reward_catalog.dart`), awarded once (`rewards` primary key).
- Entitlement: `FreeEntitlementPolicy`, 5 free unique completions **per engine** (`MonetizationConfig.freeCompletedLevelsPerGame`). Completed and in-progress levels stay playable.
- **Billing is not live:** `BillingProductConfig.annualSubscriptionId` is empty, so no purchase can happen in current builds and no user holds Premium yet. No country-specific packs exist, so there is no advertised access to protect beyond "5 free per game, Premium unlocks more".

### 1.5 Hindi/English rendering, audio, platforms

- Hindi rendering: untested. Flutter shapes Devanagari through HarfBuzz, but only if a font with Devanagari glyphs is used. Nunito has none. A licensed font (for example Noto Sans Devanagari, SIL OFL 1.1, licence to be confirmed against the downloaded files) must be bundled and declared as a fallback.
- Audio: `AssetAudioController` plays 5 effects and optional music. `playNarration(clipId)` is a **no-op**: no narration recordings exist. There is **no stop, replay, speed, ducking, or debounce API** for speech, and no text-to-speech package. Lifecycle pause/resume exists for music.
- No microphone permission, no recording. Merged manifest permissions (from the 0.1.1 audit): `INTERNET`, `com.android.vending.BILLING`, `ACCESS_NETWORK_STATE`.
- Android: delivered today. minSdk 24 (Flutter default), targetSdk/compileSdk 36.
- **iOS: no `ios/` folder exists.** Dependencies used all publish iOS support, but nothing has been generated, built, or run for iOS. This machine is Windows, so iOS cannot be built here. iOS stays **unverified**.

### 1.6 Android build configuration and signing

- `applicationId` `com.sproutlab.kids`, namespace `com.sproutlab.sproutlab`, version from `pubspec.yaml` (`0.1.2+3`).
- Release signing reads `android/key.properties` + `android/upload-keystore.jks`. Both exist locally, are gitignored, and were not pushed. No debug-key fallback for release.
- Upload certificate SHA-256 `64:8D:88:8D:EE:6A:94:F7:5C:25:56:51:5E:74:E2:C0:9C:73:5E:81:76:56:6B:8D:7E:7F:29:E1:3D:B4:5E:17`.
- Builds run in a mirror (`%TEMP%\sproutlab-apk`) because the project `build` folder has locked files. Flutter reports "failed to strip debug symbols" after `bundleRelease` because Android `cmdline-tools`/`apkanalyzer` are not installed; the bundle is still produced and signed.

### 1.7 The reported 150 MB

The 150 MB figure matches the **debug APK**, not anything a user downloads.

| Artifact | Bytes | What dominates |
|---|---:|---|
| `artifacts/app-debug.apk` (0.1.1, debug) | 165,915,775 (158 MiB) | unoptimised `libflutter.so` for 3 ABIs (112 MB), 64 MB Dart kernel (21.8 MB packed), Vulkan validation layer 15 MB |
| `artifacts/sproutlab-0.1.2-release.apk` (universal release) | 63,091,510 | native libraries for 3 ABIs stored uncompressed (about 59 MB) |
| `artifacts/sproutlab-0.1.2-release.aab` | 61,724,073 | 31.8 MB is `BUNDLE-METADATA` debug symbols, which Play does not deliver to devices |
| arm64-only release APK, `flutter build apk --release --target-platform android-arm64 --analyze-size` (measured 3 Oct 2026) | 23,716,815 | `libflutter.so` 11.7 MB, `libapp.so` (Dart AOT) 6.6 MB, `libsqlite3.so` 1.7 MB, `res` 1.3 MB, Flutter assets 1.2 MB, dex 0.47 MB |

- Estimated Play download for an arm64 phone from the AAB: about **12.1 MB** (sum of compressed arm64 entries; an estimate, not a Play Console figure). Installed size is close to the arm64 APK (about 23 MB) because native libraries are stored uncompressed.
- Not measured: Play Console's per-device download/install numbers (visible after upload), bundletool device-spec output (bundletool not installed).
- Small wins found: `res/4k.png` 411 KB and `OX.png` 242 KB (launcher/splash images), `fox_wave.png` 311 KB, `sproutlab_fox.png` 276 KB, `music.wav` 256 KB uncompressed audio, and `libdartjni.so` for x86_64/armeabi-v7a (about 200 KB) included even in the arm64 APK. None block this work.

---

## 2. Required changes mapped to the brief

| Brief section | Required change | Existing piece to reuse | Status |
|---|---|---|---|
| 2 Region | Parent-chosen learning region stored locally; no GPS/IP/SIM | `local_settings` row, onboarding, grown-up settings | Done (6.2) |
| 2 Region | One availability rule used by Explore, Home journey planner, Play again, Rewards, parent summary | `LearningArea`, `DailyJourneyPlanner` | Partly done: `RegionalAvailability` gates Explore and the module screen. The planner, Play again and Rewards have no regional activities to show yet, so they must call the rule when content arrives (6.2) |
| 2 Region | Region change hides, never deletes; switching back restores | progress is keyed by activity id, nothing deletes rows | Done (6.2) |
| 2 Languages | Interface language and teaching language (English/Hindi/bilingual), independent of country | none (no l10n) | Partly done: both are stored separately and the teaching language can be chosen. Hindi interface is shown as "Not available yet" because no strings are translated (6.3) |
| 2 Onboarding | Add country step with "Choose which learning activities to show."; optional language step | `OnboardingScreen` | Done; languages are in grown-up settings, not onboarding (6.4) |
| 2 Profiles | Multiple child profiles, independent progress | schema supports it; repository blocks it | Done (6.5) |
| 3 Age | Map bands A–D to the brief's 3–4 / 5–6 / 6–7 rows; readiness override by parent | `AgeBand`, `SkillAdaptation` | Partly done: readiness is stored per child. Nothing reads it yet; the settings screen says so (6.5) |
| 4 Hindi | Modes Listen, Find, Match, Trace, Build a Word, Review | `ChoiceCard`, `ActivityScreen` pattern | Partly done (7.1): reusable screens exist. Review mode has no separate scheduler yet |
| 4 Hindi | Concept types: vowel, consonant, matra, nasal mark, conjunct (क्ष त्र ज्ञ as conjuncts) | none | Partly done (7.1): tokens carry a concept type; क्ष is stored as a conjunct |
| 4 Hindi | Grapheme-cluster-safe tokens (`characters` package / explicit token lists) | none | Done (7.2) |
| 5 English | Letter name vs letter sound modes, reviewed recordings, Q is for queen | vocabulary engine (pictures) | Partly done (7.1): name and sound are separate lessons; Q is English-only. Recordings are not bundled |
| 6 Voice | `AudioService`: play, stop, replay, speed (where supported), debounce, stop on leave/background, ducking, mute | `AudioController`, `AudioPlayback` | Partly done (7.3): play/stop/replay, debounce, ducking, mute, lifecycle stop. Speed is not implemented |
| 6 Voice | Optional TTS fallback for explanations only, with availability detection | none | Partly done (7.3): `SpeechFallback` reports no device voice and never speaks phonics. No TTS plugin was added |
| 6 Font | Bundle licensed Devanagari font; test matras, conjuncts, line height | Nunito setup in `pubspec.yaml` | Partly done: font, licence and fallback are in and tested; matra and conjunct rendering is not yet checked on a device or with a golden (6.6) |
| 7 Tracing | Vector stroke engine, normalised coordinates, tolerance + coverage, tap-to-follow, undo, no timer, store summary only | none | Done for the engine (7.2). Templates are development-only and need an educator |
| 8 India | Journeys My India, States and Places, Capitals, Heritage; teach then quiz | `CategoryScreen`, `ChoiceCard` | Partly done (8–9): explore/learn/match/capital/review plus a heritage development slice. None of it is approved for release |
| 8 Maps | Reviewed vector outlines with full-map context, insets for small states/UTs, list alternative | none | Partly done (8.2): Natural Earth 50m public-domain geometry, simplified, not Survey of India. Pending geography review |
| 8 Capitals | Structured capital arrangements (multiple/seasonal seats), source + verification date per item | knowledge fact model | Partly done (8.3): unambiguous capitals only; Maharashtra seasonal seats recorded and excluded |
| 9 Heritage | Picture recognition and short reviewed stories; history vs legend label | knowledge bank pattern | Partly done (9): identify, match, locate, story and recall exist as development samples. Blocked on licensed photographs, reviewed narration and editorial approval |
| 10 Rights | Asset manifest with id, URL, creator, licence, attribution, changes, file, checksum, review status; parent-visible credits | `docs/asset_licenses.md`, `assets/content/*_provenance.json` | Partly done: language, geography and heritage manifests exist. Parent credits are behind the grown-up gate. Checksums stay empty because no third-party media files were shipped |
| 11 Content | Versioned packs; release loader accepts only reviewed records with valid assets | `BundledContentLoader`, `ContentValidator`, `ReviewStatus` | Partly done (10): pack ids and content versions exist; `ContentSchemaValidator` rejects missing media, duplicate ids, invalid answers, drafts, missing sources/licences and broken prerequisites. No download server. |
| 11 Progress | Per item and mode: attempts, first/last completed, correct, hints, assisted, seen-vs-recalled, status Introduced/Practising/Ready to Review | `activity_progress`, `skill_progress` | Done (10): schema 9 `learning_item_progress`. A single correct guess stays Introduced. |
| 12 Adaptation | Session of 5: up to 2 new, 2 review, 1 easy; review only taught items | `DailyJourneyPlanner` | Done (10): `LearningSessionPlanner` plus optional Home injection when India is available. Default five-game mix is unchanged. |
| 12 Parent | Summary lines such as "Practised 4 Hindi letters" with the existing disclaimer | `ParentReport`, `ParentDashboardScreen` | Done (10): factual notes only. No IQ, diagnosis or comparison. |
| 12 Entitlement | New modules use the existing Premium flag and free policy; free sample decided by owner | `FreeEntitlementPolicy`, `accessFor` | Done (10): no new Premium flags. `lesson:` / `geo:` / `heritage:` do not consume the 5-per-game count. Parent copy says so. |
| 13 Size | Keep packs small: vectors for maps/strokes, compressed narration, no reference screenshots in assets | measurements in 1.7 | Baseline done |
| 15 Privacy | Update privacy policy and About screen for country/language preferences | `docs/privacy-policy.html`, `PrivacyScreen` | Done (6.8); the hosted copy of the policy page is not updated until the file is republished |

### 2.1 Data shape (schema 8 settings; schema 9 item progress)

New `local_settings` columns, all nullable or defaulted so existing rows are unchanged:

- `learning_region` text, null until a parent chooses (null means global content only).
- `interface_language` text, default `en`.
- `teaching_language` text: `en`, `hi`, or `bilingual`; default `en`.
- `hindi_enabled` bool default true, `discover_india_enabled` bool default true. They only apply when `learning_region = 'IN'`.

New table `learning_item_progress`, primary key `(profile_id, item_id, mode)`:

- `content_version`, `attempts`, `correct`, `hints_used`, `assisted`, `first_completed_at`, `last_completed_at`, `last_seen_at`, `recalled_count`, `status` (`introduced`/`practising`/`ready_to_review`).
- Only summaries are stored, not raw touch paths.

Content record (JSON in `assets/content/packs/`), loaded by an extended `BundledContentLoader`:

- Fields: `id`, `pack`, `packVersion`, `type`, `regions`, `teachingLanguages`, `ageBands`, `skills`, `prerequisites`, `display`, `tokens`, `narrationIds`, `imageId`, `strokeTemplateId` or `geometryId`, `question`, `options`, `correctIds`, `explanation`, `sources`, `reviewedAt`, `reviewer`, `reviewStatus`, `rightsStatus`.
- Geography also carries `adminType` (`state`/`union_territory`) and a structured `capitals` list, each entry with role, seasonal note, source, and verifiedAt.

Release builds load only records with `reviewStatus = approved`, `rightsStatus = cleared`, and every referenced asset present. Draft records load only in debug builds.

---

## 3. Phase checklist and acceptance criteria

### Phase A: audit and plan

- [x] Framework, dependencies, navigation and design system audited (section 1.1, 1.2).
- [x] Games, profiles, age bands, parent gate audited (1.3).
- [x] Database, progress, rewards, scoring, entitlements audited (1.4).
- [x] Hindi/English rendering, audio, Android/iOS support audited (1.5).
- [x] Android build and signing audited (1.6).
- [x] 150 MB report traced to the debug APK; release sizes measured (1.7).
- [x] Baseline analyze and full test suite (`test` + `dist`) run and passing after fixes (5.2, 5.3).
- [x] Stable schemas: settings/profile (schema 8) and `learning_item_progress` (schema 9) are code and tested. Pack JSON still lives as Dart const packs plus asset manifests. `ContentSchemaValidator` rejects the invalid cases in section 15 of the brief. Optional downloadable packs are not started.

### Phase B: vertical slice

Engineering work:

- [x] Region and language preferences in grown-up settings and onboarding. India shows exactly two extra Explore cards, another region or no region shows none, and the choice persists across restart. No location, IP or SIM lookup exists in the code (6.2, 6.4).
- [x] Central availability rule. Explore, the module screen, Today's practice and Home regional injection all call `RegionalAvailability`. Play again and Rewards resolve completed `lesson:` / `geo:` / `heritage:` ids through `ActivityCatalog.byId` and do not invent hidden rows. Changing region still hides, never deletes.
- [x] Schema 8 migration for settings and profiles. A v7 database with a profile, progress and settings opens as v8 with all rows intact; the earlier v1–v6 migration tests still pass (6.1).
- [x] Multiple child profiles: add, switch and edit behind the parent gate, up to 6. Two profiles keep separate progress, age band and readiness. Entitlement is unchanged in code, but the free count is per profile; see the owner decision in 4.5 (6.5).
- [x] Shared UI foundation: tokens, Devanagari fallback, two accessible category cards, the module screen, and the parent preferences screen, checked at 320 dp, 411 dp, tablet and 2× text (6.7).
- [x] Narration control with stop-before-play, replay, debounce, lifecycle stop, mute, music ducking and missing-clip handling. Evidence: `dist/audio/asset_audio_controller_test.dart`. Speed control is not implemented. No reviewed clips are bundled, so play returns `missing` and the words stay on screen.
- [ ] Devanagari font bundled with licence file and hashes. **Bundling, licence and hashes are done (6.6); the rendering check below is open.** Acceptance: golden or widget test renders sample letters, matras (कि की कु कू के कै को कौ), nasal marks (अं अँ), and conjuncts (क्ष त्र ज्ञ श्र) without missing glyph boxes at text scale 1 and 2; manual check on a device.
- [x] Unicode token assembly for Build a Word. Tokens come from a curated list, comparison uses grapheme clusters, invalid mixes get a gentle prompt, and a correct word asks for the reviewed clip when one exists (7.2).
- [x] Tracing engine. Tests cover normalisation, tolerance/coverage, tap-to-follow, undo, ignored extra pointers, and summary-only persistence. No time limit. Device frame timing is not measured (7.2).
- [ ] Hindi Learning and Discover India screens with teach-then-quiz flow, large answers, replay button, and text/picture equivalents. **Partly done:** Hindi lessons and Discover India geography/heritage slices share Hear again, pinned Next/Skip and development-sample marking. Acceptance still open: device/TalkBack and reviewed content.
- [x] Entitlement wiring through `accessFor`. Hindi and Discover India samples do not increment the 5-free-per-engine count. No new Premium flag was added. Existing engines are unchanged.
- [x] Parent summary lines and privacy text updated. Privacy text is in 6.8. Summary lines use stored item/mode counts (10). Disclaimer shown.

Content needed for Phase B to ship (blocked until supplied and reviewed, see section 4):

- [ ] 5 reviewed Hindi letter/word lessons with recordings.
- [ ] 2 reviewed tracing stroke templates.
- [ ] 3 reviewed state lessons with licensed map geometry, at least one unambiguous capital activity. **Engineering sample exists (8); review is still open.**
- [ ] 2 heritage activities with licensed images and reviewed text. **Engineering samples exist (9); licensed photos and review are still open.**
- [ ] Review of the slice with a native Hindi speaker/educator and a small parent group.

Until those exist, Phase B code can ship only with the modules hidden in release builds (draft content is development-only). Release builds must not show the new Explore cards with empty or draft content.

**Release risk (open):** India cards open development-sample pages in debug/tests. Release loaders drop unreviewed Hindi and geography. Before the next store build, hide or default-off the cards unless the owner accepts a preview. No build has been made with this code.

### Phase C: expansion (after Phase B review)

- [ ] Larger reviewed Hindi corpus; English letter-name/letter-sound modes with reviewed recordings.
- [ ] Reviewed current state/UT catalogue with structured capitals, sources, verification dates.
- [ ] Staged capital lessons, heritage stories, review scheduling, expanded parent dashboard.
- [ ] Hindi interface language (needs Flutter `gen-l10n` set up and every string moved to ARB files).
- [x] Counts reported as unique reviewed items, templates, and variants separately (section 10). Reviewed items remain 0.

### Phase D: later

- [ ] Optional downloadable packs (consent, size shown, checksum and schema validation, atomic install, removal keeps progress, no executable code).
- [ ] Further languages.
- [ ] iOS: generate `ios/`, StoreKit billing adapter, build and test on a Mac. Until then iOS is unverified.
- [ ] Under-3 audience: separate scope and store review. See the separate scope item in 6.9.

---

## 4. Content, audio, image-licence and map-review dependencies

None of these exist in the repository today. Engineering will not invent them.

### 4.1 Hindi content

- Owner or native Hindi educator to supply and approve: letters for the first group, example words, pictures, meanings, example phrases (pattern: अ, अनार, यह अनार है।), age tags.
- Classification of each item as vowel, consonant, matra, nasal mark, or conjunct.
- Stroke-order templates (vector paths with start points and direction) for the first two tracing letters, including shirorekha handling, approved by the educator.
- The chart the owner attached is inspiration only; its artwork is not to be copied.

### 4.2 Audio

- Professionally recorded, reviewed clips: Hindi letters, words, phrases; English letter names, letter sounds, words (one accent per pack, documented).
- Delivery format to be agreed (for example 44.1 kHz mono, compressed after listening tests). Raw studio files stay out of the app.
- If synthetic voice is used during development: provider licence check and native-speaker approval before any clip ships.
- Decision needed: whether runtime TTS is used at all for explanatory text. It is not required for Phase B.

### 4.3 Maps and geography

- Engineering now uses Natural Earth 50m (public domain) for a simplified India canvas. Survey of India pages remain research links, not a reuse licence. Owner and a geography reviewer must still accept the source before a store release (section 8.2).
- Geography review of the slice states (shape, location, insets) is still open.
- Capital data for the slice cites Know India (and Nagpur district for Maharashtra’s winter seat), each with a URL and verification date. Seasonal or multiple seats are recorded and excluded from single-answer questions.

### 4.4 Images and heritage

- 2 heritage topics chosen from the candidates (for example Sanchi, Konark, Hampi), each with one image whose licence allows commercial use and adaptation (or commissioned art). Share-alike and noncommercial terms checked. **Engineering now has four original drawings (Sanchi, Konark, Mahabalipuram, Taj Mahal). They are not photographs and are not approved art.**
- Short reviewed text per topic, marked as documented history or traditional story.
- Two Explore card illustrations (Hindi, Discover India) in the existing style, licensed or commissioned. The current category art is AI-generated and already awaits owner confirmation (`docs/asset_licenses.md`).

### 4.5 Owner decisions

- Free sample versus Premium for the new modules. Default proposal: same rule as other games (5 free completions per module, Premium unlocks the rest), stated in the parent area.
- Whether Hindi Learning and Discover India default to on when a parent picks India. **Currently on**, and tied to the release risk in Phase B.
- Interface language Hindi in Phase B or Phase C (recommended C; it needs every string localised). Currently stored but not selectable.
- Profile switching is now implemented (6.5). **New decision:** the free limit (5 completed levels per game) is counted per profile, because `uniqueFreeCompleted` and `activity_access.dart` count the active profile's records only. Each added child therefore gets their own 5 free levels per game. If the owner wants a per-device limit, `FreeEntitlementPolicy` must change and be retested. The code was not changed here.
- Whether readiness should change difficulty in the existing English, maths and puzzle games, or only in the new modules.

---

## 5. Baseline build and test results

### 5.1 Environment

Windows, Flutter 3.47.5, Dart 3.13.4, Android SDK build-tools 37.0.0, Java from Android Studio JBR. No emulator was used in this phase. No Mac, so no iOS tooling.

### 5.2 Results (3 October 2026)

| Check | Command | Result |
|---|---|---|
| Static analysis | `flutter analyze` | No issues |
| Full tests, before fixes | `flutter test test dist` | 160 passed, 4 failed |
| Full tests, after fixes | `flutter test test dist` | **164 passed, 0 failed**, no framework exceptions in the log |
| arm64 release APK size | `flutter build apk --release --target-platform android-arm64 --analyze-size` | Built, 23,716,815 bytes (measurement only, not copied to `artifacts/`) |
| Universal release APK / AAB | from 0.1.2 build (2 Oct 2026) | 63,091,510 / 61,724,073 bytes, upload-key signed (see `docs/build_handoff.md`) |

The 0.1.2 handoff ran `flutter test`, which only covers `test/`. The 21 test files in `dist/` (database migrations, entitlement, billing, privacy, rewards, screens) were not run then. **All future checks must run `flutter test test dist`.**

### 5.3 Baseline fixes made in this phase

1. `lib/core/design_system/widgets/sprout_card.dart`: `SproutCard` now paints its colour and border with a `Material` (the shadow stays on the outer `DecoratedBox`). Before, `ListTile`/`SwitchListTile` inside a `SproutCard` (onboarding sound page, settings) triggered Flutter's "ListTile background color or ink splashes may be invisible" assertion in debug builds, and their tap ripple was hidden in release. Appearance is unchanged.
2. `dist/widget/foundation_screen_test.dart`: expectations updated for the 0.1.2 copy and navigation. The onboarding button is now "Next", the welcome page shows the wordmark and title, the journey count is "0 of 5 activities complete", the button is "Start adventure", and Explore opens a category page, then a level, then leaves. Taps scroll the button into view first. The tests still check the same behaviour: onboarding persists across restart, a game opens and closes on a 320×640 screen with no exceptions, and Rewards shows an empty state.
3. `dist/rewards/rewards_test.dart`: the learning summary empty-state text is now "No finished activities yet" (no full stop).

No build configuration, package identity, signing, schema, or entitlement code was changed.

### 5.4 Checks not run in this phase

- Install and launch on a device or emulator.
- TalkBack.
- Play Console delivered sizes.
- bundletool.
- iOS of any kind.

---

## 6. Phase B part 1: shared UI foundation and parent preferences (3 October 2026)

Final check: `flutter analyze` reports no issues, and `flutter test test dist` has **216 passed, 0 failed** (164 before this work). No APK or AAB was built, nothing was committed or pushed, and package identity, signing, billing and the free policy code are unchanged.

### 6.1 Data (schema 8)

- `local_settings` gains `learning_region` (null until chosen), `interface_language` (`en`), `teaching_language` (`en`), `hindi_enabled` (true) and `discover_india_enabled` (true). `child_profiles` gains `readiness` (`steady`). The migration only adds columns; versions above 8 still throw instead of erasing data.
- Unknown stored values fall back safely: an unknown region means no region, an unknown teaching language means English, and an unknown readiness means "Usual pace". A stored Hindi interface value falls back to English until a translation exists.
- Evidence: `dist/database/schema_migration_test.dart` "schema 8 keeps version 7 profiles, progress and settings" builds a real v7 file, reopens it as v8 and checks that the nickname, band, progress row and sound settings are kept and that no regional module is shown. All earlier migration tests pass. `test/regional_preferences_test.dart` "region, languages and switches survive a reload".

### 6.2 Region gating

- One rule: `RegionalAvailability` (`lib/domain/regional/regional_availability.dart`). A module is available only when the region is India **and** its parent switch is on. It is read through `regionalModulesProvider`.
- Explore adds one card per available module after the existing categories. `openRegionalModule` refuses to open a hidden module, and `RegionalModuleScreen` closes itself if the module becomes hidden while it is open. The app has no deep links or search today; these two guards are where any future link or search result must enter.
- Existing English, maths, logic, observation, knowledge, maze and Tic-Tac-Toe activities are unchanged in every region.
- Changing the region only writes settings. No progress, badge, reward or journey row is touched.
- Evidence in `test/regional_preferences_test.dart`:
  - "no region chosen", "another country hides both modules even when switched on", "India shows both modules by default", "grown-up switches hide each module separately", "teaching language does not change availability".
  - "changing region and back keeps progress, badges and rewards" (India, other, India, with counts compared each time).
  - Widget tests: no cards for no region or another region; India shows two labelled cards and opens a module; an open module closes when the region changes and the card returns; a hidden module cannot be opened through `openRegionalModule` or by building the screen directly.
- Not done: the daily journey planner, Play again and Rewards have no regional activities to filter yet. They must use this rule when content is added.

### 6.3 Parent preferences screen

`lib/features/parent/learning_preferences_screen.dart`, behind the 3-second parent hold and reached from grown-up settings:

- Learning region: India, or "Another country or region". The page says the region only chooses activities and the app does not use location.
- India activities: Hindi and Discover India switches. They are disabled, with an explanation, unless the region is India.
- Languages: the interface language (English; Hindi is listed as "Not available yet") and the teaching language (English, Hindi, or English and Hindi). They are independent of the region.
- Audio: sound effects, music and narration switches stay in grown-up settings under "Sound and comfort". Music stays off until a parent turns it on. The narration line now says no recordings exist yet.

### 6.4 Onboarding

The region page sits after the welcome and "saved on this device" pages and before the age band. It explains, in two short sentences, that India adds Hindi and Discover India, that every region keeps the English, maths and puzzle activities, and that languages can be changed later. Next stays disabled until a region is chosen. Evidence: `dist/widget/foundation_screen_test.dart` "onboarding persists and home appears after restart" picks a region and reloads the stored settings. The onboarding region page is also in the screen matrix (6.7).

### 6.5 Child profiles, age band and readiness

- Grown-up settings list every child, with "Playing now" or a Switch button, and an "Add a child" page (avatar, optional nickname, age band, readiness). Up to 6 children; each has their own progress, rewards, band and readiness.
- Readiness: "Take it gently", "Usual pace" or "Ready for more". Tracing uses it for tolerance and coverage. Other games still adapt from play.
- The band never changes automatically; the screen says so.
- Evidence: "each child keeps their own band, readiness and progress" and "profile count has an upper bound and switching needs a real id" in `test/regional_preferences_test.dart`.

### 6.6 Type, illustration and icon system

- Noto Sans Devanagari 400 and 700 (SIL OFL 1.1) are bundled with the licence file and are the fallback in every theme text style. Line height for Devanagari samples is 1.5. Evidence: `test/font_assets_test.dart` checks the files, the pubspec entry, the licence text and the theme fallback. Coverage was checked with fontTools (see `docs/asset_licenses.md`).
- Two new card pictures (`category_hindi.jpg`, `category_discover_india.jpg`) follow the existing generated category art. They are recorded with hashes in `docs/asset_licenses.md` and `assets/content/illustration_provenance.json`, with no text, maps, flags or monuments. **They need owner confirmation before a store release.**
- The Hindi card shows live text अ आ in a badge over the picture, which is excluded from the screen reader.
- Icons: Material rounded icons only (journey rows, settings, privacy). No emoji is used for navigation.
- New colour tokens: `hindi` / `hindiSurface` and `india` / `indiaSurface`.

### 6.7 Accessibility and layout checks

| Check | Evidence | Result |
|---|---|---|
| Contrast | `test/contrast_test.dart`: Hindi script on its badge, Hindi and India icons on their circles, title and secondary text on both header colours, disabled choice icon | All pass WCAG 4.5:1 for text and 3:1 for icons |
| Tap targets and labels | `test/screen_smoke_test.dart` "… meets tap target and contrast guidelines" for Explore with India cards, the Hindi module, learning preferences and the onboarding region page, using Flutter's `androidTapTargetGuideline` (48 dp), `labeledTapTargetGuideline` and `textContrastGuideline` | Pass |
| Screen reader labels | Cards announce "Hindi. Letters and words…" (regional test). Journey rows announce their title and "Coming soon." Region and language rows are buttons in a mutually exclusive group with a selected state | Pass in widget tests |
| Small phone, phone, tablet, 2× text, empty data | Screen matrix in `test/screen_smoke_test.dart` (320×640, 411×731, 800×1280, 2× text, no saved progress) for both module pages, learning preferences, grown-up settings with a long nickname, add a child, and the onboarding region page | No overflow or exceptions. This found and fixed an overflow in the onboarding header on phones; the wordmark now scales down |

Not checked: TalkBack on a real device, Hindi speech output in TalkBack. Matras and conjuncts now have a widget test (`test/font_shaping_test.dart`); a device check is still open.

### 6.8 Privacy text

The About and privacy screen and `docs/privacy-policy.html` now describe the region, language, switch and readiness settings. They say these settings stay on the device, are chosen by a parent, are not worked out from location, network or SIM, and only decide which activities appear. `dist/privacy/privacy_audit_test.dart` still passes. The hosted policy page must be republished for the change to be public.

### 6.9 Audience scope

- The core audience stays ages 3–7 (bands A–D). No band was added, and no store listing, age rating or target-audience setting was changed.
- **Separate scope item, not started:** an optional parent-led experience for ages 1–2. It would need its own content, its own design review, a parent-presence model, and a separate Play Families target-audience decision. It must not ship as a hidden band in the current app.

### 6.10 Open items from this part

- **Release risk:** Hindi and Discover India show marked development samples in debug/tests only. Release loaders drop unreviewed lessons and geography. Before a store build, hide or default-off the India cards unless the owner accepts a preview.
- Hindi interface language is not translated.
- Readiness now changes tracing tolerance. It still does not change existing English/maths/puzzle games.
- The free limit is per profile (owner decision, 4.5).
- Owner confirmation is needed for the two generated card pictures.
- Not run: device install, TalkBack, iOS.

---

## 7. Phase B part 2: tracing, word building and sample lessons (3 October 2026)

The functional pipeline is in. **No lesson is approved for release.** Debug and widget tests load a marked development sample. A release build (`assert` stripped) shows no Hindi/English letter lessons.

### 7.1 Sample lessons

- Hindi (India region + Hindi switch): Listen/Find अ and आ, Match अनार and आम, Trace अ, Build अनार, Remember अ.
- English (every region): letter name A, letter sound A, Remember A, Q is for queen, Trace A, Build CAT.
- Modes share one screen: large text, picture, Hear again, Next and Skip.
- Q is an English letter. The bilingual note says रानी can mean queen and does not start with a Hindi match for Q.
- Concept types are stored on tokens. क्ष is a conjunct, not a basic consonant, and is a distractor in Build अनार.

### 7.2 Word building and tracing

Implemented (engineering, development samples only):

- `WordAssembler` joins curated tokens and compares grapheme clusters (`package:characters`). Invalid mixes get a prompt and do not request speech of the wrong string. Evidence: `test/lessons/word_builder_test.dart`.
- Build अनार uses tokens अ + न + ा + र. The shaped word, picture, short meaning and bilingual note sit on the board. क्ष is a conjunct distractor, not a basic consonant.
- `TracingSession` uses normalised 0–1 points, generous coverage, readiness-based tolerance, undo, retry, tap-to-follow assistance, and ignores a second pointer. There is no timer. Next, Skip and tracing assists stay pinned so they stay tappable. Evidence: `test/lessons/tracing_test.dart` and `test/lessons/lesson_activity_test.dart` "tracing follow-the-dots completes without a timer".
- Checkpoints store lesson id, stroke index, assistance, placed token ids and scores. They do not store raw paths. A mismatched lesson id is dropped. Evidence: `test/lessons/tracing_test.dart` "a summary checkpoint restores stroke index without stored paths" and `test/lessons/lesson_activity_test.dart` "lesson checkpoints keep token ids".
- Templates are engineering polylines with a note that they are not font outlines. Release validation rejects the pack (`LanguagePackValidator`).

Reviewed coverage: none. Font outlines were not used as stroke order. Unreviewed templates stay out of release packs.

### 7.2a Tests that passed for this slice

| Requirement | Evidence | Result |
|---|---|---|
| Unicode / grapheme assembly | `test/lessons/word_builder_test.dart` | Pass |
| Assisted tracing completion | `test/lessons/tracing_test.dart`, lesson follow-the-dots widget test | Pass |
| Tracing coordinate transforms | `test/lessons/tracing_test.dart` "pointer coordinates normalise" | Pass |
| Progress persistence and no duplicate badge | `test/lessons/lesson_activity_test.dart` "word building accepts अनार and persists one badge" | Pass |
| Large-font Q copy and matra tokens | `test/lessons/lesson_activity_test.dart` "large text still shows matras…", `test/font_shaping_test.dart` | Pass |
| Screen matrix for Hindi trace/build | `test/screen_smoke_test.dart` Hindi trace, Hindi build, English Q | Pass |

### 7.3 Audio

- `AudioController.playNarration` / `replayNarration` / `stopNarration` stop the previous clip, debounce rapid taps on the same id, duck music, honour mute, and stop on background.
- Clips in the sample have no files. The activity stays readable.
- `UnavailableSpeechFallback` reports that no device voice is used. Phonics never goes through TTS.

### 7.4 Progress and rewards

- Completions use the existing `saveCompletion` path, level badges and sticker reconcile. A second save of the same lesson id does not add a second badge. Evidence: `test/lessons/lesson_activity_test.dart`.
- Development lesson ids start with `lesson:` and do not consume the 5 free levels of the existing games.

### 7.5 Coverage still pending review

| Item | Status |
|---|---|
| Native-speaker Hindi recordings | Not present |
| English letter-name and phonics recordings | Not present |
| Educator-approved stroke order, including shirorekha | Not present |
| Device/TalkBack check of Devanagari | Widget test only |
| Tracing frame timing on a low-end phone | Not measured |
| Parent-visible credits page | Done for the heritage/geography research notes (9.4); still awaiting reviewed media |

---

## 8. Phase B part 3: Discover India geography slice (3 October 2026)

The functional pipeline is in. **No place, capital, map or recording is approved for release.** Debug and widget tests load a marked development sample. A release build drops the pack (`GeographyPackValidator`). This is not a verified catalogue of 28 states and 8 union territories.

### 8.1 Slice contents

Playable in debug/tests when the region is India and Discover India is on:

- My India: full-map exploration. The 36 Natural Earth units are drawn as context. The taught slice is highlighted.
- Learn: Rajasthan (state), Kerala (state), Goa (state, small), Delhi (union territory).
- Match: name for Rajasthan; location for Kerala and Goa, after that place has been introduced.
- Capitals: Rajasthan → Jaipur, Kerala → Thiruvananthapuram, Goa → Panaji. Only after the place is introduced, and only for bands C–D.
- Review: only previously introduced places.
- Heritage: development samples in section 9. Not approved.

Maharashtra is stored with summer Mumbai and winter Nagpur and is excluded from single-answer capital questions. Delhi’s listed capital equals its name, so it is also excluded.

### 8.2 Maps

- Geometry file: `assets/content/geography/slice_geometry.json`, made from Natural Earth 50m Admin 0 and Admin 1 (public domain). Retrieved 3 October 2026. Projected to a 0–1 canvas and simplified. Borders were not moved for decoration.
- Natural Earth type labels are not used as official state/UT types. Official types come from Know India records.
- This is not a Survey of India map. Owner and geography review are still required before a store release.
- Small units (Goa, Delhi, and others under the span threshold) get a magnified inset and a list alternative. Evidence: `test/geography/map_geometry_test.dart`.

### 8.3 Facts and capitals

Each fact and capital seat has a source URL, review status (`PLACEHOLDER`) and verification date `2026-10-03`. Sources used:

- Know India Rajasthan, Kerala, Goa, NCT of Delhi pages and the states/UTs directory.
- District Nagpur (Government of Maharashtra) for Nagpur as winter capital.

Facts were checked against those pages by engineering. They are not editor-approved child copy. No licensed photographs were added. Narration clip ids exist with no files.

### 8.4 Availability, progress and entitlements

- Discover India still uses `RegionalAvailability` (India + parent switch). Changing region does not delete rows.
- Completions reuse `saveCompletion`, level badges and sticker reconcile. Ids start with `geo:` and do not consume the 5 free levels of the existing games. Evidence: `test/geography/geography_activity_test.dart`.
- Teaching language can show the Hindi name beside the English name. Interface language is still English.

### 8.5 Tests that passed for this slice

| Requirement | Evidence | Result |
|---|---|---|
| Hit targets and small-region list/inset | `test/geography/map_geometry_test.dart`, Goa widget test | Pass |
| Map scaling / letterbox transform | `test/geography/map_geometry_test.dart` | Pass |
| Answer validation | `test/geography/question_engine_test.dart` | Pass |
| Offline bundled geometry and facts | local JSON + const pack; no network in the catalog | Pass |
| Review only previously introduced places | question engine + catalog prereq tests | Pass |
| Screen matrix | `test/screen_smoke_test.dart` Discover India explore/learn | Pass |

### 8.6 Coverage still pending review

| Item | Status |
|---|---|
| Geography review of Natural Earth vs official Indian boundaries | Not done |
| Editorial approval of the four facts and three capital items | Not done |
| Licensed photographs | Not present |
| Reviewed name recordings | Not present |
| Heritage activities | Engineering samples in section 9; not reviewed |
| Full 28-state / 8-UT catalogue | Not claimed; only a slice is encoded as playable content |

---

## 9. Phase B part 4: Discover India heritage slice (3 October 2026)

The functional pipeline is in. **No heritage site, drawing, story or recording is approved for release.** Debug and widget tests load a marked development sample. A release build drops the pack (`HeritagePackValidator` / `includeDrafts: false`). This is not a verified monument catalogue.

### 9.1 Reviewed coverage (honest)

**Editor-approved for release: none.**

Engineering-checked against authoritative pages on 2026-10-03, then written as short original child copy. Still `PLACEHOLDER`:

| Site | Region / community | Sources checked | Playable modes | Not claimed |
|---|---|---|---|---|
| Sanchi | Central India; Buddhist stupas, temples and monasteries | UNESCO 524; ASI Sanchi page | Identify, match, locate, story | “Oldest” or best sanctuary |
| Konark Sun Temple | East coast / Odisha; Hindu sun temple as a stone chariot | UNESCO 246; ASI Konarak page | Identify, match, locate, story | Horse count (UNESCO short text says six; ASI and the UNESCO long note say seven) |
| Mahabalipuram | Southeast coast / Tamil Nadu; Pallava rock temples and rathas | UNESCO 249 | Identify, story | The river relief story is labelled a traditional story, not a fact |
| Taj Mahal | Northern India / Agra; Mughal marble tomb | UNESCO 252 | Identify, match, locate, story | Ranking language (“jewel”, “finest”) from the listing |

Recall asks only about sites whose **story** activity has already been finished. Locate asks only after identify or story.

Held out of playable activities after research (brief candidates): Hampi (UNESCO 241), Ajanta (242), Ellora (243). No child text or picture was added for them. Parent credits list the research links.

### 9.2 Activities

Reusable modes on one screen (`HeritageActivityScreen`), same chrome as Home / Explore / language / geography: `GameHeader`, `ChoiceCard`, Hear again, pinned Next/Skip, development-sample chip.

- Picture identification (all bands; 2 choices for A–C and gentle C, 3 for D more).
- Picture matching (bands A–C; pictures only, no name labels).
- Monument / location association (bands C–D, after the site was introduced).
- Short narrated stories (C–D; gentle C skips stories). History and “A traditional story” chips. Child screens never show URLs.
- Recall of previously introduced **stories** only.

Choice counts, explanations and missing narration follow the existing lesson pattern. Hear again stays visible; missing clips stay silent.

### 9.3 Pictures and rights

- No Wikimedia, UNESCO, ASI or Google Images file is bundled or hotlinked.
- Child pictures are original `CustomPaint` drawings (`HeritagePicture`). They are labelled as drawings, not photographs.
- Every shipped asset id is in `assets/content/heritage/heritage_asset_manifest.json` with creator, licence, attribution, modifications, review status and (where relevant) source URL. There is no local bitmap, so checksums are empty.
- Drawings need owner/art review before a store release.

### 9.4 Parent credits

`CreditsScreen` sits behind the 3-second grown-up gate, from Grown-up settings. It lists illustration and research records. URLs are plain text. The page does not open a browser.

### 9.5 Availability, progress and entitlements

- Still uses `RegionalAvailability` (India + Discover India switch). Changing region does not delete rows.
- Completions reuse `saveCompletion`. Ids start with `heritage:` and do not consume the 5 free levels of the existing games. Evidence: `test/heritage/heritage_activity_test.dart`.
- Teaching language can show the Hindi name on story cards. Interface language is still English.

### 9.6 Tests for this slice

| Requirement | Evidence | Result |
|---|---|---|
| Identification and matching | `test/heritage/heritage_engine_test.dart` | Pass (run in this pass) |
| Locate after introduce; recall only after a story | engine + catalog tests | Pass (run in this pass) |
| Release pack empty | validator + `includeDrafts: false` | Pass (run in this pass) |
| History vs legend on a story | Konark widget test | Pass (run in this pass) |
| Parent credits, no child hotlink | credits widget test | Pass (run in this pass) |
| Screen matrix | `test/screen_smoke_test.dart` heritage identify/story/credits | Pass (run in this pass) |

### 9.7 Remaining blockers

| Item | Status |
|---|---|
| Editorial approval of the four facts and stories | Not done |
| Licensed monument photographs or commissioned final art | Not present; current drawings are engineering stand-ins |
| Reviewed heritage narration | Not present |
| Hampi, Ajanta, Ellora playable lessons | Intentionally omitted |
| Device / TalkBack check | Widget tests only |
| Owner confirmation that original drawings may ship | Not done |

---

## 10. Phase B part 5: journeys, item progress and catalogue counts (3 October 2026)

Age- and readiness-based mixing is local and explainable. **No reviewed learning item is approved for release.** Downloadable packs and any server were not added.

### 10.1 Status rules

Stored on `learning_item_progress` (schema 9), primary key `(profile_id, item_id, mode)`:

- Listening, recognition, tracing, word building, location and unaided recall are separate rows.
- One correct answer → **Introduced**. It is never treated as mastery.
- Two or more completions with fewer than two unaided answers → **Practising**.
- Two unaided completions in that mode → **Ready to Review**.
- The words mastery, IQ, diagnosis and comparison with other children are not used in status labels or parent notes.

A later pack `contentVersion` updates the stored version number and keeps earlier counts. Rows are never deleted when content changes. Replaying an activity updates item counts and does not add a second level badge.

### 10.2 Session mix

`LearningSessionPlanner` builds Today's practice on the Hindi and Discover India module pages:

- Up to 2 new introduce activities, 2 reviews of already introduced items, 1 easier success.
- Gentle readiness or recent hinted/unaided-poor practice drops new material to 1 and prefers review.
- Recall and review activities are withheld until that item has been introduced.
- The same inputs produce the same plan.

`DailyJourneyPlanner.plan` keeps the existing five-game Home mix when no regional extras are passed (existing same-day test). When India is available, Home may replace the last current slot and the review slot with a regional pick. Hidden region items are never planned.

### 10.3 Parent summary and entitlement

- Learning summary adds factual lines such as "Practised 1 Hindi letter" and "Recalled 1 previously introduced state name".
- The disclaimer now also says the notes are not an IQ score and do not compare this child with other children.
- Parent learning preferences repeat that Hindi and Discover India samples do not use the 5 free activities of the existing games, and that Premium is the same purchase. No new Premium flag was added.

### 10.4 Catalogue counts (do not add these numbers together as "games")

Counted by `LearningIndex.census`. Unique items are letters, words, places and sites. Activity templates are stroke paths, the map atlas and heritage drawings. Generated variants are the existing engine slots. Changing a title or duplicating a question does not create a new game.

| Kind | Count | What it is |
|---|---:|---|
| Unique reviewed learning items | 0 | Nothing has editorial approval or cleared rights |
| Unique draft learning items | 17 | 8 language items (अ, आ, अनार, आम, A name, A sound, Q, CAT) + 5 stored places + 4 heritage sites |
| Playable development activities | 42 | 15 language + 12 geography + 15 heritage records. Not extra games |
| Activity templates | 7 | 2 stroke polylines + 1 map atlas + 4 heritage drawings |
| Generated variants (existing engines) | `activitiesInBand × 4` bands, Hindi/Discover India = 0 | Unchanged; not copies of the new lessons |

Release loaders still drop every unreviewed record. Optional downloadable packs are a later extension.

### 10.5 Schema validators

`ContentSchemaValidator` (and the language/geography/heritage validators) reject:

- duplicate or missing ids
- approved clips with no media file
- find/match/review answers that are empty or not in the option list
- draft content when `release: true`
- missing sources or rights/licence status
- review/trace/build without an introduce activity, locate without identify, match/capital without learn, recall without a story

Evidence: `test/learning/content_schema_validator_test.dart`. Development packs still pass `release: false`.

### 10.6 Tests for this slice

| Requirement | Evidence | Result |
|---|---|---|
| Single guess is Introduced | `test/learning/item_progress_test.dart` | Pass |
| Modes stay separate; version change keeps counts | same | Pass |
| Recall only after introduce; same plan; fewer new when gentle | `test/learning/session_planner_test.dart` | Pass |
| Default Home mix unchanged | same + `dist/adaptive/daily_adventure_test.dart` | Pass |
| Parent copy has no IQ/mastery/comparison | `test/learning/learning_notes_test.dart` | Pass |
| Validators catch the invalid cases | `test/learning/content_schema_validator_test.dart` | Pass |
| Reviewed count stays 0 | same | Pass |
| Schema 9 keeps v8 rows; badge once; no free-count use | `dist/database/schema_migration_test.dart`, `test/learning/progress_preservation_test.dart` | Pass |

`flutter analyze lib test dist`: no issues. `flutter test test dist`: **314 passed** after the journey work in section 10. Section 11 re-ran the same command after polish.

---

## 11. Phase B part 6: whole-app polish, size and remaining blockers (3 October 2026)

Reviewed onboarding, Home, Explore, existing games, Hindi/Discover India samples, Rewards, Parent Area, settings, Premium, About/privacy, credits, empty/error states, Play again, and activity chrome. This is an engineering polish pass. **It is not editorial review, rights clearance, or a store-ready release.**

### 11.1 What changed

- One Material rounded icon family on child and parent chrome. Navigation uses outlined icons only when unselected.
- Explore and Rewards headings match Home (`headlineMedium`). App bars allow two lines, ellipsis, and Devanagari fallback/height. Game headers keep long quiz prompts out of the title bar (`activityHeaderTitle`). Knowledge catalog titles are still the real questions.
- Maths/vocabulary/pattern titles no longer use leftover “again” labels. Activity ids are unchanged.
- Next / Done / Next activity / Hear again / Skip / Play again / Home use the same words on Hindi, geography, heritage and the existing engines (`PinnedActivityActions` / `FinishedBanner`).
- Completing a Home Hindi/geography/heritage slot now receives `journeyDate`, so the daily slot is marked and **Next activity** can open. Play again hides Hindi and Discover India when `RegionalAvailability` says they are hidden. Switching region still does not delete rows.
- Effects stop narration; narration stops effects; music still ducks during speech.
- Privacy (in-app and `docs/privacy-policy.html`) and credits now state: more than one child profile; letter/place notes on device; no IQ/diagnosis/comparison; no downloadable packs; store product not connected; Hindi/map/heritage samples are development records.
- Lesson/geography/heritage action bars clamp text scaling to 1.4 so large text does not cover **Follow the dots** or overflow the phone chrome. Content text still scales.

### 11.2 Size (comparable)

No release APK/AAB was rebuilt this turn. `artifacts/` currently has listing graphics only (no APK). Signing files `android/key.properties` and `android/upload-keystore.jks` are present locally and gitignored.

| Item | Before (documented 3 Oct, §1.7) | After this pass | Notes |
|---|---:|---:|---|
| arm64 release APK | 23,716,815 | not rebuilt | Would still be dominated by `libflutter.so` / `libapp.so` |
| Universal release APK / AAB | 63,091,510 / 61,724,073 | not rebuilt | 0.1.2 artifacts are no longer in `artifacts/` |
| Debug APK | 165,915,775 (0.1.1) | not rebuilt this turn | Debug size is not a store figure |
| Bundled Flutter assets (source) | ~1.2 MB inside the earlier arm64 APK | **1,658,367 bytes** on disk | art 500,778; fonts 545,839; audio 304,904; brand 276,278; content 30,568 |
| Design references | not in `pubspec.yaml` | still excluded | `design/reference` 2,711,690 bytes (home + explore concepts). Not packaged |

Largest bundled files now: `fox_wave.png` 311,241; `sproutlab_fox.png` 276,278; `music.wav` 256,044; Noto Devanagari 189,564 + 190,152. Category JPEGs stay 640×360. No duplicate font family was added. No unused runtime dependency was removed (`url_launcher` remains for a future store product). Development lesson/map/heritage records stay assert-gated and are not extra games.

This pass did **not** recompress the fox PNGs or `music.wav`. Doing that without a listening/art check would risk the required mascot and audio.

### 11.3 Verification that ran

| Check | Result |
|---|---|
| `flutter analyze lib test dist` | No issues |
| `flutter test test dist` | **319 passed** |
| Phone 411×731, tablet 800×1280, narrow 320×640 | `test/screen_smoke_test.dart` |
| 2× text | same + foundation large-text test + Hindi trace at 2× |
| Empty progress / empty Play again | smoke + Play again hide test |
| Two child profiles in settings | smoke overrides (`Mia` and `Ravindranath`) |
| Contrast / tap targets (sample screens) | `meetsGuideline` in smoke |
| Offline | code path is local-first; **no device airplane-mode run** |
| Physical Android phone/tablet, TalkBack | **Unverified** |
| Signed release APK/AAB, Play track install | **Not done this turn** |
| Debug APK for testers | **Failed** (Gradle cache/transform paths; see §11.5) |

New tests: `test/play/polish_consistency_test.dart`, `test/play/regional_journey_completion_test.dart`, plus the existing audio overlap test in `dist/audio/asset_audio_controller_test.dart`.

### 11.4 iOS

Shared ports (`BillingGateway`, `AudioPlayback`, Drift, Riverpod) do not import Cupertino or UIKit. `in_app_purchase`, `audioplayers` and `path_provider` publish iOS implementations.

**Unverified, and not run:** there is still no `ios/` folder. This machine is Windows. No `flutter create --platforms=ios`, no Xcode build, no simulator, no VoiceOver, no App Store Connect product, no Apple signing. Do not treat Android widget tests as iOS proof.

### 11.5 Release blockers (do not hide)

| Item | Status |
|---|---|
| Editorial/rights approval of Hindi lessons, map slice, heritage facts/drawings, and any narration | **Blocked.** Reviewed items remain **0**. Release loaders still drop drafts |
| Owner confirmation of generated category/fox art | **Not done.** Provenance is in `docs/asset_licenses.md` |
| Licensed monument photographs or commissioned final art | **Not present** |
| Reviewed narration recordings | **Not present.** Hear again stays visible; missing clips stay silent |
| Live billing | **Blocked.** `BillingProductConfig.annualSubscriptionId` is empty |
| Signed Play upload (APK/AAB) this turn | **Not done.** Local keystore exists; no release build was run |
| Debug APK for testers this turn | **Failed.** `flutter build apk --debug` exited 1: Gradle could not read cached AndroidX Browser / `android_jar` transforms (`FileNotFoundException` under `%TEMP%\cursor-sandbox-cache\...`). No APK was written. Do not use an old debug APK as proof of this polish |
| Device install, offline run, TalkBack, Play-delivered build | **Unverified** |
| iOS project and checks | **Unverified** (no `ios/`) |
| Hindi interface language | Still “Not available yet”; teaching language can include Hindi |
| Store privacy/audience declarations in Play Console | **Not assessed here** |

Catalogue counts from §10.4 are unchanged: unique reviewed items **0**; draft items 17; playable development activities 42; templates 7; generated Hindi/Discover India variants 0.

The app is **not** ready for a production store listing.

---

## 12. Signed release artifacts (3 October 2026)

Debug APK was not requested and was not built. Signed release APK and AAB were produced with the existing upload keystore.

| File | Bytes | SHA-256 |
|---|---:|---|
| `release-output/sproutlab-0.1.2+3-release.apk` | 63,893,028 | `3F4D1A4F3F19AA05DF502F3E628C67618B5AAF1AE68D1AE4A48AF11EF519A0CF` |
| `release-output/sproutlab-0.1.2+3-release.aab` | 62,349,936 | `7811A117B7117581C1F15569952B3EE2735905AD176468188E46D3C2E82A3930` |

`apksigner` (v2): `CN=SproutLab Upload`, certificate SHA-256 `64:8D:88:…:5E:17`. Package `com.sproutlab.kids`, version `0.1.2` (3). Flutter exited 1 after `bundleRelease` because `apkanalyzer` is missing; the AAB file was written. Full checks and remaining blockers: `release-output/RELEASE_REPORT.md`.

No device was attached. Play-delivered install and billing were not run. Reviewed learning items remain 0.
