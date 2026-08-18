# .bash_profile

USER_ENV_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/environment"
[[ -f "$USER_ENV_FILE" ]] && source "$USER_ENV_FILE"

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_LOG="PlatformDecoderModule:5"
fi

export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
