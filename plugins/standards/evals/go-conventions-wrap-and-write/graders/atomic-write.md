---
type: llm
---
PASS if the corrected function writes a temporary file in the target's directory and renames it over the target.

FAIL if the corrected function writes straight to the target path, with `os.WriteFile` or any other call.
