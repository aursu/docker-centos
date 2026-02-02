#!/bin/bash
set -e

export VIRTUAL_ENV_DISABLE_PROMPT=1
source /var/ansible/ansible-env/bin/activate
unset VIRTUAL_ENV_DISABLE_PROMPT

if [ "$(id -un)" = "ansible" ] && command -v gpgconf >/dev/null; then
    gpgconf --launch gpg-agent
fi

exec "$@"