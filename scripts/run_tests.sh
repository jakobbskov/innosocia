#!/bin/bash
set -euo pipefail

echo "Running ShellCheck..."
sh_files=$(git ls-files '*.sh')
if [ -n "$sh_files" ]; then
  shellcheck $sh_files
else
  echo "No shell scripts to check."
fi

echo "Running yamllint..."
yamllint -d relaxed .
