# Repair defect ledger

Date: 3 October 2026. Source of issues: owner report in `docs/SproutLab_Repair_1000_Items_and_Release_Cursor.md`. Status words match `docs/repair-expansion-status.md`.

| ID | Problem | Reproduction | Root cause | Changed files | Verification | Remaining |
|---|---|---|---|---|---|---|
| R01 | India silhouette/boundaries deformed | Geometry JSON has Andaman points with `y > 1`; insets scaled x/y independently | Independent 0–1 clip + stretched insets; islands omitted from faint outlines | `lib/domain/geography/map_geometry.dart`, `lib/domain/geography/geography_models.dart`, `lib/features/geography/india_map.dart` | `test/geography/map_geometry_test.dart` | Not Survey of India. Owner/geography review still required. Natural Earth J&K/Ladakh lines are not official Indian boundaries |
| R02 | State map / place choices too few | Pack had 5 stored places and 12 activities | Slice-only catalogue | `lib/domain/geography/geography_places.dart`, `lib/domain/geography/geography_pack.dart`, `lib/features/explore/explore_screen.dart` | Pack load + schema tests; extra places stay in the explore browser so the module list still shows Heritage | All PLACEHOLDER. Not educator-approved |
| R03 | Hear buttons silent | Lesson/geo/heritage call play with no asset path | No narration files exist | Geography/heritage Hear wiring + missing-media copy | Widget/audio unit tests | **Blocked** on reviewed recordings. Device playback unverified |
| R04 | Hindi pronunciation silent | Sample clips have `assetPath: null` | No Hindi audio bundled | Honest missing-media state; no invented speech | Lesson audio note + controller tests | **Blocked**. TTS is not used for phonics |
| R05 | Music silent | `music.wav` exists; parent switch defaults **off** | Off-by-default plus failed start still marked running | `lib/data/audio/plugin_audio_playback.dart`, `lib/features/audio/asset_audio_controller.dart` | `dist/audio/asset_audio_controller_test.dart` | Device/headphone/call focus **unverified**. First-use remains off until a grown-up enables it |
| R06 | Taj Mahal / monuments distorted | `_taj` was a circle on a box | Crude stand-in drawing | `lib/features/heritage/heritage_picture.dart` | Heritage widget tests | Still a drawing, not a licensed photograph. Art review open |
| R07 | English/Maths/Logic layout and content weak | 25/25/13 slots per band; titles recycled | Small generator catalogue | `lib/domain/games/play/activity_catalog.dart` plus existing generators | Generator + library tests | Pedagogy not educator-reviewed |
| R08 | Mazes scarce / poorly formatted | 12 slots per band | Small catalog | Maze slot count + `MazeMetrics` | `test/play/find_objects_test.dart`, maze stress tests | Device touch timing unverified |
| R09 | Difference scenes weak | 6 scenes × 4 bands = 24 | Few authored scenes; overlapping hit boxes | `lib/domain/games/find_difference/difference_catalog.dart` | Scene uniqueness + hit tests | Artwork remains engineering drawings |
| R10 | Find Objects weak | Engine did not exist | Observation was matching + difference only | New `find_objects` engine and 20 authored scenes | `test/play/find_objects_test.dart` | Artwork is original CustomPaint, not signed-off art |
| R11 | India knowledge shallow | Four learn facts | Slice-only | 36 place facts from Know India location statements | Schema/pack tests | Child copy is engineering paraphrase, PLACEHOLDER |
| R12 | Catalogue too small | 500 learning library items | Previous 100-per-section target | Catalog sizes totalling 1,000 generator/structure-validated items | LaunchManifest / scoring tests | Hindi 0/150 and India 0/70 **approved** |

Before/after screenshots were not captured in this pass (no connected device or golden capture run).
