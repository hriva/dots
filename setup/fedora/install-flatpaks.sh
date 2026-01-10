#!/usr/bin/env bash
#
# Base Flatpak package list

PKG_LIST=(
    com.belmoussaoui.Authenticator
    com.bitwarden.desktop
    com.github.qarmin.czkawka
    com.github.tchx84.Flatseal
    com.mattjakeman.ExtensionManager
    com.visualstudio.code.tool.podman
    io.podman_desktop.PodmanDesktop
    it.mijorus.gearlever
    md.obsidian.Obsidian
    org.cryptomator.Cryptomator
    org.gtk.Gtk3theme.adw-gtk3
    org.gtk.Gtk3theme.adw-gtk3-dark
    org.dbgate.DbGate
    io.github.seadve.Kooha
)

flatpak install "${PKG_LIST[@]}"
