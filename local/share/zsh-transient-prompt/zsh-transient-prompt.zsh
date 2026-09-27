#!/usr/bin/env zsh

# zsh transient prompt
#
# Requires:
#   - zsh ZLE
#   - Starship (or any other Zsh prompt)
#
# Load this AFTER starship init and AFTER plugins that modify the
# widgets you care about, especially zsh-autosuggestions.

# Configuration

# The normal prompt is whatever Starship installed.
typeset -g TRANSIENT_PROMPT_NORMAL_PROMPT=${TRANSIENT_PROMPT_NORMAL_PROMPT-$PROMPT}
typeset -g TRANSIENT_PROMPT_NORMAL_RPROMPT=${TRANSIENT_PROMPT_NORMAL_RPROMPT-$RPROMPT}

# Prompt displayed in scrollback after the command line has finished.
#
# This deliberately remains a Zsh prompt expression rather than being
# evaluated now.
typeset -g TRANSIENT_PROMPT_TRANSIENT_PROMPT=${TRANSIENT_PROMPT_TRANSIENT_PROMPT-'$(starship module character)'}
typeset -g TRANSIENT_PROMPT_TRANSIENT_RPROMPT=${TRANSIENT_PROMPT_TRANSIENT_RPROMPT-}

typeset -g TRANSIENT_PROMPT_ACTIVE=0

# Prompt state

_transientPromptSet() {
    (( TRANSIENT_PROMPT_ACTIVE )) && return 0

    TRANSIENT_PROMPT_ACTIVE=1

    PROMPT=$TRANSIENT_PROMPT_TRANSIENT_PROMPT
    RPROMPT=$TRANSIENT_PROMPT_TRANSIENT_RPROMPT

    # We are normally executing inside ZLE here.
    # reset-prompt re-expands both prompt strings.
    zle .reset-prompt 2>/dev/null
}

_transientPromptRestore() {
    # The next interactive prompt must always be the normal Starship one.
    TRANSIENT_PROMPT_ACTIVE=0

    PROMPT=$TRANSIENT_PROMPT_NORMAL_PROMPT
    RPROMPT=$TRANSIENT_PROMPT_NORMAL_RPROMPT
}

# ZLE hooks

_transientPromptLineFinish() {
    _transientPromptSet
}

# Register the hook rather than replacing other zle-line-finish logic.
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-finish _transientPromptLineFinish

# Explicit ZLE abort

_transientPromptSendBreak() {
    _transientPromptSet

    # IMPORTANT:
    # Call the builtin widget, not whatever happens to be named
    # "send-break" after our wrapper has replaced it.
    zle .send-break
}

zle -N send-break _transientPromptSendBreak

# SIGINT / Ctrl-C

TRAPINT() {
    _transientPromptSet
    return 130
}

# Restore before the next normal prompt

autoload -Uz add-zsh-hook
add-zsh-hook precmd _transientPromptRestore