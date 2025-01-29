#!/usr/bin/env bash

FNM_PATH="$HOME"/.local/share/fnm
if [[ -d "$FNM_PATH" ]] && which fnm &>/dev/null; then
    export PATH=$FNM_PATH/aliases/latest/bin:$PATH
else
    return
fi

fnm_load() {
    unset -f fnm
    if [[ "$FNM_SOURCED" -ne 1 ]]; then
        eval "$(fnm env)"
        FNM_SOURCED=1
    fi
}

fnm() {
    fnm_load
    ~/.local/bin/fnm "$@"
}
