# Repair and 1,000-item expansion status

Primary brief: `docs/SproutLab_Repair_1000_Items_and_Release_Cursor.md` (3 October 2026).
Owner follow-up: signed **release APK only**. No AAB.

Date: 3 October 2026. App version `0.1.3+5`. Package `com.sproutlab.kids` unchanged.

Status words:

- **Fixed**: code change plus a test or measured check.
- **Partial**: code improved; a named blocker remains.
- **Blocked**: cannot finish without owner/reviewer assets or approval.
- **Unverified**: no device/emulator was available.

## Defect ledger

| ID | Problem | Reproduction | Root cause | Change | Verification | Remaining |
|---|---|---|---|---|---|---|
| R01 | India silhouette/boundaries deformed | Geometry JSON has Andaman points with `y > 1`; insets scaled x/y independently | Independent 0–1 clip + stretched insets; islands omitted from faint outlines | Content-bounds letterbox; contain insets; draw all region outlines | `test/geography/map_geometry_test.dart` | Not Survey of India. Owner/geography review still required. Natural Earth J&K/Ladakh lines are not official Indian boundaries |
| R02 | State map / place choices too few | Pack had 5 stored places and 12 activities | Slice-only catalogue | 36 official-name place records + learn/locate/capital drafts; explore list | Pack load + schema tests | All PLACEHOLDER. Not educator-approved |
| R03 | Hear buttons silent | Lesson/geo/heritage call play with no asset path | No narration files exist | Missing-media copy shown; clip path passed when present | Widget/audio unit tests | **Blocked** on reviewed recordings. Device playback unverified |
| R04 | Hindi pronunciation silent | Sample clips have `assetPath: null` | No Hindi audio bundled | Honest missing-media state; no invented speech | Lesson audio note + controller tests | **Blocked**. TTS is not used for phonics |
| R05 | Music silent | `music.wav` exists; parent switch defaults **off** | Off-by-default plus failed start still marked running | `startMusic` returns success; resume can restart; parent copy already says it stays off | `dist/audio/asset_audio_controller_test.dart` | Device/headphone/call focus **unverified**. First-use remains off until a grown-up enables it |
| R06 | Taj Mahal distorted | `_taj` was a circle on a box | Crude stand-in drawing | Recognisable original CustomPaint (dome, pishtaq, four minarets) | Code review + existing heritage widget tests | Still a drawing, not a licensed photograph. Art review open |
| R07 | English/Maths/Logic weak | 25/25/13 slots per band; titles recycled | Small generator catalogue | Maths 55, English 38, pattern 35 slots per band; existing validators | Generator + library tests | Pedagogy not educator-reviewed |
| R08 | Mazes scarce | 12 slots per band | Small catalog | 38 slots per band; shortest-path and dead-end metrics | `test/play/find_objects_test.dart` maze case | Device touch timing unverified |
| R09 | Difference scenes weak | 6 scenes × 4 bands = 24 | Few authored scenes | 20 original scenes × 4 bands = 80 | Scene id uniqueness + existing hit tests | Artwork remains engineering drawings |
| R10 | Find Objects weak | Engine did not exist | Observation was matching + difference only | New `find_objects` engine, 20 authored scenes | `test/play/find_objects_test.dart` | Artwork is original CustomPaint, not signed-off art |
| R11 | India knowledge shallow | Four learn facts | Slice-only | 36 place facts from Know India location statements | Schema/pack tests | Child copy is engineering paraphrase, PLACEHOLDER |
| R12 | Catalogue too small | 500 learning library items | Previous 100-per-section target | 1,000 generator/structure-validated library items | LaunchManifest test | Hindi 0/150 and India 0/70 **approved**. See inventory |

## Catalogue inventory (honest)

Requested allocation vs what can be shipped without inventing review:

| Category | Requested approved | Actual playable validated | Notes |
|---|---:|---:|---|
| English language | 150 | 152 | `vocabulary:v1` generator variants. 4 existing English letter drafts stay drafts |
| Hindi language | 150 | **0 approved** | Existing development lessons only. No reviewed audio |
| Maths | 180 | 220 | Extra 40 variants cover the Hindi/India total shortfall. Different seeds, same rules |
| Logic/patterns | 140 | 140 | `pattern:v1` |
| Mazes | 150 | 152 | Validated reachable seeds |
| Spot the Difference | 80 | 80 | 20 original scenes × 4 bands |
| Find Objects | 80 | 80 | New engine, 20 original scenes × 4 bands |
| India geography/heritage | 70 | **0 approved** | 36 draft places + heritage samples. Hidden in store-like release |
| Matching (other) | — | 76 | Existing unique-template pool; not inflated |
| Knowledge (other) | — | 100 | Existing authored, structure-checked, not editorially reviewed |
| **Playable validated total** | **1,000** | **1,000** | Tic-Tac-Toe 20 extra, not in the 1,000 |
| **Release-approved reviewed items** | 1,000 | **0** | No educator/rights approval was supplied |

Rationale for moving 40 items into Maths: Hindi and India cannot be fabricated as approved items. Matching templates are already reused and were not inflated. Maths variants are deterministic and validator-checked.

Eligibility: age bands A–D still filter engines. Hindi and Discover India still require parent India region (unless `UNLOCK_ALL_GAMES`). Free entitlement remains 5 unique completions per engine except `lesson:` / `geo:` / `heritage:` ids.

## Asset / rights

- Maps: Natural Earth 50m public domain. Not Survey of India. Pending geography review.
- Heritage pictures: original drawings. No licensed monument photographs.
- Narration: none.
- Music/effects: existing original WAV tones.
- Category art: generated, owner confirmation still open (`docs/asset_licenses.md`).

## Storage / performance (section 7–8)

Kept the existing model: Drift records + bundled file assets. No base64 images. No new encryption (public maps/photos are not secrets; profiles already use local SQLite). No wholesale BLOB migration; current assets are small (audio ~305 KB, maps JSON tens of KB). Decode caches unchanged. No invented benchmark numbers. Device profile **not run**.

## Checks

| Check | Result |
|---|---|
| `flutter analyze lib test dist` | No issues (3 Oct 2026, after remaining test fixes) |
| `flutter test test dist` | 323 passed |
| Device install / audible Hear / music | **Unverified** (`adb devices` listed no phone or emulator) |
| Signed release APK | `release-output/sproutlab-0.1.3+5-repair-preview-release.apk`, 64,597,540 bytes, SHA-256 `D5E799A2F7155CA210FEEE0FE2B3B32ECD30231AE5FC499AFA8F78DFA9232606`. Package `com.sproutlab.kids` 0.1.3 / versionCode 5. Upload-key v2 signature. See `release-output/REPAIR_PREVIEW_0.1.3.md` |
| AAB | **Skipped** by owner instruction |
| Commit/push | **Not done** unless asked |

## Unlock flag

Source default `UNLOCK_ALL_GAMES=false`. A repair-preview APK may be built with the flag so Hindi/Discover India drafts are visible. That is not a store listing.
