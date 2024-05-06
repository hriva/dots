#!/usr/bin/env bash

# Check if upower command is available
if ! command -v upower &>/dev/null; then
	echo "upower is not installed. Please install it first."
	exit 1
fi

# Extract remaining time in hours (fractional)
BAT0_TIME=$(awk '/time to empty/ {print $4}' <(upower -i /org/freedesktop/UPower/devices/battery_BAT0))
hours=${BAT0_TIME%.*}
minutes=$(printf "%.0f" "$(echo "($BAT0_TIME - $hours) * 60" | bc)")
echo "$hours:$minutes Remaining"
