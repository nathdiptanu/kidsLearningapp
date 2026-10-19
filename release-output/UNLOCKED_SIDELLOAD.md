# SproutLab 0.1.2+4 unlocked sideload

Date: 3 October 2026. Engineering sideload only. **Not** a Play store listing. Reviewed Hindi / Discover India items remain **0**. These are development samples so the games are visible and playable.

## Why the previous APK hid Hindi and Discover India

`release-output/sproutlab-0.1.2+3-release.apk` already contained the module code, but a release build:

- loaded **empty** language / geography / heritage packs (`includeDevelopmentSamples()` is assert-gated, so false in release)
- hid Hindi and Discover India unless a grown-up had already set country to **India**
- locked new levels after **5** free completions per engine

Install this `0.1.2+4` file instead of the `0.1.2+3` APK.

## Artifact

| Field | Value |
|---|---|
| File | `release-output/sproutlab-0.1.2+4-unlocked-release.apk` |
| Bytes | 64,400,932 |
| SHA-256 | `EE7C1C3A7754D84AC494B40E5A1078FBD0717DD501B3781DA4BC417623B3F393` |
| Application id | `com.sproutlab.kids` |
| Version | `0.1.2` / versionCode `4` |
| Debuggable | no |
| ABIs | arm64-v8a, armeabi-v7a, x86_64 |
| Signing | APK Signature Scheme v2. `CN=SproutLab Upload, OU=Android, O=SproutLab, C=IN` |
| Cert SHA-256 | `64:8D:88:8D:EE:6A:94:F7:5C:25:56:51:5E:74:E2:C0:9C:73:5E:81:76:56:6B:8D:7E:7F:29:E1:3D:B4:5E:17` |
| Built with | `--dart-define=UNLOCK_ALL_GAMES=true` |

`libapp.so` contains development IDs such as `lesson:hindi:listen:a`, `lesson:hindi:trace:a`, and `discover_india`.

## What this build shows

- Explore shows **Hindi Learning** and **Discover India** even if country is not set yet
- Hindi sample lessons (listen / find / match / trace / build / review) load
- Discover India geography samples (explore / learn / match / locate / capital / review) load
- Heritage samples (identify / match / locate / story / recall) load
- Existing maths / words / pattern / maze / matching / difference / knowledge / tic-tac-toe engines stay unlocked (no 5-free wall)

Draft counts in this tree: Hindi/English language samples plus 12 geography activities and 15 heritage activities. They are placeholders, not educator-approved catalogue items.

## Checks that did not run

- APK install and launch: **not run** (`adb devices` listed no phone or emulator)
- Play upload / billing: **not run**
