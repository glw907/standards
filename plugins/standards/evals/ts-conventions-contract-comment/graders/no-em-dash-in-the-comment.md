---
type: regex
pattern: '^\s*(/\*\*|\*|//).*—'
flags: m
match: not_contains
target: last_message
---
No comment line holds an em dash.
