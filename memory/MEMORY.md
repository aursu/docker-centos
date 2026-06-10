# docker-centos memory — index

Generic, project-neutral knowledge about this repo. Travels with the repo so any Claude session opened against `docker-centos` — for any downstream consumer — loads consistent context.

**Rule:** every file in this directory must be **generic**. No company-specific paths, hostnames, registries, consumers, or workflows. Anything project-specific belongs in the consuming project's own `CLAUDE.md` / memory, not here.

## Topics

- [Tag convention & version pinning](tag-convention.md) — `<distro-version>-<role>` pattern, `RL9TAG`/`RL10TAG` env-var coupling, upstream Quay anchor
- [Version-bump workflow](version-bump-workflow.md) — multi-file sed pattern for distro minor-version upgrades, verification grep
- [Role taxonomy](role-taxonomy.md) — what each role layer (base, scm, web, nginx, node, openjdk, ruby, python, systemd, tomcat, docker, puppet) is meant to contain
- [CircleCI build pipeline](circleci-pipeline.md) — `aursu/rpmbuild@1.1.36` orb usage, base → scm → others dependency chain, GHCR push
- [Secrets directory pattern](secrets-directory.md) — what `secrets/` is for, what's gitignored, what kind of material lives there