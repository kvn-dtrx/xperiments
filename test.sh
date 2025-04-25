#!/bin/zsh
failed=0
while IFS='' read -r -d '' notebook; do
  if [ -n "$(jq '.cells[] | select(.outputs | length > 0)' "$notebook")" ]; then
    echo "The notebook ${notebook} contains uncleared output cells and should not be committed!"
    failed=1
  fi
done < <(find . -name "*.ipynb" -print0)



if [ "${failed}" -gt 0 ]; then
  exit 1
else
  echo "No uncleared output cells found."
  exit 0
fi
