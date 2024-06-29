#!/usr/bin/env bash
## previewSandbox.sh at ~/.config/lf/

set -euo pipefail
(
	exec bwrap \
		--ro-bind /usr/bin /usr/bin \
		--ro-bind /usr/share/ /usr/share/ \
		--ro-bind /usr/lib /usr/lib \
		--ro-bind /usr/lib64 /usr/lib64 \
		--symlink /usr/bin /bin \
		--symlink /usr/bin /sbin \
		--symlink /usr/lib /lib \
		--symlink /usr/lib64 /lib64 \
		--proc /proc \
		--dev /dev \
		--ro-bind /etc /etc \
		--ro-bind ~/.config ~/.config \
		--ro-bind ~/.cache ~/.cache \
		--ro-bind "$PWD" "$PWD" \
		--unshare-all \
		--new-session \
		bash "$HOME/.config/lf/sixel.sh" "${1}" "${2}" "${3}" "" "" || true
)
