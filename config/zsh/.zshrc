# zmodload zsh/zprof 
# .zshrc 
iatest=$(expr index "$-" i)

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST   
setopt extendedglob notify
setopt autocd
setopt inc_append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups  # -h
setopt hist_ignore_space  # -g
setopt hist_ignore_all_dups
bindkey -e

# End of lines configured by zsh-newuser-install
zstyle '*:compinit' arguments -i -u 
zstyle -e ':autocomplete:list-choices:*' list-lines 'reply=( $(( LINES / 3 )) )'
zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 3
zstyle ':autocomplete:history-search-backward:*' list-lines 8

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

# Plugins
if [ -f "$ZDOTDIR"/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
  . "$ZDOTDIR"/zsh-autocomplete/zsh-autocomplete.plugin.zsh
  bindkey '\t' menu-select "${terminfo[kcbt]}" menu-select
  () {  # RESET 'UP' 'DOWN' KEYBIND AFTER zsh-autocomplete
     local -a prefix=( '\e'{\[,O} )
     local -a up=( ${^prefix}A ) down=( ${^prefix}B )
     local key=
     for key in $up[@]; do
        bindkey "$key" up-line-or-history
     done
     for key in $down[@]; do
        bindkey "$key" down-line-or-history
     done
  }
else
# Check cached .zcompdump for regeneration once a day.
  autoload -Uz compinit
  if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	  compinit -i -u;
  else
	  compinit -C -i -u;
  fi;
fi

if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # Declare the variable
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[path]='none'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=red'
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
HISTSIZE=10000
SAVEHIST=10000

alias vzsh='/usr/bin/nvim "$ZDOTDIR"/.zshrc'

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

precmd(){
    fc -R
    vcs_info
}

# PROMT
PROMPT='%n %~ ${vcs_info_msg_0_}
%# '

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# zprof
