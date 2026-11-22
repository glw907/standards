---
type: regex
pattern: '@(param|returns?)\s*\{'
match: not_contains
target: last_message
---
No TSDoc tag carries a `{type}`.
