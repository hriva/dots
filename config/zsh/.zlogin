# https://zsh.sourceforge.io/Doc/Release/Files.html
# $ZDOTDIR/.zshenv $ZDOTDIR/.zprofile $ZDOTDIR/.zshrc $ZDOTDIR/.zlogin $ZDOTDIR/.zlogout
# Global Order: zshenv, zprofile, zshrc, zlogin
#
# Execute code in the background to not affect the current session
(    # <https://github.com/zimfw/zimfw/blob/master/login_init.zsh>
    zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

    # Function to check if regeneration is needed
    _should_regenerate_compdump() {
        # Check if file exists and is less than 24 hours old
        [[ ! -f "$zcompdump" ]] && return 0

        # Use find for portable 24-hour check
        if command -v find >/dev/null 2>&1; then
            [[ -z "$(find "$zcompdump" -mtime -1 2>/dev/null)" ]] && return 0
        else
            # Fallback: regenerate if find is not available (guess: unlikely but safe)
            return 0
        fi

        return 1
    }

    if _should_regenerate_compdump; then #if zcomp age > 24hrs
        autoload -Uz compinit

        /usr/bin/rm -f "$zcompdump" "$zcompdump".zwc 2> /dev/null
        compinit # dump
        ZCOMPDUMP=1
    fi

    autoload -U zrecompile
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zshrc
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zprofile
    zrecompile -pq "${ZDOTDIR:-${HOME}}"/.zshenv
    zrecompile -pq "$zcompdump"

    # recompile all zsh or sh
    for f in "${ZDOTDIR:-${HOME}}"/compile/*
    do
        zrecompile -pq "$f"
    done
) &!
