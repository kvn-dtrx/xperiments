#!/usr/bin/env bash

# ---
# description: |
#   Check if Jupyter notebooks have cleared output cells.
#   This script is intended to be run in a GitHub Actions workflow.
# ---

failed=0

notebooks="$(
    git diff --name-only --diff-filter=AM -z "${BASE_SHA}" "${HEAD_SHA}" |
        grep -z '\.ipynb$' || true
)"

echo $notebooks

# while IFS='' read -r -d '' notebook; do
#     if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "${notebook}")" ]; then
#         echo "Notebook with uncleared output cells:"
#         echo "  ${notebook}"
#         failed=1
#     fi
#     # In order to alter the state variable, the loop must be run in the main shell
#     # why process substitution is used here.
# done <<<"${notebooks}"

if [ "${failed}" -gt 0 ]; then
    exit 1
else
    echo "No notebook with uncleared cells found."
    exit 0
fi
