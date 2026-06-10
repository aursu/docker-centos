# docker-centos

Build pipeline for **Rocky Linux and CentOS Stream container base + role images**, published to `ghcr.io/aursu/*` (GitHub Container Registry). The output images are designed to be consumed as `FROM` parents by other image-build repos (e.g. RPM packaging projects) and as base images for development containers.

## Purpose

This repo produces parent / role-based images that downstream projects build on top of. Tags follow a strict `<distro-version>-<role>` convention so consumers can pin to a specific OS minor version and role layer simultaneously.

## Stack

| Aspect | Choice |
|---|---|
| Build tool | Docker / docker-compose |
| CI | CircleCI (`aursu/rpmbuild` orb v1.1.36) |
| Registry target | `ghcr.io/aursu/*` (image-source label points back at this repo) |
| Source base images | `quay.io/rockylinux/rockylinux:<version>-minimal` + Quay CentOS Stream equivalents |
| Branch | single `master`, no env-* branches |

## Layout

Five distro variants at the top level; each contains a `docker-compose.yml` and `Dockerfile` per role.

```
.
├── 8-rocky/        Rocky Linux 8.10   (long-tail legacy)
├── 9-rocky/        Rocky Linux 9.7    (current default for most consumers)
├── 9-stream/       CentOS Stream 9    (forward-looking)
├── 10-rocky/       Rocky Linux 10.1   (newest)
├── 10-stream/      CentOS Stream 10
├── .circleci/      Build pipeline config (orb-based)
├── .github/        cleanup.yml workflow (GHCR untagged-image cleanup)
└── README.md       Tag inventory (per-image)
```

Each variant directory has the same shape (modulo what's needed):

```
<variant>/
├── .env                        Pins upstream OS version, e.g. RL9TAG="9.7.20251123"
├── docker-compose.yml          Main build services (production-tagged images)
├── docker-compose.web.yml      Web-role overlay services
├── docker-compose.webtest.yml  Test overlay (where applicable)
├── docker-compose.dev.yml      Dev overlay (where applicable)
├── base/                       Minimal OS base
├── scm/                        + git, curl, build tools
├── docker/                     + docker CLI
├── httpd/                      + Apache
├── nginx/                      + nginx (and nginx/resty for OpenResty)
├── node/<N>/                   Node.js per major version (18/20/22/24)
├── node/<N>/dev/               Same, with dev tools
├── openjdk/<N>/                OpenJDK per version (21/22/26)
├── python/                     + Python (Rocky 10 only currently)
├── ruby/<N>/                   + Ruby per major version (31/33)
├── ruby/puppet/                + Puppet agent layered on Ruby
├── secrets/                    Build-time secrets (gitignored content; e.g. distro subscription keys)
├── systemd/                    Systemd-enabled base (for VM-like containers)
├── tomcat/                     + Apache Tomcat
└── web/                        Web umbrella (PHP + Apache + nginx)
```

## Image tag convention

`<repo>:<distro-version>-<role>` — the **distro version is the source-of-truth bump point**. Example tags from `9-rocky` (current pinned `RL9TAG=9.7.20251123`):

```
ghcr.io/aursu/rockylinux:9.7.20251123-base
ghcr.io/aursu/rockylinux:9.7.20251123-scm
ghcr.io/aursu/rockylinux:9.7.20251123-node20
ghcr.io/aursu/rockylinux:9.7.20251123-jdk-21
ghcr.io/aursu/rockylinux:9.7.20251123-ruby33-puppet
```

The `aursu/centos:stream9-…` and `aursu/centos:stream10-…` lines use `stream<N>-<date>-<role>`. See `README.md` for the full tag inventory.

## Build pipeline (CircleCI)

`.circleci/config.yml` defines one `workflows.dockercentos` job per `(variant × role)` combo. Each job uses the `aursu/rpmbuild@1.1.36` orb's `docker-rpmbuild/image` task with:

- `compose_file`: which variant's `docker-compose.yml`
- `build_service`: which compose service
- `registry: ghcr.io`
- `context: github-packages` (for GHCR push credentials)
- `requires:` dependency on the upstream `base` / `scm` job for that variant

Build order within a variant: `base → scm → (everything else)`. Cross-variant builds run in parallel.

## Conventions to follow

- **Version bumps touch multiple files in lockstep.** A minor OS upgrade (e.g. Rocky `9.6.20250531 → 9.7.20251123`) needs the same string replaced in `Dockerfile`s, `.github/workflows/*.yaml`, `.env`, `build/.env`, and per-build `.env` files. Pattern:
  ```bash
  sed -i 's/9.6.20250531/9.7.20251123/' \
    */Dockerfile* */.github/*/*.yaml */.env */build/.env */build/*/.env
  ```
  Confirm with `grep -r <OLD>` before committing.

- **No env-* branches.** This repo is single-branch `master`. Pushes trigger CircleCI builds via the orb-watching webhook.

- **Image source label.** Every `Dockerfile` should carry `LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos` so GHCR links back. Check this when adding a new image.

- **Don't commit secrets.** `9-rocky/secrets/forge-key.sh` is in `.gitignore` — same pattern applies to any future build-time credential (distro subscription keys, registry credentials, signing material).

- **Tag the `master` HEAD after a version-bump commit** so CircleCI's `shorttag: true` jobs produce a stable identifier alongside the moving tag.

## Reading order for a new responder

1. This file (purpose + layout + conventions).
2. [`memory/MEMORY.md`](memory/MEMORY.md) — index of generic reference docs (tag convention, version-bump workflow, role taxonomy, CircleCI pipeline, secrets pattern).
3. [`README.md`](README.md) — full tag inventory across all variants.
4. The variant's `docker-compose.yml` for the role you're about to build.
5. The variant's `.env` for the current OS version pin.
6. `.circleci/config.yml` for the build-job wiring.

## Memory (`memory/`)

Generic, project-neutral reference docs that travel with the repo. Topics covered:

- [Tag convention & version pinning](memory/tag-convention.md)
- [Version-bump workflow](memory/version-bump-workflow.md)
- [Role taxonomy](memory/role-taxonomy.md)
- [CircleCI build pipeline](memory/circleci-pipeline.md)
- [Secrets directory pattern](memory/secrets-directory.md)

Rule for this directory: **everything in it must be generic** — no company-specific paths, hostnames, registries, consumers, or workflows. Project-specific context belongs in the consuming project's own docs, not here.

## Local / private context

If you're working in this repo on behalf of a specific downstream project (a company that consumes these images for their build/CI/host stack), keep that project's context **out of this repository** — including out of `memory/`. The accepted pattern is: external workspace / meta-repo memory in the consuming project knows about `docker-centos`; the reverse direction does not exist.