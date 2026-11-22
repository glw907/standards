---
type: llm
---
PASS only if all of these hold:

1. The doc comment is TSDoc and states the contract a caller needs: the delay doubles per attempt, the exponent stops growing at attempt 30, and the result never exceeds `maxMs`. It does not restate parameter or return types, and it carries no `{type}` in a tag.
2. The answer would drop the two comments that paraphrase the next line ("compute the exponent", "multiply the base by two to the power of the exponent") and keep the one that gives the reason (one stuck call cannot stall the queue).
3. The comment contains no em dash.

FAIL if it adds `@param {number}` style tags, describes the function in words that only repeat its name and signature, or keeps the paraphrase comments.
