# Restore point

Use this file to get back to a known working tree after later changes.

## This working snapshot (0.1.9 Play AAB, versionCode 11)

Pushed to `origin/main` on 29 October 2026. App version `0.1.9+11`. Play AAB hashes are in `release-output/PLAY_RELEASE_0.1.9.md` (the `.aab` file stays out of git).

| Field | Value |
|---|---|
| Remote | `origin` → `https://github.com/nathdiptanu/kidsLearningapp.git` |
| Branch | `main` |
| Commit | `7af4df2a32e2336a8571fdfaa0a309aec71fd316` |
| Date | 29 October 2026 |
| Version | `0.1.9+11` |

Restore this snapshot:

```text
git fetch origin
git checkout 7af4df2a32e2336a8571fdfaa0a309aec71fd316
```

## Previous working push

| Field | Value |
|---|---|
| Commit | `3abc5e1` |
| Message | Open each next level only after the previous one is finished, and add teach-then-try lessons plus more India and language practice. |

```text
git checkout 3abc5e1
```

0.1.8 Play snapshot: `2f1a6095ecffb79058da404fcbe4356491e3d64a`. India Learning source snapshot: `20d0e1726a715ac6cfb1a6e800ba0beb63f407e2`. Do not force-push over `main`. Prefer `git checkout` of a SHA.
