#!/usr/bin/env zsh
# vi:ft=sh
#
# Dump shell eval hooks for zsh. Then compiles them for faster startup
if [[ -z "$ZSH_VERSION" ]]; then
    echo "This is a zsh only script."
    exit 1
fi

fzf_eval() {
    if which fzf &>/dev/null; then
        echo 'FZF found'
        fzf --zsh >"$compiles"/fzf-init.zsh
        sed -i '/end: key-bindings.zsh ###/,$d' "$compiles"/fzf-init.zsh
        zcompile "$compiles"/fzf-init.zsh
    else
        echo "no fzf command"
    fi
}

zoxide_init() {
    if which zoxide &>/dev/null; then
        echo 'zoxide found'
        zoxide init zsh >"$compiles"/zoxide-init.zsh
        zcompile "$compiles"/zoxide-init.zsh
    else
        echo "no zoxide command"
    fi
}

direnv_eval() {
    if which direnv &>/dev/null; then
        echo 'direnv found'
        direnv hook zsh >"$compiles"/direnv-init.zsh
        zcompile "$compiles"/direnv-init.zsh
    else
        echo "no direnv command"
    fi
}

dump_evals() {
    fzf_eval
    zoxide_init
    direnv_eval
}

if [[ -n "$ZDOTDIR" ]]; then
    compiles="$ZDOTDIR"/compile
    if [[ ! -d "$compiles" ]]; then
        mkdir "$compiles"
    fi
    dump_evals
else
    echo "Compile dir not found"
    exit 1
fi
