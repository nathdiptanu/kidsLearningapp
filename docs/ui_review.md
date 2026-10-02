# UI review

Date: 2 October 2026. Palette measured by `test/contrast_test.dart` on this machine. Device screenshots and TalkBack were not captured.

## Palette

Roboto is the UI face. It ships with Flutter and Android under the Apache 2.0 license. Body text on child screens stays at 22 logical pixels. Parent body text is 16. Touch targets for child actions stay at 64 logical pixels.

| Pair | Ratio | Floor |
|---|---:|---:|
| Main text #172033 on canvas #F7F8FC | 15.33:1 | 4.5:1 |
| Main text on white surface | 16.27:1 | 4.5:1 |
| Secondary text #475569 on canvas | 7.14:1 | 4.5:1 |
| Secondary text on white | 7.58:1 | 4.5:1 |
| White on primary #5B3FCB | 6.96:1 | 4.5:1 |
| White on pressed primary #3C278F | 11.18:1 | 4.5:1 |
| Main text on selected tint #EEE9FF | 13.74:1 | 4.5:1 |
| Disabled text #334155 on #E2E8F0 | 8.40:1 | 4.5:1 |
| Correct #146C43 on white | 6.45:1 | 4.5:1 |
| Retry #8A4300 on white | 7.28:1 | 4.5:1 |
| Star #7A4B00 on white | 7.41:1 | 4.5:1 |
| Main text on maths tint #E5F3FF | 14.41:1 | 4.5:1 |
| Main text on English tint #FFF0D9 | 14.50:1 | 4.5:1 |
| Main text on logic tint #EEE9FF | 13.74:1 | 4.5:1 |
| Main text on observation tint #E0F4EE | 14.21:1 | 4.5:1 |
| Main text on knowledge tint #FFE8EE | 13.97:1 | 4.5:1 |
| Primary icon on canvas | 6.56:1 | 3:1 |
| Border #5C6B82 on canvas | 5.10:1 | 3:1 |
| Category marks on their tints | 6.42:1 to 9.35:1 | 3:1 |

Category cards use a pale tint with dark text. Icons use a darker mark of the same family. White text is not placed on those tints.

## Navigation

Child tabs remain Home, Explore, and Rewards. The grown-up area is a lock icon on Home, still behind the existing hold. Today's adventure has one primary Start or Continue button.

Explore lists Maths, English, Logic, Tic-Tac-Toe, Observation, and Knowledge. The old empty Knowledge card is gone. Tic-Tac-Toe states that five new games are free and a replay does not use another free game.

Choice, maze, difference, and Tic-Tac-Toe finishes show the level badge, stars, points, Play again, Next activity when a journey is open, and Home. Rapid taps on those buttons are ignored after the first tap.

## Parent area

Parent screens stay on the calmer surface. New controls: reduced motion, and a gentle stop after 10, 15, or 20 minutes in this app. The stop does not interrupt a question and does not control other apps. Existing sound, reminder, band, and privacy controls remain.

## Not verified on a device

No emulator or physical device was available for screenshots, TalkBack, rotation photos, or a process-restart pass beyond the existing widget tests. `dist/widget/foundation_screen_test.dart` covers a 320-wide layout, large text, onboarding, and one maths finish. Those tests passed after the label updates.
