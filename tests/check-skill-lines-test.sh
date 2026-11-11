#!/usr/bin/env bash
# Prove scripts/check-skill-lines.sh passes a clean tree and fails each seeded one. Every failing
# case is the clean tree with one change. CHECK_SKILL_LINES names another script to test.
set -uo pipefail
src=$(cd "$(dirname "$0")/.." && pwd)
script=${CHECK_SKILL_LINES:-$src/scripts/check-skill-lines.sh}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

spec=plugins/standards/skills/spec-plan-review/SKILL.md
rev=plugins/standards/agents/plan-reviewer.md

# words N FILE: write a file of exactly N words.
words() { mkdir -p "$(dirname "$2")"; yes word | head -n "$1" | tr '\n' ' ' > "$2"; }

# fresh: rebuild the clean tree in $tmp/root.
fresh() {
  rm -rf "$tmp/root"
  mkdir -p "$tmp/root"
  cd "$tmp/root" || exit 2
  words 100 "$spec"
  words 1000 "$rev"
  mkdir -p plugins/standards/skills/short
  echo "A short skill." > plugins/standards/skills/short/SKILL.md
}

# expect NAME CODE PATTERN: run the script on the tree; check the exit code and, when given, stderr.
expect() {
  local out code
  out=$("$script" "$tmp/root" 2>&1 >/dev/null)
  code=$?
  if [ "$code" -ne "$2" ]; then
    echo "check-skill-lines-test: $1: exit $code, want $2" >&2
    exit 1
  fi
  if [ -n "${3:-}" ] && ! grep -q -- "$3" <<<"$out"; then
    echo "check-skill-lines-test: $1: stderr lacks '$3'" >&2
    exit 1
  fi
}

fresh
expect "clean tree" 0

fresh
mkdir -p plugins/standards/skills/long
yes line | head -n 501 > plugins/standards/skills/long/SKILL.md
expect "501 lines" 1 "skills/long/SKILL.md has 501 lines"

fresh
words 601 "$spec"
expect "601 words in spec-plan-review" 1 "601 words (limit 600)"

fresh
words 1301 "$rev"
expect "1301 words in plan-reviewer" 1 "1301 words (limit 1300)"

fresh
rm "$rev"
expect "plan-reviewer removed" 1 "is missing"

echo "check-skill-lines-test: ok"
