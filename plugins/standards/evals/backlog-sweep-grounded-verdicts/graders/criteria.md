---
type: llm
---
PASS only if all of these hold:

1. Each of the four items gets exactly one verdict, and each verdict is one of fold, keep, reword, done, duplicate, or drop. A reply may also give each item a triage disposition beside its verdict: the skill maps keep and reword to defer, and drop, done, and duplicate to drop, so a done item listed with the disposition drop is still marked done. A keep verdict that suggests sharper wording for the same item still counts as one verdict.
2. The backoff item is marked done, citing `delay *= 2` in `withRetry` as the proof.
3. The `XDG_CONFIG_HOME` item is kept (keep or defer), because `configPath` still joins the home directory with `.config` and never reads the variable.
4. One of the two JSON items is marked a duplicate of the other, and the item it merges into is kept, since `list` still has only `--all`.
5. No item is dropped only because it is old or has seen no activity.

FAIL if any item gets no verdict or two, if the backoff item is kept as open work, or if the two JSON items both stay as separate open items.
