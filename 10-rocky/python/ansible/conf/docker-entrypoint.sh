#!/bin/bash
set -e

if [ "$(id -un)" = "ansible" ] && command -v gpgconf >/dev/null; then
    gpgconf --launch gpg-agent
fi

exec "$@"
