# SproutLab: Hindi Learning and Discover India

Implementation brief for Cursor — 2 October 2026

## 1. Goal and scope

Add two cohesive, offline-first modules: Hindi Learning and Discover India. Preserve the existing games, progress, parent controls, billing and visual theme. Android is today's delivery platform; shared learning logic and content must support future iOS delivery. This brief authorizes phased implementation, not claims that content has already been verified or that releases already exist.

Use the existing purple, navy, cream and pastel SproutLab design, illustrated category cards and fox mascot. Add real Flutter interfaces, not screenshots embedded as screens. Inspect the repository first: confirm framework, persistence, theme, navigation, audio and entitlement architecture. Adapt names below to existing conventions; do not rewrite the app unnecessarily.

Do not bundle a large AI model or call cloud AI to generate child-facing facts. Local rule-based adaptation is sufficient. A large population is a potential audience, not evidence of adoption or subscription demand. Validate these features with parents and educators before expanding the catalogue.

## 2. Parent choices and regional availability

Add gated Parent Settings → Learning Preferences:

- Country/learning region: explicit parent selection, stored locally; do not infer via GPS, IP or SIM.
- Interface language: independent of country.
- Teaching language: English, Hindi or bilingual, where supported.
- Hindi Learning enabled: parent choice within the India region.
- Discover India enabled: parent choice within the India region.
- Child age band, readiness/difficulty, audio preferences and session reminders.

Owner requirement: show Hindi Learning and Discover India only when country is India. Other countries continue to see the existing global activities and age-appropriate English learning. Do not leave inaccessible promotional cards in their child Explore screen. Centralize this availability rule, including deep links and search. Country changes hide features without deleting completed levels or learning history. Changing back restores progress. Region must not determine nationality, religion, home language or presumed ability.

Do not silently reinterpret existing subscription purchases when changing region. Respect advertised access. Document any country-specific pack availability in the parent area.

Existing onboarding must remain short: parent chooses country and child age band, then optional language choices. Explain why country is requested: “Choose which learning activities to show.” No child must complete settings forms. Support multiple child profiles independently. Prefer age bands over collecting precise dates of birth. Parent can update age/readiness as a child grows; preserve history and allow easier material. Do not automatically advance based solely on a birthday.

## 3. Age and readiness design

These are proposed product defaults, not diagnostic or developmental claims. Have an early-years educator review them. Keep the existing 3–7 core audience; adding under-3 experiences is a separate release scope with audience/listing review.

| Age band | Language activities | Discover India |
|---|---|---|
| 1–2, optional later | Parent-led picture naming, tap-to-listen familiar objects; no reading or independent study expectation | Parent-led animals, places and pictures; no maps or capital tests |
| 3–4 | Listen and match; a few letters at a time; large shapes and optional forgiving pre-writing paths | Recognize a few landmarks, home-region pictures and familiar environments |
| 5–6 | Reviewed letter-sound examples, guided tracing, simple words and introductory matras | Learn a few states with full-map context, two-choice matching and picture landmarks |
| 6–7 | Word building, matras, simple sentences, English phonics and spelling appropriate to readiness | State shape/location, three-choice capital questions for learned states, short heritage stories |

Avoid a mandatory full alphabet poster, all-state memorization, speed tests or compulsory tracing. Younger screens show 2–4 choices; older screens usually 3–4. Sessions consist of small sets with an easy exit. No penalties for replaying audio, hints, missed answers or taking a break.

## 4. Hindi learning journey

Implement reusable modes: Listen, Find, Match, Trace, Build a Word and Review. Introduce a small reviewed group, then let the child explore.

For each letter or word, include the Unicode display text, reviewed pronunciation recording, familiar picture, short meaning, example phrase and applicable age/readiness tags. A simple example sequence is “अ”, “अनार”, “यह अनार है।” Have a native Hindi educator approve the actual narration, vocabulary, pronunciation and illustration relationship before shipping.

Treat vowels, consonants, vowel signs/matras, nasal marks and conjuncts as distinct teaching concepts. क्ष, त्र and ज्ञ should not silently be categorized as basic single consonants. Some letters have few familiar word-initial examples; do not invent unnatural words to force one word per letter. Teach their appearance within suitable words when appropriate. Avoid caste-linked or obscure examples when familiar inclusive alternatives work. The attached chart is inspiration only: audit spelling and examples independently and do not copy its artwork without rights.

The user's reference to “Q Hindi vocabulary” is ambiguous: Q is an English letter, not a Hindi letter. Implement English Q with a reviewed example such as “Q is for queen”, and optionally provide a Hindi explanation/meaning when teaching bilingually. Do not claim that रानी begins with a Hindi equivalent of Q. Foreign-word transliteration, including क़, is a separate advanced topic, not a direct alphabet equivalence.

Word building uses curated valid word records. A child assembling the correct tokens hears the complete reviewed word and sees its picture/meaning. Incorrect combinations receive a gentle prompt, not generated or mispronounced speech. Handle Devanagari grapheme clusters and combining signs; do not split strings by byte or code unit. A pedagogical token may comprise several code points. Correct shaping is essential.

## 5. English audio and phonics

English modes remain available internationally. Distinguish letter name from letter sound: tapping a letter must use an explicit mode and a reviewed recording. Do not imply one sound applies to every occurrence. Use picture vocabulary and listening for younger children, guided letter recognition/tracing when ready, then reviewed short-word blending/spelling and simple sentences.

English narration must be clear, unhurried and consistent. Prefer one reviewed accent per pack and document it. Hindi explanation is optional bilingual support, not a replacement for the English pronunciation. No microphone permission or automated speech grading in version one: listen-and-repeat does not require recording the child.

## 6. Voice implementation

Create an AudioService interface with play, stop, replay, narration speed where supported, and app lifecycle handling. Use short, professionally reviewed recordings for the core Hindi/English learning corpus; synthesized voice may be prepared during development only after checking provider licensing and native-speaker approval. Runtime text-to-speech is an optional fallback for explanatory text, not the sole source of phonics pronunciation.

Device Hindi voices vary and may be unavailable offline. Detect availability; never promise offline TTS universally or install voices without parent action. If the required voice/recording is unavailable, preserve readable content and offer a parent-facing explanation. Child activities must not be blocked by a network request.

Stop previous speech before starting another; debounce repeated taps, stop when leaving the activity/backgrounding the app, respect parent volume/mute settings, and duck background music during speech. Avoid overlapping music, effects and instructions. Always show a replay button and text/picture equivalent. Narration must not autoplay continuously. Audio is downloaded/bundled content, not collected child voice data.

Use a licensed font with reliable Devanagari shaping, such as an appropriately licensed Noto Devanagari family after checking its license. Test matras, conjuncts and line height on both platforms. Do not use transliteration as a substitute for Hindi text.

## 7. Tracing engine

Build reusable vector-based tracing with reviewed stroke paths, start dots, directional hints and progressive reveal. Do not grade a font glyph outline as if it were a stroke-order curriculum. A Hindi educator must approve stroke templates and instructional sequence, including appropriate handling of the headline/shirorekha.

Normalize pointer coordinates into the canvas coordinate system. Compare the drawn path to the active guide with generous distance tolerance and sufficient coverage; avoid exact pixel matching. Give configurable assistance by readiness. Never claim this measures handwriting development or diagnoses motor skills.

Allow finger input, optional stylus, left-handed use, undo/retry and a tap-to-follow alternative for children who cannot trace. No time limit or harsh failure marks. Save completion/assistance summary, not raw touch trajectories by default. Test small/large screens, orientation changes and accidental multi-touch. Tracing must remain smooth with no expensive work on every pointer event.

## 8. Discover India learning flow

Create journeys: My India → States and Places → Capitals → Heritage and Diversity. Teach first, quiz second. Start with a parent-selected home state/region if desired, then a small balanced selection; make the full reviewed catalogue available progressively.

State learning card:

1. Show a geographically reviewed outline in the full India-map context.
2. Highlight the state; provide a larger individual outline for recognition.
3. Speak the state name and show its bilingual label where enabled.
4. Introduce one short verified fact and one appropriately licensed picture.
5. Practice matching the shape/name/location.
6. Introduce the capital only at appropriate readiness.
7. Review previously taught facts in later sessions.

Use large tappable answer cards. Tiny states/territories require a magnified inset or accessible list alternative, not precise tapping. Similar silhouettes alone are poor beginner questions; provide context and hints. Keep states and union territories correctly typed. Never use AI-generated maps or distorted decorative borders. Preserve accurate map aspect ratio and island/inset context.

Current state/UT and capital facts must be checked against official sources before publication. Capital arrangements can include seasonal or multiple seats; records must represent them accurately. Avoid ambiguous capital questions, especially where a single hardcoded answer would omit a recognized arrangement. Do not use a historical capital as a current one. Every capital item needs a verification date and source.

## 9. Heritage, culture and history

Start with picture recognition and short evidence-based stories, not battles, political persuasion or date memorization. Suggested research candidates: Taj Mahal, Sanchi, Konark Sun Temple, Hampi, Mahabalipuram, Ajanta and Ellora. These are candidate topics, not permission to use any photo or a verified complete fact bank.

For ages 3–4: “Find this building”, picture matching, simple shapes/material observations. For ages 5–6: monument name, location and one short fact. For ages 6–7: two or three short narrated sentences, map connection and a reviewed recall question. Use human history, architecture, crafts, languages, nature and care for heritage. Include diverse regions, traditions and communities respectfully. Avoid defining an entire state by one food, costume, religion or language. Distinguish documented history from legend or traditional stories explicitly. No superiority claims or graphic violence.

Every story/question must be editorially reviewed. AI can assist an author with drafts but cannot publish facts directly. Do not generate facts on the child's device. Source links live in gated parent information, not an unrestricted child browser.

## 10. Sources and image rights

Research links, not blanket reuse licenses:

- National Portal state/UT directory: https://www.india.gov.in/explore-india/facts-of-india/states-ut-districts
- Know India state/UT portal: https://knowindia.india.gov.in/states-uts/
- Survey of India political maps: https://surveyofindia.gov.in/pages/political-map-of-india
- Survey of India outline maps: https://surveyofindia.gov.in/pages/outline-maps-of-india
- Survey of India state maps: https://surveyofindia.gov.in/pages/state-maps
- UNESCO India heritage entries: https://whc.unesco.org/en/statesparties/in/
- NCERT foundational-stage framework: https://ncert.nic.in/pdf/focus-group/NCF-FS_2022EN.pdf
- Wikimedia reuse guidance: https://commons.wikimedia.org/wiki/Commons:Reusing_content_outside_Wikimedia
- Creative Commons BY attribution: https://creativecommons.org/licenses/by/4.0/deed.en
- Flutter internationalization: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
- Google Play Families policy: https://support.google.com/googleplay/android-developer/answer/9893335

Use Google search only to discover original sources. Google Images does not grant permission to reuse images. Select each actual file at its source, inspect commercial reuse/adaptation terms and preserve required attribution. Government/UNESCO pages and free map downloads are not automatically copyright-free. Confirm map licensing and boundary suitability before distributing a traced/vector derivative. Do not ship placeholder or unlicensed maps/photos.

Maintain an asset manifest: asset ID, original URL, creator, license/version/link, attribution, modifications, local file, checksum and rights-review status. Prefer original commissioned art or assets with clear compatible licenses. Handle share-alike obligations deliberately; avoid noncommercial material in a monetized app unless separately permitted. Maintain parent-accessible credits and packaged license notices. Never hotlink a third-party image in a child's activity; bundle approved assets or download through the app's own controlled pack pipeline.

## 11. Shared architecture and data

Suggested structure, adapted to the existing app:

- domain: age/readiness rules, availability, question selection, progress, scoring;
- content: versioned validated language/geography/heritage packs;
- presentation: reusable cards, tracing, map, quizzes and theme;
- services: audio, storage, content-pack access and platform adapters;
- validation: schemas, fact/rights review and asset checks.

Use Flutter's shared UI/domain capabilities where already present. Isolate platform-specific TTS/audio/file handling behind interfaces. Review maintained dependencies for Android and iOS support before choosing versions. Do not add an Android-only SDK throughout the domain. Future iOS billing must use its own appropriate store adapter; this content feature must not hardcode Google billing logic.

Content record fields: stable ID, pack/version, activity type, region availability, teaching language, age/readiness tags, skill IDs, prerequisites, display text, pedagogical tokens, narration asset IDs, image ID, tracing paths/map geometry ID, question/options/correct IDs, explanation, sources, reviewedAt, reviewer status and rights status. Geography additionally needs administrative type and structured capital arrangements. Release loaders accept only reviewed records with valid assets and references. Draft records remain development-only.

Local progress: profile ID, content ID/version, attempts, first/last completed, correct responses, hints, assisted completion and review status. Preserve IDs through updates. Separate seeing an answer from recalling it. A new content version must not erase old rewards or award duplicates. Changing country/language/age must not delete history.

## 12. Local adaptation and parent insights

Use simple explainable rules rather than ML marketing. Mix new activities with previously learned items; prioritize recent errors and items not reviewed for a while. Sample only taught states/capitals in recall questions. Example initial rule: of five activities, choose up to two new, two review and one easy success; reduce novelty when the child struggles. Adjust this after real testing, not as a guaranteed learning formula.

A single correct guess is not mastery. Track recognition separately from tracing, listening, word building and unaided recall. Use status labels Introduced, Practising and Ready to Review; avoid IQ scores, diagnostic labels or comparisons with other children. Multiple spaced successful attempts may suggest confidence, not prove mastery.

Parent dashboard examples: “Practised 4 Hindi letters”, “Recalled 3 previously introduced state names”, “Used hints on two word activities”. Explain that this summarizes app activity, not a complete assessment. All learning analytics remain on-device. No third-party tracking, microphone upload or child identity upload is needed.

Use existing completion badges and non-punitive scoring; award a badge once per defined milestone. Region modules should reuse the existing entitlement service, not create separate inconsistent Premium flags. Decide free sample versus paid pack explicitly in the parent area; do not quietly convert previously advertised permanent access to a subscription.

## 13. Size, offline operation and UI quality

First audit the reported 150 MB: debug APK, release APK, AAB and installed/download sizes are different. Measure release ARM64 and device-specific delivery before and after. Exclude reference screenshots, unused full-resolution photos, duplicate fonts and raw studio audio from release assets.

Ship a small core reviewed sample; expand through compact content records and shared illustrations. Store maps/strokes as efficient reviewed vectors, optimize photo dimensions and compress narration after listening tests. Do not impose an invented MB promise. Later use optional controlled downloadable packs with clear sizes, parent consent, checksum/schema validation, atomic installation, offline availability after download and storage removal controls. Keep downloaded progress after pack removal. No executable code downloads. Version one can ship packs through ordinary app updates without a server dependency.

Match the established Home/Explore design. Hindi Learning and Discover India are two clear illustrated cards, not a wall of tiny alphabet buttons. Large text, obvious replay/help/next buttons, high contrast, generous touch targets and consistent Home/Explore/Rewards navigation. During activities, avoid accidental navigation and preserve state on interruption. Next is enabled when the activity is complete or clearly offers Skip; no invisible button or forced animation delay. Test Devanagari labels with text scaling and screen readers.

## 14. Phased implementation

Phase A: audit code, dependencies, app size, audience, theme and existing progress; create plan and stable schemas. Report actual findings before broad changes.

Phase B: working vertical slice: India availability settings, 5 reviewed Hindi letter/word lessons with audio, 2 tracing templates, 3 reviewed state lessons with at least one unambiguous capital activity, and 2 licensed heritage activities. Keep existing global English usable. Review with native Hindi speaker/educator and a small parent group.

Phase C: expand validated Hindi corpus, age-appropriate English modes, reviewed current state/UT catalogue, staged capital lessons, heritage stories, review scheduling and parent dashboard. Expand only after content/rights review. No fake “300 new games” count created by duplicating questions or swapping labels. Distinguish unique reviewed learning items, activity templates and generated variants.

Phase D: optional packs, further languages and later iOS delivery. Revisit under-3 audience separately. Do not promise a full iOS release solely because shared Dart code compiles.

## 15. Acceptance checks and release evidence

Test country India/non-India, profile switching, age/readiness changes, country changes without progress loss, entitlement restrictions, offline fresh launch and replay. Verify missing voice/assets, mute and audio interruptions. Check all word-building sequences, Devanagari rendering, tracing transforms and map hit testing. Content validators catch duplicate IDs, nonexistent answers, draft facts, ambiguous capitals, missing attribution, broken prerequisites and missing media. Review geography and narration manually; tests cannot prove their factual correctness.

Run existing lint/tests and add meaningful tests for regional gating, Unicode token assembly, progress migration, review eligibility, badge deduplication and content schemas. Exercise complete activities on a lower-end Android phone and tablet; inspect text scaling, parent gate and no-network behavior. Use iOS simulator/build checks only if tooling is available; otherwise mark iOS unverified.

Update privacy disclosures to describe actual country/age-band preferences, local activity analytics and optional pack downloads. Assess store audience/privacy declarations if scope changes. Do not claim legal compliance or therapeutic benefit from this brief. Keep parent purchase controls and no unrestricted child external links.

At the end, generate a debug APK for testing. Generate signed release APK and AAB only with existing valid owner signing configuration; do not create a replacement production identity, expose passwords or embed secrets. Verify manifest/package/version, signing, file size and SHA-256; install and launch the APK and test the actual Play-delivered build through a test track. Bundle validation alone is not proof of installation. Report exactly which checks ran, which failed and which are blocked. Do not invent build files or success.

## 16. Copy-paste starter prompt

Implement this brief in phases in the existing SproutLab project. Begin with a repository and size audit, then build Phase B completely with the current design system. Preserve existing profiles, games, rewards and billing. Keep learning data and gameplay local. Region selection must gate Hindi Learning and Discover India without deleting progress. Keep teaching language independent of country. Use reviewed content/audio and licensed images/maps; exclude unreviewed material rather than inventing facts. Add Unicode-safe word building, forgiving tracing, teach-before-quiz geography and local parent summaries. Make the shared architecture ready for iOS while delivering Android now. Validate the app across complete user journeys, then produce and verify available APK/AAB artifacts using the existing authorized signing setup. Provide a factual completion report and remaining editorial/build blockers.
