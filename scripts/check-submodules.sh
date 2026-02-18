#!/usr/bin/env bash
# Exit 0 if all submodules are initialized; exit 1 if any line starts with '-'
set -e
status=$(git submodule status)
if echo "$status" | grep -q '^-'; then
  echo "Some submodules are not initialized:"
  echo "$status" | grep '^-' || true
  exit 1
fi
echo "All submodules initialized."
echo "$status"
