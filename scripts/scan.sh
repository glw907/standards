#!/usr/bin/env bash
# Scan a git repository for secrets and personal paths, in tracked files and in every commit.
# Usage: scripts/scan.sh [repo-root]. Exits 1 on any hit. Run before every push and in CI.
set -uo pipefail

root=${1:-.}
cd "$root" || exit 2
patterns=scripts/scan-patterns.txt
exclude=(':!scripts/scan-patterns.txt' ':!tests/' ':!LICENSE')
status=0

if ! gitleaks git --no-banner --redact . ; then
  echo "scan: gitleaks found a secret in history" >&2
  status=1
fi

if git grep -nIE -f "$patterns" -- . "${exclude[@]}"; then
  echo "scan: a tracked file names a personal path, host, or workstation tool" >&2
  status=1
fi

if git log --all -p --no-color --format='commit %h' -- . "${exclude[@]}" |
  grep -E '^\+' | grep -vE '^\+\+\+' | grep -nE -f "$patterns"; then
  echo "scan: a commit in history added a personal path, host, or workstation tool" >&2
  status=1
fi

exit $status
