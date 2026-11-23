#!/usr/bin/env bash
# Prove the content-review Vale style and its wrapper script. Every vocabulary term in the
# method's catalog must trip the style, so a word added to the catalog and not to the style
# fails here. The method's two samples must come out as the method says. A file Vale can't
# read must fail the wrapper. CONTENT_VALE names another script to test.
set -uo pipefail
src=$(cd "$(dirname "$0")/.." && pwd)
skills=$src/plugins/standards/skills
script=${CONTENT_VALE:-$skills/content-review/scripts/content-vale.sh}
method=$skills/content-draft/references/web-content-method.md
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

die() { echo "content-style-test: $1" >&2; exit 1; }

# expect NAME CODE PATTERN FILE: run the wrapper on FILE; check its exit code and its output.
expect() {
  local out code
  out=$("$script" "$4" 2>&1)
  code=$?
  [ "$code" -eq "$2" ] || die "$1: exit $code, want $2"
  if [ -n "$3" ] && ! grep -q -- "$3" <<<"$out"; then die "$1: output lacks '$3'"; fi
}

# The catalog's vocabulary line runs from "Vocabulary to skip:" to the first full stop.
terms=$(awk '/^Vocabulary to skip:/{on=1} on{print} on&&/\.$/{exit}' "$method" |
  tr '\n' ' ' | sed -e 's/^Vocabulary to skip: //' -e 's/\.[[:space:]]*$//' -e 's/ ([^)]*)//g' |
  tr ',' '\n' | sed -e 's/^ *//' -e 's/ *$//')
count=$(grep -c . <<<"$terms")
[ "$count" -ge 30 ] || die "read $count vocabulary terms from the method, want 30 or more"

n=0
while IFS= read -r term; do
  n=$((n + 1))
  printf 'The club will %s a plan this year.\n' "$term" > "$tmp/term-$n.md"
  out=$("$script" "$tmp/term-$n.md" 2>&1)
  grep -q -i -F -- "'$term'" <<<"$out" || die "the style does not flag the catalog term '$term'"
done <<<"$terms"

# Each fixed construction in the catalog, one sentence apiece.
i=0
while IFS= read -r line; do
  i=$((i + 1))
  printf '%s\n' "$line" > "$tmp/phrase-$i.md"
  expect "construction $i" 1 "banned construction" "$tmp/phrase-$i.md"
done <<'PHRASES'
It's not just training.
Whether you're new or not, come along.
The club is more than just a team.
In today's world, skiing costs money.
It's worth noting that practice is free.
It's important to note that practice is free.
When it comes to wax, ask a coach.
At its core, the club is a ski team.
At the end of the day, we ski.
Join us as we start the season.
Discover the joy of skiing.
Take your skiing to the next level.
PHRASES

# The method's two samples. Sample A is the quoted paragraph after its label, and sample B is
# the fenced block after its label.
awk '/^Sample A,/{on=1; next} /^Sample B,/{on=0} on' "$method" > "$tmp/sample-a.md"
awk '/^Sample B,/{on=1; next} on&&/^```/{f++; next} on&&f==1' "$method" > "$tmp/sample-b.md"
grep -q 'Summer training' "$tmp/sample-a.md" || die "sample A not found in the method"
grep -q 'East Community Nordic' "$tmp/sample-b.md" || die "sample B not found in the method"
expect "sample A" 0 " in 1 file" "$tmp/sample-a.md"
expect "sample B" 1 " in 1 file" "$tmp/sample-b.md"

# What Vale can't read must fail the wrapper, never pass it.
cp "$tmp/sample-a.md" "$tmp/sample-a.txt"
expect "a file type Vale skips" 2 "Vale read no file" "$tmp/sample-a.txt"
expect "a missing file" 2 "no such file" "$tmp/missing.md"
out=$(PATH=/nonexistent /bin/bash "$script" "$tmp/sample-a.md" 2>&1)
code=$?
[ "$code" -eq 2 ] || die "vale missing: exit $code, want 2"
grep -q "vale is not installed" <<<"$out" || die "vale missing: output lacks 'vale is not installed'"

# A Vale config in the user's home folder must change nothing. This one reads .txt as Markdown,
# which would make Vale read the .txt copy and pass it.
mkdir -p "$tmp/xdg/vale"
printf '[formats]\ntxt = md\n' > "$tmp/xdg/vale/.vale.ini"
out=$(XDG_CONFIG_HOME=$tmp/xdg "$script" "$tmp/sample-a.txt" 2>&1)
code=$?
[ "$code" -eq 2 ] || die "a config in the home folder: exit $code, want 2"

echo "content-style-test: $count catalog terms, $i constructions, 2 samples, and 4 failure cases pass"
