# BACKLOG

> Project issue tracker. Managed by `/log-issue`.

## Medium

- [ ] **#2** Drop the `fix` and `triage` offers from vale-setup `#improvement` `#standards` *(2026-11-22)*
  `plugins/standards/skills/vale-setup/SKILL.md:11-12` and `:67` still point the reader at Vale's
  `fix` and `triage` skills, which PR #24 removed. The workstation's rename overlay no longer maps
  them, since workstation PR #268 drops their entries, so a session told to use them finds no skill.
  Found by the review of workstation PR #268.

## Done

- [x] **#1** Reword the old "pass" sense in the two verifier agents `#improvement` `#standards` *(2026-11-21 → 2026-11-21)*
  `plugins/standards/agents/visual-verifier.md:3` says "any visual-fidelity pass" and
  `plugins/standards/agents/figure-verifier.md:17` says "a pass worktree". Neither phrase holds a
  retired word, but both name the old process, so a reader who never used it can't place them.
  Found by the task "The plugin" (PR #22).
