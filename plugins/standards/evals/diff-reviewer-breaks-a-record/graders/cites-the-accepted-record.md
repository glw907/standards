---
type: llm
---
PASS if the reply reports, as blocking, that the importer mints its own member ID (with `uuid.NewString`) instead of calling `store.NewID`, and gives decision record 0002 ("The store mints member IDs") as the reason.

FAIL if the reply never raises the ID, raises it only as non-blocking, or raises it without citing record 0002.
