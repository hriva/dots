#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

R --quiet --no-echo -e "styler::style_file(\"$1\")" 1>/dev/null 2>&1
