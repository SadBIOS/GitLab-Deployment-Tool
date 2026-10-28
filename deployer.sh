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

EXIT_IP="$(ip -4 addr show scope global | awk '/inet/ {print $2}' | cut -d/ -f1 | head -n1)"

CNF_NAM=""

function eleven_guys_one_server() {
    CNF_NAM="$SCRIPT_ROOT/thats-a-lot-of-guys.rb"
}

function one_guy_one_server() {
    CNF_NAM="$SCRIPT_ROOT/just-a-guy.rb"
}

function inschtall () {

}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --med-perf)
            eleven_guys_one_server
            
            exit 0
        ;;

        --low-perf)
            one_guy_one_server
            exit 0
        ;;
    esac
done
