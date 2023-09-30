#!/usr/bin/env bash

dconf dump /org/gnome/shell/extensions/pop-shell/ > ~/DOTFILES/config/gnome-shell/keybinds-pop-shell.toml
dconf dump /org/gnome/desktop/wm/keybindings/ > ~/DOTFILES/config/gnome-shell/keybinds-wm.toml
dconf dump /org/gnome/mutter/keybindings/ > ~/DOTFILES/config/gnome-shell/keybinds-mutter.toml
dconf dump /org/gnome/mutter/wayland/keybindings/ > ~/DOTFILES/config/gnome-shell/keybinds-mutter-wayland.toml
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > ~/DOTFILES/config/gnome-shell/keybinds-settingsdaemon-mediakeys.toml

