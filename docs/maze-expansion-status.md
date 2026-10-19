# Maze expansion — 0.1.5+7

The catalogue now contains 50 maze activities per band for Ages 3–4, 4–5, 5–6 and 6–7: 200 total, including 48 added activities. The parent-led Ages 2–3 band keeps its picture activities.

Five original garden palettes rotate through the catalogue. Pastel squares, dark walls, a smiling explorer, a flower finish and small visited-path dots make the board playful while retaining clear paths. Instructions encourage exploration and patience. A “Show a little clue” button reveals the next useful step without recording a wrong move; assistance is recorded separately for scoring. Completion celebrates finding the flower.

Existing activity IDs, seeds and generator version are preserved so stored progress and checkpoints keep their meaning. Every newly added maze is distinct from the older layouts in its band and from the other additions. Some original layouts repeat; those were retained for compatibility.

Validation checks all 200 mazes for valid walls and reachable finishes, validates the additions for distinct topology, and checks stored ID/seed lookup. Phone previews use bundled app fonts. Physical-device play testing has not been performed.

Static analysis passed with no issues. All 332 tests in the app and extended regression suites passed. Validation logs: `build/maze-analyze.log` and `build/maze-full-tests.log`. The earlier screenshot repair report describes the separate outstanding editorial and narration work.

Signed Android APK: `release-output/sproutlab-0.1.5+7-maze-preview-release.apk`. Android signature verification passed with the existing SproutLab upload certificate. SHA-256: `7423E73E2EFFF9A376AA78D79ED7AB55D7910E7E9D9EA74F1AD2D09527D1E463`.
