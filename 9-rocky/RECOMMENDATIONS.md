# Rocky Linux 9 — improvement recommendations

Findings and proposed fixes for the `9-rocky/` image set, ordered by impact.
Companion: [catalog](README.md) · [root inventory](../README.md) ·
[role taxonomy](../memory/role-taxonomy.md).

Reference point: **`10-rocky/` is the clean template** — it publishes every
image to `ghcr.io` and carries the correct CI wiring. Most items below are
"make 9-rocky match 10-rocky".

---

## P1 — correctness / publishing

### 1. Registry drift: 9 images still publish to Docker Hub
The stated target is `ghcr.io/aursu/*`. These 9-rocky images use the bare
`aursu/…` (Docker Hub) namespace instead:

`docker-cli`, `httpd`, `nginx`, `resty`, `jdk-21`, `jdk-26`, `ruby31`,
`ruby33`, `pdk`.

Their CI jobs (`rocky9docker`, `rocky9nginx`, `rocky9resty`, `rocky9httpd`,
`rocky9jdk`, `rocky9jdk21`, `rocky9ruby31`, `rocky9ruby33`) also **lack**
`registry: ghcr.io` + `context: [github-packages]`, so they don't push to
GHCR at all.

**Fix** — for each, in the compose file change
`aursu/rockylinux:${RL9TAG}-<role>` → `ghcr.io/aursu/rockylinux:${RL9TAG}-<role>`,
and in `.circleci/config.yml` add to each job:
```yaml
          registry: ghcr.io
          context:
            - github-packages
```
Diff `10-rocky/docker-compose*.yml` and its CI jobs as the reference.
Note the internal `FROM` chains that reference bare tags too — e.g.
`nginx/resty/Dockerfile` (`FROM aursu/rockylinux:${rocky}-nginx`),
`ruby/puppet/Dockerfile` (`FROM aursu/rockylinux:${rocky}-ruby33`),
`tomcat/Dockerfile` (`FROM aursu/rockylinux:${rocky}-jdk-22`) — must be
repointed to `ghcr.io/…` in lockstep or the downstream build pulls the wrong
(or non-existent) parent.

### 2. `tomcat/` builds but isn't wired into compose/CI
The [`tomcat/Dockerfile`](https://github.com/aursu/docker-centos/blob/master/9-rocky/tomcat/Dockerfile)
was optimized (2026-07): `FROM …-jdk-26` (was a non-existent jdk-22), stale
`functions` override removed, redundant packages/ENV dropped, exec-form `CMD`.
Verified against `tomcat-9.0.117-1.el9_8`: java runs as PID 1 and `docker stop`
is graceful (exit 143). What remains:

- **Still no compose service / CI job**, so nothing builds it. Add a
  `rocky9tomcat` service (build context `tomcat`, `FROM …-jdk-26`) and a CI job
  `requires: rocky9jdk`. Model on `8-rocky`'s tomcat.
- The `FROM` still points at the bare `aursu/…` jdk-26 (Docker Hub). Move it to
  `ghcr.io/…` together with jdk-26 as part of the registry-drift fix (P1.1).
- **JVM awareness (not a bug today):** `tomcat` pulls Java 8 via `ecj` (JSP
  compiler), but the base's JDK 26 stays the higher-priority `jre` alternative,
  so Tomcat runs on 26. Also, `server` always passes `-Djava.endorsed.dirs=`;
  a modern JVM tolerates the *empty* value but **aborts on a non-empty one**
  (verified: exit 1) — keep `JAVA_ENDORSED_DIRS` unset.

### 3. `pdk` has no CI job
`rocky9ruby33pdk` exists only in `docker-compose.dev.yml`; CI builds the
Rocky 10 equivalent (`rocky10ruby33puppet`) but nothing for Rocky 9.

**Fix** — add a `rocky9pdk` job `requires: rocky9ruby33`, passing the
`forge_key` secret. Consider renaming the service to match 10-rocky's
`ruby33-puppet` tag for cross-variant consistency (currently the Rocky 9 tag
is `-pdk`, Rocky 10 is `-ruby33-puppet`).

---

## P2 — convention compliance

### 4. Missing `org.opencontainers.image.source` label
The repo convention (CLAUDE.md) says every Dockerfile carries
`LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos`
so GHCR links back. Only `base`, `scm`, and the `node*` images have it.

**Missing on:** `docker`, `systemd`, `httpd`, `web`, `nginx`, `nginx/resty`,
`tomcat`, `openjdk/21`, `openjdk/26`, `ruby/31`, `ruby/33`, `ruby/puppet`,
`python/3.12`, `python/3.12/dev`, `python/ansible`.

**Fix** — add the `LABEL` line under each `FROM`. (Cheap, mechanical; do it
in the same pass as the registry fix.)

---

## P3 — hardening / robustness

### 5. Unverified Docker Scout install
[`docker/Dockerfile`](https://github.com/aursu/docker-centos/blob/master/9-rocky/docker/Dockerfile)
runs `curl -sSfL …/scout-cli/main/install.sh | sh` with no checksum/signature
check — pulls an install script from `main` at build time.

**Fix** — pin to a release tag and verify the downloaded binary's checksum,
mirroring the SOPS pattern already used in
[`python/ansible/Dockerfile`](https://github.com/aursu/docker-centos/blob/master/9-rocky/python/ansible/Dockerfile)
(`sha256sum -c … --ignore-missing`).

### 6. nginx builds a 4096-bit dhparam at image-build time
[`nginx/Dockerfile`](https://github.com/aursu/docker-centos/blob/master/9-rocky/nginx/Dockerfile)
runs `openssl dhparam -out … 4096` during build. Two problems: it makes the
build slow/non-deterministic, and it **bakes one shared DH parameter into the
published image** — every container from this tag uses the same params.

**Fix** — generate dhparam at container start (entrypoint) into a volume, or
drop custom dhparam entirely (modern TLS uses ECDHE; fixed FFDHE groups are
acceptable and don't need per-image generation).

### 7. Exact RPM pins age out of upstream repos
Many images pin exact builds (`java-21-openjdk-1:21.0.11.0.10`,
`nodejs-22.23.0`, `docker-ce-cli-29.4.3`, `openresty-1.29.2.3`,
`puppet-agent-8.16.0`). When upstream rotates the repo, the exact NEVR
disappears and the build breaks — even without any change here.

**Fix** — this is a deliberate reproducibility trade-off; keep it, but treat
"build suddenly fails on an untouched Dockerfile" as a signal to bump the pin,
and keep the pins moving with the version-bump workflow rather than letting
them rot. (See [version-bump workflow](../memory/version-bump-workflow.md).)

### 8. `epel-release` enabled in `base`
[`base/Dockerfile`](https://github.com/aursu/docker-centos/blob/master/9-rocky/base/Dockerfile)
installs `epel-release`, so **every** descendant image has EPEL enabled. If a
downstream only wants RHEL/Rocky core packages, EPEL can silently satisfy a
dependency from a less-controlled source.

**Fix (consider)** — move `epel-release` to `scm/` (the toolbox layer) instead
of `base/`, keeping `base/` to core + curated libs only. Verify nothing in
`base` itself needs EPEL first.

---

## Suggested order of work

1. **One mechanical pass** (P1.1 + P2.4): repoint the 9 Docker Hub images to
   `ghcr.io`, fix their CI jobs, and add the missing `LABEL` — all touch the
   same files.
2. **Decide tomcat** (P1.2): wire up or delete.
3. **Add `pdk` CI job** (P1.3).
4. Hardening items (P3) as time permits.

Cross-check the result against `10-rocky/` — after these fixes, 9-rocky and
10-rocky should differ only in version pins and the 8→9→10 role set.
