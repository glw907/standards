---
name: go-conventions
description: >
  Mandatory rules for writing Go code. Use before
  writing, reviewing, or modifying any Go file. Covers anti-patterns
  (unnecessary interfaces, builder patterns, defensive nil checks),
  project structure, cobra CLI shape, error wrapping, atomic file writes,
  table-driven tests, Makefile gates, naming, modern-stdlib idioms, and
  the comment standard. Every Go file, function, test, comment, and error
  message must conform.
---

# Go Conventions

Rules for writing Go utilities. Code follows
**Effective Go** and **Go Code Review Comments**
(https://go.dev/wiki/CodeReviewComments); comments follow **Go Doc Comments**
(https://go.dev/doc/comment). The linters are **gofmt** and **go vet**,
both wired into `make check`. The canonical exemplar is **the Go standard
library**: read the doc comments next to the code you are writing and
match their density, shape, and voice.

## Principles

Three principles carry every comment decision; the rest of this file
applies them to Go specifics.

- **Comment the why, not the what.** The code already states what it
  does. A comment earns its place when it carries a reason, a
  constraint, or a piece of evidence the code cannot.
- **Document the contract.** A doc comment states what a caller must
  know: the invariant, the unit, the nil-semantic, the concurrency
  hazard. Not the implementation.
- **Do not paraphrase the code.** If removing the comment leaves a
  competent Go reader no worse off, the comment should not exist. This
  is the single most effective filter against machine-shaped comments.

## Anti-Patterns: Go That Looks Like Python or JavaScript

Reject these forms, which carry habits from other languages into Go:

- **Unnecessary interfaces.** Don't define an interface until a second
  consumer exists. A concrete type is fine.
- **Gratuitous goroutines.** CLI tools are sequential. No goroutines or
  channels unless there is measured concurrency to exploit.
- **Builder patterns / functional options.** Use a plain config struct.
  `NewFoo(cfg Config)` not `NewFoo(WithBar(...), WithBaz(...))`.
- **Error types as classes.** A struct with `Error() string` is enough.
  No error hierarchies, no `errors.New` wrappers that add nothing.
- **Overuse of generics.** Concrete types unless the function operates
  on multiple types.
- **fmt.Sprintf for simple concatenation.** `path + "/" + name` is fine.
- **Defensive nil checks everywhere.** Trust internal code. Validate at
  boundaries (user input, external API responses).
- **Constants for strings used once.** Inline them.
- **Package-level init() functions.** Avoid. Pass dependencies explicitly.
- **`interface{}` instead of `any`.** Go 1.18+; `any` is canonical.
- **Vague package names.** Beyond Code Review Comments' list, never name a package
  `utils`, `helper`, or `shared`. Name by what it provides:
  `atomicfile`, `timeparse`.
- **`[]T{}` for an empty slice.** Where the nil/empty distinction
  matters at a JSON or API boundary, comment why.

## Modern Stdlib Idioms

Reach for the modern stdlib form by default (Go 1.21 or later); the older
spelling signals that the code predates the toolchain. The rules cover
sorting, one-shot init, iterators, logging, loops, maps, builtins,
comparators, error joining, and loop scoping, each with the old and new
form side by side: [references/modern-stdlib.md](references/modern-stdlib.md).
`modernize` in the lint config reports most stale forms.

## Project Structure

```
project-name/
  cmd/project-name/     # main package - CLI wiring only
    main.go             # build root cmd, run, print error, exit
    root.go             # cobra command definition + flags struct
    *.go                # one file per command/handler
  internal/             # all business logic
    subpackage/         # one package per concern
  e2e/                  # end-to-end tests (build + exec real binary)
    testdata/           # fixtures, golden files
  go.mod
  go.sum
  Makefile
  .golangci.yml
  CLAUDE.md
```

Rules:
- `cmd/` contains only CLI wiring. No business logic.
- `internal/` for all library code. No `pkg/` directory.
- One concern per file. Name files by what they do: `write.go`,
  `read.go`, `sweep.go`.
- Test files live alongside source: `foo_test.go` next to `foo.go`.

## CLI Framework

Use cobra with these conventions:

```go
func newRootCmd() *cobra.Command {
    var f flags

    cmd := &cobra.Command{
        Use:           "tool [args...]",
        Short:         "One-line description",
        RunE:          func(cmd *cobra.Command, args []string) error { return run(cmd, args, &f) },
        SilenceUsage:  true,
        SilenceErrors: true,
    }
    // register flags on cmd.Flags()
    return cmd
}
```

- `SilenceUsage: true` - cobra does not print usage on error.
- `SilenceErrors: true` - cobra does not print the error itself, because
  `main()` is the only error printer. Without it every error prints twice.
- Flags in a struct, not loose variables.
- `RunE` returns error. `main()` prints to stderr and exits 1.
- Hidden flags for aliases: `cmd.Flag("name").Hidden = true`.
- Subcommands only when the tool has distinct modes that don't flatten
  to flags. Prefer a flat command with flags for simple tools.
- Where this skill and the vendored `golang-spf13-cobra` skill conflict,
  this skill wins. The four known conflicts: a package-level `rootCmd`
  (use `newRootCmd()`), testify (stdlib assertions only), output streams
  (the cobra skill writes status text through `cmd.OutOrStdout()`; here
  data goes to stdout and status to stderr), and viper (not assumed).

## main.go

Always this shape:

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    cmd := newRootCmd()
    if err := cmd.Execute(); err != nil {
        fmt.Fprintln(os.Stderr, err)
        os.Exit(1)
    }
}
```

main() is the only place that prints errors and calls os.Exit.

## Error Handling

```go
// Context-prefixed, lowercase, no trailing period
return fmt.Errorf("load config %s: %w", path, err)

// Sentinel checks
if errors.Is(err, os.ErrNotExist) { ... }

// Custom error type extraction
var pe *ParseError
if errors.As(err, &pe) { ... }
```

Rules:
- **Capitals.** Beyond a proper noun or an acronym, capitalize only a
  package name used as the prefix.
- **Context-first.** Noun-verb form: `"load config"`, `"create
  directory"`. Never start with `"failed to"`.
- **`%w` only when callers branch on the sentinel.** Use `%w` if
  any caller calls `errors.Is` / `errors.As` on the result.
  Otherwise `%v` or omit wrapping. Reflexive `%w` exposes the
  underlying error type as part of the package's API surface.
- **Adjacent error sites diverge in phrasing.** If two error
  returns in one function read identically, vary them: bare
  noun, context prefix, or operation-name inline.
- **No function name in its own errors.** The call stack provides
  it. State the condition, not the location.
- Library functions return errors. Only `main()` prints them.
- Status messages (not errors) go to `os.Stderr`.

## File Writes

All file mutations use atomic write (temp + sync + rename):

```go
// internal/atomicfile/atomicfile.go
func WriteFile(path string, data []byte, perm os.FileMode) error
```

This prevents partial writes on crash. Write to a temp file in the
same directory, sync, then rename over the target.

Directory permissions: 0755. Plain files: 0644. Sensitive files: 0600.

## Testing

Before writing or changing a test, read [references/testing.md](references/testing.md).

## Build System

Before writing or changing a Makefile, a gate, or the lint config, read
[references/build.md](references/build.md) and
[references/linting.md](references/linting.md).

## Dependencies

- Minimal. Stdlib where possible.
- cobra for CLI, nothing else assumed.
- No frameworks, no DI containers, no ORM.
- Direct dependencies explicitly required in go.mod.
- Indirect dependencies annotated with `// indirect`.

## Naming

- Unexported types use short names: `day`, `flags`, `rule`.
- Boolean fields: positive sense (`Encrypt`, not `NoEncrypt`).
  Use `*bool` for optional overrides.

## Comments

Comments follow **Go Doc Comments** (https://go.dev/doc/comment).
The exemplar is the standard library: when a comment's shape is in
doubt, read the doc comments next to the same kind of code in the
stdlib and match them. `go vet` flags malformed doc comments; `gofmt`
canonicalizes their layout.

### Comment-or-not (write-time gate)

Before reaching for the placement rubric in
[references/comments.md](references/comments.md) (which also holds the
doc comment shape and the comment review), run this three-question
gate:

```
(a) Does the function/type name already say this?
(b) Is the why obvious from the next ≤5 lines?
(c) Would a reader otherwise miss a hidden constraint, invariant,
    or surprising consequence?
```

Skip rule: if (a) or (b), don't write the comment. Write rule:
only when (c). **Mechanical test: if the comment paraphrases the
next ≤5 lines, delete it.** The paraphrase test is the primary
check for an in-function comment.

Doc comments on unexported symbols are opt-in, not opt-out: comment
only when name and signature leave something a competent Go reader
would not immediately know. Silence is the default, the same as the
standard library's own unexported code.

## Output

- Data goes to stdout.
- Status messages and counts go to stderr.
- Errors returned, not printed (except in main).

## Module Naming

Use `github.com/<owner>/<project-name>` as the module path, matching
the repository it lives in. The Go version in go.mod should match the
toolchain installed on the system (`go version`).
