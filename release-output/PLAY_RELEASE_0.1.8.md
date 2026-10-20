# SproutLab Play release 0.1.8 (10)

Date: 20 October 2026. Package `com.sproutlab.kids`. Signed with the existing SproutLab upload key. This bundle exists so Play can upgrade users past `versionCode` 9.

## Play Console fields

**Release name**

```text
0.1.8 (10) — India Learning
```

**Release notes (en-US, under 500 characters)**

```text
Hindi Learning and Discover India for ages 3–7 when India is selected. Teach-then-try India map, neighbours, capitals, and real monument photos. Dedicated mazes, ages 2–3 parent-led play, Tic-Tac-Toe with two players or computer first, and optional background music. Existing progress, profiles, and the five free new levels per game are unchanged.
```

## How to upload (avoids the previous errors)

1. Discard or abandon the empty **0.1.7 (9)** production draft that had no new bundles.
2. Create a new Production release.
3. Upload only this file (do not re-upload the 0.1.7+9 AAB):
   `release-output/sproutlab-0.1.8+10-play-release.aab`
4. Confirm the release lists version code **10**, then Preview and confirm.

`versionCode` 10 is higher than 9, so existing testers and users can upgrade.

## AAB (not committed)

| Field | Value |
|---|---|
| File | `release-output/sproutlab-0.1.8+10-play-release.aab` |
| Version name / code | `0.1.8` / `10` |
| Size | 129,904,549 bytes (123.9 MB) |
| SHA-256 | `5951842650192DB8C7EFC9F1F368DF0B54F2CD026E46CB284F7942E36A4A9C65` |
| Signer | `CN=SproutLab Upload, OU=Android, O=SproutLab, C=IN` |
| `jarsigner -verify` | `jar verified.` |

## Honest limits

Same app content as 0.1.7. Play Console upload, store install, and billing were not run here.
