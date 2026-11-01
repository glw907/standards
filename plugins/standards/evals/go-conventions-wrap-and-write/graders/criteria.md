---
type: llm
---
PASS only if the corrected function does all of these:

1. Wraps each error with context and `%w` (for example `fmt.Errorf("marshal config: %w", err)`), so the caller can use `errors.Is` and `errors.As`.
2. Does not both log and return the same error, and does not discard the underlying error by returning a new message with no `%w`.
3. Writes the file atomically: a temporary file in the same directory, synced and closed, then renamed over the target, so a crash never leaves a half-written file.

FAIL if it keeps `fmt.Errorf("save failed")` with no wrapped error, keeps the log line plus the return, or keeps a bare `os.WriteFile` on the target path.
