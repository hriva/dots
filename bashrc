# .bashrc
iatest=$(expr index "$-" i)

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

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

unset rc

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
#<---------------------------------------START--------------------------------------------->

HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='cd:htop:rm *:svn revert*:source /home/*/devel-env/bin/activate:/home/*/devel-env/bin/python:*brave-browser*'
HISTSIZE=10000
HISTFILESIZE=11000

shopt -s histappend # Append to the history file upon exit
shopt -s checkwinsize # Check the window size after each command 
shopt -s autocd # Enable auto cd by typing a dir

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Ignore case on auto-completion
# Note: bind used instead of sticking these in .inputrc
if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

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

# Aliases
alias cdranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias l='/usr/bin/ls -lhF --color=always --group-directories-first'
alias la='/usr/bin/ls -alhF --color=always --group-directories-first'
alias lm='/usr/bin/ls -alhF -t --color=always --group-directories-first'
alias le='eza -la --icons --group-directories-first --sort name'
alias lz='eza -l --icons --group-directories-first --sort name'
alias lR='eza -laTR --icons --group-directories-first --sort name'
alias docker='podman'
alias ducks='du -cksh *'
alias usage='find . -maxdepth 1 -type d -exec du -shx {} \; | sort -hr'
alias pkghist='rpm -qa --last | less'
alias dt='date "+%Y%m%dT%H%M%S"'
alias nbash='nvim ~/.bashrc'
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
alias get-epp='cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference | uniq' 

# Conditional Aliases
if whereis btrbk 2>&1 > /dev/null; then
	alias baks='sudo btrbk list snapshots'
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
# Trap non zero errors
EC() {
	echo -e '\e[1;33m'code $?'\e[m\n'
}
trap EC ERR

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

eval "$(zoxide init bash)"
eval "$(starship init bash)"
