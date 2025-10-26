#shellcheck shell=bash
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# vars
export EDITOR=neovide
export WGETRC=$HOME/.config/.wgetrc
export MOZ_ENABLE_WAYLAND=1
export _ZO_RESOLVE_SYMLINKS=0
export BIOME_CONFIG_PATH=~/.config/biome/biome.json
export RIPGREP_CONFIG_PATH=~/.config/ripgreprc
export FZF_LAYOUT="--border=rounded"
export FZF_DEFAULT_OPTS="--keep-right --info=inline --bind=ctrl-z:ignore,btab:up,tab:down $FZF_LAYOUT"
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --height=40% --exact --no-sort --cycle --tabstop=1 --exit-0 --layout=reverse"
export SHELLCHECK_OPTS="-e SC2034"

# export DOCKER_CONFIG=${DOCKER_CONFIG:-"$HOME"/.local/share/docker}
# TODO: source from ~/.config/environment.d/global.conf

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
alias l='/usr/bin/ls -lhFG --color=always --group-directories-first'
alias la='/usr/bin/ls -alhFG --color=always --group-directories-first'
alias lm='/usr/bin/ls -alhFG -t --color=always --group-directories-first'
alias le='eza -la --git --icons --group-directories-first --sort name'
alias lz='eza -l --icons --group-directories-first --sort name'
alias lR='eza -laTR --icons --group-directories-first --sort name'
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
alias baks='sudo btrbk list snapshots'
alias quadlet-drun='/usr/libexec/podman/quadlet -dryrun'
alias rpm-gpg-keys='rpm -q --qf "%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n" gpg-pubkey | sort -k 2'
alias yesterday='date -d "yesterday 13:00" "+%Y-%m-%d"'
alias ls-uniq='find . -maxdepth 1 -type f -exec md5sum {} + | sort | uniq -w 33'

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
alias safereboot='sudo shutdown -r now'
# alias rebootforce='sudo shutdown -r -n now'

# alias chmod commands
alias mx='chmod u+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 740='chmod -R 740'
alias 750='chmod -R 750'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

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
# intel only: default performance balance_performance balance_power power
alias get-intel-epb='cat /sys/devices/system/cpu/cpu*/power/energy_perf_bias | uniq'

# Functions

# Get path usage
usage() {
    find "${1:-.}" -maxdepth 1 -type d -exec du -shx {} \; | sort -hr
}

# convert ascii file to UTF-8
ascii-to-utf8() {
    set -o errexit -o nounset -o pipefail -o errtrace
    if [[ "${TRACE-0}" == "1" ]]; then
        set -o xtrace
    fi

    if [[ $# -ne 2 ]]; then
        echo "Usage: ascii_to_utf8 [SOURCE_FILE] [DEST_FILE]"
    fi

    iconv -f iso-8859-1 -t UTF-8//TRANSLIT "$1" -o "$2"
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

rg-precmd() {
    case "$1" in
    *.pdf)
        exec pdftotext "$1" -
        ;;
    *)
        case $(file "$1") in
        *Zstandard*)
            exec pzstd -cdq
            ;;
        *)
            exec cat
            ;;
        esac
        ;;
    esac
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
    if whereis rg &>/dev/null; then
        rg -iHn --color=always -- "$1" "${2:-.}" | less -r
    else
        grep -iIHrn --color=always "$1" "${2:-.}" | less -r
    fi
}

ffw() {
    grep -iIrl "$1" "${2:-.}" |
        fzf --layout=default --height=100% --preview='bat --style=numbers --color=always --line-range :1000 {}'
}

# Quick find files
ff() {
    find "${2:-.}" -iname """*""$1*""" 2>/dev/null
    # echo '"*'"$1"'*"'
}

fcd() {
    local dir="${1:-.}"
    cd "$(find "$dir" -maxdepth 1 -type d | fzf --reverse)" || echo 1
}

# Get process without line wrap
psg() {
    printf '\033[?7l' # prevent linewrap
    ps aux | grep "$1"
    printf '\033[?7h' # prevent linewrap
}

lfcd() {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")" || exit
}

brzip() {
    /usr/bin/tar -cvf "$1" --use-compress-program="brotli -Z" "$@"
}

tar-zstd() {
    tar -cf "$1" -I 'zstd --ultra -22' "$@"
}

emf() {
    local file
    file=$(fzf --prompt="Edit: ")
    [[ -n $file ]] && "$EDITOR" "$file"
}

# Interactive directory change
cdd() {
    local dir
    dir=$(fd -t d | fzf --prompt="Directory: ")
    [[ -n $dir ]] && cd "$dir"
}

fed() {
    if [[ $# -ne 1 ]]; then
        echo "Usage:  requires 1 arguments but passed $#"
        return 1
    fi
    local file
    file=$(fd "$1" | fzf --preview 'bat --color always {}' --prompt="Edit: ")
    [[ -n $file ]] && "$EDITOR" "$file"
}

# Credit to
#https://github.com/basecamp/omarchy/blob/2df8c5f7e0a2aafb8c9aacb322408d2ed7682ea5/default/bash/functions
transcode-video-1080p() {
    ffmpeg -i "$1" -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy "${1%.*}"-1080p.mp4
}

# Transcode a video to a good-balance 4K that's great for sharing online
transcode-video-4K() {
    ffmpeg -i "$1" -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k "${1%.*}"-optimized.mp4
}

# Transcode any image to JPG image that's great for shrinking wallpapers
img2jpg() {
    magick "$1" -quality 95 -strip "${1%.*}".jpg
}

# Transcode any image to JPG image that's great for sharing online without being too big
img2jpg-small() {
    magick "$1" -resize 1080x\> -quality 95 -strip "${1%.*}".jpg
}

# Transcode any image to compressed-but-lossless PNG
img2png() {
    magick "$1" -strip -define png:compression-filter=5 \
        -define png:compression-level=9 \
        -define png:compression-strategy=1 \
        -define png:exclude-chunk=all \
        "${1%.*}.png"
}
