#!/usr/bin/env bash

if [ "$BASH_VERSION" != "" ]; then
	bind -m emacs -x '"\C-P": zi && nvim'
elif [ "$ZSH_VERSION" != "" ]; then

	open_dir_vs() {
		__zoxide_zi && nvim
		zle reset-prompt
	}
	zle -N open_dir_vs
	bindkey "^O" open_dir_vs

fi
