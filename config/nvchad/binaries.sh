#!/usr/bin/env bash

curl -o shellharden.tar.gz \
	https://github.com/anordal/shellharden/releases/latest/download/shellharden-x86_64-unknown-linux-gnu.tar.gz
tar -xzf shellharden.tar.gz -C ~/.local/bin/

curl -o biome \
	https://github.com/biomejs/biome/releases/latest/download/biome-linux-x64

mv biome ~/.local/bin/
