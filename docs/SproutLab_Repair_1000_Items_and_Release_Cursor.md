# SproutLab: Repair first, 1,000 validated learning items, verified release

Owner implementation instructions for Cursor — 3 October 2026

## Priority and authority

This is a repair-first supplement to the existing SproutLab briefs. Preserve their design, local-first learning, region gating, parent controls, stable progress and future iOS goals. This document supersedes earlier lower content-count targets: the new total target is at least 1,000 validated, playable learning items across the app, not 1,000 new engines or media files. Fix visible defects before expanding the catalogue. Do not rebuild unrelated architecture or add a backend/cloud AI to resolve these issues.

The owner reports malformed India maps and Taj Mahal artwork; Hear buttons and Hindi pronunciation do not work; background music does not work; place choices and India knowledge are sparse; English, Maths, Logic, Maze, Spot the Difference and Find Objects have insufficient and poorly formatted content. These are reported defects, not independently reproduced findings. Reproduce each on the actual code/build, then record its cause and fix. No app repository or build is attached to this brief itself.

## Working method

Work sequentially through the six prompts at the end. Maintain docs/repair-expansion-status.md and a defect ledger with issue ID, reproduction, root cause, changed files, actual verification and remaining limitations. Keep the app runnable after each phase. A checklist tick without code/content/test evidence is not completion. Independent research may run separately; shared audio, database, navigation and game logic changes stay sequential.

Keep existing package ID, signing identity, parent profiles, purchase entitlements, game history and badge IDs. Use safe migration/backfill where needed. Repeated startup/import must not duplicate content or reset data. Do not claim facts, audio or images are educator-reviewed without a real review. Finish unblocked work and explicitly identify missing approval/assets; never fabricate them to satisfy the item target.

## 1. Repair ledger and baseline

Required defects:

| ID | Problem | Passing evidence |
|---|---|---|
| R01 | India silhouette/boundaries deformed | Reviewed geometry, correct aspect ratio, visible islands/insets, correctly transformed taps |
| R02 | State map or place choices too few | Navigable reviewed catalogue, readiness-appropriate answers and accessible region list |
| R03 | Hear buttons silent | Actual audible playback on device, offline replay and clear missing-media behavior |
| R04 | Hindi word pronunciation silent | Every released word has valid audible Hindi narration; language and shaping correct |
| R05 | Music silent | Parent-controlled audible background music with lifecycle and narration ducking |
| R06 | Taj Mahal or monuments distorted | Recognizable licensed/reviewed imagery with preserved proportions |
| R07 | English/Maths/Logic layout and content weak | Complete readable activities with validated answers and varied learning objectives |
| R08 | Mazes scarce/poorly formatted | Solvable age-appropriate layouts, usable touch controls, no unreachable exits |
| R09 | Difference scenes weak | Aligned pairs, authored differences, consistent hit detection and no crop artifacts |
| R10 | Find Objects weak | Clear targets, deliberate placements, readable scenes and responsive hit areas |
| R11 | India knowledge shallow | Learn-first facts, region/heritage breadth and recall of introduced material |
| R12 | Catalogue too small | Reproducible validated item inventory reaching 1,000 without fake duplicates |

Record baseline screenshots, release/profile performance, build identity, artifact size and exact data count. Audit image BoxFit/stretching, SVG viewBox/path transforms, scene overlays, missing asset manifests, audio asset paths, player initialization, mute defaults and lifecycle handlers. Do not assume every malformed image is a layout bug: the source may itself be wrong.

## 2. Visual and map repairs

Use the approved Home/Explore references and existing purple/navy/off-white/pastel system. One consistent licensed icon family; functional speaker, replay, back, hint, next and submit icons, with readable labels where appropriate. No emoji substitute for important controls. High contrast, generous touch targets, stable card sizing and clear child instructions. No clipped Hindi matras, overlapping controls or giant headings that push questions off-screen.

Use contain/fit with the original aspect ratio for maps and identification images. Never stretch an image to fill a card. Intentional scene cropping must preserve all targets, landmarks and differences. Map display and hit-testing must use the same transform. Provide magnified insets/list alternatives for small regions. Test phones, tablets, landscape where supported and enlarged system text.

Map references: Survey of India political/state/outline sources. Confirm actual permission for redistribution/derivatives and applicable boundary accuracy before shipping. Free download is not a blanket licence. No generated decorative silhouettes passed off as geography. Keep the geographical source, edition, review date, geometry attribution and licence in the asset manifest.

Taj Mahal: replace the malformed source with a licensed photograph or accurate reviewed illustration showing its recognizable architecture. Similar requirements apply to other monuments. Do not replace it with a generic palace or generated distorted dome. Child-facing imagery must not misteach identity. Use original playful illustrations for everyday objects where appropriate; historical/geographical identity requires factual review.

A missing or invalid asset must produce a deliberate fallback and a development report. Do not show a placeholder while counting the lesson as fully verified.

## 3. Sound repair: prove playback, not just button wiring

Separate narration, sound effects and music channels under one lifecycle-aware audio service. Inspect the actual player/dependencies and use existing capabilities where adequate. Bundle short licensed, reviewed recordings for essential Hindi letters/words and English phonics. Device TTS can be an optional fallback for ordinary explanations; it cannot silently replace verified phonics, and offline voices cannot be assumed available.

For every Hear button: valid content-to-audio mapping, correctly packaged asset, awaited player load/play, error handling, accessible label, clear playing/replay state and actual device playback. Stop the previous narration, debounce rapid taps and ignore stale async completions after a screen change. No overlapping narration; duck music and restore it afterward. Stop/pause correctly when leaving or backgrounding the app. Test headphone/Bluetooth changes and calls/audio focus where supported. An automated mock player test does not prove audible sound.

Hindi examples must pronounce the displayed letter/word accurately with a reviewed natural voice. Keep English letter names distinct from sounds. Ensure all released items requiring audio have usable media. Do not request microphone access or record child speech. Missing voices/assets should be handled visibly, with parent-facing remedies; do not show a successful playback state for silence.

Music: parent toggle, independent volume, licensed low-distraction loop, clean loop transition, no multiplication of players after navigation. Respect parent mute and existing Android audio behavior; do not bypass device silence settings to force playback. Give music and narration independent controls. Do not autoplay music during sleep/background use. Consider a gentle off-by-default preference and make first-use behavior explicit rather than unexplained silence.

Include low-volume tap/submit/success effects where helpful; avoid harsh failure sounds, constant noise or effects masking speech. Text/visual feedback must remain usable without audio.

## 4. Better game mechanics and formatting

### English

Reviewed picture-word matching, listening, letter recognition, initial sounds, spelling and short sentences according to age/readiness. Clearly state the task. Pictures must match answer labels. Distractors must be distinct, plausible and have no accidental second correct answer. Do not count cosmetic label/option shuffles as new content.

### Maths

Counting with clearly separated objects, comparing quantities, number sequence and age-appropriate arithmetic. Validate integer bounds and answers; avoid unintended negative results or inappropriate operations. Reuse object art instead of rendering numbers of complex widgets beyond practical limits. Different learning constraints matter more than arbitrary large number substitutions.

### Logic

Patterns, sorting, matching rules and simple reasoning. Make the intended rule unambiguous; exclude puzzles with equally valid alternate answers. Use clear shapes/colors but do not rely on color alone. Explain correct feedback in child-friendly terms.

### Maze

Use deterministic seeds and difficulty specifications with varied topology. A DFS/backtracking generator can be O(V+E) time and O(V) space; validate start-to-goal reachability with BFS/DFS. Record shortest path and dead-end metrics to check readiness. Grid size, route complexity and motor controls are separate difficulty dimensions. Prefer straightforward bounded grids over claiming a globally optimal algorithm.

Large visible cells, distinct entrance/goal, generous swipe or tap controls, hints and reset. No movement through walls, unreachable goals or goal icons occluding the path. Avoid expensive path calculations on every pointer event; compute immutable geometry once per level. Render clean vectors with constrained paint work. Verify each shipped seed and random-generation invariants; store compact seeds/configuration rather than full maze images.

### Spot the Difference

Use an authored base scene and intentional vector/image overlays, or carefully reviewed licensed image pairs. Both panels share scene dimensions and consistent transforms. Store explicit difference geometry in normalized coordinates. Correct for resize/letterboxing; taps outside the scene do not score. One difference scores once. Show the required count clearly and offer hints without punishment.

Lossy compression must not introduce apparent extra differences. Use matched exports/settings, or lossless formats for sensitive pairs. Check every pair visually at phone scale, not just source resolution. No accidental crop, shifted camera or global color change counted as a local difference. Smaller children start with fewer larger differences.

### Find Objects

Build controlled scenes from recognizable shared assets with normalized object placements and hit regions. Show pictured target cards plus optional narration. Avoid tiny targets, unintentional duplicates, ambiguous partial occlusion and coordinate mismatches. Mark found objects distinctly; one target must not award repeatedly. Bound retry attempts when assembling procedural scenes and fail safely into a verified authored scene. Do not claim overlap-free solvability from random placement alone.

### Other existing games

Preserve Matching, Hindi tracing/word building, Tic-Tac-Toe and existing rewards. Recheck scoring, turn legality, next/replay, session exit, assisted completion and idempotent badges. Trace templates and Unicode word assembly follow the earlier Hindi brief. No sudden increase in difficulty solely because country/age changes.

## 5. India learning: breadth with accuracy

Provide a learn-first browser with states/UTs, capitals, monuments, nature and cultural heritage. Show a useful scrollable catalogue and filters; quiz answer choices should remain age-appropriate rather than displaying dozens of small buttons. A larger catalogue and a sensible number of options per question are different requirements.

Verify current administrative regions and capital arrangements at publication. Model seasonal/multiple seats explicitly and exclude ambiguous questions. Distinguish state/UT, current/history and fact/legend. Use official government and heritage sources, dated review and original short summaries. Broaden regional representation without defining communities by stereotypes. Avoid political persuasion, superiority claims, violent history for young children or invented national facts.

For each place: accurate name, reviewed image/map, audio as supported, short age-appropriate explanation and eligible questions. Ask recall questions only after introduction; give a learn-first route when new. Adults can inspect sources/credits behind the parent gate. India-specific content remains available only under the parent-selected India region; country changes hide it without deleting progress. English/global activities remain accessible internationally.

## 6. At least 1,000 learning items: measurable target

Proposed minimum distribution across the full catalogue:

| Category | Validated playable items |
|---|---:|
| English language | 150 |
| Hindi language, India region | 150 |
| Maths | 180 |
| Logic/patterns | 140 |
| Mazes | 150 |
| Spot the Difference | 80 |
| Find Objects | 80 |
| India geography/heritage knowledge | 70 |
| **Total** | **1,000** |

Existing valid items count toward this total. These are minimum allocation targets, adjustable only with an explicit reported rationale while preserving total and meaningful category coverage. Other games add to this total. This is catalogue capacity, not a promise of 1,000 items available to every age/country or free entitlement. Retain existing free/permanent-replay rules. Explain eligible counts by age, region, language and entitlement honestly.

An item must have a stable ID, meaningful objective, valid answer/mechanics, difficulty/readiness, required working media and content status. Use curated language/fact records and deterministic generated maths/maze/logic/scene records. Save enough configuration to reproduce the exact item. Different validated seeds/configurations may count as variants; report them separately from editorially distinct prompts and engine templates. Do not inflate counts with reordered answer options, repeated identical layouts, unused asset files, renamed copies or unreachable content.

Record difficulty metrics and deduplicate exact normalized content/layout hashes. Check near-duplicate families as part of editorial quality. Generated questions may use reviewed templates and bounded mathematical rules, never unreviewed generated history/geography. Automated validators prove schema/algorithm properties; they do not certify pronunciation, pedagogy, image identity or rights.

Create a reproducible inventory with: total registered, published, excluded/draft, distinct editorial items, generated variants, templates, category breakdown and eligibility breakdown. The release-approved playable total must reach 1,000 to satisfy the full expansion objective. If genuine review/assets prevent this, finish other work and state the shortfall; do not count drafts as approved or claim completion. A repair preview APK may still be built with a transparent inventory and limitations.

## 7. Local media, database, compression and encryption

Yes, media can be stored locally. Default recommendation: database for content records, paths/asset IDs, progress and indexes; bundled/local media files for larger images/audio. Deduplicate shared objects using asset IDs/content hashes. Do not base64-encode images into JSON/rows: it adds overhead. SQLite BLOBs can suit some small assets; benchmark representative reads/imports and app/database size before choosing them wholesale. Avoid both bundled and copied DB/file duplicates unless necessary.

Compression saves space; encryption does not. Already-compressed image/audio formats may gain little from extra archive compression. Resize to real rendered needs, remove unused files, use an appropriate supported WebP/JPEG/PNG/vector strategy, and listen-test compressed audio. Ensure Flutter renderer/codec support on Android and future iOS. No blind conversion that breaks transparency, crisp letters, maps or differences. Decoded memory depends on pixel dimensions even when compressed disk size is small.

Do not encrypt public maps/photos merely to claim storage savings. For local sensitive learning/profile records, assess the existing threat model and use an established encrypted storage/database library only if appropriate, with OS-backed key protection and tested backup/migration behavior. For owner-required media encryption, first report measured size/latency implications; use an established authenticated scheme, compress before encryption, and decrypt only the active asset into a bounded cache. Never load/decrypt the entire catalogue at launch. No homegrown cipher or hardcoded reusable secret claimed as strong protection. Client-side media encryption cannot guarantee that users cannot extract playable assets. Preserve licence notices and attribution.

No server requirement for version one; pack assets can ship through app updates. Optional future packs use parent-approved download sizes, checksum/schema validation, atomic import, safe rollback and progress retained after pack removal. Do not download executable code.

## 8. Practical performance requirements

“Best complexity” is not a measurable universal claim. Specify algorithms and measure them on representative devices.

- Indexed content selection by category/region/age/status; bounded result batches. Use query plans; avoid ORDER BY RANDOM over the whole catalogue every round.
- Stable ID lookups through indexed tables/hash maps; cache immutable descriptors where justified.
- Maintain eligible/shuffled ID pools for bounded sessions; do not rebuild all 1,000 records every frame or interaction.
- Lazy lists/grids and limited next-item prefetch; byte-bounded image/audio caches with eviction.
- Decode images at display-appropriate dimensions. Keep heavy import/generation/decompression off the UI thread where supported.
- Transactions/batched imports and indexes suited to actual queries, not every column. Preserve incremental updates.
- Map/scene hit testing: scan a small visible target set if adequate; spatial index only when measurements justify it. Render and hit geometry share transforms.
- No repeated full scene regeneration during build(), no leaking audio players and no global unbounded caches.

Profile release/profile builds. Record device, data volume, cold start, activity transition latency, frame timing, peak/steady memory, import time, artifact/download-size estimate and asset-category sizes. Establish a baseline and check regressions with the same device/build configuration. Do not invent benchmark numbers or enforce arbitrary promised MB targets. App size, installed size, AAB upload size and actual device download are separate figures.

## 9. Required verification and child usability

Tests: audio routing/errors/lifecycle, content schema/deduplication, migration idempotency, region gating, maze reachability, answer validity, hit coordinates, score/badge deduplication and review eligibility. Use meaningful property tests for generators with reproducible failing seeds.

Manual/visual: every factual image/map and difference pair; representative generated scenes across supported dimensions; all released Hindi recordings via content review plus actual device audio playback. Offline fresh launch, repeated navigation, parent mute, narration/music interaction, large text, small phones/tablets, interruption/resume and multi-profile history. No mocks presented as end-to-end sound evidence. No screenshot-only tests presented as geographic review.

Show question/scene/choices clearly without external child links, tiny controls or purchase prompts. Offer gentle hints and exit; avoid timers for foundational activities, distressing failure sounds and streak pressure. Do not record child voice or upload learning analytics. No assessment/therapeutic claims. Age suggestions are product defaults needing educator review, not guarantees of development. Under-3 scope remains separately reviewed.

## 10. Delivery and reference links

Deliver defect ledger, catalogue inventory, asset/source/licence manifest, before/after screenshots, test/performance report and actual signed release APK when signing is available. Also generate AAB with the same existing signing configuration if available, but APK is the owner's immediate test deliverable. Increment version appropriately; do not change production identity or create substitute signing keys. Inspect signature/manifest/version and compute SHA-256. Install/launch the APK and perform critical offline/audio journeys if a device/emulator is available. If no device, mark runtime checks unverified. Use bundle validation for AAB; do not claim Play installation or billing tested unless it ran through Play.

References (source availability does not grant reuse rights):
- https://surveyofindia.gov.in/pages/political-map-of-india
- https://surveyofindia.gov.in/pages/state-maps
- https://www.india.gov.in/explore-india/facts-of-india/states-ut-districts
- https://whc.unesco.org/en/statesparties/in/
- https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia
- https://www.sqlite.org/intern-v-extern-blob.html
- https://docs.flutter.dev/perf/best-practices
- https://docs.flutter.dev/perf/app-size

## 11. Sequential Cursor prompts

Place this file at docs/SproutLab_Repair_1000_Items_and_Release_Cursor.md and attach the existing Home/Explore design reference images. Use each prompt only after the previous phase's report. This file is the primary repair brief; earlier briefs remain supplementary where consistent.

### Prompt 1 — Reproduce and repair maps, images and controls

Read @docs/SproutLab_Repair_1000_Items_and_Release_Cursor.md completely. Inspect the actual repository and existing design references. Reproduce R01–R12 and create docs/repair-expansion-status.md with real causes and evidence. First fix malformed India/state maps, Taj Mahal/monument imagery, aspect ratios, hit transforms, clipped text and misleading/dead Hear/Next/Submit controls. Replace incorrect sources with licensed accurate assets, not generic placeholders. Preserve current data and identity. Complete all unblocked visual repairs before content expansion. Verify phone/tablet layouts and record before/after screenshots. Do not claim geographic/rights review without evidence. Report unresolved asset blockers explicitly and continue other repairs.

### Prompt 2 — Make all sound work

Continue from the status document. Implement section 3 of the repair brief fully: narration, Hindi pronunciation, English sounds, Hear/replay, parent audio settings, music loops, volume/ducking, lifecycle and error handling. Audit every released content-to-audio mapping and packaged file. Fix real missing/invalid media and playback failures. Use reviewed licensed core audio; distinguish letter names and sounds. Test actual audible playback offline, rapid taps, navigation, mute, background/resume and music/narration interaction. Keep unreviewed recordings development-only and report missing review. Complete unblocked code, meaningful tests and factual evidence; mocks alone do not prove sound works.

### Prompt 3 — Repair every game engine and learning screen

Implement sections 4 and 5 of the repair brief. Improve English, Maths, Logic, Maze, Difference, Find Objects and existing game layouts using the established design system. Ensure solvable bounded mazes, unambiguous answers, authored difference regions, controlled find-object scenes and correct resize/hit transforms. Expand the usable India place browser and learn-first flow without overwhelming quiz option counts. Preserve rewards, profiles and regional availability. Add generator/schema/progress tests and manually review representative scenes. Finish engine and UI quality before mass importing content. Update the status document with verified repairs and remaining issues.

### Prompt 4 — Publish a genuine 1,000-item catalogue

Implement section 6 using the repaired engines. Reach at least 1,000 validated playable items across the specified category allocation, counting existing valid items. Use reviewed language/India facts and bounded deterministic generators for appropriate puzzles. Do not manufacture approvals, facts, counts or licences. Include meaningful variation, stable IDs, seeds, difficulty, correct answers, required media and provenance. Separate editorially distinct items, generated variants and templates; exclude cosmetic duplicates/drafts/unreachable items from the approved total. Produce reproducible inventory and validation reports with eligibility breakdowns. Preserve progress through migration. Finish all unblocked expansion; if review/assets block the target, report the exact shortfall and remaining work rather than claiming completion.

### Prompt 5 — Optimise local storage and verify the whole app

Implement sections 7–9. Benchmark media files plus database references versus relevant BLOB cases; choose based on actual data. Deduplicate assets, optimise dimensions/codecs/audio and bounded caches. Compression saves space; do not present encryption as compression. Apply established encrypted storage only where appropriate and document any owner-required media protection with realistic limitations. Profile the app with the full catalogue; report actual comparable sizes, memory, timing and query evidence. Audit every app screen, existing/new game, parent controls, offline journeys, audio and progress. Resolve regressions. Produce final defect ledger, content/rights manifest and honest verified-versus-pending report.

### Prompt 6 — Generate the verified release APK

Complete final checks from the repair brief. Resolve outstanding technical issues and clearly state content/rights/review gaps. Generate a signed release APK using the project's existing authorized signing identity and an appropriate version code/name. Generate a release AAB as well if signing/tooling supports it. Do not create replacement production keys or silently debug-sign releases. If signing is unavailable, generate a debug testing APK and report the specific release-signing blocker; never claim a release APK exists. Verify manifest/package/version/signature, sizes and SHA-256. Install and launch the APK, test offline maps/places, Hindi and English Hear buttons, music, mazes, differences, find objects, rewards and parent flows on available devices. Mark unperformed checks unverified. Put actual artifacts in release-output/ with a release report and exact paths. State whether the approved catalogue reached 1,000; a repair preview is not full expansion completion. Continue until all unblocked build and verification work is complete; do not stop at build instructions.

### Resume instruction if Cursor stops early

Continue the current phase from docs/repair-expansion-status.md. Verify the actual implementation before ticking anything complete. Finish all unblocked work and checks; report exact blockers without inventing content, assets or success. Do not move to the next phase yet.
