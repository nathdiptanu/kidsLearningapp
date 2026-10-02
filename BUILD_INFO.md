# BUILD_INFO

Recorded from the machine that created this project. Do not treat this as a Play-ready release record.

## Toolchain

- Flutter: 3.47.5 stable
- Flutter framework revision: 6a19cca564
- Engine revision: af7e796e16
- Dart: 3.13.4
- DevTools: 2.60.0
- Flutter SDK path: C:\src\flutter
- Java: 17.0.7 (Android Studio JBR also present)
- Android SDK: C:\Users\MSUSERSL123\AppData\Local\Android\Sdk
- Android SDK reported by flutter doctor: 36.1.0
- Installed platforms: android-35, android-36, android-36.1
- Installed build-tools: 34.0.0, 36.0.0, 36.1.0, 37.0.0
- Gradle wrapper: 9.3.1
- Android Gradle Plugin: 9.1.0
- Kotlin plugin: 2.4.0
- Flutter default compileSdk: 36
- Flutter default minSdk: 24
- Flutter default targetSdk: 36
- Flutter default NDK: 28.2.13676358
- cmdline-tools: not installed when M0 started
- Android licenses file exists; flutter doctor still reported license status unknown because cmdline-tools were missing

## Application identity

- Visible name: SproutLab (temporary codename)
- Application id: com.sproutlab.kids (temporary, not approved for Play upload)
- Namespace: com.sproutlab.sproutlab (generated Flutter package)
- Version: 0.1.0+1
- Learning locale constant: en-IN

## Direct dependencies resolved by pub

- drift 2.35.0
- flutter_riverpod 3.4.3
- path 1.9.1
- path_provider 2.1.6
- drift_dev 2.35.0 (dev)
- build_runner 2.16.1 (dev)
- flutter_lints 6.0.0 (dev)
- sqlite3 3.5.2 (direct, because the database opener imports it; bundles SQLite through Dart hooks)
- in_app_purchase 3.3.0
- in_app_purchase_android 0.5.3
- url_launcher 6.3.2
- audioplayers 6.5.0

sqlite3_flutter_libs 0.6.0+eol was not kept. Its publisher says that version does nothing and is obsolete after sqlite3 3.x.

## Schema

SQLite schema version 5. Upgrading from version 1 adds local settings. Upgrading from version 2 adds generator metadata columns and keeps existing completions. Upgrading from version 3 adds skill outcome columns, daily-journey role and done flags, and the activity checkpoint table. Upgrading from version 4 adds the practice-day table used for Five-Day Learner. Existing reward rows and activity progress are kept. An unknown future schema version throws instead of deleting progress.

## Debug APK

Built on this machine on 30 Sep 2026 after M10. This binary includes M8 billing source, M9 audio, and the M10 privacy fixes. Billing was not exercised against Play. Performance acceptance on a device is pending. See `M10_AUDIT.md`.

- Command: `flutter build apk --debug`
- Result: success, Gradle `assembleDebug` about 74.0s, exit code 0
- Output: `build\app\outputs\flutter-apk\app-debug.apk`
- Size: 203830957 bytes
- SHA-256: `C010320864E43434108E2C5BFC43E8F67BC129F02D01D9B5C2A587411A6526D4`
- Application id: `com.sproutlab.kids` (temporary, not approved for Play)
- Version: 0.1.0+1 (versionCode 1, versionName 0.1.0)
- `aapt dump badging` confirms package name, version, label SproutLab, minSdk 24, targetSdk 36
- Debug APK permissions from `aapt dump permissions`: `INTERNET`, `com.android.vending.BILLING`, `ACCESS_NETWORK_STATE`, and the app's own dynamic-receiver permission. No `RECORD_AUDIO`. No `AD_ID`.

This is a debug APK for device testing. It is not a signed release app bundle and it is not store-ready. Purchases are not verified.

## Profile APK

Built on this machine on 30 Sep 2026 for later device profiling. It was not installed and no frame timings were taken from it.

- Command: `flutter build apk --profile`
- Result: success, Gradle `assembleProfile` about 373.8s, exit code 0
- Output: `build\app\outputs\flutter-apk\app-profile.apk`
- Size: 79075295 bytes
- SHA-256: `4E22E16F6329A87E691C0954ADAFF31104A12DC890BC1804821C2AA887A131D5`
- Same application id and version as the debug APK

The previous M9 debug APK had SHA-256 `6E7610025F6EC505DA493841E4CD127063EC03D989BD99E86982C18AB1308EA4`.

The previous M7 debug APK had SHA-256 `A23F8BB6B6A8A3061EBE35D77F73E3A4C508302B4F221082F2AE0BF0AFE05790` and did not contain M8 or M9.

The previous M6 debug APK had SHA-256 `57618AE33D186217CB66D1415E4E1D16CA10AB7FF42E46A529ED580933838D2A`.

The previous M5 debug APK had SHA-256 `4C0DACA8B6BB1822EC98B5A5E14BE12BE3A2EC2CEE23877FB28E9901A96DF7E6`.

Java on this PC still needs the local truststore for Gradle downloads:

`JAVA_TOOL_OPTIONS=-Djavax.net.ssl.trustStore=C:\src\gradle\jssecacerts -Djavax.net.ssl.trustStorePassword=changeit`

## M7 status

M0–M6 remain. Schema stays at version 5. M7 does not add a table and does not delete activity progress, rewards, practice days, or the entitlement cache.

Access rules:

- `FreeEntitlementPolicy` is the access decision for Explore, Daily Adventure, and game routes.
- Five successfully completed unique free activities per game category. The count uses `countedAsFree` on the category storage key, not the learning band, seed, or generator version.
- The activity identity is the catalog slot, such as `maths:v1:A:0`. A new seed updates that slot and does not create another free level.
- Opening, leaving, a bad checkpoint, or backing out does not write a free completion.
- Replay updates last played, attempts, and best stars. It does not increment the free count.
- A checkpoint for an unfinished activity stays `continueInProgress` after the allowance is full, so a started game is not interrupted by the locked screen.
- Completion and allowance consumption are one Drift transaction and a second completion callback for the same activity is a replay.

Migration assumptions:

- Existing `counted_as_free` rows remain the allowance. They are not recounted or deleted.
- A missing entitlement-cache row stays inactive. It is not treated as Premium.
- Cached entitlement rows are kept. Price is not stored.
- An unknown future schema version still throws instead of wiping the database.

Parent gate:

- Grown-up settings, the learning summary, and Premium each open behind a 3-second hold, including a direct route.
- Authorization is in memory only. Leaving the parent route, or the app moving to paused or hidden, clears it. Nested parent pages opened from settings do not clear the page still underneath.
- Early release says “Hold a little longer.”
- Child controls never receive the billing gateway.

Premium UI:

- Parent copy explains the five-free rule, permanent replay, and the planned Premium library.
- Purchase and restore buttons are disabled. This build says store purchases are not connected.
- ₹199 is not shown. The localized price waits for Google Play metadata in M8.
- An injected active entitlement can show “Premium is active on this device.” That path is for tests. The default gateway does not grant Premium.

## M8 status

M8 is in source. Schema stays at version 5. No entitlement row, completion, reward, or practice day is deleted.

Billing:

- `in_app_purchase` 3.3.0 and `in_app_purchase_android` 0.5.3. The Android implementation uses Google Play Billing Library 8.0.0.
- `url_launcher` 6.3.2 opens the Play subscription page from the parent Premium screen only.
- `BillingProductConfig.annualSubscriptionId` is empty. No product id, base plan, or offer was invented. Until the owner sets the Play Console id, purchase, restore, and subscription management stay disabled and no price is shown.
- On Android, after that id is set, `PlayStoreBillingPort` loads localized price, billing period, and eligible offers from Play. Blank store prices are rejected. ₹199 is not a live price.
- A purchase callback does not grant Premium. The app queries Play, acknowledges an unacknowledged purchase, queries again, and only then writes the cache.
- Pending payment and a failed acknowledgement stay free. Duplicate purchase keys collapse to one cache row.
- Restore uses `queryPurchasesAsync` through the plugin. It is idempotent.
- There is no Play Developer API backend. The client cannot see expiry time, and it cannot tell grace from active, or pause from account hold. Those states are stored only when a future `SubscriptionVerifier` supplies them. A verifier failure does not grant Premium.
- When Play returns an owned subscription and no expiry, Premium lasts 7 days after the last successful check, then needs another check. A known expiry, once a verifier provides one, is the bound instead. A missing expiry is not permanent Premium.
- A failed or offline Play check keeps the last cache. A successful check that no longer returns the subscription marks it expired and leaves learning history and rewards in place.
- Reconciliation runs at startup and when the app resumes. It does not open a purchase sheet or interrupt a started game.
- No production switch grants Premium.

Play sandbox purchase, pending payment, cancellation, renewal, expiry, and restore were not run. No Play-distributed build was installed.

## Play setup still required

1. Approve the final application ID before the first Play upload. The current id `com.sproutlab.kids` is temporary.
2. Create the app in Play Console and upload a licensed test build with that id.
3. Create one subscription and its base plan. Copy the subscription id into `BillingProductConfig.annualSubscriptionId`. Optionally set `basePlanId` and `offerId` to the Play ids. Leave them empty to buy the regular base plan Play returns.
4. Set the price and any offer in Play Console. Do not put ₹199 in code.
5. Add license testers, or use an internal testing track. Install from that track. Sideloading a debug APK does not complete real purchases.
6. Add a privacy policy URL before store listing. This build does not open one.
7. Prepare signing for a release AAB only after the identity is approved. No release AAB was built.
8. Confirm the merged manifest has `com.android.vending.BILLING` from the billing library and does not add `AD_ID`. The M9 debug APK dump includes `BILLING` and does not include `AD_ID`.

License-tester checks after that setup: purchase, cancel the sheet, pending payment, successful purchase, restore on a second launch, cancel renewal while access remains, expiry or refund, and offline use inside the 7-day window. Those are not done.

## M9 status

M9 is in this debug APK. Schema stays at version 5. Saved progress, the five-free rule, the parent hold, and the application id are unchanged.

Audio uses one effects player and one quieter music player. Effects default on. Music defaults off. The spoken-instructions switch is saved and plays nothing, because no reviewed pronunciation clips are bundled. Games stay playable with sound off. There is no microphone permission.

Avatars, stickers, vocabulary pictures, and find-the-difference scenes remain original drawings. `productionReady` stays false. There are no 1600x1200 master PNG pairs. See `assets/content/audio_provenance.json`, `illustration_provenance.json`, and `sticker_provenance.json`.

Analyzer: no issues. Tests: 89 passed. Widget screenshots are in `build/m9_review/`. No Android phone or emulator was connected, so TalkBack, a physical contrast check, hardware background, and airplane mode were not run.

## Remaining milestones

M10 is recorded in `M10_AUDIT.md`. Device performance acceptance is still pending.
M11 Release hardening, signed AAB, and the open-testing checklist.
