#!/usr/bin/env bash
#
# Install this image's Ruby gems and leave nothing behind but the gems.
#
# Usage: gem-setup.sh [gem ...]
#
# Runs during the image build, bind-mounted by the Dockerfile so the script
# itself never lands in a layer. Everything the gem commands write besides the
# libraries a running program loads — the RubyGems self-update gem, the fetched
# package index, superseded gem versions, per-gem test suites, documentation and
# the C sources a native gem was compiled from — is removed here, in the same
# layer that created it.

set -euo pipefail

log_info() { printf '### [INFO] %s\n' "$1"; }
log_err() { printf '### [ERROR] %s\n' "$1" >&2; }
die() {
    log_err "$1"
    exit 1
}

# Directories inside an installed gem that hold nothing a running program needs:
# its own test suite and fixtures, its documentation, and the C sources a native
# extension was built from (the compiled object lives elsewhere by then).
readonly PRUNE_DIRS=(
    spec test tests features examples sample benchmark
    doc docs man ext
    .git .github .circleci
)

# Files at a gem's top level that only matter to the gem's own developers.
readonly PRUNE_FILES=(
    '*.md' '*.rdoc' '*.txt' '*.yml' '*.json' 'Rakefile' 'Gemfile*' '.*'
)

# Licence texts are kept: the image is published, and the licences travel with
# the code they cover.
readonly KEEP_FILES=(
    'LICENSE*' 'COPYING*' 'NOTICE*'
)

# Join a list of names into a find(1) expression: ( -name a -o -name b ... ).
# Built as an array so no name is ever re-split or glob-expanded by the shell.
name_expression() {
    local -a expression=('(')
    local name

    for name in "$@"; do
        [ "${#expression[@]}" -eq 1 ] || expression+=(-o)
        expression+=(-name "$name")
    done

    expression+=(')')
    printf '%s\n' "${expression[@]}"
}

install_gems() {
    log_info "updating RubyGems itself"
    gem update --no-document --system

    # Bring the gems that shipped with the distribution's ruby up to their
    # current releases. Drop this call to keep the distribution's own versions
    # — it is what pulls in the compiler and the *-devel headers at build time.
    log_info "updating the gems that came with the distribution"
    gem update --no-document

    [ "$#" -gt 0 ] || return 0

    log_info "installing: $*"
    gem install --no-document "$@"
}

# `gem update --system` installs rubygems-update to do its job and leaves it
# installed; `gem update` leaves every superseded version next to the new one.
remove_superseded_gems() {
    log_info "removing the self-update gem and superseded gem versions"
    gem uninstall --executables --force rubygems-update > /dev/null 2>&1 || true
    gem cleanup > /dev/null 2>&1 || true
}

prune_development_files() {
    local gem_dir=$1 ext_dir=$2
    local -a roots=("$gem_dir/gems") directories=() files=() keep=() pattern

    if [ -d "$ext_dir" ]; then
        roots+=("$ext_dir")
    fi

    mapfile -t directories < <(name_expression "${PRUNE_DIRS[@]}")
    mapfile -t files < <(name_expression "${PRUNE_FILES[@]}")

    for pattern in "${KEEP_FILES[@]}"; do
        keep+=(! -name "$pattern")
    done

    log_info "pruning tests, documentation and extension sources"
    find "${roots[@]}" -type d "${directories[@]}" -prune -exec rm -rf {} +

    # -maxdepth 2 keeps this to a gem's own top level: <gem_dir>/gems/<gem>/<file>.
    find "$gem_dir/gems" -maxdepth 2 -type f "${files[@]}" "${keep[@]}" -delete
}

# `gem update --system` installs RubyGems, and the bundler it vendors, outside
# the gem directory — into site_ruby, where the pruning above does not reach.
# Two things there are not code: the manual pages (this image has no man(1) to
# read them) and the ronn sources they were generated from.
#
# bundler/templates is deliberately left alone: its spec/ and test/ directories
# are the skeleton `bundle gem` copies into a newly generated gem.
prune_manuals() {
    local site_dir=$1

    log_info "pruning manual pages installed outside the gem directory"
    find "$site_dir" -type d -name man -prune -exec rm -rf {} +
    find "$site_dir" -type f -name '*.ronn' -delete
}

remove_caches() {
    local gem_dir=$1 ext_dir=$2

    log_info "removing gem caches and extension build logs"

    # Downloaded .gem archives, plus the doc and build_info trees RubyGems
    # creates whether or not anything was written into them.
    rm -rf "$gem_dir/cache" "$gem_dir/doc" "$gem_dir/build_info"

    if [ -d "$ext_dir" ]; then
        rm -f "$ext_dir"/*/gem_make.out "$ext_dir"/*/mkmf.log
    fi

    # The fetched package index. RubyGems 4 keeps it under XDG_CACHE_HOME,
    # earlier versions under ~/.local/share/gem — clear both, so a RubyGems
    # upgrade cannot silently start leaving 25 MB in the image again.
    rm -rf "${XDG_CACHE_HOME:-${HOME}/.cache}/gem" "${HOME}/.local/share/gem"
}

main() {
    local gem_dir ext_dir site_dir

    command -v gem > /dev/null || die "gem is not on PATH"

    # Ask RubyGems where it installs, rather than hard-coding paths: this
    # distribution splits pure Ruby (share/gems) from compiled extensions
    # (lib64/gems/ruby), and the split is not the same on every distribution.
    gem_dir=$(gem env gemdir) || die "could not determine the gem directory"
    ext_dir=$(ruby -e 'require "rubygems"; print Gem.default_ext_dir_for(Gem.dir).to_s')
    site_dir=$(ruby -rrbconfig -e 'print RbConfig::CONFIG["sitelibdir"]')

    install_gems "$@"
    remove_superseded_gems
    prune_development_files "$gem_dir" "$ext_dir"
    prune_manuals "$site_dir"
    remove_caches "$gem_dir" "$ext_dir"

    log_info "gems installed in $gem_dir: $(du -sh "$gem_dir" | cut -f1)"
}

main "$@"
