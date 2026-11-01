---
max_turns: 8
timeout_seconds: 300
tags: [go-conventions]
---
Review this Go function for how it handles errors and how it writes the file, and give me the corrected version.

```go
func SaveConfig(path string, cfg Config) error {
	data, err := json.Marshal(cfg)
	if err != nil {
		return err
	}
	if err := os.WriteFile(path, data, 0o644); err != nil {
		log.Println("save failed:", err)
		return fmt.Errorf("save failed")
	}
	return nil
}
```
