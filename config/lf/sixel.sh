#!/bin/env bash

set -o errexit -o nounset -o pipefail -o errtrace
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

if which bat &>/dev/null; then
	BAT_EXISTS=true
fi

## Script arguments
FILE_PATH="${1}" # Full path of the highlighted file
PV_WIDTH="${2}"  # Width of the preview pane (number of fitting characters)
## shellcheck disable=SC2034 # PV_HEIGHT is provided for convenience and unused
PV_HEIGHT="${3}" # Height of the preview pane (number of fitting characters)
FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "$FILE_EXTENSION" | tr '[:upper:]' '[:lower:]')"

case "$(file -Lb --mime-type -- "$FILE_PATH")" in
image/*)
	chafa -f sixels -s "$PV_WIDTH"x"$PV_HEIGHT" --animate off --polite on "$FILE_PATH"
	exit 1
	;;
text/* | application/json | */xml)
	## Syntax highlight
	if [[ "$BAT_EXISTS" ]]; then
		env COLORTERM=8bit bat --color=always --paging=never --plain "$FILE_PATH" && exit 5
		exit 2
	else
		cat "$FILE_PATH"
	fi
	;;
*pdf)
	## Preview as text conversion
	pdftotext -l 10 -nopgbrk -q -- "$FILE_PATH" - |
		fmt -w "$PV_WIDTH" && exit 5
	mutool draw -F txt -i -- "$FILE_PATH" 1-10 |
		fmt -w "$PV_WIDTH" && exit 5
	exiftool "$FILE_PATH" && exit 5
	exit 1
	;;
*)
	cat "$FILE_PATH" && exit 5
	;;
esac
