---
max_turns: 12
timeout_seconds: 600
tags: [diff-reviewer]
---
The `feature` branch in this repo is ready. Before I merge it, have a fresh reviewer read `main..feature` against the task's acceptance criteria and give me its verdict: accept, fix, or escalate.

Acceptance criteria:

1. `remind` emails each member whose reminder is due.
2. `-store` picks where reminders are kept: `file`, the default, reads a JSON file, and `memory` holds them in memory for a dry run.
3. A failed send is reported with the member's address, and the run goes on to the next reminder.
