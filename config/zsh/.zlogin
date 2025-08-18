# https://zsh.sourceforge.io/Doc/Release/Files.html
# $ZDOTDIR/.zshenv $ZDOTDIR/.zprofile $ZDOTDIR/.zshrc $ZDOTDIR/.zlogin $ZDOTDIR/.zlogout
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# Execute code in the background to not affect the current session
(    # <https://github.com/zimfw/zimfw/blob/master/login_init.zsh>
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

    autoload -U zrecompile
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zshrc
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zprofile
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zshenv

    if [[ -f "$zcompdump" ]]; then
        zrecompile -pq "$zcompdump"
    fi

    # Recompile all zsh or sh files
    for f in "${ZDOTDIR:-${HOME}}"/compile/*; do
        [[ -f "$f" ]] && zrecompile -pq "$f"
    done
) &!
