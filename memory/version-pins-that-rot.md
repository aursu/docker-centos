---
name: Version pins that rot
description: Which package pins in these Dockerfiles break on their own over time, why, and what to pin instead
type: reference
---

Two CI builds failed on the same day (2026-09) without a line of either
Dockerfile having changed. Both were pins that rot by themselves.

## A micro pin on one half of a pair

`python/3.12` pinned `python3-3.12.13` and took `python-unversioned-command`
unpinned. The two packages must be the same version — the unversioned command
requires exactly its own `python3`. The moment the repository published 3.12.14,
the transaction stopped depsolving:

```
package python-unversioned-command-3.12.14 requires python3 = 3.12.14,
but none of the providers can be installed
```

**Rule:** pin what the image's *name* promises, not the micro version the
distro rebuilds. On a distro whose platform python already is the wanted minor
version, take both packages unpinned and assert the identity in the same layer,
so a distro that ever moves it fails the build loudly instead of publishing a
mislabelled image:

```dockerfile
	&& python3 --version | grep -q '^Python 3\.12\.' \
```

The pin is only necessary where the wanted interpreter is *not* the platform
one — there, install the versioned package (`python3.12`) and never the
unversioned command, which would drag the platform interpreter in behind it.

## `java-latest-openjdk` is a moving target

`openjdk/26` pinned `java-latest-openjdk-1:26.0.2.0.10`. That build is gone:
`java-latest-openjdk` had moved to the next major — `27.0.0.0.35-0.0.1.0.ea`,
an **early-access** build — and no JDK 26 package of any name was left in the
repository. A role built on `java-latest-openjdk` therefore has two failure
modes: the pin stops resolving, and an unpinned version silently ships a
pre-release JVM.

**Rule:** pin the **versioned stable** package (`java-NN-openjdk`), and accept
that when a major disappears the role is renamed, not repaired — the published
tag carries the major in its name, so the rename reaches the compose service,
the tag inventories in the READMEs, and every image built `FROM` it.

Still carrying the same trap, unfixed: `8-rocky/openjdk/24` and
`9-stream/openjdk/22` both pin a `java-latest-openjdk` build.

## Find out what is available instead of guessing

Query the repositories from inside the role's own parent image — the answer
depends on the distro version the parent is pinned to:

```sh
docker run --rm <parent image> microdnf repoquery --available 'java-*-openjdk'
docker run --rm <parent image> microdnf repoquery --available python3 python-unversioned-command
```

Enabling every repository (`--enablerepo='*'`) makes this download debug and
source metadata and take minutes; the default set answers the question.
