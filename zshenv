export ZDOTDIR="$HOME"/.config/zsh
export HISTFILE=~/.zsh_history
export HISTORY_IGNORE='(cd *|htop|vi *|vim|z *|z -|la *|git pull|git push|ranger|gs|git s|git su|la|l|rm *|svn revert*|sudo dnf update|pyenv *|deactivate|fg|git push|git c|git commit|findme|flatpak update)'
export __DISABLE_ZPLUGINS=1
export RCS=1
export GLOBAL_RCS=1

# https://github.com/sorin-ionescu/prezto/blob/master/runcoms/zshenv
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
  source "${ZDOTDIR:-$HOME}/.zshrc"
fi
