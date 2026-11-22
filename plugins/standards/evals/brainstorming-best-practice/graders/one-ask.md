---
type: llm
---
PASS if one answer from the user would answer everything the reply asks, or if the reply asks nothing. A question followed by its choices and a closing "which do you want?" is one ask. None of these counts as an ask: a sentence that says why the question is asked, a decision stated with an invitation to correct it ("I'll go with X unless you'd rather not"), and an offer to skip the questions ("Or if you'd rather I just get going, say so").

FAIL if answering the reply in full would take two or more separate answers or actions from the user. Two different questions fail, whether joined with "and" or written as separate sentences. So do a question beside a request (for example "point me at the repo"), and a list of questions.
