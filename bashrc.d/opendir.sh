#!/usr/bin/env bash

if [[ -n "$BASH_VERSION" ]]; then
	bind -m emacs -x '"\C-O": " __zoxide_zi\C-m"'

elif [[ -n "$ZSH_VERSION" ]]; then
	open_dir_vs() {
		__zoxide_zi
		zle reset-prompt
	}
	zle -N open_dir_vs
	bindkey "^O" open_dir_vs

fi
