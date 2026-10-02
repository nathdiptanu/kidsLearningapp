# SproutLab 0.1.2+3 release artifacts

Date: 3 October 2026. Built from a clean tree at `%TEMP%\sproutlab-release-20261003` using the existing owner upload keystore. Debug APK was not requested and was not built.

This is a signed engineering build for sideload or Play **internal/open testing**. It is **not** a production store listing. Reviewed Hindi / Discover India learning items remain **0**.

## Artifacts

| File | Bytes | SHA-256 |
|---|---:|---|
| `release-output/sproutlab-0.1.2+3-release.apk` | 63,893,028 | `3F4D1A4F3F19AA05DF502F3E628C67618B5AAF1AE68D1AE4A48AF11EF519A0CF` |
| `release-output/sproutlab-0.1.2+3-release.aab` | 62,349,936 | `7811A117B7117581C1F15569952B3EE2735905AD176468188E46D3C2E82A3930` |

Previous comparable 0.1.2 artifacts (2 October, same package and version code): APK 63,091,510 / AAB 61,724,073. This build is larger by about 0.8 MB (APK) and 0.6 MB (AAB), consistent with Noto Sans Devanagari and the two regional category pictures added since that measurement.

## Identity

| Field | Value | How checked |
|---|---|---|
| Application id | `com.sproutlab.kids` | `aapt dump badging` |
| Version name / code | `0.1.2` / `3` | badging; `pubspec.yaml` `0.1.2+3` |
| Label | SproutLab | badging |
| minSdk / targetSdk / compileSdk | 24 / 36 / 36 | badging |
| Debuggable | no | badging has no `application-debuggable` |
| ABIs | arm64-v8a, armeabi-v7a, x86_64 | badging and AAB `base/lib/*` |
| Permissions | `INTERNET`, `ACCESS_NETWORK_STATE`, `BILLING`, app dynamic-receiver | badging. No `RECORD_AUDIO`, no `AD_ID` |

## Signing

Existing `android/key.properties` + `android/upload-keystore.jks`. No debug-key fallback. No new keystore was created. Passwords were not printed or copied.

| Check | Result |
|---|---|
| APK `apksigner verify --print-certs` | Verifies. APK Signature Scheme v2 |
| APK signer DN | `CN=SproutLab Upload, OU=Android, O=SproutLab, C=IN` |
| APK certificate SHA-256 | `64:8D:88:8D:EE:6A:94:F7:5C:25:56:51:5E:74:E2:C0:9C:73:5E:81:76:56:6B:8D:7E:7F:29:E1:3D:B4:5E:17` (matches the documented upload certificate) |
| AAB `jarsigner -verify` | `jar verified.` Same DN. Flutter then printed the known missing-`apkanalyzer` strip warning and exited 1; the AAB file was still written |
| Debug certificate | **Not used** |

`jarsigner` also printed usual AAB warnings (self-signed upload cert, no timestamp, JarFile vs JarInputStream). Those match the previous 0.1.2 handoff. They do not mean the file is unsigned.

## AAB structure

Zip listing (166 entries): `BundleConfig.pb`, `base/` (manifest, dex, three ABI `lib/` trees, flutter assets), `BUNDLE-METADATA/` (including `.so.sym` debug symbols that Play does not deliver to devices), `META-INF/`. Design reference PNGs under `design/reference` are **not** in the bundle.

bundletool is not installed. Device-specific split APKs were not generated.

## Checks that ran

| Check | Result |
|---|---|
| `flutter analyze lib test dist` | No issues |
| `flutter test test dist` | **319 passed** |
| Release catalogs default to empty language/geography/heritage packs when `includeDevelopmentSamples()` is false | Code change in this pass; widget tests still use debug asserts so they load samples |
| Package / version / permissions / signing / hashes | Passed, as above |
| Design references excluded from the AAB | Passed (0 hits) |

## Checks that did not run

| Check | Status |
|---|---|
| APK install and launch | **Not run.** `adb devices` listed no emulator or phone |
| Offline / audio / parent-gate on a device | **Unverified** on hardware. Covered only by widget/unit tests |
| TalkBack | **Unverified** |
| Play Console upload, test-track install, Play-delivered APK | **Not run** |
| Play Billing sandbox | **Not run.** `BillingProductConfig.annualSubscriptionId` is empty |
| bundletool device-spec | **Not available** |
| iOS | **Unverified.** No `ios/` folder. Windows host |

## Reviewed content coverage

| Kind | Count |
|---|---:|
| Unique reviewed learning items | **0** |
| Draft items (debug/tests only) | 17 |
| Playable development activities | 42 |
| Activity templates | 7 |
| Generated Hindi / Discover India engine slots | 0 |

Release loaders drop unreviewed lessons, map activities and heritage activities. Existing maths/words/pattern/maze/matching/difference/knowledge/tic-tac-toe engines are unchanged.

## Remaining limitations

- No editorial or rights approval for Hindi lessons, map facts, heritage drawings or narration.
- Owner still needs to confirm generated category/fox art.
- Premium cannot be purchased in this build.
- Flutter `bundleRelease` reported that it could not strip native debug symbols (`apkanalyzer` / cmdline-tools missing). The AAB includes `BUNDLE-METADATA` `.so.sym` files.
- Application id and visible name remain temporary engineering identity.

Do not treat these files as a finished Play production release.
