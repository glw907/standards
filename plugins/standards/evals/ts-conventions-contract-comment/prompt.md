---
max_turns: 8
timeout_seconds: 300
tags: [ts-conventions]
---
Write the doc comment for this exported function, and say in one line which comments in the body you would leave out.

```ts
export function clampRetryDelay(attempt: number, baseMs: number, maxMs: number): number {
  // compute the exponent
  const exp = Math.min(attempt, 30);
  // multiply the base by two to the power of the exponent
  const raw = baseMs * 2 ** exp;
  // never wait longer than the cap, so one stuck call cannot stall the queue for minutes
  return Math.min(raw, maxMs);
}
```
