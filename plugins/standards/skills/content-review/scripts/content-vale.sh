#!/usr/bin/env bash
# Runs Vale on one site-content file with the banned-word style this skill ships.
#
# Usage: content-vale.sh <file.md>
#
# Exits 0 when Vale read the file and found no error, 1 when it found one, and 2 when the check
# did not run: Vale is not installed, the file is missing, or Vale read no file. Vale itself
# exits 0 in the last two cases, which is why this script reads its summary line. --no-global
# keeps a config in the user's home folder from adding file types or accepted words.
set -uo pipefail
here=$(cd "${BASH_SOURCE[0]%/*}/.." && pwd)

fail() { echo "content-vale: $1" >&2; exit 2; }

[ $# -eq 1 ] || fail "usage: content-vale.sh <file.md>"
command -v vale >/dev/null 2>&1 || fail "vale is not installed, so the banned-word check did not run"
[ -f "$1" ] || fail "no such file: $1"

out=$(vale --no-global --config "$here/vale/vale.ini" --no-wrap "$1" 2>&1)
code=$?
printf '%s\n' "$out"
grep -q ' in 1 file\.$' <<<"$out" || fail "Vale read no file, so the banned-word check did not run. It reads Markdown (.md) only: $1"
exit "$code"
