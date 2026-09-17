---
name: Ruby gem layer in the puppet images
description: How `ruby/puppet` installs gems through a bind-mounted script, the three roots a gem cleanup has to cover, and what must not be pruned
type: reference
---

## How the layer is built

`<variant>/ruby/puppet/Dockerfile` installs its gems by running
`gem-setup.sh`, which sits next to the Dockerfile and is **bind-mounted** for
the build:

```dockerfile
RUN --mount=type=bind,source=gem-setup.sh,target=/root/bin/gem-setup.sh \
	/root/bin/gem-setup.sh \
		bundler \
		hiera-eyaml
```

A bind mount rather than `COPY` + `rm`: a copied file stays in its layer even
after a later layer deletes it. BuildKit also removes the `/root/bin` directory
it creates for the mount, so the finished image has no trace of the script.
BuildKit is already required by this repo elsewhere (`--mount=type=secret` for
the forge key), and `/root/bin` is where this repo's builder stages keep their
scripts.

The gem list is passed as arguments, so the same script serves every variant.
**The copies under each variant must stay byte-identical** — check with `cmp`
before committing a change to one of them.

## Leftovers hide in three roots, not one

A cleanup that only knows the gem directory misses two thirds of the problem:

| Root | How to find it | What collects there |
|---|---|---|
| gem directory | `gem env gemdir` | test suites, docs, `ext/` build trees, the downloaded `cache/` |
| extension directory | `Gem.default_ext_dir_for(Gem.dir)` | `gem_make.out`, `mkmf.log` |
| `site_ruby` | `RbConfig::CONFIG["sitelibdir"]` | RubyGems itself **and the bundler it vendors** — installed by `gem update --system`, out of reach of any gem-directory pruning |

Ask for the paths rather than hard-coding them: the Fedora/EL family splits pure
Ruby (`share/gems`) from compiled extensions (`lib64/gems/ruby`), and that split
is not universal.

## Things that are easy to get wrong

- `gem update --system` leaves the `rubygems-update` gem installed (about 5 MB),
  and `gem update` leaves every superseded version next to the new one —
  `gem cleanup` is not implied by either.
- **RubyGems 4 moved its fetched package index to `XDG_CACHE_HOME`**
  (`~/.cache/gem`, about 25 MB in a freshly built image). Deleting
  `~/.local/share/gem`, where it used to live, now reclaims nothing. Clear both.
- The gem is called **`bundler`**. `gem install bundle` installs a stub gem that
  only depends on the real one, and the image ends up carrying both.
- **Do not prune `site_ruby/bundler/templates/`.** Its `spec/`, `test/`, `ext/`,
  `github/` and `circleci/` directories carry exactly the names a cleanup list
  matches, but they are the skeleton `bundle gem` copies into a generated gem.
  Pruning them breaks `bundle gem` silently. The rule for `site_ruby` is
  therefore narrow on purpose: directories named `man`, and `*.ronn` files.
- Keep `LICENSE*` / `COPYING*` / `NOTICE*`. These images are published, and the
  licences travel with the code they cover.
- `/tmp`, `/var/tmp` and `~/.bundle` are not worth deleting: the first two are
  empty in the finished image, and the third holds the `BUNDLE_PATH`
  configuration written by the Dockerfile's last layer.

## Verifying a change to the layer

Behaviour, in a container from the built image:

```sh
bundle --version
eyaml createkeys && echo -n s3cr3t | eyaml encrypt --stdin --output=string \
    | eyaml decrypt --stdin          # must print s3cr3t
bundle install                        # in a directory with a one-gem Gemfile
bundle gem sample_gem                 # proves the site_ruby templates survived
```

To prove a refactor changed nothing, list
`find /usr/local /root -printf '%s %p\n' | sort` in the old and the new image
and `diff` the two listings — cheaper and stricter than reading the diff.

`shellcheck` needs no local install:

```sh
docker run --rm -v "$PWD:/mnt" -w /mnt koalaman/shellcheck:stable gem-setup.sh
```

## What the layer does not touch

`/opt/puppetlabs` is the bulk of these images — several hundred megabytes of
agent, bolt and PDK, including cached `*.gem` archives, vendored test suites and
a second Ruby stack that PDK keeps for older Puppet versions. Every candidate
there breaks a specific PDK scenario, so none of it is swept by default.
