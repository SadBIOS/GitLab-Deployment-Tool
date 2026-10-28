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
    MODIFIED_CONTENT="$(sed "s/IPIPIP_PIPIPI/$EXIT_IP/g" "$CNF_NAM")"
    TMP_FILE="$(mktemp)"
    sudo awk -v REPL="$MODIFIED_CONTENT" '{
        if ($0 ~ /^external_url[[:space:]]/) {
            print REPL
        } else {
            print
        }
    }' /etc/gitlab/gitlab.rb > "$TMP_FILE"
    sudo cp -v "$TMP_FILE" /etc/gitlab/gitlab.rb
    rm -vrf "$TMP_FILE"
}

function one_guy_one_server() {
    CNF_NAM="$SCRIPT_ROOT/just-a-guy.rb"
    MODIFIED_CONTENT="$(sed "s/IPIPIP_PIPIPI/$EXIT_IP/g" "$CNF_NAM")"
    TMP_FILE="$(mktemp)"
    sudo awk -v REPL="$MODIFIED_CONTENT" '{
        if ($0 ~ /^external_url[[:space:]]/) {
            print REPL
        } else {
            print
        }
    }' /etc/gitlab/gitlab.rb > "$TMP_FILE"
    sudo cp -v "$TMP_FILE" /etc/gitlab/gitlab.rb
    rm -vrf "$TMP_FILE"
}

function inschtall () {
    sudo gitlab-ctl reconfigure
    sudo gitlab-rails runner "Feature.disable(:duo_agent_platform_widget_self_managed)"
    sudo gitlab-rails runner "User.find_each { |u| u.avatar = nil; u.save(validate: false) }"
    sudo gitlab-rake cache:clear
    sudo gitlab-ctl restart
}

function gootlab_creds() {
    PASSWORD="$(sudo awk '/^Password:/ {print $2}' /etc/gitlab/initial_root_password)"
    printf "\n\e[32mServer is up and running!\e[0m\n"
    printf "The following credentials are valid for \e[31m24 Hours\e[0m\n"
    printf "temp_username: root\n"
    printf "temp_password: %s\n" "$PASSWORD"
    printf "login_portal: http://%s/\n" "$EXIT_IP"
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --med-perf)
            eleven_guys_one_server
            inschtall
            clear
            gootlab_creds
            exit 0
        ;;

        --low-perf)
            one_guy_one_server
            inschtall
            clear
            gootlab_creds
            exit 0
        ;;
    esac
done
