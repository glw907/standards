---
type: llm
---
PASS if the reply marks the backoff item done and gives the code as the reason: it quotes `delay *= 2`, says the delay doubles, or names the retry function or its file.

FAIL if the reply keeps the backoff item as open work, or marks it done with no reference to the code.
