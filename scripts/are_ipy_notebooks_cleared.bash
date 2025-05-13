#!/usr/bin/env bash

# ---
# description: Check if Jupyter notebooks have been cleared of output cells.
# ---

failed=0

while IFS='' read -r -d '' notebook; do
    if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "${notebook}")" ]; then
        echo "Notebook with uncleared output cells:"
        echo "  ${notebook}"
        failed=1
    fi
    # In order to alter the state variable, the loop must be run in the main shell
    # why process substitution is used here.
done < <(
    git diff --name-only --diff-filter=AM -z origin/"${BASE_REF}"...HEAD |
        grep -z '\.ipynb$' ||
        true
    # find . -name "*.ipynb" -print0
)

if [ "${failed}" -gt 0 ]; then
    exit 1
else
    echo "No notebook with uncleared cells found."
    exit 0
fi
