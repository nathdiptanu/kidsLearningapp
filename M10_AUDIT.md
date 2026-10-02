# M10 audit

Recorded 30 Sep 2026 from this machine. This is an engineering audit of the current SproutLab source. It is not a Play Data Safety submission, a Families-policy sign-off, or a store-readiness claim.

## Outcome

Local learning data was eligible for Android backup. Backup and device transfer of the app database are now excluded, and cleartext traffic is off. Debug diagnostics no longer print raw errors, nicknames, or purchase-token text. A grown-up About page describes what this build actually stores and sends. Maze hint paths are cached for the current cell. No analytics or crash SDK was added.

Physical-device performance acceptance is pending. No Android phone or emulator was connected.

## Fixes

- `android:allowBackup="false"`, with `backup_rules.xml` and `data_extraction_rules.xml` excluding the database, files, shared preferences, and root.
- `android:usesCleartextTraffic="false"`.
- `LocalLog` prints only in debug, drops messages that mention a nickname or purchase token, and keeps each line under 240 characters. Bootstrap and entitlement refresh no longer log exception text or stack traces.
- Parent area → About this app (`lib/features/parent/privacy_screen.dart`), behind the existing hold.
- Maze hint cells are computed once per player cell and hint stage.

Schema stays at version 5. Application id, progress, the five-free rule, and the parent hold are unchanged. The subscription id is still empty, so this build does not call Google Play Billing.

## Data on the device

SQLite file `sproutlab.sqlite`, private app storage. Nothing in this inventory is sent by learning or gameplay.

| Data | Use | Leaves the device |
| --- | --- | --- |
| Optional nickname, avatar id, age band | Greeting and learning band | No. Nickname is absent from logs. |
| Activity progress, stars, hints, generator seed and version | Resume, free allowance, parent summary | No |
| Checkpoints | Resume an unfinished activity | No |
| Daily journey and practice days | Today's Adventure and the five-day badge | No |
| Rewards | Stickers and badges | No |
| Sound, music, narration, onboarding draft | Settings | No |
| Entitlement cache: product id, status, expiry, last check time | Offline Premium window | No. No purchase token and no price are stored. |

A purchase token exists only in memory while a future Play query is handled. It is not written to SQLite.

Network in this build:

- Learning, Home, games, rewards, and the parent summary do not open a connection.
- Billing stays on `InactiveBillingGateway` while the subscription id is empty. It reads the local cache only.
- `url_launcher` is used only after a grown-up asks to open Play subscription settings. With no product id, that action does not open.
- No analytics, crash reporter, ads SDK, or child account.

Retention: rows stay until uninstall or storage clear. Backup and device transfer of the database are turned off. A bad checkpoint restarts that activity and does not delete progress. Schema upgrades through version 5 keep existing rows.

## Permissions

Source manifests: main has no `uses-permission`. Debug and profile add `INTERNET` for Flutter tooling. Release source does not.

Merged manifests after this build:

| Permission | Debug APK | Profile APK | Release merged manifest | Why it is present |
| --- | --- | --- | --- | --- |
| `INTERNET` | Yes | Yes | Yes | Debug and profile manifests, and the Play Billing / Play services graph in every variant |
| `com.android.vending.BILLING` | Yes | Yes | Yes | Billing Library 8.0.0. Required for a later purchase. Not called while the product id is empty. |
| `ACCESS_NETWORK_STATE` | Yes | Yes | Yes | Same billing / Play services graph |
| App signature permission `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | Yes | Yes | Yes | AndroidX. Not a user-facing permission. |

Not present in the debug APK, profile APK, or release merged manifest: location, contacts, SMS, phone, camera, microphone, storage, `AD_ID`.

`MainActivity` is exported for the launcher. Billing proxy activities and the Play transport services are exported false. `ProfileInstallReceiver` is exported and limited to `android.permission.DUMP`. That is the AndroidX profile installer, not a child-data export.

Debug and profile manifests set `debuggable`. The release merged manifest does not. Release signing in `android/app/build.gradle.kts` still points at the debug keystore. That is an M11 blocker, not a release artifact.

## Dependencies

Direct packages, from `pubspec.lock` and each package `LICENSE`:

| Package | Version | Purpose | License |
| --- | --- | --- | --- |
| drift | 2.35.0 | SQLite access | MIT |
| flutter_riverpod | 3.4.3 | App state | MIT |
| audioplayers | 6.5.0 | One effects player and one music player | MIT |
| in_app_purchase | 3.3.0 | Billing interface | BSD-3-Clause |
| in_app_purchase_android | 0.5.3 | Play Billing Library 8.0.0 | BSD-3-Clause |
| url_launcher | 6.3.2 | Parent subscription page only | BSD-3-Clause |
| path | 1.9.1 | Database file path | BSD-3-Clause |
| path_provider | 2.1.6 | App documents directory | BSD-3-Clause |
| sqlite3 | 3.5.2 | SQLite engine bundled at build time | MIT |

`shared_preferences` is not in the lockfile. App code does not import `package:http`. `http` is transitive through audioplayers and is not used for learning. `in_app_purchase_storekit` is transitive for a later iOS build and is not the Android billing path. No ads, Firebase, Sentry, or crash SDK is locked.

Newer versions are listed by the resolver for several packages, including audioplayers 6.8.1 and in_app_purchase 3.3.1. They were not upgraded in this pass.

Advisory check on 30 Sep 2026: a search of OSV/NVD for these package names did not return a CVE for audioplayers 6.5.0, in_app_purchase 3.3.0, drift 2.35.0, or the Dart sqlite3 package. CVE-2026-27704 is a pub-cache zip-slip fixed in Dart 3.11.0 and Flutter 3.41.0. This machine has Dart 3.13.4 and Flutter 3.47.5. Dependencies are from pub.dev. That search was not a complete scan of every transitive package.

Play Billing pulls Play services and a non-exported data-transport scheduler. This app does not configure that transport and does not add an analytics SDK. Removing Billing would remove the permission and the scheduler, and would also remove the approved purchase path.

## Performance

Not measured on a device. `flutter devices` showed Windows, Chrome, and Edge only. DevTools Performance/Memory, profile-mode frame timing, startup, memory, and airplane mode were not run. Debug timings are not used as release numbers.

The profile APK below was built for that testing and was not installed.

Local SQLite check, `flutter test`, in-memory database, Windows, 30 Sep 2026: 200 activity rows were inserted, then the profile list and parent summary were read. Elapsed time was 60 ms. The parent summary uses SQL totals and returns 20 recent rows. Product activity ids are catalog slots, so a normal profile does not grow a new row for every generated seed.

Startup reads one bundled content manifest and opens SQLite. Explore and Rewards are built on first visit. Game screens are pushed when an activity opens.

## Checks that did not run

- Profile or release frame timing, jank, startup, and memory on a phone.
- Airplane mode, process death, and hardware background on a phone.
- A full OSV scan of every transitive package.
- A signed release APK or AAB.

Automated coverage that did run: analyzer clean, 92 tests passed, including the 60 ms history read, log redaction, the about page, schema migration, a bad checkpoint, and offline entitlement rules in unit tests.

## Play Data Safety inputs

These are notes for a later form. They were not submitted.

- Data stored on device: optional nickname, avatar, age band, learning progress, rewards, settings, entitlement status cache.
- Data not stored: purchase token, price, exact date of birth, location, contacts, photos, audio recordings.
- No child account. No analytics. No advertising id.
- Learning does not leave the device.
- A future grown-up purchase or restore would contact Google Play and would not include the nickname or learning history. This binary does not make that call.
- A public privacy-policy URL is still required before a store listing. This app does not open one.

## M11 still open

- Approved application id, public name, and signing. Release Gradle still uses the debug keystore.
- Play subscription id, license testers, and a privacy-policy URL.
- Signed release AAB.
- Device performance acceptance on the profile APK.
- Final art, 1600×1200 difference masters, and OGG audio. Current drawings and WAV tones are marked not production-ready.
- Store rating questionnaire. No rating was invented.
