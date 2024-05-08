#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

# Check if upower command is available
if ! command -v upower &>/dev/null; then
	echo "upower is not installed. Please install it first."
	exit 1
fi

BATTERY="$(awk '/time to empty/ {print $4, $5}' <(upower -i /org/freedesktop/UPower/devices/battery_BAT0))"

# Exit if Charging
if [[ -z $BATTERY ]]; then
	echo "Charging"
	exit 0
fi

# Split string on whitespace the hardway due enforcing shellharden
BAT0=()
while read -rd " " i; do
	BAT0+=("$i")
done < <(printf '%s%s' "$BATTERY" " ")

BAT0_TIME=${BAT0[0]}

if [[ ${BAT0[1]} =~ "hours" ]]; then
	# Extract remaining time in hours (fractional)
	hours=${BAT0_TIME%.*}
	minutes="$(echo "($BAT0_TIME - $hours) * 60" | bc)"
	printf -v minutes "%02.0f" "$minutes"
	echo "$hours:$minutes Remaining"
else
	minutes=${BAT0_TIME%.*}
	printf -v minutes "%02.0f" "$minutes"
	echo "0:$minutes Remaining"
fi
