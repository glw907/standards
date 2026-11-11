---
name: running-passes
description: Plans, executes, and closes a pass of work in any repository: design, plan, execute, gate, review, close. Use when starting a multi-task change, writing or reviewing a plan, running tasks in parallel, or deciding when a pass is done.
---

# Running passes

A pass is one planned change, executed by one session in its own worktree and closed by one pull request. A repository's own pass guide (its contributing guide or a skill) supplies its gate, setup command, path-to-class map, and who merges. Where it disagrees with this skill, it wins.

## Risk classes

Give each task a class from the repository's path map. `auth-data` covers authentication, sessions, secrets, migrations, and anything that guards user data. `runner` covers skills, agents, workflows, CI, and the gate tools themselves. `ordinary` is the rest. A pass takes its highest task's class. Only the maintainer's ruling raises a class. Mark a run that can touch a real cloud, repository, or registry account as `live-account`.

## Design

A change whose diff fits in one sentence skips the lifecycle: make it, run the gate, commit.

Otherwise explore the design with the user in chat, one question at a time, with a recommendation on each. Settle a design of a page or less:

1. The outcome.
2. The files and interfaces touched.
3. What is out of scope.
4. How each behavior fails (bad input, no permission, over a limit), with a number for every limit.
5. One end-to-end check.
6. The risk class.
7. Every step only the user can do (a sign-in, a secret, a dialog, a permission rule).

Sweep the backlog for items the design clears or contradicts, and list each verdict in the design. Keep to what was asked: no extra features, no refactors beyond the task, no defensive handling for cases that cannot happen, no abstraction for a one-time operation. Extras go in a "Later" list and are never built.

## Plan

The plan is a task list. Each task states its outcome, files, risk class, acceptance check, test, and an estimate in minutes. A task never carries implementation code. Fold a single-deliverable task into a neighbor.

- Open the plan with a pre-flight list of every step only the user can do. Execution starts only when each is done and checked.
- Mark independent tasks (disjoint files, generated outputs included) as pairs.
- Estimate the path, the longest chain of tasks that run in sequence, with a pair counting at its larger estimate. The sum over all tasks double-counts pairs and sets nothing.
- Write the acceptance check so it can fail. A check that passes for a wrong result is not a check.
- An `auth-data` task writes its failing test first.
- A stop the plan writes (a cap, a ceiling, a line stop) carries a standing answer. A count cap on reads, retries, or reruns is a loop guard, not a stop for the user.

## Execute

One session executes. It works in a worktree cut for the pass, runs the repository's setup command, commits per task, and opens a draft pull request on the first push.

- **Gates.** After each task, run the repository's fast lane. Continuous integration carries the whole suites. A red stops the line: fix forward, or revert the commit. Do not start the next task on a red.
- **Pairs.** Two tasks with disjoint files go to two subagents, each in its own worktree cut from the session's latest commit. Each runs the setup command first, commits, and never pushes. The session merges both, runs the fast lane, and pushes. A merge conflict stops the line.
- **Judgment calls.** Make routine calls inside the approved design, budget, and scope yourself, and record each in the pull request under `## Decisions`: the call, the choice, the alternative, and the reason. Stop and ask only for spend past the budget, an irreversible or destructive act, a secret, a change of scope or design, or a product or taste call the design left open.
- **Scope.** Work found mid-task goes to the backlog and the pull request body. It does not go into the task in flight, unless the task would otherwise build on something known to be wrong.
- **Clock.** A task that passes twice its estimate gets one line in the pull request's `## Decisions`, naming the estimate and the actual, and the run goes on.

## Close

1. The full suite is green on the head commit.
2. A fresh reviewer reads the whole branch against the design and plan (a `standards:diff-reviewer` at whole-branch scope), loading any checklist the repository maps to the changed paths. An `auth-data` task also gets a security read.
3. One batched fix chain follows, then the gate again. A second review runs only on a blocker. A fix dispatch quotes each finding verbatim (location, finding, and fix) as its acceptance criteria, never a summary. State an overruled verdict with its reason in the pull request.
4. Run the repository's close checklist: docs, changelog, and the live smoke test for an `auth-data` pass.
5. The pull request body opens with a brief that says what approving it changes, then lists what landed, the `## Decisions`, and the score: time on the critical path, fix rounds, and any defect that escaped to a later pass.
6. File each worthwhile "found, not done" item in the backlog and list it in the pull request. An item not worth doing stays in the body, marked dropped.

Who merges is the repository's rule. Absent one, the maintainer merges after a green suite and an accepted review. Merge with a plain merge commit, then update the main checkout.
