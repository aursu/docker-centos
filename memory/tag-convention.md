---
name: Tag convention & version pinning
description: <distro-version>-<role> pattern, RL*TAG env vars, Quay upstream anchor, immutable vs floating tags
type: reference
---

## Tag format

```
<repo>:<distro-version>-<role>
```

Examples:

```
ghcr.io/aursu/rockylinux:9.7.20251123-base
ghcr.io/aursu/rockylinux:9.7.20251123-scm
ghcr.io/aursu/rockylinux:9.7.20251123-node20
ghcr.io/aursu/rockylinux:9.7.20251123-jdk-21
ghcr.io/aursu/rockylinux:9.7.20251123-ruby33-puppet
ghcr.io/aursu/centos:stream9-20240715.0-web
```

The `<distro-version>` part is the **upstream source-of-truth identifier** — for Rocky it's the exact minor + dated build (`9.7.20251123` = Rocky 9.7 build 2025-11-23); for CentOS Stream it's `stream<N>-<date>` (`stream9-20240715.0`).

## How variants pin the upstream

Each variant directory has a `.env` that holds the upstream pin:

```bash
# 9-rocky/.env
RL9="9.7.20251123"
RL9TAG="9.7.20251123"
```

The `Dockerfile` consumes the upstream version via build-arg + the `ARG` directive:

```dockerfile
ARG rocky=9.7.20251123
FROM quay.io/rockylinux/rockylinux:${rocky}-minimal
```

And `docker-compose.yml` interpolates `RL9TAG` into the output tag:

```yaml
image: "ghcr.io/aursu/rockylinux:${RL9TAG}-base"
```

So `RL9` (build-arg passed in) and `RL9TAG` (output tag suffix) are deliberately the same value — coupling the upstream pin to the output tag is the convention.

## Why this matters

- **A bump in `.env` propagates to every image of that variant** automatically — the role layers above `base` all inherit the same `<distro-version>` prefix via the multi-stage `FROM ghcr.io/aursu/rockylinux:${RL9TAG}-scm`-style chain.
- **The tag is immutable in practice.** Consumers that want a stable pin can use the full `<version>-<role>` tag; consumers that want to track the latest build for a major version need to do so externally (this repo does not produce `:9-base` or `:latest`-style floating tags).
- **The upstream Quay digest** (`quay.io/rockylinux/rockylinux:<X>-minimal`) is the canonical authority for what "Rocky 9.7.20251123" means. If Quay re-publishes the same tag with different content (rare but possible), a rebuild here picks it up — the dated build suffix is best-effort, not cryptographically pinned.

## How to apply

- When proposing a new role's tag, follow `<distro-version>-<role>` exactly; do not invent `-latest` or `-v1` suffixes.
- When the upstream Quay tag itself moves, that's a **version bump** — see `version-bump-workflow.md`.
- Consumers downstream (any project that does `FROM ghcr.io/aursu/...`) should pin to the full `<distro-version>-<role>` tag, not to a major-version shorthand that doesn't exist.