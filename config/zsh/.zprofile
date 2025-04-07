# https://zsh.sourceforge.io/Doc/Release/Files.html
# $ZDOTDIR/.zshenv $ZDOTDIR/.zprofile $ZDOTDIR/.zshrc $ZDOTDIR/.zlogin $ZDOTDIR/.zlogout
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# User specific environment and startup programs
if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
	export MOZ_ENABLE_WAYLAND=1
	export MOZ_LOG="PlatformDecoderModule:5"
fi

export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
export ZSH_PROF_SRCD=1
