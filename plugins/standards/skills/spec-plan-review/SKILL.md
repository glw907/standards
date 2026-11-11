---
name: spec-plan-review
description: >
  Use when a design spec or a pass plan is drafted and needs review before the owner approves
  it. Triggers include "review this spec", "plan review", "adversarial review of the plan", "fan
  out reviewers on the draft", and a plan-approval gate that has no review record yet. Sets
  review depth by risk class and says how the one read is folded. Do not use for a code diff
  (that is diff-reviewer) or for published docs pages.
---

# Spec and plan review

A review finds the defects that would cost a build or an owner sitting, and the fold applies
them without over-engineering the document. The reviewer stays wide and the fold stays selective.

## Depth by class

| Class | Before code |
| --- | --- |
| `ordinary` | None. The plan's `Reviewed:` line says so |
| `runner` | One `standards:plan-reviewer` read |
| `auth-data` | One `standards:plan-reviewer` read |

A run marked `live-account` takes the one read whatever its class. The read covers the plan, and
the spec where one exists. The planning session folds it; no fold agent runs.

A design of a page or less needs no separate spec. No prose, register, or conformance review runs on a spec or plan.

## The read

The reviewer reports everything, ranked by consequence, and the fold filters ("ask it to report
everything and filter in a separate pass instead", Prompting Claude Opus 5,
<https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompting-claude-opus-5>).
The dispatch names the target path and commit. The dispatching session saves the reply beside the
plan as `<date>-<target>-review-mechanics.md`. The reviewer never commits.

## The fold

The fold follows `standards:receiving-code-review`: it verifies a finding before acting on it,
and records a disposition for each: folded, refused with a one-line reason, or owner fork.

- It drops `optional` findings and folds `correctness` findings. It may refuse one whose fix
  costs more than the risk it removes.
- It probes or quotes every new mechanism it introduces, and never states one from memory.
- A finding whose fix is new machinery folds only when a team or published source runs it and a
  measured defect answers it.
- It never rules an owner fork. Each becomes a `### Decide:` block in the design's brief. A
  question with one clearly correct answer is not a fork.
- An unattended fold records an unclear finding as refused or as an owner fork, and never stops
  to ask.
- A finding that changes the approved design returns to the owner as one batched question.
- A revision that changes a ratified document's meaning records an owed erratum.
- Commits are path-limited, never `git add -A`.
