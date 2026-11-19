# docker-centos memory — index

Generic, project-neutral knowledge about this repo. Travels with the repo so any Claude session opened against `docker-centos` — for any downstream consumer — loads consistent context.

**Rule:** every file in this directory must be **generic**. No company-specific paths, hostnames, registries, consumers, or workflows. Anything project-specific belongs in the consuming project's own `CLAUDE.md` / memory, not here.

## Topics

- [Tag convention & version pinning](tag-convention.md) — `<distro-version>-<role>` pattern, `RL9TAG`/`RL10TAG` env-var coupling, upstream Quay anchor
- [Version-bump workflow](version-bump-workflow.md) — multi-file sed pattern for distro minor-version upgrades, verification grep
- [Role taxonomy](role-taxonomy.md) — what each role layer (base, scm, web, nginx, node, openjdk, ruby, python, systemd, tomcat, docker, puppet) is meant to contain
- [CircleCI build pipeline](circleci-pipeline.md) — **the orb executor pins the OS versions (beats `.env`): an OS bump needs a new orb release**; `aursu/rpmbuild@1.1.38` orb usage, base → scm → others dependency chain, GHCR push
- [Version pins that rot](version-pins-that-rot.md) — every package pinned exactly; a pair that must match (`python3` + `python-unversioned-command`) is pinned together, no version asserts; `java-latest-openjdk` changes major and old builds vanish — pin the versioned stable package; how to query what is actually available
- [Ruby gem layer in the puppet images](ruby-gem-layer.md) — gems installed by a bind-mounted `gem-setup.sh`; the three roots a cleanup must cover (gem dir, ext dir, `site_ruby`); what must not be pruned; how a change is verified
- [Secrets directory pattern](secrets-directory.md) — what `secrets/` is for, what's gitignored, what kind of material lives there