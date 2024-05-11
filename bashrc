# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			# TIMEFORMAT="$rc: %E"
			# time . "$rc"
			# unset TIMEFORMAT
			. "$rc"
		fi
	done
fi

unset rc

HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='cd:htop:vi:vim:z:z -:ls:git pull:git push:ranger:gs:git s:la:l:rm *:svn revert*:sudo dnf update'
HISTSIZE=20000
HISTFILESIZE=20000

shopt -s histappend   # Append to the history file upon exit
shopt -s checkwinsize # Check the window size after each command
shopt -s autocd       # Enable auto cd by typing a dir

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
bind "set completion-ignore-case on"

# Show auto-completion list automatically, without double tab
bind "set show-all-if-ambiguous On"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# vars
export EDITOR=/usr/bin/nvim
export WGETRC=$HOME/.config/.wgetrc
export MOZ_ENABLE_WAYLAND=1

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

alias vbash='nvim ~/.bashrc'
alias source-rc='source ~/.bashrc'

# Trap non zero errors
EC() {
	echo -e '\e[1;33m'code $?'\e[m'
}
trap EC ERR

# Mimic zsh run-help keybind
run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE" 2>/dev/null; }
bind -m vi-insert -x '"\eh": run-help'
bind -m emacs -x '"\eh": run-help'

eval "$(zoxide init bash)"
eval "$(starship init bash)"
