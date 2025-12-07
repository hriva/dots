#!/usr/bin/env bash

dconf load /org/gnome/shell/extensions/pop-shell/ < keybinds-pop-shell.toml
dconf load /org/gnome/desktop/wm/keybindings/ < keybinds-wm.toml
dconf load /org/gnome/mutter/keybindings/ < keybinds-mutter.toml
dconf load /org/gnome/mutter/wayland/keybindings/ < keybinds-mutter-wayland.toml
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < keybinds-settingsdaemon-mediakeys.toml
