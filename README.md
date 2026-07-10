# docker-centos — image inventory

Rocky Linux and CentOS Stream container **base + role images**, published to
`ghcr.io/aursu/*` (GitHub Container Registry) and consumed as `FROM` parents by
downstream image-build repos.

- Orientation & conventions: [CLAUDE.md](CLAUDE.md)
- Reference docs (tag convention, role taxonomy, CI, version bumps): [memory/](memory/)
- **Rocky Linux 9 catalog** (per-image detail): [9-rocky/README.md](9-rocky/README.md)

## Tag convention

`<repo>:<distro-version>-<role>` — the distro version is the source-of-truth
bump point, pinned per variant in `<variant>/.env`. See
[memory/tag-convention.md](memory/tag-convention.md).

| Variant | `.env` pin (current) | Registry / repo |
|---------|----------------------|-----------------|
| `8-rocky/` | `RL8TAG=8.10.20240528` | mixed: `ghcr.io/aursu/rockylinux` + `aursu/rockylinux` (Docker Hub) |
| `9-rocky/` | `RL9TAG=9.8.20260525.0` | mixed: `ghcr.io/aursu/rockylinux` + `aursu/rockylinux` (Docker Hub) |
| `9-stream/` | `OS9TAG=stream9-20260706.0` | `aursu/centos` (Docker Hub) |
| `10-rocky/` | `RL10TAG=10.2.20260525.0` | `ghcr.io/aursu/rockylinux` (all GHCR) ✅ |
| `10-stream/` | `OS10TAG=stream10-20260707.1` | `aursu/centos` (Docker Hub) |

> ⚠️ **Registry drift.** The stated target is `ghcr.io/aursu/*`, and `10-rocky`
> follows it for every image. `8-rocky` and `9-rocky` still publish several
> roles to the bare Docker Hub `aursu/…` namespace (flagged 🐳 below), and the
> Stream variants publish entirely to Docker Hub. See
> [9-rocky/RECOMMENDATIONS.md](9-rocky/RECOMMENDATIONS.md).

Legend: 🐳 = published to Docker Hub (`aursu/…`), not GHCR.

---

## 9-rocky — Rocky Linux 9 (`RL9TAG=9.8.20260525.0`)

Full per-image detail in [9-rocky/README.md](9-rocky/README.md).

### base / scm / infra
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-base`
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-scm`
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-systemd`
- `aursu/rockylinux:9.8.20260525.0-docker-cli` 🐳

### web
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-web`
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-webdev`
- `aursu/rockylinux:9.8.20260525.0-httpd` 🐳
- `aursu/rockylinux:9.8.20260525.0-nginx` 🐳
- `aursu/rockylinux:9.8.20260525.0-resty` 🐳
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-node22`
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-node24`
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-node22dev`
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-node24dev`

### language runtimes
- `aursu/rockylinux:9.8.20260525.0-jdk-21` 🐳
- `aursu/rockylinux:9.8.20260525.0-jdk-26` 🐳
- `aursu/rockylinux:9.8.20260525.0-ruby31` 🐳
- `aursu/rockylinux:9.8.20260525.0-ruby33` 🐳
- `aursu/rockylinux:9.8.20260525.0-pdk` 🐳 *(no CI job — built only via `docker-compose.dev.yml`)*
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-python3.12`
- `ghcr.io/aursu/rockylinux:9.8.20260525.0-ansible`

> `tomcat/Dockerfile` is present but **orphaned** — no compose service, no CI
> job, and it builds `FROM …-jdk-22` which 9-rocky does not produce (only
> jdk-21 / jdk-26). It cannot build as-is.

---

## 10-rocky — Rocky Linux 10 (`RL10TAG=10.2.20260525.0`) — all GHCR ✅

- `ghcr.io/aursu/rockylinux:10.2.20260525.0-base`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-scm`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-systemd`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-docker-cli`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-web`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-webdev`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-httpd`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-nginx`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-resty`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-ruby33`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-ruby33-puppet`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-python3.12`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-ansible`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-node22`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-node24`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-node22dev`
- `ghcr.io/aursu/rockylinux:10.2.20260525.0-node24dev`

---

## 8-rocky — Rocky Linux 8 (`RL8TAG=8.10.20240528`) — long-tail legacy

- `ghcr.io/aursu/rockylinux:8.10.20240528-base`
- `ghcr.io/aursu/rockylinux:8.10.20240528-scm`
- `ghcr.io/aursu/rockylinux:8.10.20240528-web`
- `ghcr.io/aursu/rockylinux:8.10.20240528-httpd`
- `aursu/rockylinux:8.10.20240528-webdev` 🐳
- `aursu/rockylinux:8.10.20240528-systemd` 🐳
- `aursu/rockylinux:8.10.20240528-docker-cli` 🐳
- `aursu/rockylinux:8.10.20240528-nginx` 🐳
- `aursu/rockylinux:8.10.20240528-resty` 🐳
- `aursu/rockylinux:8.10.20240528-jdk-21` 🐳
- `aursu/rockylinux:8.10.20240528-jdk-24` 🐳
- `aursu/rockylinux:8.10.20240528-tomcat` 🐳
- `aursu/rockylinux:8.10.20240528-ruby31` 🐳
- `aursu/rockylinux:8.10.20240528-ruby31-puppet` 🐳
- `aursu/rockylinux:8.10.20240528-node18` 🐳
- `aursu/rockylinux:8.10.20240528-node18dev` 🐳
- `aursu/rockylinux:8.10.20240528-node20` 🐳
- `aursu/rockylinux:8.10.20240528-node20dev` 🐳

---

## 9-stream — CentOS Stream 9 (`OS9TAG=stream9-20260706.0`) — Docker Hub

- `aursu/centos:stream9-20260706.0-base`
- `aursu/centos:stream9-20260706.0-scm`
- `aursu/centos:stream9-20260706.0-web`
- `aursu/centos:stream9-20260706.0-webdev`
- `aursu/centos:stream9-20260706.0-httpd`
- `aursu/centos:stream9-20260706.0-systemd`
- `aursu/centos:stream9-20260706.0-jdk-22`
- `aursu/centos:stream9-20260706.0-node18`
- `aursu/centos:stream9-20260706.0-node18dev`
- `aursu/centos:stream9-20260706.0-node20`
- `aursu/centos:stream9-20260706.0-node20dev`
- `aursu/centos:stream9-20260706.0-puppet7`
- `aursu/centos:stream9-20260706.0-puppet8`

---

## 10-stream — CentOS Stream 10 (`OS10TAG=stream10-20260707.1`) — Docker Hub

- `aursu/centos:stream10-20260707.1-base`
- `aursu/centos:stream10-20260707.1-scm`
- `aursu/centos:stream10-20260707.1-web`
- `aursu/centos:stream10-20260707.1-webdev`
- `aursu/centos:stream10-20260707.1-systemd`
- `aursu/centos:stream10-20260707.1-node22`
- `aursu/centos:stream10-20260707.1-node22dev`

---

# systemd containers

Kernel parameters:

```
systemd.unified_cgroup_hierarchy=1 cgroup_enable=memory swapaccount=1
```

Docker daemon options:

```json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "features": { "buildkit": true },
  "experimental": true,
  "cgroup-parent": "docker.slice"
}
```

Run command:

```
docker run -ti --rm --privileged --cgroup-parent=docker.slice --cgroupns private \
  --tmpfs /tmp --tmpfs /run ghcr.io/aursu/rockylinux:9.8.20260525.0-systemd
```
