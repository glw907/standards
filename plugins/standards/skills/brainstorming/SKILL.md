---
name: brainstorming
description: >-
  Explores a design with the user before it is built: reads the project first, asks one question
  at a time and only what the user alone can answer, lays out two or three approaches with a
  recommendation, then writes a design to approve. Use when new work's design is not settled, or
  when the user asks to brainstorm or think something through.
---

# Brainstorming

A builder's guess at what the user wants is thinner than it feels. This skill finds out what they
want, and why, before anything gets built. When you know the why, you can make the many decisions
they never mention the way they would have made them.

## When to brainstorm

Before you reply, ask yourself what you know about what they want, and why.

- Everything that matters is in the request ("make the icon cornflower blue"). Do it, and say
  what you did. This skill is done.
- Something that would change what gets built is missing. Brainstorm.

A brainstorm runs in this order: understand what they want, lay out the approaches and let them
pick, write the design, get the written design approved, then build. Build nothing before that
approval. Building means product code, scaffolding, installing dependencies, or creating a
project. A "sounds good" in conversation covers only what they saw, and a design that isn't
written down hasn't been seen.

Two things are not building. A throwaway spike they agreed to may be built, and keeping what it
produced is a new request. If they tell you to skip the questions, this skill is done: state any
significant choice of platform, language, or medium in one line, and do what they asked.

## Read before you ask

Read what they pointed at and the project around it before your first message, and again each
time an answer points somewhere new. Read until you can say how the relevant parts work today and
what the change would touch. Open the files nearest the request; a listing of names is not a
read. Say in a line what you read, so they can tell you what you missed.

A question the project, their files, the earlier conversation, or the web could answer wastes
their turn. Look it up and say what you found. Don't ask permission to look.

## What to ask

Ask only what the user alone can answer and whose answer would change what gets built. That is
what the thing is for, who uses it, what matters most to them, what it must never do, and how
much it is worth. How it gets built is your call. Decide, and say the decision and its reason in
a line they can correct. When they ask "what's best practice here?", answer with the practice
and its reason, treat that as decided, and go on. They asked you to decide, so don't ask them to
confirm it.

Ask a question they can answer from what they already know: a fact about their situation today,
or a preference they hold.

- Good: "How do people sign up today?" "Who needs to see the list?" "Which of these two matters
  more to you?"
- Bad: "Picture a member opening the page. What do they see?" "Think of the last time this went
  wrong. What happened?" "Why do you think customers stop coming back?" "What would make you wince?"

The bad ones ask them to imagine a scene, recall one incident, or guess at other people's
reasons. They sound thoughtful, and the usual answer is "I have no idea."

Ask one thing in a message: one answer from them should cover everything it asks. Each of these
makes them give a second answer, and each gets cut:

- a second question joined on with "and": "How do people book the hall today, and what would make
  an online form better?"
- a follow-on question in the next sentence: "What bothers you about the paper form? What should
  the new one do better?"
- a request beside the question: "Point me at the repo" or "tell me what it runs on"
- "Does that sound right?" after a decision that was yours to make, followed by the next question

Before you send a message, count the answers it needs. If the count is over one, keep the ask
that would change the build most and cut the rest. They will still be there next turn. Write the
ask as a question, with a question mark, as the last line of the message. In a first message the
offer to skip the questions is the one line that follows it. When the reason for asking isn't
plain, give it in one sentence before the question.

Ask why they want it first, if they haven't said. Make it an open question with no answers
attached: no guesses at what the trouble might be, and no "if it's X, I'd build Y". Their own
words carry intent your options would steer. Once you know why, and a decision is theirs and has
choices you can name, give the choices as a numbered list: what each one gets them, what it
costs, and which you recommend. They can answer with a number.

Keep to what they said.

- Stay inside the scope they named. If they are gathering requirements, don't ask about the
  build.
- A number they called a guess is rough. Don't build a question on it.
- Size the work to the request. A small tool for a few people gets a small design, with no
  pipeline, monitoring, or review rounds they didn't ask for.
- Use their words and ordinary ones. Don't coin a label, an id, or a short name for a part of the
  design and then use it as if they knew it.
- When you state back what they told you, state it plainly: "You want the hall booked
  without phone calls." Don't dramatize it as a discovery ("So the real goal isn't the form").

## Your first message

Keep it under about 150 words.

1. Name what you read, in one sentence. If the folder holds nothing about the request, say that
   in one sentence and go on. Where the project lives is a question for a later turn, when an
   answer depends on it.
2. Add what you found that bears on the request: how the relevant parts work today, or a
   constraint, a conflict, or a cheaper path they may not have considered. If they handed you a
   spec, a plan, or a request of several paragraphs, say it back in two or three sentences so
   they can see whether you have its shape. Don't say a short request back to them. They just
   wrote it.
3. End with one of these:
   - options to pick from, if they have said they can't describe what they want (see "Show it");
   - the why question, if they haven't said why;
   - the one question whose answer would change the build most, if the why is known;
   - a short design to approve, if nothing is open and there is one sensible way to build it.

Add one line after the question: "Or if you'd rather I just get going, say so."

## Lay out the approaches

Once you understand what they want, and before you write anything up, put the ways of building
it in a message of their own.

Look for published practice first: the vendor's documentation, and well-cited community practice.
Do it at this point and no earlier, because the why decides what is worth looking up. Keep it to
a few lookups on the choice in front of them. A brainstorm is a conversation, and a long research
run in the middle of it leaves them waiting. If the choice needs more reading than that, say what
you would read and go on with what you have.

Say where each approach comes from, whether that is the documentation, a named community source,
or your own design. Prefer a documented approach to one you invented, and say so when you found
none. If you can't search, say the approach is from memory and unchecked.

Give the two or three real alternatives, each concrete enough to picture, with what it trades
off. Number them, recommend one, and say why. Ask which they want. If they have left the how to
you, say you'll go with your pick. If there is one sensible way, say why the others don't fit.

## Show it

When seeing would help more than reading, sketch it in text: a few lines of what they would see.

When they can't describe what they want ("I'm not a designer"), don't ask them to describe it,
and don't ask another question first. In that same message, show two or three options, each
concrete enough to picture, and ask which is closest. This comes before the why question, even
in your first message. Their pick tells you what they want, and the why can wait a turn.

Offer the visual companion the first time the look itself is theirs to decide: a screen, a
layout, a flow, or options that would look different from each other. The offer is its own
message:

> "This might be easier if I show you. Want me to open a browser tab with some mockups?"

If they decline, stay in text. If they accept, read `visual-companion.md` in this directory
before starting the server. The server's scripts are
`${CLAUDE_SKILL_DIR}/scripts/start-server.sh` and `${CLAUDE_SKILL_DIR}/scripts/stop-server.sh`.
Run each by that full path wherever `visual-companion.md` names it. Mockups, layouts, and
side-by-side options go in the browser. Requirements, scope, and trade-offs stay in text.

A quick throwaway build is sometimes the cheapest way to learn what they want. Offer a spike
when it would help, keep it labeled throwaway, and bring what it taught you back into the
conversation.

## Play it back

When you understand one part well enough to describe it, describe it back in a short paragraph
and ask what's wrong or missing. What they said goes in as theirs. What you filled in goes in as
your proposal, with your reason.

After they pick an approach, play back the whole design once and ask whether anything is left to
talk through. Write it up when they say it is settled, because picking an approach doesn't mean
they are done thinking.

## The written design

Say how big the work is in plain words. A small change gets a short design: what you covered
together, in a line or two for each point. A project gets the full document. If the work is
really several independent projects, say so, agree on an order, and take them one at a time.

When the repository or the user's instructions say how a design or a spec is written and where it
goes, follow that guide. The written design is that document, written once and approved once.
Don't write a design and then a second document from it.

Without a guide, pick a sensible place, say where, and cover:

- the intent and the why, in their words
- goals, non-goals, and what would make it a failure even if it works
- constraints
- the approaches considered, where each came from, which they picked, and why
- what happens when it goes wrong, and the number for each limit
- the parts of the how they decided, as they decided them
- the calls you made, in one list they can check
- what done looks like: what they would see or run, each item able to fail

For a project, have a fresh reader check the document before you hand it over. Dispatch a
subagent with `builder-check-prompt.md` in this directory, on the strongest model you can name,
and tell the user a reviewer will read it first. Sort what it asks into three piles:

- answered already by the conversation or the project: put the answer in the document;
- minor, where a sensible builder could settle it without changing what gets built: settle it
  and mark it as your call;
- theirs, where only the user can answer and the answer changes what gets built.

Bring the third pile in one message, most important first. That is the only round of questions
the check produces. Without a subagent tool, read the document as that builder yourself.

After they approve the written design, build it by the repository's guide for building from a
spec, if it has one.
