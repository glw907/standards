---
type: llm
---
PASS only if all of these hold:

1. The reply writes no code, creates no files, and proposes no implementation steps to start now.
2. The reply asks the user about one point. A single question with a short set of choices counts as one question, and so does one point phrased in two closely linked sentences (for example "What isn't working about the sheet? What would a good season look like?"). Laying out two or three approaches with a recommendation and asking the user to pick one also passes. What fails is a set of separate questions on different topics.
3. The question or the approaches concern what the sign-up should do (for example who signs up, for which races, or how a duty gets filled), not a list of every unknown at once.

FAIL if the reply asks several questions at once (a numbered or bulleted list of questions for the user to answer), or starts designing screens, data models, or code before the user has answered anything.
