---
name: CircleCI build pipeline
description: How the orb-based pipeline is wired, the per-variant dependency chain, GHCR auth context, debugging tips
type: reference
---

## The pipeline file

`.circleci/config.yml`, version `2.1`.

```yaml
orbs:
  docker-rpmbuild: aursu/rpmbuild@1.1.36

workflows:
  dockercentos:
    jobs:
      - docker-rpmbuild/image:
          name: <variant><role>           # e.g. rocky9base
          compose_file: <variant>/docker-compose.yml
          build_service: <service>        # e.g. rocky9base
          shorttag: true                  # produce a stable short-tag in addition
          registry: ghcr.io
          context:
            - github-packages             # CircleCI context providing GHCR push creds
          requires:
            - <upstream-job>              # base / scm typically
```

One job entry per `(variant × role)` combination. Cross-variant builds run in parallel; within a variant, `base → scm → others` is enforced via `requires:`.

## The orb (`aursu/rpmbuild@1.1.36`)

The `docker-rpmbuild/image` task does:

1. Check out the repo.
2. Set up docker-buildx with multi-platform support.
3. Read `.env` from the variant directory (so `RLxTAG` is populated).
4. `docker compose -f <compose_file> build <build_service>`.
5. Tag the result both as the full `<distro-version>-<role>` and (if `shorttag: true`) a short variant.
6. Push to the configured `registry:` (here `ghcr.io`).

Authentication comes from the **CircleCI context** named `github-packages` (set up once at the org level, not per-repo). The context must supply a token with `write:packages` scope on the target GHCR namespace.

## Reading a CI failure

When a build fails, the orb's output typically shows:

- The `docker compose build` step's stderr (Dockerfile RUN steps that failed).
- The `docker push` step's stderr (auth / network / registry-side errors).

For Dockerfile failures: the failed RUN line + the exit code is what to fix locally first (`docker compose build <service>` in the variant dir, reproduce, fix).

For push failures:
- `denied: permission_denied` → CircleCI context's token doesn't have `write:packages` on the target namespace. Org-level fix.
- `manifest unknown` → the upstream parent image (e.g. an `scm` job that failed) didn't publish; the dependent `requires:` should have prevented this — check that the upstream job actually ran first.

## Per-variant build order

```
rocky8base   ──► rocky8scm   ──► rocky8(httpd|nginx|node*|ruby*|web|...)
rocky9base   ──► rocky9scm   ──► rocky9(...)
rocky10base  ──► rocky10scm  ──► rocky10(...)
stream9base  ──► stream9scm  ──► stream9(...)
stream10base ──► stream10scm ──► stream10(...)
```

Cross-variant: parallel (no dependencies between, say, `rocky9base` and `rocky10base`).

## When adding a new job

For each new `(variant, role)`:

1. Add the role's directory + Dockerfile in `<variant>/<role>/`.
2. Add the build service to `<variant>/docker-compose.yml`.
3. Add a `docker-rpmbuild/image:` entry in `.circleci/config.yml` with the right `requires:`.
4. Push and watch the first build — orb caching may take a couple runs to settle.

## GitHub Actions in this repo

There's only `.github/workflows/cleanup.yml`, which prunes untagged images from GHCR. **It does NOT build images** — all builds run on CircleCI. Don't confuse the two.

## Debugging locally

```bash
cd 9-rocky
# Make sure .env is loaded by your shell or use --env-file
source .env
docker compose build rocky9base
docker compose build rocky9scm   # only after base succeeds
```

If a build works locally but fails on CircleCI, the gap is usually:
- CircleCI runs on a fresh checkout — make sure new files are committed.
- The orb pulls upstream parent images from `ghcr.io`, not your local cache.
- Network egress restrictions on CI may differ from your machine.