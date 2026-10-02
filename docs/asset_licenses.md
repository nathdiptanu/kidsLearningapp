# Asset licenses

Date: 2 October 2026.

## Type

Nunito is the interface font from version 0.1.2. It is bundled, not downloaded at run time. Copyright 2014 The Nunito Project Authors, licensed under the SIL Open Font License 1.1; the licence text ships beside the files as `assets/fonts/Nunito-OFL.txt`. The static Latin files came from the Fontsource build of the Google Fonts release (`cdn.jsdelivr.net/fontsource/fonts/nunito@latest/latin-{400,600,700,800}-normal.ttf`) on 2 October 2026. Glyphs outside Latin fall back to the system font.

| File | Bytes | SHA-256 (first 16) |
|---|---|---|
| `assets/fonts/Nunito-400.ttf` | 39,332 | `0F050BE91A610576` |
| `assets/fonts/Nunito-600.ttf` | 39,436 | `6C35AA6494C36471` |
| `assets/fonts/Nunito-700.ttf` | 39,284 | `5D6AC65FAF738568` |
| `assets/fonts/Nunito-800.ttf` | 39,300 | `1804F686F4A8FE64` |

### Noto Sans Devanagari (Hindi)

Added on 3 October 2026 for Hindi text. It is a fallback in every theme text style (`SproutType.fallback`), so Latin text stays in Nunito and Devanagari characters use Noto. Copyright 2022 The Noto Project Authors (github.com/notofonts/devanagari), licensed under the SIL Open Font License 1.1; the licence text ships as `assets/fonts/NotoSansDevanagari-OFL.txt` (copied from the google/fonts repository). The font files are the Devanagari-subset static TTFs from the Fontsource build of the Google Fonts release, font version 2.006 in the name table. They contain no Latin glyphs.

| File | Bytes | SHA-256 (first 16) |
|---|---|---|
| `assets/fonts/NotoSansDevanagari-400.ttf` | 189,564 | `DE3B255978EA080F` |
| `assets/fonts/NotoSansDevanagari-700.ttf` | 190,152 | `98714C3F46B6F3DE` |
| `assets/fonts/NotoSansDevanagari-OFL.txt` | 4,386 | `A216F6F8D85C7228` |

Coverage was checked with fontTools: all 60 tested code points are present (independent vowels, consonants, vowel signs, ं ँ ः ् ़ ।), and the GSUB/GPOS tables carry the `deva` and `dev2` scripts used for matras and conjuncts. A widget test renders matras and conjuncts at 1× and 2× text. Rendering on a real device has not been checked yet.

## Language development sample (3 October 2026)

`assets/content/language_asset_manifest.json` lists every narration clip, stroke template and picture used by the Hindi/English sample lessons. Every row is `PLACEHOLDER`. There are no reviewed recordings and no local audio files. Stroke templates are engineering polylines, not font outlines, and they are excluded from release packs. Pictures are temporary `WordPicture` drawings. The supplied alphabet chart was not copied.

## Theme illustrations (0.1.2)

Separate pictures used by the Home, Explore, game header and completion screens. None of them contain interface text; every title, count and button is a real Flutter widget drawn on top. The concept mockups were used only as style references and are not bundled.

Source: generated on 2 October 2026 with the image-generation tool in Cursor for this project, from written prompts. The fox prompt used the owner-approved fox/book/sprout artwork as its reference so the character matches; the category prompts used the owner-supplied Explore and Home concept images as style references. Post-processing (`make_art.py`, kept outside the repository): category pictures cropped to 16:9 and resized to 640 × 360 JPEG at quality 84; the fox background was removed by edge flood fill and the result resized to 512 × 512 PNG with alpha.

Rights: no third-party stock or character art was used. The owner should confirm these generated pictures are acceptable as project artwork before a store release, in the same way the fox icon was approved.

| File | Shows | Bytes | SHA-256 (first 16) |
|---|---|---|---|
| `assets/art/fox_wave.png` | The SproutLab fox waving, holding a sprout | 311,241 | `64E388B80496C5C4` |
| `assets/art/category_maths.jpg` | Stacked 1, 2, 3 blocks | 12,522 | `BECB0F495376A2C3` |
| `assets/art/category_english.jpg` | Open book with an apple | 18,794 | `14881B798E3AD515` |
| `assets/art/category_logic.jpg` | Star, triangle and ball with a sun | 14,540 | `90B04E3AE4D4E6EF` |
| `assets/art/category_observation.jpg` | Two lion cards and a magnifier | 23,515 | `573251DCDFBF28F6` |
| `assets/art/category_knowledge.jpg` | Globe, sapling and sun | 21,924 | `4FFAB1DE531230B4` |
| `assets/art/category_tictactoe.jpg` | Board with crosses and circles | 19,848 | `001564D34F2528F1` |
| `assets/art/category_maze.jpg` | Garden path to a flag | 24,217 | `0E33B5A6951DEAE2` |

### Regional category pictures (3 October 2026)

Made the same way and with the same post-processing as the category pictures above (Cursor image tool, Explore concept as the style reference, 640 × 360 JPEG at quality 84). They contain no letters, text, flags, maps or monuments, so they make no factual claim. The Hindi letters on the card (अ आ) are live text drawn by the app in Noto Sans Devanagari, not part of the picture. A first Discover India picture showed a pocket watch instead of a compass and was discarded.

| File | Shows | Bytes | SHA-256 (first 16) |
|---|---|---|---|
| `assets/art/category_hindi.jpg` | A blank writing slate with a pomegranate and a mango | 22,023 | `DE00A6A4BB4F08EB` |
| `assets/art/category_discover_india.jpg` | A small train, green hills, a river and a compass | 32,154 | `3ACDFDCA609565B9` |

Rights: as above, the owner must confirm these generated pictures before a store release.

Accessibility: all of these are decorative. `FoxMascot` and `ArtTile` exclude them from the accessibility tree, and the nearby text carries the meaning. They are static, so reduced motion does not change them.

## Audio

Existing files under `assets/audio/` are original synthesized tones described in `assets/content/audio_provenance.json`. They are not studio recordings and not third-party music. There are still no narration clips. Badge moments reuse the existing reward tone. This pass did not add silent files or call the audio set complete.

## Pictures

Category marks, the level badge, and Tic-Tac-Toe crosses and circles are drawn in code. No stock photography was added. Spot-the-difference scenes remain the in-app drawings noted in `difference_catalog.dart`. They are original to the project and are not production-final artwork.

## App icon and brand image

The fox reading a book with a sprout is owner-approved artwork, supplied on 2 October 2026 as a flattened 1024 × 1024 JPEG. Its creator and licence terms are held by the owner and are not recorded in this repository. Every file below is a uniform resize of that one image, placed on its measured background colour `#FEFAEF`. Nothing was redrawn.

- Play icon: `artifacts/sproutlab-play-icon-512.png`
- Launcher: `android/app/src/main/res/mipmap-*/ic_launcher*.png` and `mipmap-anydpi-v26/ic_launcher*.xml`
- Splash before Android 12: `android/app/src/main/res/drawable-*/launch_brand.png`
- In-app: `assets/brand/sproutlab_fox.png` on the welcome and About screens

The artwork is flattened, so the adaptive foreground is the whole picture scaled down to fit the safe zone, not a separate fox layer. The themed-icon layer `ic_launcher_monochrome.png` is a one-colour stencil made from the artwork's coloured areas. The old sprout-only icon was removed.

## Discover India map geometry (3 October 2026)

`assets/content/geography/slice_geometry.json` is a child-size canvas made from Natural Earth 50m Admin 0 and Admin 1 cultural vectors. Natural Earth is public domain; see https://www.naturalearthdata.com/about/terms-of-use/. India was extracted, projected to 0–1, and simplified. Borders were not moved for decoration. This is **not** a Survey of India map and is **not** an official boundary product. Owner and geography review are still required before a store release. Facts in the slice cite Know India pages checked on 3 October 2026 and remain `PLACEHOLDER` until an editor signs them. There are no licensed monument photographs and no reviewed narration files.

See `assets/content/geography/geography_asset_manifest.json`.

## Discover India heritage drawings (3 October 2026)

`assets/content/heritage/heritage_asset_manifest.json` lists every heritage picture and narration id. Pictures are original `CustomPaint` drawings in `lib/features/heritage/heritage_picture.dart`. They are not photographs, not copied from Wikimedia or Google Images, and not hotlinked. There are no local image files and therefore no checksums. Narration clip ids exist with no files.

Facts were checked against UNESCO World Heritage Centre listings 524 (Sanchi), 246 (Konark), 249 (Mahabalipuram) and 252 (Taj Mahal), and against ASI pages for Sanchi and Konark, on 3 October 2026. Child copy is an original short paraphrase. UNESCO listing text is CC-BY-SA IGO 3.0 and was not copied into child screens. Hampi (241), Ajanta (242) and Ellora (243) were researched and left out of playable activities. Every row remains `PLACEHOLDER` until owner, art and editorial review.

Parent-visible credits live behind the grown-up gate (`CreditsScreen`). URLs are shown as text and do not open a browser from a child screen.

## Stickers

Milestone stickers remain the in-app drawings recorded in `assets/content/sticker_provenance.json`. Level completion uses one shared badge icon plus the activity title. Hundreds of badge bitmaps were not added.
