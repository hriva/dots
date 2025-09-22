#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-.}"
SORT_KEY="${2:-ext}"

if [[ ! -d "$DIR" ]]; then
    echo "Error: '$DIR' is not a directory" >&2
    exit 1
fi

# Associative arrays for LOC and count
declare -A LOC_MAP
declare -A COUNT_MAP

# Find files and process safely using NUL separators
while IFS= read -r -d '' f; do
    base="$(basename "$f")"
    # Determine extension: include leading dot (e.g., .cs), or 'no_extension'
    if [[ "$base" == *.* && "$base" != .* ]]; then
        ext=".${base##*.}"
    else
        ext="no_extension"
    fi

    # Count lines; if wc fails, treat as 0
    if lines=$(wc -l <"$f" 2>/dev/null); then
        :
    else
        lines=0
    fi

    # Accumulate
    LOC_MAP["$ext"]=$((${LOC_MAP["$ext"]:-0} + lines))
    COUNT_MAP["$ext"]=$((${COUNT_MAP["$ext"]:-0} + 1))
done < <(find "$DIR" -type f -print0)

# Choose sort
if [[ "$SORT_KEY" == "loc" ]]; then
    SORT_CMD='sort -k2,2nr -k1,1'
else
    SORT_CMD='sort -k1,1'
fi

# Output
{
    echo -e "extension\tloc\tfiles"
    for ext in "${!COUNT_MAP[@]}"; do
        printf "%s\t%d\t%d\n" "$ext" "${LOC_MAP[$ext]}" "${COUNT_MAP[$ext]}"
    done | eval "$SORT_CMD"
} | awk 'NR==1{printf "%-14s %8s %7s\n",$1,$2,$3; next} {printf "%-14s %8d %7d\n",$1,$2,$3}'
