#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

# Get path usage
find "${1:-.}" -maxdepth 1 -type d -exec du -shx {} \; | sort -hr
