#!/usr/bin/env bash

dconf dump /org/gnome/shell/extensions/pop-shell > ~/DOTFILES/config/gnome-shell/keybinds-pop-shell.conf
dconf dump /org/gnome/shell/extensions/pop-shell/ > ~/DOTFILES/config/gnome-shell/keybinds-pop-shell.conf
dconf dump /org/gnome/desktop/wm/keybindings/ > ~/DOTFILES/config/gnome-shell/keybinds-wm.conf
dconf dump /org/gnome/mutter/keybindings/ > ~/DOTFILES/config/gnome-shell/keybinds-mutter.conf
dconf dump /org/gnome/mutter/wayland/keybindings/ > ~/DOTFILES/config/gnome-shell/keybinds-mutter-wayland.conf
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > ~/DOTFILES/config/gnome-shell/keybinds-settingsdaemon-mediakeys.conf

