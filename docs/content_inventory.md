# Content inventory

Date: 3 October 2026. Counts come from `LaunchManifest` in `lib/domain/games/content/launch_manifest.dart`. `test/scoring_content_badge_test.dart` checks unique ids and the section totals.

Tic-Tac-Toe is excluded from the learning-section totals.

| Section | Playable activities | How they are made | Review status |
|---|---:|---|---|
| Maths | 220 | `maths:v1`, 55 slots in each of 4 bands | generator_validated |
| English | 152 | `vocabulary:v1`, 38 slots in each band | generator_validated |
| Logic | 292 | pattern 140 + maze 152 | generator_validated |
| Observation | 236 | matching 76 + spot-the-difference 80 + find-objects 80 | matching is generator_validated; difference and find-object art is placeholder_artwork |
| Knowledge | 100 | 25 authored facts in each band, one question each | authored_structure_checked |
| Learning total | 1,000 | | |
| Tic-Tac-Toe | 20 | 5 curated openings in each band | rules_checked, not part of the 1,000 |

Global id check: 1,020 catalog ids, no duplicates. Original slots keep the previous seed formula. Later slots use a separate seed range so old activity ids do not change their seeds.

## Allocation vs the 1,000-item brief

The brief asked for 150 English, 150 Hindi, 180 Maths, 140 Logic, 150 Mazes, 80 Difference, 80 Find Objects, and 70 India knowledge.

| Category | Requested approved | Actual playable validated | Notes |
|---|---:|---:|---|
| English language | 150 | 152 | Vocabulary generator variants |
| Hindi language | 150 | 0 approved | Development samples only. No reviewed audio |
| Maths | 180 | 220 | Extra 40 variants cover the Hindi/India approved shortfall |
| Logic/patterns | 140 | 140 | |
| Mazes | 150 | 152 | Reachable seeds with path metrics |
| Spot the Difference | 80 | 80 | 20 original scenes × 4 bands |
| Find Objects | 80 | 80 | 20 original scenes × 4 bands |
| India geography/heritage | 70 | 0 approved | 36 PLACEHOLDER places + heritage samples, hidden unless India/unlock |
| Matching (other) | — | 76 | Existing unique-template pool |
| Knowledge (other) | — | 100 | Structure-checked, not editorially reviewed |

Rationale for moving 40 items into Maths: Hindi and India cannot be fabricated as approved items. Matching templates were not inflated. Maths variants are deterministic and validator-checked.

## What is not finished release content

Spot-the-difference and find-object scenes use in-app drawings. They are playable but not signed-off art.

Knowledge facts were checked for one answer and unique choices. They have not had a separate editorial review.

Hindi lessons and Discover India remain `PLACEHOLDER`. There are no reviewed pronunciation files and no Survey of India map licence.

Maths, pattern, and maze generators were checked for 1,000 seeds each, plus every catalog knowledge question.

## Free play

Each engine still allows five unique free completions except `lesson:` / `geo:` / `heritage:` ids. Opening, leaving, or replaying the same id does not use another free completion. Daily adventures still pick five activities and do not add Tic-Tac-Toe.

## Shortfall against a signed-off release library

The playable, validator-checked library meets 1,000. The educator/rights-approved subset is **0**. A repair preview APK can ship the generator-validated catalogue with those limitations stated.
