# Storage, performance and audit notes

Date: 3 October 2026. These are engineering observations, not invented device benchmarks.

## Storage model (section 7)

Kept the existing layout:

- Drift/SQLite for progress, settings, entitlements and content indexes.
- Bundled files for maps, fonts, category art and short WAV tones.
- Content records hold asset paths / clip ids, not base64 image payloads.

No wholesale BLOB migration. Current bundled audio is about 305 KB total. Map geometry is tens of KB of JSON. Encoding those as SQLite BLOBs would not reduce size.

Compression: existing JPEG category art and WAV tones were left as-is. No extra archive compression was applied. Encryption was not added for public maps or drawings. Profiles remain in local SQLite. Client-side media encryption would not prevent extraction of playable assets and was not requested with a measured size budget.

No downloadable packs in this version. No executable downloads.

## Performance (section 8)

Catalogue selection uses in-memory `ActivityCatalog` slots and indexed Drift lookups for progress. Generators compute one activity from a seed; they do not rebuild all 1,000 items on each frame.

Map and scene hit tests share the same transform as drawing. Difference and find-object scenes use a small authored target list, not a spatial index.

No device or emulator was connected, so cold start, frame timing, peak memory and import time were **not measured**. Do not treat earlier arm64 size notes from 3 October (`docs/india-learning-implementation-status.md`) as this build’s numbers.

## Screen audit (section 9)

Automated coverage:

- Widget tests for Home/Explore/category smoke, geography, heritage, find-objects, difference hits, maze reachability, audio controller lifecycle, region gating and library counts.
- Generator stress: 1,000 maths, pattern and maze seeds.

Not run (mark unverified):

- Device install, offline first launch, headphone/Bluetooth, call audio focus.
- Actual audible Hear / Hindi / music playback.
- TalkBack, large-text on a physical phone, landscape tablet beyond widget constraints.
- Play Billing sandbox.
- Educator review of facts, Hindi audio, monument identity and Survey of India rights.

## Rights manifest pointer

See `docs/asset_licenses.md` and `assets/content/geography/geography_asset_manifest.json`. Maps remain Natural Earth 50m public domain, not Survey of India. Heritage pictures remain original drawings. Narration files remain absent.
