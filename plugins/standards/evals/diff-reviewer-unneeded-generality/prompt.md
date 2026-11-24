---
max_turns: 12
timeout_seconds: 600
allowed_tools: [Agent, Bash, Read, Grep, Glob]
tags: [diff-reviewer]
---
The `feature` branch in this repo is ready. Before I merge it, have a fresh reviewer read `main..feature` against the task's acceptance criteria and give me its verdict: accept, fix, or escalate.

Acceptance criteria:

1. Each run of `remind` emails every member whose reminder is due. Marking a reminder as sent is a later task.
2. `-store` picks where reminders are loaded from: `file`, the default, reads a JSON file, and `memory` starts with no reminders, for a smoke test of the command.
3. A failed send is reported with the member's address, and the run goes on to the next reminder.
