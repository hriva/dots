# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_LOG="PlatformDecoderModule:5"
fi

# Override libva Driver for amd
export LIBVA_DRIVER_NAME=radeonsi

# Export VAAPI for Nvidia
#if rpm -V nvidia-vaapi-driver; then
#    export MOZ_DISABLE_RDD_SANDBOX=1
#    export EGL_PLATFORM=wayland
#    export LIBVA_DRIVER_NAME=nvidia
#    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/10_nvidia.json
#fi

# Export THEME
export GTK_THEME=Colloid-Dark
