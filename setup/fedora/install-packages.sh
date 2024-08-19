#!/usr/bin/env bash

xargs -a fedora-base-pkg-list.txt -d '\n' sudo dnf install -y --skip-broken
xargs -a fedora-rpmfusion-pkg-list.txt -d '\n' sudo dnf install -y --skip-broken
sudo rkhunter --update
sudo rkhunter --propup
sudo rkhunter --enable hidden_ports
