# SproutLab Play release 0.1.9 (11)

Date: 29 October 2026. Package `com.sproutlab.kids`. Signed with the existing SproutLab upload key. This bundle exists so Play can upgrade users past `versionCode` 10.

## Play Console fields

**Release name**

```text
0.1.9 (11) — More play, teach then try
```

**Release notes (en-US, under 500 characters)**

```text
More maths, words, mazes, and India facts for ages 3–7. Levels open one after another. Short lessons come before times, share, grammar, Hindi letter-words, and India map questions. New connect-the-dots paths. Culture and language notes sit under the real India map. Existing progress and the five free new levels per game stay the same.
```

## How to upload

1. Create a new Production release.
2. Upload only this file:
   `release-output/sproutlab-0.1.9+11-play-release.aab`
3. Confirm the release lists version code **11**, then Preview and confirm.

`versionCode` 11 is higher than 10, so existing testers and users can upgrade.

## AAB (not committed)

| Field | Value |
|---|---|
| File | `release-output/sproutlab-0.1.9+11-play-release.aab` |
| Version name / code | `0.1.9` / `11` |
| Size | 130,088,318 bytes (124.1 MB) |
| SHA-256 | `03C35686B0FF9440767E8512FE8463E4BD66A45949D2564A30A316B5C911EB97` |
| Signer | `CN=SproutLab Upload, OU=Android, O=SproutLab, C=IN` |
| `jarsigner -verify` | `jar verified.` |

Store AAB was built without `--dart-define=UNLOCK_ALL_GAMES`.

## Honest limits

0 educator-approved Hindi audio. Device TTS is interim and not reviewed. Extra monument facts reuse the six licensed photos. No new monument photographs. Play Console upload, store install, and billing were not run here. `apksigner` cannot verify AABs; that is not a failure.
