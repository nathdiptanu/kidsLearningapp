# SproutLab: complete repair handoff for Codex and Cursor

Prepared 3 October 2026. This document is an implementation specification requested by the app owner. It does not claim that the features below are finished. Read the current repository before editing; preserve existing local work, saved progress, signing identity and package name.

## 1. What the owner expects

Deliver a usable, colorful, encouraging learning app. Hindi must teach with audible pronunciation; Discover India must contain accurate geography, recognizable monument images, all states/union territories and neighbouring-country learning. Mazes must be easy to find. Completing an adventure must lead to a clear choice to continue or stop. Children aged 2–3 need an appropriate parent-led experience. Tic-Tac-Toe must support going second and local two-player play.

Do not equate a passing unit test, an asset filename or a catalogue entry with a working feature on a phone. Do not remove “Coming soon” or set every content record to approved merely to make a screenshot look complete. Finish the content and routing, validate it, then make the feature available in the normal release build.

## 2. Screenshot observations and current-source diagnosis

The supplied 18:47 screenshots show earlier layouts and development screens. The 20:07 screenshot shows improved full-word tiles but Hindi and Discover India still say “Coming soon.” The installed version and build flags cannot be identified from these screenshots alone.

| Owner-visible problem | Evidence / current source | Required outcome |
|---|---|---|
| Hindi and Discover India say Coming soon | `ExploreScreen` uses that text whenever `includeDevelopmentSamples()` is false. That helper uses assertions/debug or `UNLOCK_ALL_GAMES` to include drafts. Normal release excludes unreviewed packs. | Complete a reviewed release pack and derive availability from its actual playable contents. Distinguish region-disabled, missing content and premium access. |
| More mazes cannot be found | `LearningArea.logic` groups patterns and mazes. Catalogue now has 50 mazes per Ages 3–7 band, but there is no top-level Mazes tile. | Add explicit Explore → Mazes access and a browsable level list. Verify all 50 selected-band entries appear. |
| Five activities end without an obvious next step | Current Home code contains Next adventure, Play again and Take a break only when the stored plan is complete. | Verify the fifth successful completion updates the correct stored session and refreshes Home; show the choices immediately. |
| India map has overlapping/jagged borders | Earlier screenshots show an unsuitable polygon atlas. Current map view rejects unapproved atlases. | Replace the atlas with an authoritative, reviewed source; do not restore the distorted map. |
| Hear again is silent | Screenshots explicitly say recordings are absent. Current code disables replay for missing reviewed clips. | Provide real local pronunciation clips and correct tap routing. Missing audio must never appear to play successfully. |
| Background music enabled but inaudible | Existing controller uses `assets/audio/music.wav`. Owner-supplied loop is only under design/audio, not adopted as the runtime track. | Integrate and audibly verify the chosen track with persisted controls and lifecycle handling. |
| Knowledge/Observation words split mid-word | Old two-column screenshots show this; latest screenshot has full words. Shared card layout has already changed. | Keep the correction and test narrow phones and enlarged text with the real fonts. |
| Ages 2–3 absent | Source now has T storage key and six parent-led matching activities. Older screenshot only shows A–D. | Verify onboarding, settings, eligibility and saved progress in the actual release; improve the parent-led catalogue. |
| No second-player option | Source now has I go first, Computer goes first, and Two players on this device. | Verify these are reachable before starting a game and that O actually moves second. |
| Flowers/fruit/monuments look robotic | Schematic drawings remain in teaching content. | Use recognizable original or properly licensed art, validated for the intended identity. |

Current maze implementation: 200 catalogue slots across four older bands, including 48 added slots; five garden palettes, smiling marker, flower finish, optional clue and visited dots. All additions have distinct topology in their band. Older repeated layouts were retained to preserve saved games. “200 catalogue slots” does not mean 200 independently educator-reviewed lessons.

## 3. First establish which build is being tested

1. Add an unobtrusive version name/build number and content-pack version to the grown-up area.
2. Record the installed APK version, selected age band, learning region, enabled modules, entitlement state and whether this is a debug or release build. Do not expose signing secrets.
3. Reproduce each report on the release artifact. Capture screens and an issue list before changing behavior.
4. Latest maze preview produced in this workspace is `release-output/sproutlab-0.1.5+7-maze-preview-release.apk`. It still excludes draft regional packs. Installing it does not complete Hindi or India content.
5. Preserve `com.sproutlab.kids`, the existing signing key and saved database. Increment release version for a new build. Test upgrading an existing installation, as well as fresh installation.

## 4. Ideal Home and adventure progression

An adventure is a persistent set of five eligible activities for Ages 3–7. It is not a gate that forces a child to wait until tomorrow. For Ages 2–3 use a shorter parent-led session, recommended default three activities, with a clear break choice.

### Required state transitions

| State | Home presentation | Action |
|---|---|---|
| New session | 0 of 5; Start adventure | Open the first unfinished activity. |
| Partly finished | N of 5; Continue adventure | Resume the next unfinished activity and its checkpoint. |
| Fifth activity just finished | Calm completion message plus Next adventure / Play again / Take a break | Return to a refreshed Home or show an equivalent completion panel with these actions. |
| Next adventure pressed | A new session with 0 of 5 | Persist a new session ID and chosen activities while retaining the completed session/history. |
| Replay pressed | Completed favourites | Replay does not duplicate the original completion or mint repeated first-completion rewards. |
| App reopened or date changes | Resume stored session or show its completed choices | Do not silently delete an unfinished adventure or reset learning progress at midnight. |
| Eligible catalogue exhausted | Practice choices and a clear completion message | Do not show a dead button or invent unavailable levels. |

Prefer eligible unfinished activities in the next session, with variety and gradual difficulty. A deliberate practice repeat may occur if eligibility leaves too few new activities; label it clearly. Starting another adventure must be an explicit choice, not an automatic endless loop. Do not automatically change age band or require payment to finish a session already granted access.

Persist profile ID, session ID, activity IDs, completion positions and creation time. Completion writes must be idempotent. Keep calendar date separate from session identity. A skip may allow navigation but must not falsely mark a level completed; if all entries have been finished or explicitly skipped, resolve the session with honest completed/skipped totals and continuation choices.

Verify five completions through the real UI, immediate Home refresh, same-day next session, midnight while playing, force close/reopen, double-tap completion, band switch and replay. Locate existing work in `home_screen.dart`, `drift_journey_repository.dart`, `daily_journey_planner.dart` and completion/session providers before duplicating it.

## 5. Make mazes visible and useful

Add a dedicated Mazes tile on Explore, or a prominent labeled Mazes section visible without guessing that Logic contains them. If Logic remains a grouped tile, put Patterns and Mazes choices at the top of its screen rather than interleaving all levels into an opaque list.

Requirements:

- At least 50 selectable maze entries for each supported older band. Show a band-specific count and completed count.
- Keep existing IDs/seeds for existing levels; do not reset checkpoints when polishing visuals.
- Order levels from approachable to harder, using board size and solution metrics rather than title alone.
- Provide colorful themes and readable walls. Use a smiling explorer, recognizable destination, optional clue and warm feedback. Avoid countdowns, failure sounds that shame, or forced speed.
- Distinguish available, completed and premium-locked entries. A catalogue count must not imply all entries are free; document the applicable access rule. Do not leave access ambiguity as the reason the owner cannot find the levels.
- For the Ages 2–3 catalogue, use parent-led matching and exploratory play; any maze-like task should be a very short broad path with adult guidance, not a reduced older-child maze automatically assigned to toddlers.

Acceptance: fresh release install → Explore → Mazes → open first, middle and last available maze; valid walls and reachable goals in every generated layout; every new layout distinct; completion/relaunch/replay preserve the expected state.

## 6. Accurate India maps: sources, rendering and fallback

Do not generate political boundaries with image generation, hand-draw approximate polygons or use a generic Google image result as an authoritative source. A Google search result locates a file; it does not provide its reuse licence. Do not hotlink an arbitrary remote map into a child's offline lesson.

Authoritative reference links checked 3 October 2026:

- [Survey of India political maps](https://surveyofindia.gov.in/pages/political-map-of-india): current listing includes English 13th edition/2026 and Hindi 10th edition/2026.
- [Survey of India outline maps](https://surveyofindia.gov.in/pages/outline-maps-of-india): starting point for a simpler teaching outline.
- [India and adjacent countries](https://surveyofindia.gov.in/pages/india-and-adjacent-countries): reference for neighbouring-country lessons.
- [Geospatial guidelines on the official portal](https://onlinemaps.surveyofindia.gov.in/GeospatialGuidelines.aspx): clause xiii specifies Survey of India maps/boundary data as the standard for political maps and addresses digital display/printing.
- [Website copyright policy](https://surveyofindia.gov.in/pages/copyright-policy): separately restricts reproduction of website material.

The earlier repair report treated written reproduction permission as a blanket blocker. That conclusion was too broad: the portal's geospatial guidance also contains a specific political-map display provision. Record the exact product, edition, applicable terms and proposed use; reconcile the product terms and published guidance instead of assuming either that every online image is free or that every political map always requires a separate letter. Seek clarification for unresolved terms. This handoff does not certify legal compliance or assert that the screenshot alone establishes a legal violation.

Implementation sequence:

1. Acquire the exact authoritative reference and record provenance, date, edition, checksum, applicable rights and attribution.
2. Choose local SVG/vector data if lawful and suitable for interactions, or a high-resolution local raster with a separately reviewed interaction layer. A correct static map is preferable to an inaccurate interactive one.
3. Preserve aspect ratio with a single uniform scale. Use the same transform for painting, state highlights and hit testing. Never stretch the image independently on the two axes.
4. Validate outer boundary, Northeast connectivity, region boundaries, islands, UT representation and labels against the source. If a schematic island inset is necessary, label it and keep it geographically honest.
5. Ensure state polygons do not cross or overlap. Highlighting must not change the silhouette. Provide a textual region picker for tiny regions and accessibility.
6. A person familiar with Indian geography should review the rendered phone/tablet outputs against the source before enabling map lessons.

If an accurate usable asset is unavailable, tell the parent clearly: “The map lesson is not available yet while we verify the map.” Offer reviewed photo/text geography activities instead. Disable map-dependent questions; do not substitute distorted artwork, pretend an asset has been generated correctly, or keep a silent tappable map.

## 7. Discover India: coverage and content

Provide a navigable region directory and age-appropriate learning, not just a few sample locations. Verify the current administrative list against official sources before release. Expected scope is all 28 states and 8 union territories; catalogue scaffolding alone does not fulfil the requirement.

State coverage checklist: Andhra Pradesh, Arunachal Pradesh, Assam, Bihar, Chhattisgarh, Goa, Gujarat, Haryana, Himachal Pradesh, Jharkhand, Karnataka, Kerala, Madhya Pradesh, Maharashtra, Manipur, Meghalaya, Mizoram, Nagaland, Odisha, Punjab, Rajasthan, Sikkim, Tamil Nadu, Telangana, Tripura, Uttar Pradesh, Uttarakhand, West Bengal.

UT coverage checklist: Andaman and Nicobar Islands, Chandigarh, Dadra and Nagar Haveli and Daman and Diu, Delhi/National Capital Territory of Delhi, Jammu and Kashmir, Ladakh, Lakshadweep, Puducherry. Check current formal names and capital conventions rather than copying old constants.

For each region supply a spoken name, accurate locator where available, one or more recognizable images, a short verified fact and at least one appropriate interaction. Older bands can learn capitals and adjacent regions; younger bands should focus on names, familiar places and pictures. Verify seasonal/multiple-capital facts individually. Avoid implying a region has only one language, food, community or landscape.

Neighbouring countries: provide a separate lesson covering land neighbours and nearby island countries, with categories clearly distinguished. Use the authoritative Indian map standard and current official descriptions. The Ministry of Home Affairs describes borders with Bangladesh, Pakistan, China, Nepal, Bhutan, Myanmar and Afghanistan; do not use an inconsistent generic map to silently drop or reinterpret a boundary. Nearby island-country lessons may include Sri Lanka and Maldives; do not call them land-border neighbours. Keep child-facing teaching factual and simple, with detailed source context in parent credits.

Reference: [Ministry of Home Affairs border management](https://www.mha.gov.in/hi/divisionofmha/%E0%A4%B8%E0%A5%80%E0%A4%AE%E0%A4%BE-%E0%A4%AA%E0%A5%8D%E0%A4%B0%E0%A4%AC%E0%A4%82%E0%A4%A7%E0%A4%A8-%E0%A4%AA%E0%A5%8D%E0%A4%B0%E0%A4%AD%E0%A4%BE%E0%A4%97-i). For region facts use current state/UT government sources, not redirected old Know India URLs assumed to retain the old content.

## 8. Monuments and natural-looking teaching art

Use the [UNESCO Taj Mahal record](https://whc.unesco.org/en/list/252/) as an identity/fact reference. A suitable photo candidate is [Taj Mahal, front view on Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Taj_Mahal,_front_view.jpg). The file page identifies Divya Shikhar as author and CC BY-SA 4.0 as its licence. Preserve attribution, the licence link, modification notices and applicable share-alike terms for adaptations. Inspect the actual image for teaching suitability before adopting it; a reference link is not an approved asset. Follow [Commons reuse guidance](https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia).

For the Taj Mahal, preserve recognizable architecture: central dome, balanced facade, four minarets and the monument's proportions. Show the identifying title and a simple accurate location. Use a photograph for identity teaching when possible. Original illustrations may simplify detail but must not invent the building. Apply the same process to every other monument: verify identity, location, source and image rights individually.

For flowers, fruit, animals and everyday objects, replace anonymous geometric stand-ins with recognizable licensed photos or coherent original illustrations. Pomegranate should resemble a pomegranate, with appropriate shape/crown/seeds when cut; a generic red circle is insufficient for word association. Use warm natural textures and varied believable shapes, readable outlines and uncluttered backgrounds. Avoid eyes/faces on factual objects when they obscure identity. Keep answer options comparable in scale, lighting and visual prominence so the artwork does not leak the correct answer.

Suggested illustration brief: “A recognizable [object/species], friendly illustrated picture-book style, believable silhouette and distinctive features, warm natural colors, soft textured shading, clean background, no text, no misleading extra parts.” Use this for everyday art, never political boundaries. Generated art still requires identity review.

Create an asset manifest with ID, local path, subject, source URL, author, licence/permission, attribution, modifications, reviewer/date and checksum. Bundle approved teaching images locally; optimize without destroying detail. Put external reference links in the grown-up area, rather than sending children out to a search page.

## 9. Hindi: tap-to-hear must actually work

Provide native-speaker-reviewed audio for every released letter, word and required instruction. Record the intended pronunciation, not an English approximation of Devanagari. Distinguish letter name from sound and whole-word pronunciation in content metadata. A silent recorded-file placeholder does not fulfil this requirement.

For each playable item:

1. Store stable lesson/token IDs, displayed Devanagari, target pronunciation, local clip path, rights, review status and reviewer/date.
2. Tap on a letter or word tile plays that tile's clip. Hear again replays the relevant instruction/model clip. An answer tap may evaluate the answer but must not play an unrelated sound.
3. Validate every path against the Flutter asset bundle, not just filesystem existence. Catch decode/playback failures and present a brief honest response.
4. Cancel stale/overlapping playback when a new tile is tapped, screen changes or app backgrounds. Duck music during narration, then restore it on completion and failure.
5. Keep mute states clear. Persist spoken-instruction preferences separately from music/effects. Do not enable a misleading Hear again control when no clip exists; use visual instructions and an explicit availability explanation until the clip is supplied.
6. Do not use unreviewed runtime TTS as the sole pronunciation authority. Any synthetic clips must be generated ahead of release and reviewed like recordings. Do not claim reviewed narration merely because a synthesizer produced a file.

Validate on a physical Android device with the normal release build: sound on/off, tile taps, rapid taps, replay, speaker/headphones, app pause/resume, volume changes and offline cold launch. Check intelligibility with a Hindi speaker. Automated mocks verify routing; they cannot prove audible pronunciation.

## 10. Background music supplied by the owner

Existing supplied file: `C:/Users/MSUSERSL123/Downloads/sproutlab-gentle-loop.wav`. The copy at `design/audio/sproutlab-gentle-loop.wav` is identical: SHA-256 `68B2F5737FCD8EE00CB26F2684ADFD7B27134F1AFD5F0974240D1D8424FBFE21`. It is currently a design reference, not the runtime music asset. The app controller points to `audio/music.wav`.

Use the supplied loop as the requested candidate: listen for clipping, harshness, unsuitable loudness and loop seam; record its provenance/rights; integrate an approved runtime copy and its asset declaration. No replacement composition is necessary just to address the integration bug.

Music starts only when the saved preference is on, at a quiet level. Provide a parent volume control and preview; preserve settings across relaunch. Fade gently, loop without an audible seam, duck during pronunciation and restore on completion/failure. Pause on background/audio interruption and stop when switched off. Handle unavailable output/device playback errors honestly. Test repeated setting changes for duplicate players. Never start a second music loop on every navigation.

Acceptance: switch on and Save → audible quiet playback; relaunch retains preference; off stops playback; narration remains clearly audible; offline works. A WAV copied into the repository and an enabled purple switch are not sufficient evidence.

## 11. Ages 2–3 and readable layouts

Expose Ages 2–3 in onboarding and grown-up settings. Preserve A–D serialized keys and existing seed behavior; the current T key should remain stable. Changing bands preserves completed activity records and starts/resumes an appropriate session rather than reinterpreting older IDs.

Use adult-supported play: short sessions, large targets, one simple instruction, two recognizable options, familiar colors/objects, simple matching and exploration. Avoid mandatory reading, tracing accuracy, capitals quizzes, complex mazes or competitive Tic-Tac-Toe. Review eligibility for Home and Explore, not only the settings label. Existing six toddler activities are an initial small set; do not represent them as a comprehensive curriculum.

Keep complete words on Explore cards. Let text determine height, allow natural wrapping between words, put arrows where they do not steal essential title width and switch to one column on narrow screens/large text. Test Knowledge, Observation, Discover India, Tic-Tac-Toe and Devanagari with bundled fonts. Do not fix overflow by shrinking all text or clipping descriptions. Ensure sticky lesson controls do not hide the last answer, image caption or scrollable content. Use accessible tap targets and readable contrast.

## 12. Tic-Tac-Toe choices

Before starting, clearly offer: “I go first (X)”, “Computer goes first (I play O)”, and “Two players on this device.” The existing source contains these choices; verify rather than replacing it with a duplicate implementation.

Computer-first makes exactly one opening move, then waits for the child. Local mode alternates two human players with visible turn labels and no AI. Restart keeps the selected mode; Change players permits a deliberate fresh game. Ignore occupied cells and taps after game end. Cancel delayed AI on restart, mode change, exit and lifecycle changes. Save mode, board and next turn in checkpoints; reject inconsistent old checkpoints safely. Use calm draw/win feedback and keep local matches separate from AI mastery scoring.

## 13. Implementation phases and acceptance evidence

### Phase A — reproduce and repair navigation

Establish build/version; expose Mazes; verify same-day adventure continuation, toddler selection, card layouts and Tic-Tac-Toe options. Preserve working code. Deliver release screenshots and interaction traces for each path.

### Phase B — source and build usable media

Acquire accurate map reference and applicable use terms, select monument/object assets, prepare audio scripts and clips, integrate the supplied music. Track missing assets by exact ID. Proceed with unaffected code while asset work continues; do not call the phase complete with placeholder media.

### Phase C — complete and enable regional packs

Finish coverage, identity/pronunciation review and asset-bundle checks. Compute availability from reviewed eligible activities. The normal release must open Hindi and Discover India for the intended selected region/settings; `UNLOCK_ALL_GAMES` is not the production fix. If only part of a pack is ready, show honest playable coverage and identify unfinished topics in the parent area.

### Phase D — verify the delivered build

Run relevant automated tests and static analysis, then build with existing signing identity. Test fresh install and upgrade on a physical phone, offline media, progression, enlarged text and all game modes. Report exactly what was tested and what remains blocked. Supply versioned APK, checksums, content/media manifests and a concise change/status report. Do not publish or change signing/package identity without the owner's request.

Release acceptance checklist:

- [ ] Hindi opens in normal release and every released tap-to-hear target is audibly correct.
- [ ] Discover India opens; state/UT coverage and neighbour learning are reachable and verified.
- [ ] Accurate map renders without distortion, or unavailable map activities are clearly withheld with usable alternatives.
- [ ] Taj Mahal and other monument teaching images are recognizable and rights/provenance recorded.
- [ ] At least 50 selected-band mazes can be found through an obvious Explore route.
- [ ] Fifth completion shows continuation choices and Next adventure creates a fresh persisted session.
- [ ] Background music preference produces the expected audible result and survives relaunch.
- [ ] Ages 2–3 is selectable and all assigned tasks are parent-led and age appropriate.
- [ ] Whole-word cards and lesson content fit narrow phones and enlarged text.
- [ ] Computer-first and local two-player Tic-Tac-Toe work on the delivered device build.
- [ ] Existing progress/checkpoints survive upgrade; release version and content version are visible.
- [ ] Physical-device evidence is supplied; automated results are not substituted for listening/visual review.

## 14. Pasteable instruction for the implementing agent

> Read this handoff and the current repository. First reproduce the owner's issues in the installed release and report its version. Implement the phases above, preserving existing local changes and stable progress IDs. Make mazes and continuation choices discoverable; complete regional media/content rather than bypassing review flags. Use authoritative India map references with recorded applicable terms, recognizable local teaching images and reviewed pronunciation. Integrate the supplied music and verify real audible output. Run automated checks and physical-device acceptance where available. Deliver a versioned build and an evidence-based status report. If an asset, rights determination or connected device prevents completion, name the exact missing input and finish all independent work; do not claim the feature is complete or silently substitute an inaccurate asset.

