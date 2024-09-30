# https://zsh.sourceforge.io/Doc/Release/Files.html
# $ZDOTDIR/.zshenv $ZDOTDIR/.zprofile $ZDOTDIR/.zshrc $ZDOTDIR/.zlogin $ZDOTDIR/.zlogout
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# Execute code in the background to not affect the current session
(    # <https://github.com/zimfw/zimfw/blob/master/login_init.zsh>
    autoload -U zrecompile
    # Compile zcompdump, if modified, to increase startup speed.
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        zrecompile -pq "$zcompdump"
    fi
    # zcompile .zshrc
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zshrc
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zprofile
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zshenv
    # recompile all zsh or sh
    for f in "${ZDOTDIR:-${HOME}}"/compile/*
    do
        zrecompile -pq "$f"
    done
) &!
