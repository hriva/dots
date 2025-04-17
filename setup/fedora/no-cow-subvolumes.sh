#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [ "$UID" -ne 0 ]; then
    echo "This script most be run as root"
fi

IMAGE_DIR="/var/lib/libvirt/images"
if [[ -d "$IMAGE_DIR" ]]; then
    if [[ -z "$(ls -A "$IMAGE_DIR")" ]]; then
        echo "DIR $IMAGE_DIR must be empty"
        exit
    fi
    rm -ri "$IMAGE_DIR"
fi

mkdir "$IMAGE_DIR"
chattr +C "$IMAGE_DIR"
chcon -t virt_image_t "$IMAGE_DIR"
chmod 722 "$IMAGE_DIR"
setfacl -m u:qemu:rwx "$IMAGE_DIR"
restorecon -v "$IMAGE_DIR"
