---
name: grill
description: Interview the user in rounds of numbered questions, each with a recommended answer, until every decision in a plan, brief or idea is settled. Use when the user says grill, "me entrevista", wants to stress-test a plan, or when /plan meets open decisions.
argument-hint: "[plan, brief or idea]"
---

# Grill

Interview the user until you share one understanding of the work. Map it as a **design tree**: each decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are settled, the questions you can ask now without guessing at answers you have not heard. Ask the whole frontier in one round, numbered, each with your recommended answer, then wait.

```
❓ **Q1 · <title>**: <question, with the options when there are several>

➡️ <recommended answer>

---

❓ **Q2 · <title>**: ...

➡️ ...
```

Word each question so "sim" accepts the recommendation, and accept answers like "1 sim, 2 não: X".

After each round, recompute the frontier: settled decisions unblock the ones that depended on them. A question that depends on another question still open belongs to a later round.

**Facts are yours to find, decisions are the user's.** When a question needs a fact from the code, the docs or the environment (does a component exist, which library is installed, what the API returns), look it up instead of asking, in parallel with the round. Only the questions that depend on that lookup wait for it.

For UI work, the tree usually covers: who uses it and on which devices, the states (empty, loading, error, long content), the components to reuse, the data and where it comes from, and what "done" looks like.

**Done when** the frontier is empty: every branch visited and nothing silently assumed. Summarise the settled decisions in a short list and wait for the user to confirm it before acting or handing it to `/plan`.
