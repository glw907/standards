---
max_turns: 10
timeout_seconds: 600
tags: [backlog-sweep]
---
Sweep my backlog and tell me what in it still matters. Here is `docs/BACKLOG.md` and the current code it talks about.

```markdown
# Backlog

## Open

- The fetch retry loop never backs off; add exponential backoff. (2024-03-02)
- The config loader ignores `XDG_CONFIG_HOME`. (2024-03-09)
- Add a `--json` flag to `list`. (2024-05-20)
- Support JSON output for the `list` command, for scripts. (2025-01-14)
```

`internal/fetch/retry.go`:

```go
func withRetry(ctx context.Context, attempts int, f func() error) error {
	delay := 200 * time.Millisecond
	var err error
	for i := 0; i < attempts; i++ {
		if err = f(); err == nil {
			return nil
		}
		select {
		case <-time.After(delay):
			delay *= 2
		case <-ctx.Done():
			return ctx.Err()
		}
	}
	return err
}
```

`internal/config/load.go`:

```go
func configPath() (string, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return "", fmt.Errorf("find home: %w", err)
	}
	return filepath.Join(home, ".config", "tool", "config.toml"), nil
}
```

`cmd/list.go` defines the `list` command with one flag, `--all`.
