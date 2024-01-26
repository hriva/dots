## Get the aliases and functions
if [ -f ~/.zshrc ]; then
	. ~/.zshrc
fi

# User specific environment and startup programs
if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_LOG="PlatformDecoderModule:5"
fi
