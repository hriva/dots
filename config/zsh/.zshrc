
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle :compinstall filename '/home/alquimista/.zshrc'

#autoload -Uz compinit
#compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extendedglob notify
bindkey -v
# End of lines configured by zsh-newuser-install

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST

#plugins
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # Declare the variable
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[path]='none'
  ZSH_HIGHLIGHT_STYLES[precommand]='fg=red'
fi

if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f $ZDOTDIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
  source $ZDOTDIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi


# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

__vte_urlencode() (
  # This is important to make sure string manipulation is handled
  # byte-by-byte.
  LC_ALL=C
  str="$1"
  while [ -n "$str" ]; do
    safe="${str%%[!a-zA-Z0-9/:_\.\-\!\'\(\)~]*}"
    printf "%s" "$safe"
    str="${str#"$safe"}"
    if [ -n "$str" ]; then
      printf "%%%02X" "'$str"
      str="${str#?}"
    fi
  done
)

__vte_osc7 () {
  printf "\033]7;file://%s%s\007" "${HOSTNAME:-}" "$(__vte_urlencode "${PWD}")"
}

__vte_prompt_command() {
  local command=$(HISTTIMEFORMAT= history 1 | sed 's/^ *[0-9]\+ *//')
  command="${command//;/ }"
  local pwd='~'
  [ "$PWD" != "$HOME" ] && pwd=${PWD/#$HOME\//\~\/}
  printf "\033]777;Command completed;%s\007\033]0;%s@%s:%s\007%s" "${command}" "${USER}" "${HOSTNAME%%.*}" "${pwd}" "$(__vte_osc7)"
}

case "$TERM" in
  xterm*|vte*)
    [ -n "$BASH_VERSION" ] && PROMPT_COMMAND="__vte_prompt_command"
    [ -n "$ZSH_VERSION"  ] && precmd_functions+=(__vte_osc7)
    ;;
esac

#----------------------------------------START-----------------------------------------------

ZDOTDIR=$HOME/.config/zsh
HISTCONTROL="ignoredups:erasedups:ignorespace"

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'} history -a; history -c; history -r"

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

# Aliases
alias cdranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias ls='/usr/bin/ls -lhF --color=always --group-directories-first'
alias la='/usr/bin/ls -alhF --color=always --group-directories-first'
alias lm='/usr/bin/ls -alhF -t --color=always --group-directories-first'
alias ll='exa -la --icons --group-directories-first'
alias le='exa -l --icons --group-directories-first --sort name'
alias lR='exa -laTR --icons --group-directories-first --sort name'
alias docker='podman'
alias ducks='du -cksh *'
alias usage='find . -maxdepth 1 -type d -exec du -shx {} \; | sort -hr'
alias pkghist='rpm -qa --last | less'
alias dt='date "+%Y%m%dT%H%M%S"'
alias vzsh='/usr/bin/nvim $ZDOTDIR/.zshrc'
alias zps="ps aux | awk '$8 ~ /^[Zz]/'"
alias diffside='diff --side-by-side --ignore-all-space --suppress-common-lines'
alias gh='cd ~'
alias gD='cd $HOME/Documentos'
alias gd='cd $HOME/Descargas'
alias gs='cd $HOME/DOTFILES'
alias services='systemctl --type=service --state=running'
alias flatpak-list='flatpak --columns=app,name,size list'
alias elf='ps -elf'
alias findme='nohup nautilus . 2>&1 > /dev/null &'

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Search files in the current folder
alias f="find . | grep "

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Alias's for safe and forced reboots
alias safereboot='sudo shutdown -r now'
# alias rebootforce='sudo shutdown -r -n now'

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# alias chmod commands
alias mx='chmod u+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 740='chmod -R 740'
alias 750='chmod -R 750'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Alias's to modified commands
alias cp='cp -ipdv'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias px='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias c='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias curl="curl --proto '=https' --tlsv1.2 -Sf -L"
alias fzf='fzf --border=rounded'
alias fbat="fzf --border=rounded --preview 'bat --color always {}'"
alias fless="fzf --preview 'less {}'"
alias fzfpath='tree -afR /home/$USER | fzf'
alias fcd='cd $(find /home/$USER -type d | fzf)'
alias vim='nvim'
alias pgrep='pgrep -li'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# GPU
alias check-driver='lspci -nnk | grep -iA2 vga'
alias fgovernor='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'

# CPU https://docs.kernel.org/admin-guide/pm/working-state.html
alias governors='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors'
alias alsa-cards='cat /proc/asound/cards'
# Intel/AMD HWP performance, balance_performance, default, balance_power, power
alias epp-avaliable-policies='cat /sys/devices/system/cpu/cpufreq/policy0/energy_performance_available_preferences'
alias epp-default-power='echo default | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference'
alias epp-balance-power='echo balance_power | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference'
alias epp-prefer-power='echo power | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference'
alias get-epp='cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference | uniq' 

# Conditional Aliases
if whereis btrbk 2>&1 > /dev/null; then
	alias baks='sudo btrbk list snapshots'
fi

# CPU Specific tweaks
if grep -q intel /proc/cpuinfo; then
    # Intel Performance Bias (EPB)
    # EPB vales 0,4,6,8,15 for performance, balance-performance, normal default, balance-power, power
    # https://wiki.archlinux.org/title/CPU_frequency_scaling#Intel_performance_and_energy_bias_hint
    alias intel-epb-balance-power='echo 8 | sudo tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias'
    alias intel-epb-prefer-power='echo 15 | sudo tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias'
    alias intel-epb-prefer-balance='echo 6 | sudo tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias'

	get_intel_energy () {
	 cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference | uniq
	 cat /sys/devices/system/cpu/cpu*/power/energy_perf_bias | uniq
	}
#elif grep -q AMD /proc/cpuinfo; then
#    true
fi

# Nix aliases for Determinate Systems install if nix found
if whereis nix 2>&1 > /dev/null; then
    alias nix-upgrade="sudo -i sh -c 'nix upgrade-nix'"
    alias nix-update="nix profile upgrade '.*'"
    alias nix-search="nix search nixpkgs"
    alias nix-list="nix profile list | grep 'Flake attribute' | awk '{print $3}'"
    alias nix-hist="nix profile history"
    alias nix-rollb="nix profile rollback"

    nix_install () {
        nix profile install nixpkgs\#"$1"
    }

    nix_remove () {
        nix profile remove "$1" && nix-collect-garbage
    }
fi

# Functions

# Extracts any archive(s) (if unp isn't installed)
extract () {
	for archive in "$@"; do
		if [ -f "$archive" ] ; then
			case $archive in
				*.tar.bz2)   tar xvjf $archive    ;;
				*.tar.gz)    tar xvzf $archive    ;;
				*.bz2)       bunzip2 $archive     ;;
				*.rar)       rar x $archive       ;;
				*.gz)        gunzip $archive      ;;
				*.tar)       tar xvf $archive     ;;
				*.tbz2)      tar xvjf $archive    ;;
				*.tgz)       tar xvzf $archive    ;;
				*.zip)       unzip $archive       ;;
				*.Z)         uncompress $archive  ;;
				*.7z)        7z x $archive        ;;
				*)           echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
ftext ()
{
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" . | less -r
}


# Get process without line wrap
psg () {
    printf '\033[?7l' # prevent linewrap
    ps aux | grep "$1"
    printf '\033[?7h' # prevent linewrap
}

precmd(){
    vcs_info
}

# PROMT
PROMPT='%n %~ ${vcs_info_msg_0_}
%# '

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

