# .bashrc

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

HISTSIZE=10000
HISTCONTROL=ignoredups:erasedups
HISTFILESIZE=11000
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# vars
EDITOR=/usr/bin/nvim

# Aliases
alias cdranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias ll='exa -lar --icons --sort modified'
alias ls='exa -lr --icons'
alias la='exa -lar --icons'
alias docker='podman'
alias ducks='du -cks * | sort -rn'
alias pkghist='rpm -qa --last | less'
alias dt='date "+%Y%m%dT%H%M%S"'
alias nbash='nvim .bashrc'
alias zps="ps aux | awk '$8 ~ /^[Zz]/'"
alias gitstat='git status -uno'
alias diffside='diff --side-by-side --ignore-all-space'

# Alias's to modified commands
alias cp='cp -ipdv'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# GPU
alias check-driver='lspci -nnk | grep -iA2 vga'
alias fgovernor='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'

# CPU 
alias governors='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors'
alias alsa-cards='cat /proc/asound/cards'
alias cpu-low='echo conservative | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'

# Conditional Aliases
if rpm -V btrbk; then
	alias baks='sudo btrbk list snapshots'
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
