---
name: Version-bump workflow
description: How to upgrade a distro's pinned upstream version across all touchpoints (Dockerfile, env, workflow YAML) in one atomic pass
type: reference
---

## When you need to bump

- Upstream publishes a new Rocky/CentOS Stream minor build (e.g. Rocky 9.6.20250531 → 9.7.20251123).
- A CVE notice tells you to rebuild against the latest upstream.
- A scheduled refresh cadence (monthly is a reasonable default).

Find the new upstream tag via [`quay.io/repository/rockylinux/rockylinux?tab=tags`](https://quay.io/repository/rockylinux/rockylinux?tab=tags) or the equivalent for CentOS Stream.

## Pattern — one find-and-replace across all touchpoints

The version string appears in multiple files, and **they must move together** or builds will fail / drift:

- `<variant>/.env` — both `RL9` and `RL9TAG` (or the variant's equivalent)
- `<variant>/Dockerfile`s — the `ARG rocky=<version>` default in every role's Dockerfile
- `.github/workflows/*.yaml` — if any workflow references the version literally
- Per-build `.env` files (any `build/.env`, `build/*/.env`) — if the variant uses them

Canonical one-liner from operator practice:

```bash
sed -i 's/9.6.20250531/9.7.20251123/' \
    */Dockerfile* \
    */.github/*/*.yaml \
    */.env \
    */build/.env \
    */build/*/.env \
    */run/.env \
    */run/*/.env
```

(Adjust the globs depending on which variant directories you're touching. The pattern works because every file uses the same version string format `X.Y.YYYYMMDD`.)

## Verification

```bash
grep -r '9.6.20250531' .   # expect: no output
grep -r '9.7.20251123' .   # expect: matches across .env, Dockerfile, workflows
```

Then run a sanity build locally for at least the `base` role:

```bash
cd 9-rocky
docker compose build rocky9base
```

## Commit pattern

One commit per version bump, with a clear message:

```
Bump Rocky 9 upstream to 9.7.20251123
```

If multiple distros bump in the same window, separate commits — easier to revert one independently.

## Tagging the bump (optional but recommended)

CircleCI's `shorttag: true` produces a stable short-tag in addition to the moving `<distro-version>-<role>` tag. Adding a git tag at the bump commit gives you a fixed reference point for "the day we went to 9.7.20251123":

```bash
git tag rocky9-9.7.20251123
git push origin rocky9-9.7.20251123
```

## What NOT to do

- **Don't bump only `.env` without the Dockerfile defaults.** A user running `docker compose build` without overriding `--build-arg` will then build against the old version because the `ARG rocky=...` default in the Dockerfile is what wins when no override is passed.
- **Don't bump only the Dockerfile without `.env`.** `docker-compose.yml` interpolates the env var into the **output tag**, so the build will succeed but tag itself with the wrong (old) version.
- **Don't do partial replacements** — search the entire tree with `grep -r` first; missing one file is the most common cause of broken builds in this repo.