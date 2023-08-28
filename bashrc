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

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
eval "$(starship init bash)"

HISTIGNORE='rm *:svn revert*:source /home/*/devel-env/bin/activate:/home/*/devel-env/bin/python'
HISTSIZE=10000
HISTCONTROL=ignoredups:erasedups:ignorespace
HISTFILESIZE=11000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

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
#alias ll='ls -lh --color=always --group-directories-first'
#alias la='ls -lah --color=always --group-directories-first'
alias ll='exa -lar --icons --sort modified --group-directories-first --git'
alias ls='exa -lr --icons --group-directories-first --sort name'
alias la='exa -lar --icons --group-directories-first --sort name'
alias lR='exa -larTR --icons --group-directories-first --sort name'
alias docker='podman'
alias ducks='du -cks * | sort -rn'
alias pkghist='rpm -qa --last | less'
alias dt='date "+%Y%m%dT%H%M%S"'
alias nbash='nvim ~/.bashrc'
alias zps="ps aux | awk '$8 ~ /^[Zz]/'"
alias gitstat='git status -uno'
alias diffside='diff --side-by-side --ignore-all-space'
alias gh='cd ~'
alias gD='cd $HOME/Documentos'
alias gd='cd $HOME/Descargas'
alias gs='cd $HOME/DOTFILES'
alias services='systemctl --type=service --state=running'

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
alias fzbat="fzf --border=rounded --preview 'bat --color always {}'"
alias fzless="fzf --preview 'less {}'"
alias fzfpath='tree -afR /home/$USER | fzf'
alias fzfcd='cd $(find /home/$USER -type d | fzf)'
alias vim='nvim'
alias pgrep='pgrep -li'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# GPU
alias check-driver='lspci -nnk | grep -iA2 vga'
alias fgovernor='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'

# CPU 
alias governors='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors'
alias alsa-cards='cat /proc/asound/cards'
# alias cpu-low='echo conservative | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'

# Intel Performance Bias (EPB)
# EPB vales 0,4,6,8,15 for performance, balance-performance, normal default, balance-power, power
# https://wiki.archlinux.org/title/CPU_frequency_scaling#Intel_performance_and_energy_bias_hint
alias intel-balance-power='echo 8 | sudo tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias'
alias intel-prefer-power='echo 15 | sudo tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias'
alias intel-prefer-balance='echo 6 | sudo tee /sys/devices/system/cpu/cpu*/power/energy_perf_bias'
alias get-intel-epb='cat /sys/devices/system/cpu/cpu*/power/energy_perf_bias | uniq'

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
    #alias nix-install="nix profile install"
    #alias nix-remove="nix profile remove"

    nix_install () {
        nix profile install nixpkgs\#"$1"
    }

    nix_remove () {
        nix profile remove "$1" && nix-collect-garbage
    }
fi

# Functions
flatpak-purge(){
    flatpak uninstall $1
    local flatpak_conf=~/.var/app/$1
    if [[ -d $flatpak_conf ]]; then
        trash -v $flatpak_conf
        echo "$flatpak_conf removed"
    fi
}

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

# Check if directory is writeable
is-writeable () {
[ -w "$1" ] && echo "WRITEABLE" || echo "NOT WRITEABLE"
}

# Get process without line wrap
psg () {
    printf '\033[?7l' # prevent linewrap
    ps aux | grep "$1"
    printf '\033[?7h' # prevent linewrap
}
