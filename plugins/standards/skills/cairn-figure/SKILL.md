---
name: cairn-figure
description: The production path for a figure (diagram, screenshot, or reproduction) on a project docs page. Use when adding, editing, or reviewing a figure on a docs page, or when a page needs a diagram, screenshot, or illustration and you are deciding whether it earns its place.
---

# Figure production

A figure is a diagram, a screenshot, or a hand-drawn reproduction on a docs
page, and pages rarely need one. This skill holds the production path: whether a figure
earns its place, which of the two tools to reach for, what must ship alongside it, and how it
gets verified before a human reads the page.

## The two figure tests

Apply both before drawing anything and again to any figure already on the page.

1. **Remove it.** Delete the figure and read the surrounding prose alone. If the prose still
   makes the point, the figure earns nothing the words did not already carry.
2. **Read for the missing figure.** Read each paragraph and ask whether it is the text
   alternative of a diagram nobody drew: enumerable content forced into prose, or a spatial or
   branching relation described in a sentence a reader has to re-read to trace. A paragraph
   that fails this test wants a figure the page does not have.

A set of items is a table, not a figure. A linear sequence is a numbered list, not a figure.
Code the reader will type is a code block, not a figure.

## The two-lane routing rule

See the project's docs style guide, if it has a section on visuals, for the current rules; this
section only restates what a builder needs at hand.

Mermaid in the page is the default: a diagram that is text in the same commit as its prose
renders in the docs' own theme and in a plain GitHub view, and it cannot go stale
without the diff showing it. Hand-authored SVG is the exception, reached for only when a
themed mermaid render cannot carry the diagram at the docs' polish bar. There is no third
tool.

Every figure, mermaid or SVG, ships its generating source committed alongside the page that
uses it: the mermaid block in the page itself, or the SVG's source file and the script that
generated it. A figure with no committed source is a finding on its own, independent of
whether it earns its place.

A diagram carries a complexity budget of about 15 nodes; split or simplify a diagram past it.
Diagrams render in the docs' own theme: the stock `neutral` mermaid render never ships, and a
diagram the themed render cannot carry at the polish bar is hand-authored SVG, never a
drawing-tool screenshot.

## Interface figures: live first

A figure that shows the project's own interface (a screen, a control, a state) is a live
reproduction that renders the actual component, never a screenshot, wherever the docs'
reproduction mechanism can carry it. A screenshot goes stale silently; the component cannot.
Where no such mechanism exists yet, outline the figure as a reproduction and file what it
needs in the project's backlog. A screenshot is the exception, taken only
for what no component renders (a browser chrome, an email client, a third-party console), and
the page records why.

## The text-alternative and containment rules

The project's docs style guide carries the alt-text, caption, and decorative-image rules; read
it before authoring a figure rather than working from a copy here.

A `repro` fence carries its caption a different way: the caption lives INSIDE the fence body,
as the `caption` key, not as an emphasis paragraph after the fence, because the body must be
self-describing where the mermaid plugin does not run (GitHub, the tarball). The fence's
`width` key satisfies the 320/390 responsive bar, which binds every live reproduction even
though diagrams are exempt from it (below). The key shape, as a docs style guide would state it:

```repro
caption: "..."
width: 390
```

Authored docs diagrams are exempt from the 320/390 responsive bar (WCAG 1.4.10
exempts diagrams from reflow by name): they scroll inside their own `overflow-x: auto` figure
at narrow widths instead of shrinking. A live reproduction stays bound by the bar. Check the
project's docs style guide for its ruling on this.

## Hand-authored SVG: the method that held up

Start from these rules when a page needs SVG.

- **One authoring source, one emitter.** A single source file carries a shared `<style>` block
  and one nested `<svg>` per figure; an emitter script promotes each to its own shipped file,
  so palette, type stack, and ownership registers cannot drift between figures.
- **Measure text floors from the rendered DOM** at the width the figure is read at: 12 CSS px
  minimum (the anatomy figure landed at 12.15 px in a 720 px column at 0.90 scale, the concept
  figure at 14 px full width). Character counts mislead at these sizes. A figure wider than the
  column scrolls inside its `overflow-x: auto` figure rather than shrinking below the floor.
- **Three ownership registers, one boundary stroke.** project-owned is a solid border plus a left
  rule bar; user-owned is a dashed border; outside actors (third-party services) are a dotted
  border with a pill radius. The app outline is a heavy solid stroke belonging to no owner,
  because the boundary is the figure's subject and must stay the most visible line; drawing it
  dashed would say the whole app belongs to the user.
- **Containment over legend.** In an anatomy figure, draw a shared directory across the seam between
  the two bands; containment is a relation the reader reads without a
  legend.
- **An `<img>` exposes only its alt.** A page embeds an SVG figure with `<img>`, so the SVG's own
  `<title>` and `<desc>` are not exposed to assistive technology. Ship each SVG with a companion
  note carrying the alt (about 150 characters), the caption, and the full text alternative.

## Comparison figures

A concept figure draws one system with its boundary. A two-panel contrast
argues by box count, which the eye reads before any label, and a box costs the same ink
whether a vendor sells it or a user writes it. Costs, drawbacks, and comparisons belong to
the page prose, never the drawing, and that prose treats the alternative as a competent setup with
its real advantages, the project's own trade-offs beside them. Where a figure must show a contrast,
no adjective grades either side, no vendor is named, and every sub-label is verifiable as a
general statement.

## The mechanical gate

A project's visuals check, where it has one, is the mechanical floor for this standard. Such a check covers mermaid
`accTitle:` and `accDescr:`, captions, alt length, and `repro` fences. It does not judge whether a
figure earns its place; that is the verifier's work.

## Verification: a fresh reviewer

The judgment layer for a figure is a read-only reviewer agent, a fresh context that did not draw the figure. Dispatch it
after a page carrying a figure is drafted or edited, before a human reads the page. It grades
every figure on the page against the two figure tests above and the docs style guide's visual rules, and returns one of five verdicts per figure, each with a `file:line`: earns its
place, decoration, should be a table, should be a numbered list, or missing figure. It also
flags a missing source, alt, or caption as a separate, fixable finding even on a figure that
earns its place.
