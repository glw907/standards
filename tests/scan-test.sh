#!/usr/bin/env bash
# Prove scripts/scan.sh passes a clean repository and fails a seeded one.
set -uo pipefail
src=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/scripts"
cp "$src/scripts/scan.sh" "$src/scripts/scan-patterns.txt" "$tmp/scripts/"
cd "$tmp" || exit 2
git init -q -b main .
git config user.email t@example.com
git config user.name t
echo "A clean skill." > a.md
git add . && git commit -qm clean

if ! scripts/scan.sh . >/dev/null 2>&1; then
  echo "scan-test: the clean repository failed the scan" >&2
  exit 1
fi

# Built at run time so this file never holds a personal path itself.
printf '%s\n' "see $(printf '/ho''me')/someone/notes.md" > b.md
git add . && git commit -qm seeded
if scripts/scan.sh . >/dev/null 2>&1; then
  echo "scan-test: the seeded repository passed the scan" >&2
  exit 1
fi
echo "scan-test: ok"
