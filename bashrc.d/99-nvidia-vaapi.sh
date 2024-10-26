#!/usr/bin/env sh
#
# Override VAAPI settings.
# TODO: grep -P 'nvidia_gpu\s\d*\s[^0]' /proc/modules
if grep -q "Hybrid" /etc/supergfxd.conf; then
    export NVD_BACKEND=direct
    export VDPAU_DRIVER=nvidia
    export LIBVA_DRIVER_NAME=nvidia
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
    export MOZ_DISABLE_RDD_SANDBOX=1
    export LIBVA_MESSAGING_LEVEL=1
fi
