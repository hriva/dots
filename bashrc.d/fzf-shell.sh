#!/usr/bin/env bash

# Check if the shell is Zsh or Bash
if [ -f /usr/share/fzf/shell/key-bindings.bash ] && [ "$BASH_VERSION" != "" ]; then
	source /usr/share/fzf/shell/key-bindings.bash
elif [ -f /usr/share/fzf/shell/key-bindings.zsh ] && [ "$ZSH_VERSION" != "" ]; then
	source /usr/share/fzf/shell/key-bindings.zsh
fi
