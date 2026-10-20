# Restore point

Use this file to get back to a known working tree after later changes.

## This working snapshot (0.1.8 Play AAB, versionCode 10)

Pushed to `origin/main` on 20 October 2026. App version `0.1.8+10`. Play AAB hashes are in `release-output/PLAY_RELEASE_0.1.8.md` (the `.aab` file stays out of git).

| Field | Value |
|---|---|
| Remote | `origin` → `https://github.com/nathdiptanu/kidsLearningapp.git` |
| Branch | `main` |
| Commit | `2f1a6095ecffb79058da404fcbe4356491e3d64a` |
| Date | 20 October 2026 |
| Version | `0.1.8+10` |

Restore this snapshot:

```text
git fetch origin
git checkout 2f1a6095ecffb79058da404fcbe4356491e3d64a
```

## Previous working push

| Field | Value |
|---|---|
| Commit | `b5389e0d1b58f911ca538fc573e3d066f5cd23b9` |
| Message | Record the 0.1.7 working-snapshot SHA in the restore-point note. |

```text
git checkout b5389e0d1b58f911ca538fc573e3d066f5cd23b9
```

India Learning source snapshot: `20d0e1726a715ac6cfb1a6e800ba0beb63f407e2`. Do not force-push over `main`. Prefer `git checkout` of a SHA.
