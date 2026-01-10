#!/usr/bin/env bash
#
# non free codecs
if [ "UID" -ne 0 ]; then
    echo "This script must be run as root"
fi
dnf swap mesa-va-drivers mesa-va-drivers-freeworld
dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
dnf swap ffmpeg-free ffmpeg --allowerasing
dnf install radeontop
