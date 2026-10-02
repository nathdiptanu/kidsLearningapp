# Build handoff

Date: 2 October 2026. A signed release app bundle is ready for Play internal testing and open testing. The upload keystore stays outside git.

## Identity

- Visible name: SproutLab (temporary)
- Application id: `com.sproutlab.kids` (temporary, not approved for Play)
- Version in `pubspec.yaml`: 0.1.2+3
- SQLite schema: 7. Existing progress is kept. Version 7 adds `best_score`, level badges, reduced motion, and the gentle-stop minutes.

## What this build contains

- New palette and contrast checks
- 500 learning activities plus 20 local Tic-Tac-Toe games
- Per-engine scores and one level badge per finished activity
- Reduced motion and an optional in-app gentle stop
- No ads, no child account, no new permissions

## Visual theme release (0.1.2)

Fox and purple theme across Home, Explore with category pages, Play again, Rewards, onboarding, every game screen and completion summary, the locked screen, the grown-up gate, settings, the learning summary, More activities, and About and privacy. Nunito font (OFL) and the theme illustrations are bundled; see `docs/asset_licenses.md`. Activity titles are no longer numbered, and level numbers are shown separately. The daily reminder is shown as not available, because this version sends no notifications. Schema, entitlement (5 free completions per engine), subscription logic and signing are unchanged.

Both files were built from the clean copy `AppData\Local\Temp\sproutlab-apk` and signed with the upload key (certificate SHA-256 `64:8D:88:…:5E:17`, as below).

- `artifacts\sproutlab-0.1.2-release.apk`: `flutter build apk --release`, 63,091,510 bytes, SHA-256 `02E625B505096A3B7CC569103DF30C19C704618E13AC1657A288B1193933CB7C`, APK Signature Scheme v2 verified with `apksigner`
- `artifacts\sproutlab-0.1.2-release.aab`: `flutter build appbundle --release`, 61,724,073 bytes, SHA-256 `7243E60E08CC2C8EB838F446DF77FBA6D1C9A5F92BF6E254A2E41EE957B625E3`, `jarsigner -verify`: jar verified. Flutter printed the same `apkanalyzer` strip message described below
- Package `com.sproutlab.kids`, versionName `0.1.2`, versionCode `3`
- Checks: `flutter analyze` no issues; `flutter test` 72 passed, including `test/screen_smoke_test.dart`, which renders Home, Explore, Rewards, Play again, every category page and the completion summary on 320 dp and 411 dp phones, a 800 dp tablet, at 2× text, and with no saved progress, failing on any layout overflow or exception
- Not run: emulator or device install, TalkBack, Play Billing sandbox. No new store screenshots were taken

## Release bundle (0.1.0)

One file covers both testing tracks. Upload it to internal testing, then promote that same release to open testing. Do not upload the debug APK.

- Command: `flutter build appbundle --release`
- Gradle `bundleRelease`: success, about 1535.9s
- Flutter then exited 1 because Android `cmdline-tools` / `apkanalyzer` are not installed, so its symbol check could not read the bundle. The bundle itself contains stripped `libapp.so` and `libflutter.so` for arm64-v8a, armeabi-v7a, and x86_64, plus matching `BUNDLE-METADATA/.../*.so.sym` files.
- Build path: `build\app\outputs\bundle\release\app-release.aab`
- Copy: `artifacts\app-release.aab`
- Size: 59,731,262 bytes
- SHA-256: `78D3ECBBD475B479DA2CD7564C543727C83B2919BD70F530DEE64B554FEA9822`
- Package: `com.sproutlab.kids`
- versionName `0.1.0`, versionCode `1`
- `jarsigner -verify`: jar verified
- Upload certificate: `CN=SproutLab Upload, OU=Android, O=SproutLab, C=IN`
- Certificate SHA-256: `64:8D:88:8D:EE:6A:94:F7:5C:25:56:51:5E:74:E2:C0:9C:73:5E:81:76:56:6B:8D:7E:7F:29:E1:3D:B4:5E:17`
- Valid from 2 October 2026 until 17 February 2054
- This is the upload key. Play App Signing keeps a separate app signing key after the first upload.

The keystore is `android\upload-keystore.jks`. The password is only in `android\key.properties`. Both are gitignored. Back them up before the first Play upload.

## Still open

- The in-app subscription id is empty, so purchase testing stays off until a Play subscription id is created and written into the app
- Editorial sign-off for the 100 knowledge facts
- Final artwork for the 24 spot-the-difference activities
- Device, TalkBack, and Play Billing sandbox checks
- The visible name and application id are still marked temporary in app code. This bundle uses SproutLab and `com.sproutlab.kids`

## App icon and branding (0.1.1)

The sprout-only icon was replaced with the approved fox/book/sprout artwork. See `docs/asset_licenses.md`.

- Play icon: `artifacts\sproutlab-play-icon-512.png`, 512 × 512, RGB PNG with no alpha channel, 276,278 bytes
- Feature graphic: unchanged
- Adaptive icon: `mipmap-anydpi-v26/ic_launcher.xml` and `ic_launcher_round.xml`, with foreground `mipmap-*/ic_launcher_foreground.png`, background colour `#FEFAEF`, and monochrome `mipmap-*/ic_launcher_monochrome.png`
- Legacy icons for Android 7: `mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png` and `ic_launcher_round.png`, 48 to 192 px
- The manifest now uses `@mipmap/ic_launcher` and `@mipmap/ic_launcher_round`. Before this it pointed at a vector drawable, so the adaptive icon was never used
- Splash: Android 12+ uses the system splash with the adaptive icon on `#FEFAEF` (`values-v31`, `values-night-v31`). Android 11 and lower show `drawable-*/launch_brand.png` from `launch_background.xml`. Each version shows one splash, and no delay was added
- In app: `assets/brand/sproutlab_fox.png` through `BrandMark` on the welcome page and the About screen
- Previews: `artifacts\icon-previews\adaptive_masks.png` (circle, squircle, rounded square and teardrop masks, with the 66 dp safe zone in red), `small_sizes.png`, `themed_monochrome.png`

## Debug artifact

Built 2 October 2026 from a clean copy of this tree, `C:\Users\MSUSERSL123\AppData\Local\Temp\sproutlab-apk`, because the project `build` folder has locked audio files (`errno 183` on `correct.wav`). Gradle used the existing cache at `AppData\Local\Temp\cursor-sandbox-cache\...\gradle`. Its damaged `caches\9.3.1\transforms` folder was moved aside and rebuilt.

- Command: `flutter build apk --debug`
- Gradle `assembleDebug`: success, about 1113s
- Copy: `artifacts\app-debug.apk`
- Size: 165,915,775 bytes
- SHA-256: `75F142C01BB2ECD64F571FBC1B6DEB87F4920770E9BFE8A9F23CE4BE7E16AFC9`
- Package: `com.sproutlab.kids`
- versionName `0.1.1`, versionCode `2`
- Icon: `res/mipmap-anydpi-v26/ic_launcher.xml`
- minSdk 24, targetSdk 36, compileSdk 36
- Label: SproutLab
- `aapt dump badging` reports `application-debuggable`
- Permissions: `INTERNET`, `com.android.vending.BILLING`, `ACCESS_NETWORK_STATE`, plus the app's own dynamic-receiver permission
- No `RECORD_AUDIO`. No `AD_ID`
- Native ABIs: arm64-v8a, armeabi-v7a, x86_64
- Signing: APK Signature Scheme v2, certificate `CN=Android Debug`, SHA-256 `7c28f860888412129eea6769fed604a69e1edf2580ebe458255a1fffae977ef8`
- This is a debug certificate. It is not an upload key.

## Checks run

- `flutter analyze`: no issues
- `flutter test test dist`: the full set was run; five failures were fixed and those tests were run again successfully
- Contrast ratios in `docs/ui_review.md` come from `test/contrast_test.dart`
- 1,000 deterministic maths, pattern, and maze cases passed
- Tic-Tac-Toe rules, scores, the 500-activity counts, badge idempotency, and the daily-adventure exclusion passed

## Checks not run

- No Android emulator or device was connected, so the APK was not installed or smoke-tested
- TalkBack was not run
- Play Billing sandbox was not run
- `flutter build appbundle --release` produced the signed bundle above. Flutter's own success line did not print because `apkanalyzer` is missing
- bundletool was not used

Toolchain used for this build: Flutter 3.47.5 at `C:\src\flutter`, Dart 3.13.4, Android SDK build-tools 37.0.0, Java from the Android Studio JBR.
