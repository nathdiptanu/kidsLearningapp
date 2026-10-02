# Restore point

Use this file to get back to a known working tree after later changes.

## This working snapshot (Hindi / Discover India + polish)

Pushed to `origin/main` on 3 October 2026. App version `0.1.2+3`. `flutter test test dist`: 319 passed. Signed APK/AAB hashes are in `release-output/RELEASE_REPORT.md` (binaries stay out of git).

| Field | Value |
|---|---|
| Remote | `origin` → `https://github.com/nathdiptanu/kidsLearningapp.git` |
| Branch | `main` |
| Commit | `REPLACE_AFTER_COMMIT` |
| Date | 3 October 2026 |

Restore this snapshot:

```text
git fetch origin
git checkout REPLACE_AFTER_COMMIT
```

If `main` has moved and you only want this file’s commit:

```text
git log --oneline -- docs/RESTORE_POINT.md
git checkout <the commit that last updated this file>
```

## Previous working push (before this work)

| Field | Value |
|---|---|
| Commit | `84bf29b` |
| Message | SproutLab kids app 0.1.2 with fox and purple visual theme |

```text
git checkout 84bf29b
```

Do not force-push over `main` unless you intend to rewrite history. Prefer `git checkout` or a new branch from the SHA above.
