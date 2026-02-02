#!/bin/bash
set -e

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

source /var/ansible/ansible-env/bin/activate

exec "$@"