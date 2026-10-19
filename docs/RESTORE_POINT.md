# Restore point

Use this file to get back to a known working tree after later changes.

## This working snapshot (0.1.7 India Learning Play AAB)

Pushed to `origin/main` on 19 October 2026. App version `0.1.7+9`. Play AAB hashes are in `release-output/PLAY_RELEASE_0.1.7.md` (the `.aab` file stays out of git).

| Field | Value |
|---|---|
| Remote | `origin` → `https://github.com/nathdiptanu/kidsLearningapp.git` |
| Branch | `main` |
| Commit | `20d0e1726a715ac6cfb1a6e800ba0beb63f407e2` |
| Date | 19 October 2026 |
| Version | `0.1.7+9` |

Restore this snapshot:

```text
git fetch origin
git checkout 20d0e1726a715ac6cfb1a6e800ba0beb63f407e2
```

If `main` has moved and you only want this file’s commit:

```text
git log --oneline -- docs/RESTORE_POINT.md
git checkout <the commit that last updated this file>
```

## Previous working push

| Field | Value |
|---|---|
| Commit | `6102982b0b98abce10f85b49ef461809ffce6076` |
| Message | Record the working-snapshot SHA in the restore-point note. |

```text
git checkout 6102982b0b98abce10f85b49ef461809ffce6076
```

Earlier Hindi / Discover India polish snapshot: `34801ddaf46194aaa03f8643440ae1218dd3fd62`. Theme snapshot: `84bf29b`.

Do not force-push over `main` unless you intend to rewrite history. Prefer `git checkout` or a new branch from the SHA above.
