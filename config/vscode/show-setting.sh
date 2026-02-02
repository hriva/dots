#!/usr/bin/env bash
#
# Shows the json inside a vscode.code-profile file

set -o errexit -o nounset -o pipefail -o errtrace
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ $# -ne 2 ]]; then
    echo "Usage: [INPUT CODE-PROF] [SETTING]"
    exit 1
fi

case "$2" in
*extensions)
    sed_str='s/\\//g;s/^"//g;s/"$//g'
    ;;
*)
    sed_str='s/\\\\r\\\\n/\n/g;s/\\//g;s/"{/{/g;s/}"/}/g'
    ;;
esac

jq "$2" "$1" | sed "$sed_str" | biome format --config-path="$BIOME_CONFIG_PATH" --stdin-file-path file.json
