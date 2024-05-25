#!/usr/bin/env bash

# Copy file with a progress bar
cpp() {

	set -o errexit
	set -o nounset
	set -o pipefail
	if [[ "${TRACE-0}" == "1" ]]; then
		set -o xtrace
	fi
	strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
		awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

cpp "$@"
