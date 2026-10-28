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

1. On the current **Preview and confirm** page, click **Discard draft release**. Do not click **Proceed anyway**. That empty draft has no bundle, so Play shows 0 devices and “you cannot remove all production APKs”.
2. Create a new Production release.
3. Upload only this file:
   `release-output/sproutlab-0.1.9+11-play-release.aab`
4. Confirm the release lists version code **11** and that phones/tablets are supported again, then Preview and confirm.

`versionCode` 11 is higher than 10, so existing testers and users can upgrade.

## AAB (not committed)

| Field | Value |
|---|---|
| File | `release-output/sproutlab-0.1.9+11-play-release.aab` |
| Version name / code | `0.1.9` / `11` |
| Size | 130,088,273 bytes (124.1 MB) |
| SHA-256 | `156D0AF44945F75CC6F9002C5561A259E7A897B2A966D6B5F710D4339F541A21` |
| Signer | `CN=SproutLab Upload, OU=Android, O=SproutLab, C=IN` |
| `jarsigner -verify` | `jar verified.` |

Store AAB was built without `--dart-define=UNLOCK_ALL_GAMES`.

## Honest limits

0 educator-approved Hindi audio. Device TTS is interim and not reviewed. Extra monument facts reuse the six licensed photos. No new monument photographs. Play Console upload, store install, and billing were not run here. `apksigner` cannot verify AABs; that is not a failure.
