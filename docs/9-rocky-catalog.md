# Rocky Linux 9 — image catalog

Per-image reference for every image produced under `9-rocky/`.
Current pin: **`RL9TAG=9.8.20260525.0`** (`9-rocky/.env`), upstream
`quay.io/rockylinux/rockylinux:9.8.20260525.0-minimal`.

Companion docs:
[README inventory](../README.md) ·
[recommendations](9-rocky-recommendations.md) ·
[role taxonomy](../memory/role-taxonomy.md) ·
[tag convention](../memory/tag-convention.md)

## Build graph

```
quay …:9.8…-minimal
        │
     base ──────────────────────────────── web ──┬── httpd
        │                                    │    ├── nginx ── resty
        └── scm ──┬── docker-cli             │    ├── node22 / node24
                  ├── systemd                │    └── (webdev) ── node22dev / node24dev
                  ├── jdk-21                  │
                  ├── jdk-26                  └── (webdev = web FROM scm, dev overlay)
                  ├── ruby31
                  ├── ruby33 ── pdk
                  ├── python3.12 ── ansible
                  └── (tomcat: orphaned, FROM jdk-22 which is not built)
```

Legend: 🐳 = Docker Hub (`aursu/…`) instead of `ghcr.io/aursu/…`.

## Images

### base — `ghcr.io/aursu/rockylinux:9.8.20260525.0-base`
- **FROM** `quay.io/rockylinux/rockylinux:9.8.20260525.0-minimal`
- **Adds** security updates to a curated TLS/crypto/XML/curl library set;
  `epel-release`, `glibc-langpack-en`, `shadow-utils`. Installs a
  no-weak-deps `dnf.conf` (`system/etc/dnf/dnf.conf`), `--nodocs`,
  `install_weak_deps=0`. Cleans dnf cache + `__db*`.
- **Notes** minimal footprint; `epel-release` is enabled repo-wide for all
  descendants. Carries the `org.opencontainers.image.source` label.

### scm — `ghcr.io/aursu/rockylinux:9.8.20260525.0-scm`
- **FROM** `-base`
- **Adds** `diffutils findutils git openssh-clients procps rsync`.
- **Role** the "general scripting + SCM toolbox" catch-all; parent for most
  derived roles. Carries the source label.

### docker-cli — `aursu/rockylinux:9.8.20260525.0-docker-cli` 🐳
- **FROM** `-scm` (build-arg `image=scm`)
- **Adds** `docker-ce-cli 29.4.3`, `docker-compose-plugin 5.1.3`, `skopeo`,
  and Docker Scout `1.21.0` (installed via `curl … | sh` into
  `/usr/libexec/docker/cli-plugins`).
- **Notes** no daemon (CLI only); `docker.sock` mounted at run time. Missing
  the source label. Scout install is unverified (no checksum/signature).

### systemd — `ghcr.io/aursu/rockylinux:9.8.20260525.0-systemd`
- **FROM** `-scm`
- **Adds** `systemd`; masks/removes most `*.wants` units; `CMD /usr/sbin/init`.
- **Run** requires `--privileged` (see README systemd section). Missing label.

### httpd — `aursu/rockylinux:9.8.20260525.0-httpd` 🐳
- **FROM** `-base`
- **Adds** stock `httpd`; wipes default `conf.d/*` + `conf.modules.d/*` and
  drops in curated `httpd.conf`, `00-mpm.conf`, `00-base.conf`.
- **Runs** `httpd -DFOREGROUND`, `EXPOSE 80`. Missing label; 🐳 on Docker Hub
  while 8-rocky/10-rocky publish httpd to GHCR.

### web — `ghcr.io/aursu/rockylinux:9.8.20260525.0-web`
- **FROM** `-base` (build-arg `image=base`; `webdev` overrides `image=scm`)
- **Adds** the `www-data` uid/gid **33** account (deletes the conflicting
  `tape` group first), and `/var/www/html` owned by it.
- **Role** shared parent for nginx/httpd/node web images. Missing label.

### webdev — `ghcr.io/aursu/rockylinux:9.8.20260525.0-webdev`
- Same Dockerfile as `web`, built `FROM …-scm` (dev overlay adds the scm
  toolbox). Parent for the `node*dev` images.

### nginx — `aursu/rockylinux:9.8.20260525.0-nginx` 🐳
- **FROM** `-web`
- **Adds** `nginx 1.31.1` from nginx-mainline repo; generates a **4096-bit
  dhparam at build time**; logs symlinked to stdout/stderr; curated
  `nginx.conf`. `EXPOSE 80 443`, `STOPSIGNAL SIGQUIT`.
- **Notes** dhparam generation makes the build slow and bakes a *shared*
  DH parameter into the published image. Missing label; 🐳.

### resty — `aursu/rockylinux:9.8.20260525.0-resty` 🐳
- **FROM** `-nginx`
- **Adds** `openresty 1.29.2.3` + `openresty-debug` from the OpenResty repo;
  curated `nginx.conf` + `00-proxy.conf` under `/usr/local/openresty`.
- **Notes** missing label; 🐳.

### node22 / node24 — `ghcr.io/aursu/rockylinux:9.8.20260525.0-node22` / `-node24`
- **FROM** `-web`
- **Adds** NodeSource repos (nodejs + nsolid), imports the NS GPG key,
  installs `nodejs 22.23.0` / `24.17.0`; creates uid/gid **1000** `node`
  user; `docker-entrypoint.sh`. Carries the source label.

### node22dev / node24dev — `ghcr.io/aursu/rockylinux:9.8.20260525.0-node22dev` / `-node24dev`
- **FROM** `-webdev`
- **Adds** same Node install plus `npm 11.14.1` (via npmjs install.sh),
  `corepack` + `yarn 4.14.1`, `tar`, `which`. Carries the source label.

### jdk-21 / jdk-26 — `aursu/rockylinux:9.8.20260525.0-jdk-21` / `-jdk-26` 🐳
- **FROM** `-scm`
- **Adds** `bzip2 unzip xz` + `java-21-openjdk 21.0.11.0.10` /
  `java-latest-openjdk 26.0.1.0.8` (exact-pinned).
- **Notes** missing label; 🐳. Exact RPM pins age out of the repo over time.

### ruby31 / ruby33 — `aursu/rockylinux:9.8.20260525.0-ruby31` / `-ruby33` 🐳
- **FROM** `-scm`
- **Adds** enables `ruby:3.1` / `ruby:3.3` module; installs `ruby ruby-devel
  make gcc-c++ redhat-rpm-config glibc-devel` (native-gem build toolchain).
- **Notes** missing label; 🐳.

### pdk — `aursu/rockylinux:9.8.20260525.0-pdk` 🐳
- **FROM** `-ruby33` (build-arg `image=ruby33`)
- **Adds** Puppet Core + tools repos, then `puppet-agent 8.16.0`,
  `puppet-bolt 5.0.1`, `pdk 3.6.1.1`. Consumes a Forge API key via a
  build secret (`forge_key` → `DNF_ENV_FILE`).
- **Notes** **no CI job** — only buildable via `docker-compose.dev.yml`.
  Missing label; 🐳. (10-rocky builds the equivalent as `-ruby33-puppet`.)

### python3.12 — `ghcr.io/aursu/rockylinux:9.8.20260525.0-python3.12`
- **FROM** `-scm`
- **Adds** `python3.12` RPM, then `pip` bootstrapped globally via
  `get-pip.py` piped to `python3.12` **as root**.
- **Notes** pip installs into the system 3.12 interpreter. See the
  [pytest recommendation](9-rocky-recommendations.md#pytest) for the
  venv-based approach.

### ansible — `ghcr.io/aursu/rockylinux:9.8.20260525.0-ansible`
- **FROM** `-python3.12`
- **Adds** an `ansible` uid/gid **1000** user, a **venv** at
  `/var/ansible/ansible-env` (`ansible-core 2.20.5`,
  `ansible-dev-tools 26.4.6`, `argcomplete 3.6.3`), SOPS `3.13.1`
  (checksum-verified), GnuPG scaffolding, bash completion, and Galaxy
  collections from `conf/requirements.yml`.
- **Notes** this is the **reference pattern** for the pytest recommendation:
  dedicated user + `ENV PATH`/`VIRTUAL_ENV` + `python -m venv` + argcomplete.

### tomcat — *orphaned, not built* ⚠️
- **FROM** `aursu/rockylinux:9.8.20260525.0-jdk-22` — **jdk-22 is not built
  in 9-rocky** (only jdk-21/jdk-26).
- No compose service, no CI job. Would fail to build as-is. See
  [recommendations](9-rocky-recommendations.md).
