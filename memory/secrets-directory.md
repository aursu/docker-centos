---
name: Secrets directory pattern
description: What `<variant>/secrets/` is for, what's gitignored, what kind of material lives there, never-commit rule
type: reference
---

## What the `secrets/` directory is

Each variant directory may contain a `secrets/` subdir holding **build-time credentials** that the image needs during `docker build` but **must not** be baked into the final image or committed to the repo.

Typical contents:
- Distro subscription keys (RHEL developer keys, etc.)
- Repository access tokens for private package mirrors
- Signing keys for `rpm` / `apt`
- Any other build-time credential that needs to be present during the build but never in the final image

## How they're used (build secrets pattern)

Docker BuildKit's `--secret` mechanism is the right primitive — secret files are mounted into the build environment for specific RUN steps and are NOT copied into image layers:

```dockerfile
# syntax=docker/dockerfile:1.4
FROM <upstream>
RUN --mount=type=secret,id=forge_key,target=/run/secrets/forge-key.sh \
    sh /run/secrets/forge-key.sh && \
    dnf install -y <packages-needing-forge-access> && \
    rm -f /tmp/* /var/cache/dnf/*
```

In `docker-compose.yml`:

```yaml
secrets:
  forge_key:
    file: secrets/forge-key.sh

services:
  rocky9scm:
    build:
      context: 9-rocky/scm
      secrets:
        - forge_key
```

The secret file lives on disk in `secrets/`, the build process mounts it for the specific RUN step, and the final image carries no trace of the credential.

## What's gitignored

The `.gitignore` at the repo root excludes the specific known secret file paths, e.g.:

```
9-rocky/secrets/forge-key.sh
```

When adding a new build-time secret:

1. Place the file in the appropriate `<variant>/secrets/`.
2. Add its exact path to `.gitignore` (specific path; not a broad `secrets/*` glob — broad globs can hide intentionally-tracked files like READMEs).
3. Configure the `secrets:` block in `docker-compose.yml` to reference it.
4. Verify with `git status` that the new secret file is not staged.

## Never-commit rule

If a secret accidentally lands in git history:

1. Rotate the credential immediately (do not assume the commit will be unnoticed).
2. Rewrite history (`git filter-repo` or BFG) to scrub the file from all past commits.
3. Force-push to overwrite the public ref (with caution — this affects all clones).
4. Add the path to `.gitignore` so it can't recur.

A scrubbed-but-still-rotated credential is the safer outcome than a "we removed it from git so it should be fine" credential.

## Sample files

If you want a `forge-key.sh.sample` or similar **template** showing the shape of the secret (without the actual secret value), commit that with a `.sample` suffix and reference it in `README.md`. Sample files are useful for onboarding.

## Build-time vs runtime secrets

This directory is for **build-time** secrets only. Runtime secrets (API tokens used by the running container) should be provided via environment variables, Docker secrets at run time, or a secret-management system — never via build args or `RUN` operations.