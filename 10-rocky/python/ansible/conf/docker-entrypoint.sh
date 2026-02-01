#!/bin/bash
set -e

source /var/ansible/ansible-env/bin/activate

if command -v gpgconf >/dev/null; then
    gpgconf --launch gpg-agent
fi

exec "$@"