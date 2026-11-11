# Testing

Reference for the `go-conventions` skill. Read it before writing or changing a test.

## Unit Tests

- Same package as source (not `_test` package).
- Table-driven with `[]struct{ name, input, expected }`.
- Sub-tests: `t.Run(tt.name, func(t *testing.T) { ... })`.
- No third-party assertion libraries. Use `t.Errorf` / `t.Fatalf`
  with `strings.Contains` and direct comparison.
- Test error paths explicitly. They are first-class tests.

## Assertion Discipline (no useless tests)

For every test, ask: "what would have to be wrong about the code
under test for this test to fail?" If the answer is "nothing
realistic," the test is theatre. Specific anti-patterns to reject
on sight:

- **Silent-success fakes.** A fake/mock whose mutation methods
  (`Send`, `Append`, `Copy`, `CreateDraft`, …) always `return nil`
  makes every error-path test in the suite trivially pass. Rule:
  any fake method that models a fallible production call gets a
  per-method `*Err error` field; the fake consults it on call;
  error-path table rows set it. Extend the shared fake, not the
  call sites.
- **Self-derived expectations.** Computing `want` from the system
  under test (`wantCol := m.popover.width()`) tests that a function
  equals itself. Hard-code the expected value, or derive it from
  inputs the test owns.
- **Trivially-true style assertions.** `style.Render("x") != ""`
  passes for the zero-value `lipgloss.Style{}`, asserting nothing
  about styling. Assert the resolved attribute instead:
  `style.GetForeground() == expected`, `style.GetBold()`, etc.
  (See `elm-conventions` for the bubbletea-specific tells.)
- **Cmd-shape assertions that don't invoke.** `if cmd != nil`
  proves the function returned *something*, not that the right
  thing happened. Invoke the cmd, type-switch on the resulting
  `tea.Msg`, assert the message's payload.
- **Skipped placeholder tests.** A `t.Skip("implement later")`
  at the top of a test function body is green CI signal with
  zero coverage. Either write the assertion or delete the
  function. Conditional skips (env-gated integration tests,
  GOOS-specific tests, missing-fixture guards) are fine.
- **Goldens are last-resort.** Snapshot tests catch *that*
  output changed, not *what* should have changed. Mutation
  testing fights them. Use goldens only for high-fidelity render
  surfaces where the value is the literal bytes; for everything
  else, assert on parsed structure.

The strong signal for assertion meaningfulness is mutation
testing. Surviving mutants are tests that can't tell correct code
from broken code. Treat them as bug reports against the test
suite, not the source.

## End-to-End Tests

- Package `e2e` in an `e2e/` directory.
- `TestMain` builds the binary once into a temp dir.
- All tests exec the real compiled binary.
- `testEnv` struct carries dir, config path, etc. No globals.
- `t.TempDir()` for all test directories.
- Helper functions: `run`, `runErr`, `runWithStdin`.

## Golden Tests (when applicable)

- Golden files in `e2e/testdata/golden/`.
- `--update-golden` flag to regenerate from an oracle.
- Normalization functions to handle acceptable differences.
