#!/usr/bin/env bash
#

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
    echo "You must be a root user to run this script" 2>&1
    exit 1
fi

# resolved_conf_path=$(realpath "$1")
resolved_conf_path=$(realpath "$1")
stub_path=/etc/systemd/resolved.conf.d

if [[ ! -f "$resolved_conf_path" ]]; then
    echo "$resolved_conf_path"
    echo "[×] Config file not found"
    exit 1
fi

if grep -q "[Resolve]" "$resolved_conf_path"; then
    echo "[✓] Valid file passed"
    if [[ ! -d "$stub_path" ]]; then
        mkdir -p "$stub_path"
        echo "[✓] Creating $stub_path"
    fi
    cp -f "$resolved_conf_path" "$stub_path"
    chmod 644 "$stub_path"/"$(basename "$resolved_conf_path")"
    echo "[✓] Config file installed"
    systemctl restart NetworkManager
    systemctl restart systemd-resolved.service
    echo "[✓] Networkf services restarted"
    echo "[✓] Success"
else
    echo "[×] configuration doesn't comply to resolved.conf"
    exit 1
fi
