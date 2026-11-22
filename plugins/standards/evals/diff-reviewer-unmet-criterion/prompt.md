---
max_turns: 10
timeout_seconds: 600
tags: [diff-reviewer]
---
A commit for one task is ready. Before I merge it, have a fresh reviewer read the diff against the task's acceptance criteria and give me its verdict: accept, fix, or escalate.

Acceptance criteria:

1. `ParsePort` returns an error for any value outside 1 to 65535.
2. Every error `ParsePort` returns names the input it rejected.

```diff
--- a/internal/config/port.go
+++ b/internal/config/port.go
@@ -1,9 +1,20 @@
 package config

-import "strconv"
+import (
+	"errors"
+	"fmt"
+	"strconv"
+)

-func ParsePort(s string) int {
-	p, _ := strconv.Atoi(s)
-	return p
+// ParsePort parses s as a TCP port number.
+func ParsePort(s string) (int, error) {
+	p, err := strconv.Atoi(s)
+	if err != nil {
+		return 0, fmt.Errorf("parse port %q: %w", s, err)
+	}
+	if p < 0 || p > 65535 {
+		return 0, errors.New("port out of range")
+	}
+	return p, nil
 }
```
