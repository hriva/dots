#!/usr/bin/env bash

xargs -a $PWD/fedora-base-pkg-list.txt -d '\n' sudo dnf install -y --skip-broken
xargs -a $PWD/fedora-rpmfusion-pkg-list.txt -d '\n' sudo dnf install -y --skip-broken
