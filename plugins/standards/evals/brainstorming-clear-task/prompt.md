---
max_turns: 8
timeout_seconds: 300
tags: [brainstorming]
---
Rename the variable `cnt` to `count` in this function and show me the result.

```js
function tally(xs) {
  let cnt = 0;
  for (const x of xs) cnt += x;
  return cnt;
}
```
