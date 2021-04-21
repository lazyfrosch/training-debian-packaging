#!/bin/bash

set -e

rc=0

while read -r file; do
  if ! node_modules/.bin/markdown-link-check "$file"; then
    rc=$?
  fi
done < <(find README.md docs/ -name \*.md)

exit $rc
