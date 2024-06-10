#shellcheck shell=bash
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# vars
export EDITOR=/usr/bin/nvim
export WGETRC=$HOME/.config/.wgetrc
export MOZ_ENABLE_WAYLAND=1
export _ZO_RESOLVE_SYMLINKS=0

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Alias's to modified commands
alias cp='cp -ipdv'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ping='ping -c 10'
alias less='less -R'
alias c='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias curl="curl --proto '=https' --tlsv1.2 -Sf -L"
alias fzf='fzf --border=rounded'
alias vim='nvim'
alias pgrep='pgrep -li'
alias fd='fd -ui'
alias neo='neo --charset=devanagari -F'

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
alias pkghist='rpm -qa --last | less'
alias dt='date "+%Y%m%dT%H%M%S"'
alias zps="ps aux | awk '$8 ~ /^[Zz]/'"
alias diffside='diff --side-by-side --ignore-all-space --suppress-common-lines'
alias gh='cd ~'
alias gD='cd $HOME/Documentos'
alias gd='cd $HOME/Descargas'
alias gs='cd $HOME/DOTFILES'
alias services='systemctl --type=service --state=running'
alias px='ps auxf'
alias elf='ps -elf'
alias findme='xdg-open .' # Use mime app
alias kat='bat --plain --paging=always'
alias fbat="fzf --border=rounded --preview 'bat --color always {}'"
alias fless="fzf --preview 'less {}'"
alias fzfpath='tree -afR /home/$USER | fzf'
alias update-grub='grub2-mkconfig -o /boot/grub2/grub.cfg'
alias osshfs='sudo sshfs -o allow_other,default_permissions'
alias zim='__zoxide_zi && nvim'

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
alias baks='sudo btrbk list snapshots'

# Functions

# Get path usage
usage() {
	find "${1:-.}" -maxdepth 1 -type d -exec du -shx {} \; | sort -hr
}

# Extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf "$archive" ;;
			*.tar.gz) tar xvzf "$archive" ;;
			*.bz2) bunzip2 "$archive" ;;
			*.rar) rar x "$archive" ;;
			*.gz) gunzip "$archive" ;;
			*.tar) tar xvf "$archive" ;;
			*.tbz2) tar xvjf "$archive" ;;
			*.tgz) tar xvzf "$archive" ;;
			*.zip) unzip "$archive" ;;
			*.Z) uncompress "$archive" ;;
			*.7z) 7z x "$archive" ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Searches for text in all files in the current folder
fw() {
	# -i case-insensitive
	# -I ignore binary files
	# -H causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -F treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iIHrn --color=always "$1" "${2:-.}" | less -r
}

# Quick find files
ff() {
	find "${2:-.}" -iname """*""$1*""" 2>/dev/null
	# echo '"*'"$1"'*"'
}

fcd() {
	local dir="${1:-.}"
	cd "$(find "$dir" /home/"$USER" -type d | fzf)" || echo 1
}

# Get process without line wrap
psg() {
	printf '\033[?7l' # prevent linewrap
	ps aux | grep "$1"
	printf '\033[?7h' # prevent linewrap
}
