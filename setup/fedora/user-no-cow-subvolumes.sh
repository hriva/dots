#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [ "$UID" -eq 0 ]; then
    echo "This script most be run rootless"
fi

USER_DIRS=(
    ~/.local/share/gnome-boxes
    ~/.local/share/containers
    ~/.local/share/no-cow-vol
)

for dir in "${USER_DIRS[@]}"; do
    if [[ ! -d $dir ]]; then
        btrfs subvolume create "$dir"
        chattr +C "$dir"
    else
        echo "$dir already exists."
    fi
done
