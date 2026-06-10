---
name: Role taxonomy
description: What each role-layer directory under a variant is meant to contain, the dependency between them, and where to add new tools
type: reference
---

## The roles

Each variant directory (`8-rocky/`, `9-rocky/`, `9-stream/`, `10-rocky/`, `10-stream/`) contains a subset of these role subdirectories. Each role produces one image tagged `<distro-version>-<role>` (with sub-versions for things like Node/Ruby).

| Role | Contents | Builds FROM |
|---|---|---|
| `base/` | Minimal OS install: security updates, ca-certificates, basic tools, locale | upstream Quay minimal |
| `scm/` | + git, curl, jq, build essentials, common SCM/CI tooling | `<version>-base` |
| `docker/` | + Docker CLI (no daemon) + buildx/compose/scout plugins + **skopeo** (OCI image inspect/copy/delete) | `<version>-scm` |
| `systemd/` | + systemd init (for VM-like containers; requires `--privileged`) | `<version>-base` |
| `httpd/` | + Apache HTTP server | `<version>-base` (or `-scm`) |
| `nginx/` | + nginx | `<version>-base` |
| `nginx/resty/` | + OpenResty (nginx + LuaJIT + ngx_lua) | `<version>-nginx` or sibling |
| `node/<N>/` | + Node.js major version N | `<version>-base` (or `-scm`) |
| `node/<N>/dev/` | + dev toolchain on top of node/<N> | `<version>-node<N>` |
| `python/` | + Python (currently Rocky 10 only) | `<version>-base` |
| `openjdk/<N>/` | + OpenJDK version N | `<version>-base` |
| `tomcat/` | + Apache Tomcat | `<version>-jdk-<N>` |
| `ruby/<N>/` | + Ruby major version N | `<version>-base` |
| `ruby/puppet/` | + Puppet agent layered on a Ruby base | `<version>-ruby<N>` |
| `web/` | Umbrella: PHP + Apache + nginx combo | `<version>-scm` |
| `secrets/` | NOT an image — directory for gitignored build-time credentials | n/a |

(Specifics may vary slightly per variant — some variants don't ship every role. Cross-check against the variant's `docker-compose.yml`.)

## Build chain

```
                      ┌── docker/
                      ├── scm/ ──┼── web/
                      │         └── (other scm-derived roles)
   <variant>/base/ ──┤
                      ├── nginx/ ── nginx/resty/
                      ├── node/<N>/ ── node/<N>/dev/
                      ├── python/
                      ├── openjdk/<N>/ ── tomcat/
                      ├── ruby/<N>/ ── ruby/puppet/
                      ├── httpd/
                      └── systemd/
```

CircleCI enforces this by `requires:` declarations in `.circleci/config.yml` — `base` first, then everything else (with `scm` as another common parent for derived roles).

## Where to add a new tool

Decision flow:

1. **Is the tool universally useful** (jq, ripgrep, fzf, htop, vim)?
   → Add to **`scm/`**. Every downstream consumer that picks up an scm-derived image gets it for free, and it doesn't bloat the minimal `base/` for image-only consumers (Tomcat, OpenJDK consumers etc. that bypass scm).

2. **Is the tool a developer convenience (not needed in production)?**
   → Add to the **`dev/` overlay** of the relevant role (`node/<N>/dev/`, etc.). Production builds skip dev overlays.

3. **Is the tool tied to a specific language/runtime?**
   → Add inside that role's directory (e.g. Python utilities in `python/`, Ruby gems pre-installed in `ruby/<N>/`).

4. **Is the tool needed for *every* image, even the smallest?**
   → Add to `base/`. Bar is high — base/ should stay minimal. Only widely-required runtime libraries (ca-certificates, glibc-locale-source, etc.) belong here.

5. **Is the tool specific to one downstream project?**
   → **Do NOT add it here.** That project's own image builds `FROM` this repo and adds the tool in its own Dockerfile.

## Why scm is the catch-all

`scm/` already gathers git, curl, build tools. It's the natural home for "the toolbox you reach for when scripting things" — which is exactly the same audience as jq, yq, ripgrep, etc.

Avoid the temptation to create more granular roles (`tools/`, `cli/`, `devops/`). The current taxonomy is the result of years of consolidation; adding role variants increases CI matrix complexity superlinearly.

## Why skopeo lives in `docker/` (not `scm/`)

Skopeo is specifically an **OCI/Docker image-ecosystem** tool — registry-direct inspect, copy, delete, sync. Its mental model and dependencies (containers-common, libostree, image storage helpers) are the same family as the Docker CLI itself.

Putting it in `docker/` rather than `scm/` keeps both layers' purposes clean:
- `scm/` = "general scripting + SCM" (git, curl, jq).
- `docker/` = "image-ecosystem CLI" (docker-cli, buildx, compose, scout, skopeo).

Anything `FROM <version>-docker-cli` (or further downstream, e.g. `docker → kube → kube2` chains used by jumpbox-style consumers) inherits skopeo automatically. Consumers that only need scripting tools (the `-scm` layer) don't pay the ~30 MB skopeo + containers-common cost.