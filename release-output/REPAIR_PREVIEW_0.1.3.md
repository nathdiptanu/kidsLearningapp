# SproutLab 0.1.3+5 repair preview APK

Date: 3 October 2026. Engineering sideload / repair preview. **Not** a Play store listing. Educator-approved catalogue items remain **0**.

Owner instruction: signed **release APK only**. AAB was not built.

## Artifact

| Field | Value |
|---|---|
| File | `release-output/sproutlab-0.1.3+5-repair-preview-release.apk` |
| Bytes | 64,597,540 |
| SHA-256 | `D5E799A2F7155CA210FEEE0FE2B3B32ECD30231AE5FC499AFA8F78DFA9232606` |
| Application id | `com.sproutlab.kids` |
| Version | `0.1.3` / versionCode `5` |
| Debuggable | no |
| minSdk / targetSdk | 24 / 36 |
| ABIs | arm64-v8a, armeabi-v7a, x86_64 |
| Permissions | `INTERNET`, `ACCESS_NETWORK_STATE`, `com.android.vending.BILLING`, plus the app dynamic-receiver permission. No `RECORD_AUDIO`. No `AD_ID`. |
| Signing | APK Signature Scheme v2. `CN=SproutLab Upload, OU=Android, O=SproutLab, C=IN` |
| Cert SHA-256 | `64:8D:88:8D:EE:6A:94:F7:5C:25:56:51:5E:74:E2:C0:9C:73:5E:81:76:56:6B:8D:7E:7F:29:E1:3D:B4:5E:17` |
| Built with | `--dart-define=UNLOCK_ALL_GAMES=true` from a clean temp copy |

Source default stays `UNLOCK_ALL_GAMES=false`. This APK turns the flag on so Hindi and Discover India drafts are visible. That is not a store listing.

Built from `AppData\Local\Temp\sproutlab-repair-013` because the project `build` folder has locked files. Existing upload keystore only. No replacement key. Not debug-signed.

## Catalogue honesty

Playable, validator-checked library: **1,000**. Release-approved reviewed items: **0**.

Hindi requested 150 approved: **0**. India geography/heritage requested 70 approved: **0**. Extra generator-validated maths variants cover that numeric shortfall. See `docs/content_inventory.md` and `docs/repair-expansion-status.md`.

## Automated checks

- `flutter analyze lib test dist`: no issues
- `flutter test test dist`: 323 passed

## Checks that did not run

- APK install and launch: **not run** (`adb devices` listed no phone or emulator)
- Audible Hear / Hindi / music / headphone / call focus: **unverified**
- TalkBack, Play upload, Play Billing: **not run**
- Educator / geography / rights review: **not done**
- AAB: **skipped** by owner instruction
