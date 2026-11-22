---
type: llm
---
PASS if every error that the corrected `SaveConfig` returns names the operation that failed and carries the underlying error, for example `fmt.Errorf("marshal config: %w", err)`. Either `%w` or `%v` passes. Judge `SaveConfig` alone: a helper the reply adds may return a bare `err` to it.

FAIL if the corrected `SaveConfig` returns a bare `err`, or returns a message with no underlying error, such as `fmt.Errorf("save failed")`.
