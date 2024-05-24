#!/usr/bin/env bash

# Check if jq command is available
if ! command -v jq &>/dev/null; then
	echo "jq is not installed. Please install it first."
	exit 1
fi
pw-dump | jq -r 'map(.info?.props?) | map(select(.["node.name"]? == "xdg-desktop-portal-wlr")) | map(.["stream.is-live"]? == true | "LIVE") | .[]?'
