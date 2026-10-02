# SproutLab

Temporary engineering name for an offline-first kids learning app.
Android is the V1 target. The visible name and application id are not
approved for Google Play.

## Toolchain

- Flutter 3.47.5 stable, at `C:\src\flutter`
- Dart 3.13.4
- Android SDK at `%LOCALAPPDATA%\Android\Sdk`
- Java 17 from the Android Studio JBR

If `flutter` is not on PATH, call `C:\src\flutter\bin\flutter.bat`.

## Commands

```text
flutter pub get
dart format .
flutter analyze
flutter test
flutter build apk --debug
```

The debug APK is for local installation. It is not a Play release.

`flutter build appbundle --release` is not a Play upload until the owner
supplies `android/key.properties` and an upload keystore that is kept
out of source control. Release builds do not use the debug keystore.
Do not commit `key.properties`, `.jks`, or `.keystore` files.

## What this tree contains

Onboarding, one local child profile, six games, Today's Adventure,
rewards, a parent area, audio settings, the five-free-activity rule,
and a Play Billing path that stays off while the subscription id is
empty. Learning data stays in SQLite on the device.

See `BUILD_INFO.md` for toolchain and artifact records, `M10_AUDIT.md`
for privacy and permissions, and `M11_RELEASE.md` for the open-testing
handoff.
