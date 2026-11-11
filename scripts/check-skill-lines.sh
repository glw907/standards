#!/usr/bin/env bash
# Two checks over the plugin tree, each reporting on stderr and failing with exit 1.
#
# Line cap: any SKILL.md over 500 lines, the length Anthropic's skill authoring guidance sets.
#
# Word cap: each file in WORD_CAPS over its word count (wc -w over the whole file), and a capped
# file that is absent, so a rename cannot drop a cap silently. The two caps come from the pass
# process design of 2026-11-10: the plan review skill stays short, and the reviewer agent stays
# at its size, so a checklist item goes in only when one comes out.
set -uo pipefail
cd "${1:-$(dirname "$0")/..}" || exit 2

# One path and one cap per line.
WORD_CAPS=(
  "plugins/standards/skills/spec-plan-review/SKILL.md 600"
  "plugins/standards/agents/plan-reviewer.md 1300"
)

status=0
while IFS= read -r -d '' f; do
  n=$(wc -l < "$f")
  if [ "$n" -gt 500 ]; then
    echo "check-skill-lines: $f has $n lines (limit 500)" >&2
    status=1
  fi
done < <(find plugins -name SKILL.md -print0)

for entry in "${WORD_CAPS[@]}"; do
  f=${entry% *}
  cap=${entry##* }
  if [ ! -f "$f" ]; then
    echo "check-skill-lines: $f is missing (word cap $cap)" >&2
    status=1
    continue
  fi
  n=$(wc -w < "$f")
  if [ "$n" -gt "$cap" ]; then
    echo "check-skill-lines: $f has $n words (limit $cap)" >&2
    status=1
  fi
done
exit $status
