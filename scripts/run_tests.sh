#!/bin/bash
set -euo pipefail

# Ensure required tools are available
if ! command -v shellcheck >/dev/null; then
  echo "shellcheck is required but not installed." >&2
  exit 1
fi

if ! command -v yamllint >/dev/null; then
  echo "yamllint is required but not installed." >&2
  exit 1
fi

echo "Running ShellCheck..."
mapfile -t sh_files < <(git ls-files '*.sh' start)
if [ ${#sh_files[@]} -gt 0 ]; then
  shellcheck "${sh_files[@]}"
else
  echo "No shell scripts to check."
fi

echo "Running yamllint..."
yamllint -d relaxed .
