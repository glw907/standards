---
max_turns: 12
timeout_seconds: 600
allowed_tools: [Agent, Bash, Read, Grep, Glob]
tags: [diff-reviewer]
---
The `feature` branch in this repo is ready. Before I merge it, have a fresh reviewer read `main..feature` against the task's acceptance criteria and give me its verdict: accept, fix, or escalate.

Acceptance criteria:

1. `members import <file.csv>` adds each `name,email` row as a member.
2. A row with no email is skipped and reported with its line number, and the import goes on.

The export has no header row.
