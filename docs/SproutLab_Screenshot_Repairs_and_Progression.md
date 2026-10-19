# SproutLab: Screenshot-grounded repair instructions

For Codex and Cursor — 3 October 2026

## Scope and priority

Repair the actual app, not only its screenshots. Preserve earlier local-first, consistent-theme and 1,000 validated-item objectives. This supplement takes priority for the specific defects below. Work sequentially and keep a factual repair-status report. Preserve production identity, signing, profiles, purchases, progress and badges. Future iOS support remains a shared architecture requirement, not a claim that iOS is already tested.

## What the nine supplied screenshots actually show

- Parent settings offer 3–4, 4–5, 5–6 and 6–7, with no younger choice.
- Background music and spoken instructions are toggled on, but settings explain that reviewed lesson recordings are absent.
- Hindi lesson “Find अ” and the Taj Mahal lesson show “Development sample” and explicitly say no reviewed recording is in the build. Hear again remains visible. This is incomplete media delivery, not necessarily a volume problem.
- Hindi choices appear as radio-button rows. The अ example picture is a schematic red fruit and needs pedagogical/identity review.
- Taj Mahal is represented by a generic line-style building, unsuitable as the main identification reference without review.
- My India and Rajasthan screens use angular/simplified geometry that needs comparison with current authoritative maps. Screenshots alone cannot establish the precise source or legal implications.
- Explore cards break “Observation” into “Observati / on” and “Knowledge” into “Knowledg / e”; card sizing/text flow is demonstrably wrong.
- Home shows “0 of 5 activities complete”; this screenshot does not prove the five-completion bug, which is reported by the owner and needs reproduction.
- No Tic-Tac-Toe match screen is provided; missing second-player choice is owner-reported and needs reproduction.

Store these screenshots as development references, excluded from release assets. Do not repeat statements that every issue has been verified from images or that sound was tested by looking at a screenshot.

## 1. Accurate maps and images

Immediately remove any unverified or incorrect geography from released learning activities. Do not attempt to repair national/state boundaries by eye, use generated polygons, or use an AI image as a geographic source.

Authoritative reference pages:
- Political map: https://surveyofindia.gov.in/pages/political-map-of-india
- Outline maps: https://surveyofindia.gov.in/pages/outline-maps-of-india
- State maps: https://surveyofindia.gov.in/pages/state-maps
- India and adjacent countries: https://surveyofindia.gov.in/pages/india-and-adjacent-countries
- State/UT directory: https://www.india.gov.in/explore-india/facts-of-india/states-ut-districts
- Taj Mahal reference/facts/photos: https://whc.unesco.org/en/list/252/
- Other heritage: https://whc.unesco.org/en/statesparties/in/
- Image reuse guidance: https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia

These are reference sources, not a blanket licence to copy their files. Inspect each downloadable map/photo licence and obtain necessary permission before distribution. Use current editions; archive the chosen source, attribution, rights decision and date. Google search links are useful for discovery but neither accurate boundaries nor reuse rights follow merely from appearing in Google Images. Do not hotlink images into children's offline activities.

Recommended pipeline: acquire a permitted authoritative map, review it, preserve its projection/aspect ratio, convert into an appropriately optimized local image/vector only if adaptation is allowed, then validate the resulting view against the original. Vector hit regions must correspond to the same authoritative geometry and use the same transform as rendering. Never draw guessed state borders on top of a correct national image. Include island/inset context and provide zoom/list alternatives for tiny regions. Review boundaries and labels before publication. If accurate permitted interactive geometry is not available, ship a reviewed static map plus accessible region cards, and clearly report that interactive map work is blocked.

Map unavailability: parent information should say “Map activities are temporarily unavailable while we verify the learning material.” Offer accurate text/image lessons where available. Do not show a malformed map with a disclaimer. Do not promise legal compliance; factual/boundary review and rights assessment remain required.

Use a recognizable licensed Taj Mahal photo or accurate reviewed illustration. Confirm the asset shows the actual monument. Preserve the dome, minarets, perspective and aspect ratio; do not crop crucial identifying elements. Replace generic palace clip art and robotic flowers/animals with consistent, recognizable licensed photos or high-quality original illustrations. Everyday decorative art may be stylized; identification tasks must depict what the label actually names. Keep clear silhouettes, plausible natural shapes, consistent scale and safe framing. Generated botanical art requires identity review before teaching species.

Asset manifest: ID, local file, original URL, creator, licence/version, attribution, edits, dimensions, checksum and review status. Never count placeholder images as finished content. Include credits behind the parent gate.

## 2. Complete India catalogue and neighbours

Create a browseable current state and union-territory catalogue verified against official sources. Every region needs a name, administrative type, accurate locator/static map if permitted, age/readiness-appropriate introduction and selected reviewed facts. Learning across all states must be available, but a young child is not required to learn all of them in one session. Catalogue browsing and quiz-option count are separate: use two beginner choices and usually three/four for older children.

Add staged region journeys: introduce name/place → observe picture/context → practise → recall on later sessions. Provide home-region choice in parent settings, a balanced sequence across regions and a full accessible list. Capital questions come only after introduction. Model multiple/seasonal capital arrangements explicitly and avoid ambiguous questions. Do not hardcode uncertain facts.

Add “India and our neighbours” for appropriate readiness. Distinguish land neighbours from nearby maritime countries. Source border classifications from current authoritative Indian sources; keep territorial/administrative distinctions accurate and do not oversimplify contested geography into guessed borders. Younger children identify a few introduced countries by name/location, older children learn direction and selected reviewed facts. No political persuasion, superiority claims or stereotypes. Do not require this for ages 2–3.

Stories cover regions, nature, architecture, languages and heritage through short sourced explanations, not rote quizzes alone. Keep fact and legend explicitly distinct, no graphic conflict stories for young children. Review narration and content with an educator/native speaker. AI drafts cannot publish themselves.

## 3. Hindi and English pronunciation: deliver actual audible media

Audit content asset IDs, asset packaging, audio player initialization, runtime paths, error states and parent preferences. A working button connected to missing recordings is not a completed feature. Inventory every lesson requiring audio and report missing media separately from playback-code defects.

Bundle reviewed Hindi letter/word recordings and English letter-name/phonics/word recordings for essential released lessons. Do not claim educator/native-speaker approval unless it happened. Development synthesized samples may demonstrate the pipeline but must not silently become approved release phonics. Device TTS may be used only as a documented optional fallback with correct language, supported voice and offline availability detection. It must not silently read Hindi with an English voice. Do not assume Hindi voices are installed.

Tapping a letter/word tile plays its relevant audio; Hear again replays the current prompt. Distinguish letter sound, letter name, example word and instruction, with stable asset mapping. Show playing/loading/error feedback accurately. Never simulate completion on silent playback. If audio is missing in an internal preview, show “Audio unavailable in this preview” and disable replay rather than a dead button; release-required missing media remains a release blocker.

Use one lifecycle-aware service with separate narration/effects/music channels. Stop prior speech, debounce rapid taps, cancel stale async callbacks, duck music for narration and restore it afterward. Respect mute/volume settings and pause on background, phone interruptions and route changes. Stop on screen disposal. No microphone access, child voice capture or cloud tracking.

Verify actual audible sound on a physical Android device if available and separately test offline. Mock player tests are insufficient. Include correct pronunciation, Devanagari shaping/matras, language selection, repeated taps, navigation/resume and all mute settings. Review key iOS adapter behavior later; do not call it tested without a build/device.

## 4. Background score and supplied test loop

The attached sproutlab-gentle-loop.wav is an original procedurally synthesized 16-second test loop supplied with this brief. It is not a commercial track, a voice recording or evidence of child suitability. The owner may evaluate it as a starting asset. Listen and parent-test before adopting it; provide an easy off switch and prefer subtle volume. Replace with commissioned/licensed music if better suited, preserving rights documentation. No claim of exclusive rights or copyright certification is made.

Implement a music player using the existing maintained cross-platform audio stack where suitable. Register the asset correctly, start only while the app is foregrounded and the parent setting is enabled, and loop without a click/gap. Avoid creating a new player for every screen. Persist volume/toggle, fade gently, duck during speech and pause during app interruptions. Setting on should really play if a valid asset exists; errors need a parent-visible explanation. No surprising full-volume start or music while backgrounded. Keep sensory comfort and reduced motion settings independent.

Test the actual output with narration, headphones, navigation and repeated app launches. Use compressed media only after comparing audible quality and decoded/runtime behavior; maintain the source WAV for development, exclude it from release if a smaller suitable version replaces it.

## 5. Tile and knowledge-card layout

Fix word-breaking at the component level. Do not split words by character to fit narrow cards. Use a responsive two-column grid where width allows, switching to one column at larger text scales or narrower screens. Use natural word wrapping, appropriate line-height and content-driven sizing. A deliberate “Tic-Tac-Toe” wrap is acceptable; “Knowledg / e” is not.

Keep common padding, title baseline, image area, subtitle spacing, progress and button position. Avoid forcing equal small heights that clip longer Hindi/English text; choose a shared height adequate for visible rows or responsive layout. Support text scaling without concealing the learning objective. Decorative illustrations should not consume the space needed for readable labels. Use one clear visual hierarchy on lesson cards: task, media/text, answer choices, feedback and primary action. Avoid development caveats inserted into children's instructions in release mode.

Require screenshot checks at supported phone/tablet sizes and accessibility text scales. Test long region names, Hindi matras, bilingual titles and empty/missing-media states. Use shared theme tokens and consistent original/licensed icons; never flatten the UI into images.

## 6. Home progression after five activities

Separate session progress, catalogue level completion, learning readiness and purchase entitlement. Five activities complete one adventure/session, not the entire game engine and not proof of mastery. Do not interpret the old five-free-items rule as a five-activity session rule; preserve the actual existing free/permanent-replay entitlement contract.

Required sequence:
1. Create a stable adventure/session ID and save its five selected activity IDs per child.
2. Finishing an activity persists completion once, updates its circle/check mark and Home count immediately. Failed attempts/hints do not reset unrelated progress. Skip is not completed learning; allow a replacement if appropriate.
3. At 5/5 show a gentle completion screen, existing milestone badge only if newly earned, and a summary.
4. Offer “Next adventure”, “Play again” and “Take a break”. No countdown, forced autoplay, purchases in the child's completion screen or compulsory streak pressure.
5. Next adventure creates a new session with reviewed eligible activities, mixing new and revision items. Reset only the new session counter to 0/5; retain completed levels, badges and history.
6. Readiness-based difficulty changes gradually. Replays remain available; if no new eligible/free content exists, offer revision and parent-gated information rather than a broken Next button or silent paywall.

Home displays “Adventure complete” and the Next adventure action while that session is finished. On app relaunch, retain that state until the child chooses next. Partial sessions resume their actual next uncompleted item. Handle double taps, route return, restart and profile switches without duplicate rewards. Explicitly test 0/5 through 5/5 and next-session creation. Do not hide a stuck session behind a daily reset.

## 7. Ages 2–3: parent-led experience

The owner now authorizes adding an Ages 2–3 learning choice. This supersedes earlier deferral for that band. Implement parent-led readiness defaults: very short picture/listening/large-target matching activities, familiar objects/colors/shapes, no reading requirement, no capital quizzes, fine tracing expectation, timers or competitive score pressure. Let parents choose older/easier material based on readiness without deleting progress.

Add the band in onboarding/settings, eligible-content selection, narration, help, analytics and migration. Define boundaries unambiguously so a three-year-old is not assigned conflicting defaults; parent-selected band is authoritative. Do not collect exact birthdates unnecessarily or claim educational/clinical outcomes. Update store audience/privacy declarations as appropriate to the actual release; assess current store requirements without making unsupported claims of compliance. No under-2 independent app experience is requested. Preserve parent gate and gentle stop controls.

## 8. Tic-Tac-Toe player choice

Implement “Play with computer” and “Two players on this device”. In computer mode let the child select “I go first (X)” or “Computer goes first (I play O)”. Use the standard X-starts rule: playing O means the computer makes the opening move automatically. If existing rules differ, document and standardize them. Explain choices through clear symbols and narration where supported.

Local two-player mode is pass-and-play, with obvious turn indicators, X/O assignment, replay and optional swap-sides. No online accounts/network matchmaking required. Prevent input during computer turns, double taps, occupied-cell overwrite and moves after terminal state. Cancel delayed AI callbacks on exit/restart and keep easy difficulty friendly. Check win/draw detection, computer opening, second-player play, restart and profile switching. No unfair badge farming from repeated end-state taps. Tic-Tac-Toe is optional for younger bands rather than a required developmental activity.

## 9. Catalogue, storage and performance requirements remain

Retain at least 1,000 genuinely validated playable items across language, maths, logic, mazes, differences, find objects and knowledge as required in the earlier repair brief. Count current approved items; report editorial items, generated variants and templates separately. Do not inflate counts with shuffled options, renamed duplicates or asset files. Region/age eligibility means not every child sees all items. Facts, phonics and identity images require genuine review; deterministic maths/maze generation needs answer/solvability validation.

Keep local media plus database references as the default; deduplicate shared pictures/audio, index actual selection queries, batch migrations and lazy-load activities. Compression reduces disk size; encryption does not. No base64 image blobs, unbounded caches or full-catalogue decrypt/load at startup. Benchmark before switching to BLOBs or encryption. Preserve progress/keys during migrations. Profile release builds, report actual device/timing/memory measurements, and distinguish APK/AAB/download/installed sizes. No fabricated claims of optimal complexity or guaranteed tiny builds.

## 10. Acceptance and release evidence

Track each defect as reported/reproduced/fixed/tested. Map correctness and media rights require review, not only widget tests. Audio needs audible device evidence. Catalogue size needs reproducible counts. Automated tests cover availability, session state/rewards, migrations, audio routing, Tic-Tac-Toe rules, question validity and map/hit transforms; manual checks cover visuals, pronunciation and scene recognizability.

Walk through ages 2–3 and older bands, India/non-India region settings, profile switching, five-activity completion, next adventure, Hindi tile taps, replay, music, India catalogue/neighbours, image questions and both Tic-Tac-Toe modes. Check offline fresh launch, background/resume, mute, missing assets, tablet and enlarged text.

Build the signed release APK using the existing authorized signing configuration and appropriate version increment. Also build AAB if available. No replacement production keys, debug-signing disguised as release, exposed secrets or changed package ID. If signing/tooling/device is missing, finish unblocked work and report specific limits; provide debug preview only as debug. Verify signature, manifest, version, checksum, file size and installation/launch where possible. Do not call Play delivery/billing tested without actual Play tests. Final report includes real paths, completed/pending repairs, validated content counts and editorial blockers. Do not claim the screenshots have already been repaired by this brief.

## 11. Sequential prompts to paste into Codex/Cursor

Put this file at docs/SproutLab_Screenshot_Repairs_and_Progression.md. Copy the supplied WAV into a development audio folder; reference it from the app asset folder only after evaluation. Attach screenshots and approved Home/Explore references.

### Phase 1: maps, imagery and layout
Read this brief completely and inspect the repository. Reproduce the screenshot defects and owner-reported issues. Fix inaccurate/unsupported maps, Taj Mahal/identity images, Explore word breaking and lesson/card formatting. Use permitted authoritative geography and reviewed licensed recognizable images; if map geometry/rights cannot be verified, remove the incorrect map and provide an accurate static/list fallback with an explicit blocker. Do not hotlink Google images. Create a repair ledger and asset manifest, preserve profiles/history/identity, and verify responsive screenshots. Complete unblocked fixes before expanding content.

### Phase 2: audible Hindi/English and music
Implement sections 3–4 completely. Replace missing-media placeholders with real reviewed usable recordings where available, and fix packaging/player/lifecycle errors. Tile taps and Hear again must play correct audio offline. Integrate and evaluate the supplied original loop or a properly licensed replacement with parent volume/toggle and narration ducking. Verify audible device playback; no mock-only success. Exclude unreviewed teaching media from approved release counts and report exact missing-review blockers. Continue all unblocked implementation and tests.

### Phase 3: progression, ages 2–3 and Tic-Tac-Toe
Implement sections 6–8. Complete a persistent 0/5→5/5 adventure flow with celebration, Next adventure, replay and break. Keep session completion distinct from difficulty and purchase entitlements. Add parent-led Ages 2–3 choices and eligible content without resetting profiles. Add human-second/computer-first play and local two-player Tic-Tac-Toe. Test state transitions, double taps, relaunch, profile changes, AI cancellation and idempotent rewards. Update repair evidence and current audience-related release tasks.

### Phase 4: all-state learning, neighbours, catalogue and full QA
Implement sections 2 and 9–10: reviewed full current state/UT catalogue, appropriate neighbouring-country lessons, learn-first stories, age-eligible recall and 1,000 validated items across the app. Preserve the repaired game engines, offline play, audio and consistent theme. No invented facts/licences/review approvals or duplicate count inflation. Validate content, generators and assets; profile memory/size/performance and test complete app journeys. Report actual coverage, missing reviews and unresolved blockers clearly.

### Phase 5: signed release APK for testing
Resolve unblocked failures and generate the signed release APK with the existing authorized signing identity. Generate AAB too if available. Verify package/version/signature, file size and SHA-256; install/launch and test Hindi/audio/music, map/catalogue, 5/5 progression, age bands and Tic-Tac-Toe modes on available devices. Mark any unavailable runtime/signing/Play checks explicitly unverified. Deliver actual files in release-output/ and a factual release report. A preview with pending reviewed content is not full 1,000-item completion. Do not stop at commands or claim nonexistent artifacts.
