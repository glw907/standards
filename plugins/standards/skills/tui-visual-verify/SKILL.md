---
name: tui-visual-verify
description: Verify a terminal UI (bubbletea or any TUI) by driving the REAL terminal and looking at what it paints, never only at a text capture. Use before any claim that a TUI screen, theme, glyph, resize rung, or pointer behavior "works", at every gate that demos a TUI, when an owner reports a screen that looks wrong, and when goldens and teatest are green but nobody has seen the painted result. Drives kitty-headless-shot and grades fresh-context.
---

# TUI visual verification

Goldens, teatest flows, and tmux smoke checks all check text (a gate
can pass every one, and the owner's first look in a real terminal
finds what none had seen). A terminal paints grounds, erases
to the current background, drops blank cells from text dumps, and
delivers pointer events only when the app asked for them. Those are the things that
break, and only the painted terminal shows them.

The rule: **a TUI claim is verified when a screenshot of a real
terminal window has been looked at, by a context that did not build
the change, against the ratified reference.** A text capture is
evidence of content, never of paint.

## What the field does, and where it stops

Bubbletea practice (Charm's own guidance, catwalk, teatest, golden
files) drives Update and View deterministically and diffs the rendered
string. Keep all of that; it is fast and it pins content and geometry.
Charm's VHS adds headless stills through xterm.js in Chromium, which is
the right CI layer for docs captures (Charm's VHS docs). Neither
paints the owner's terminal. For a gate, the gate platform (kitty in this skill)
is the only truthful medium, so this skill drives kitty.

Claude Code's guidance is the same in one line: give Claude a way to
see the result and hand the user the evidence, not the claim.

## The harness

Call `kitty-headless-shot` directly. The helper ships in this plugin's
`bin` folder, which Claude Code puts on the PATH while the plugin is
enabled, and `--help` is the spec, so a repo carries no copy. It drives
a real kitty on an Xvfb display that exists only inside a distrobox
(`term-headless`; `kitty-headless-shot setup` creates it, idempotent). The terminal and
its glyphs are the real ones, in the same font as the owner's own
`kitty.conf` (shared into the container unchanged), and both grounds are
capturable (`-t dark|light`). Nothing appears on the owner's screen and
no focus is stolen, because the display is not the owner's.
It drives a long-running full-screen program correctly: start it, send
keys, clicks, wheel, and resize against the live process across many
`shot:` steps, then quit it, all inside one invocation. `-c` is required
and names the app to drive. Point the command at an isolated XDG store, for
example, so a second instance never fights the real one's lock.
The host's ImageMagick has no X11 delegate and the GNOME screenshot portal
is denied or interactive, so no on-desktop route exists to fall back on.

```
kitty-headless-shot [-o OUTDIR] [-t dark|light] [-s COLSxROWS] -c CMD STEP...
  key:K           one character, or a kitty key name (escape, down)
  type:TEXT       literal text
  click:COL,ROW   left click on a cell, 1-based
  wheel:up|down[@COL,ROW]
  resize:COLSxROWS   live resize, in cells, verified against kitty
  sleep:S
  shot:NAME       OUTDIR/NAME.png + NAME.ansi, size appended to sizes.txt
```

Every design choice in the script was forced by a failure on the day. The reasons sit in
the header of `bin/kitty-headless-shot`, beside the code each one shaped.

## The matrix

A gate run covers: every surface at the owner's real window size;
both themes (launch kitty with the light ground so the app's
background query answers light); every rung boundary pair from the
design language, in both directions; below the floor; the pointer
vocabulary (each advertised click target, one wheel notch, Esc); the
states the live app cannot reach on demand (modal, toast, banner,
offline) through the repo's fixture viewer; the degrade profiles; and
the ratified exemplar painted by the same terminal as the reference
image. Write a manifest that says what each capture claims to show.

## Grading

Follow `visual-fidelity`: the builder never grades. Fan out
fresh-context vision graders (one per capture group), each
handed the PNGs, the reference images, and the wireframe line ranges,
returning one verdict per visual device per capture, classified
STRUCTURAL, COSMETIC, or DESIGN-QUESTION with the reference cited.
Adversarially verify every STRUCTURAL finding (a refuter reads the
image and the source, defaults to refuted when the reference is silent
or a ruling already sanctions the behavior). Add one auditor whose
question is "is it right, and what will the owner's eye catch", not
"does it conform". The main loop then looks at the decisive PNGs
itself before anything is reported.

## Owner reports

When the owner says a screen looks wrong, reproduce at their exact
size, font, and terminal theme (read their `kitty.conf`) before
theorizing, and if it still does not reproduce, ask for a screenshot of
their window rather than guessing. Treat "I see X" as a capture
request, not a question.
