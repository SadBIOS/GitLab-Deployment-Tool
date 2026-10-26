#!/bin/bash

if [[ $# -eq 0 ]]; then
    exit 0
fi

sudo -v || {
    printf "\n\e[31mAuthentication failed\e[0m\n" >&2
    exit 1
}

SCRIPT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BINPATH="$SCRIPT_ROOT/gitlab_bin.deb"

while [[ $# -gt 0 ]]; do
    case "$1" in

    esac
done