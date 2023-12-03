#!/usr/bin/env bash

dconf load /org/gnome/shell/extensions/pop-shell/ < ~/DOTFILES/config/gnome-shell/keybinds-pop-shell.toml
dconf load /org/gnome/shell/extensions/forge/keybindings/ < ~/DOTFILES/config/gnome-shell/keybinds-forge.toml
dconf load /org/gnome/desktop/wm/keybindings/ < ~/DOTFILES/config/gnome-shell/keybinds-wm.toml
dconf load /org/gnome/mutter/keybindings/ < ~/DOTFILES/config/gnome-shell/keybinds-mutter.toml
dconf load /org/gnome/mutter/wayland/keybindings/ < ~/DOTFILES/config/gnome-shell/keybinds-mutter-wayland.toml
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ~/DOTFILES/config/gnome-shell/keybinds-settingsdaemon-mediakeys.toml

