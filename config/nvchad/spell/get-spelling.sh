#!/usr/bin/env bash
#
# Download spelling for vim
set -o errexit -o nounset -o pipefail -o errtrace
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if ! which wget 2>/dev/null; then
    echo "Need to install wget."
    exit 2
fi

directory=$(dirname "$0")
cd "$directory"

# consult https://www.vim.org/mirrors.php
wget --no-check-certificate http://www.netgull.com/vim/runtime/spell/es.latin1.spl
wget --no-check-certificate http://www.netgull.com/vim/runtime/spell/es.latin1.sug
wget --no-check-certificate http://www.netgull.com/vim/runtime/spell/es.utf-8.spl
wget --no-check-certificate http://www.netgull.com/vim/runtime/spell/es.utf-8.sug
