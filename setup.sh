#!/bin/bash

if [[ $# -eq 0 ]]; then
    exit 0
fi

sudo -v || {
    printf "\n\e[31mAuthentication failed\e[0m\n" >&2
    exit 1
}

SCRIPT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
RUNTIME="$SCRIPT_ROOT/apt_engine.sh"
PKGLIST="$SCRIPT_ROOT/pkglist.txt"
PKG_ARCH="$SCRIPT_ROOT/gitlab_dependencies.tar.gz"
EXTERN_PACK_RESOLVER="$SCRIPT_ROOT/deployer.sh"

GIT_BIN="https://packages.gitlab.com/gitlab/gitlab-ee/debian/trixie/pool/main/g/gitlab-ee/gitlab-ee_19.5.1-ee.0_amd64.deb"

MAX_ATTEMPTS=5
ATTEMPTS=0

DEPS=(
    wget
    unzip
)


function conn_stat() {
    ping -c 1 -W 2 1.1.1.1 &>/dev/null || ping -c 1 -W 2 8.8.8.8 &>/dev/null
}

function makepkg_cache() {
    if conn_stat; then
        if [[ -f "$PKGLIST" || -f "$PKG_ARCH" ]]; then
            rm -vrf "$PKGLIST"
            rm -vrf "$PKG_ARCH"
        fi

        printf '%s\n' "${DEPS[@]}" > "$PKGLIST"

        "$RUNTIME" --gen-pkglist "$PKGLIST"
        
        if [[ -f "$PKGLIST" ]]; then
            rm -vrf "$PKGLIST"
        fi

        find $SCRIPT_ROOT -maxdepth 1 -type f -name 'depsys-custpkg-*.tar.gz' -exec mv -v {} "$PKG_ARCH" \;
    fi
}

function offline() {
    if [[ ! -f "$PKG_ARCH" ]]; then
        if ! conn_stat; then
            echo -e "\033[31mNo Dependency archive was found\033[0m" >&2
            echo -e "\033[31mAdditionally the machine is offline thus dependency archive creation is not possible\033[0m" >&2
            exit 1
        else
            makepkg_cache
        fi
    else
        "$RUNTIME" --dgst-pkglist "$PKG_ARCH"
    fi
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --build-offline-archive)
        	makepkg_cache
        	offline
            wget -O "$SCRIPT_ROOT/gitlab_bin.deb" "$GIT_BIN"
            exit 0
        ;;

        --deploy)
        	
            exit 0
        ;;
    esac
done


while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
    echo "Please choose a deployment setup:"
    echo "1. Admin + 10 Concurrent Users"
    echo "2. Admin + 1 User"
    read -p "Please enter your choice (1 or 2): " CHOICE

    if [ "$CHOICE" = "1" ]; then
        echo "Success! You selected Option 1."
        exit 0
    elif [ "$CHOICE" = "2" ]; then
        echo "Success! You selected Option 2."
        exit 0
    else
        ATTEMPTS=$((ATTEMPTS + 1))
        REMAINING=$((MAX_ATTEMPTS - ATTEMPTS))

        if [ $REMAINING -gt 0 ]; then
            echo "Invalid choice. Please enter only 1 or 2. ($REMAINING attempts left)"
            echo "--------------------------------------------------"
        else
            echo "Maximum incorrect attempts ($MAX_ATTEMPTS) reached. Exiting."
            exit 1
        fi
    fi
done