---
type: llm
---
PASS if the doc comment tells a caller that the delay grows with each attempt (doubling, or exponential growth, both count) and that the result never exceeds `maxMs`.

FAIL if the doc comment leaves out the growth or leaves out the cap.
