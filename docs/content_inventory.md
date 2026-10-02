# Content inventory

Date: 2 October 2026. Counts come from `LaunchManifest` in `lib/domain/games/content/launch_manifest.dart`. `test/scoring_content_badge_test.dart` checks unique ids and the section totals.

Tic-Tac-Toe is excluded from the learning-section totals.

| Section | Playable activities | How they are made | Review status |
|---|---:|---|---|
| Maths | 100 | `maths:v1`, 25 slots in each of 4 bands | generator_validated |
| English | 100 | `vocabulary:v1`, 25 slots in each band | generator_validated |
| Logic | 100 | pattern 52 + maze 48 | generator_validated |
| Observation | 100 | matching 76 + spot-the-difference 24 | matching is generator_validated; difference art is placeholder_artwork |
| Knowledge | 100 | 25 authored facts in each band, one question each | authored_structure_checked |
| Learning total | 500 | | |
| Tic-Tac-Toe | 20 | 5 curated openings in each band | rules_checked, not part of the 500 |

Global id check: 520 catalog ids, no duplicates. Original slots (variant 0–5) keep the previous seed formula `(band + 1) * 100 + variant + 1`. Later slots use a separate seed range so old activity ids do not change their seeds.

## What is not finished release content

Spot-the-difference still uses the six in-app scene drawings. They are not production-final artwork, so those 24 activities are playable but not signed-off art. The same scene is reused across bands with a different number of spots.

Knowledge facts were written into the app and checked for one answer and unique choices. They have not had a separate editorial review. Do not treat them as finished release copy.

Maths, pattern, and maze generators were checked for 1,000 seeds each in `test/scoring_content_badge_test.dart`, plus every catalog knowledge question.

## Free play

Each engine, including Knowledge and Tic-Tac-Toe, still allows five unique free completions. Opening, leaving, or replaying the same id does not use another free completion. Daily adventures still pick five activities and do not add Tic-Tac-Toe.

## Shortfall against a signed release library

The playable library meets the 500 floor. The signed-off subset does not: 24 difference activities wait on final art, and 100 knowledge facts wait on editorial review. Generator-validated maths, English, logic, and matching activities are the 376 that do not depend on that art or editorial pass.
