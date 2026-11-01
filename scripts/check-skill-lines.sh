#!/usr/bin/env bash
# Fail when any SKILL.md runs over 500 lines, the length Anthropic's skill authoring guidance sets.
set -uo pipefail
cd "${1:-.}" || exit 2
status=0
while IFS= read -r -d '' f; do
  n=$(wc -l < "$f")
  if [ "$n" -gt 500 ]; then
    echo "check-skill-lines: $f has $n lines (limit 500)" >&2
    status=1
  fi
done < <(find plugins -name SKILL.md -print0)
exit $status
