---
name: agent-writing
description: How to write documents an agent reads. Use when creating or editing a skill, a SKILL.md description, a hook message, an agent definition, CLAUDE.md or AGENTS.md.
---

# Agent writing

Everything an agent reads, whether a skill, a `CLAUDE.md`, a hook message or a doc it is pointed at, works by the same levers. The goal is that the agent takes the same path every run. When the document is a skill, also read [skill-mechanics.md](skill-mechanics.md).

## Pointers decide when material is read

A **pointer** is the line in the agent's context that names material it has not read yet and says when to read it. A skill description is one; a `CLAUDE.md` line naming a doc is another. Its wording, not the material behind it, decides whether the agent ever gets there. When material is skipped, rewrite the pointer first, and inline the material only if that fails.

A pointer says what the material is and lists the **branches** that should trigger it, one trigger per distinct case:

- Put the triggering word first.
- Collapse synonyms that name the same case into one.
- Use the words the user actually types, in their language too ("quebrou", "tabela").
- Leave out what the body already says about itself.

Always-loaded lines (descriptions, `CLAUDE.md`, hook output) cost tokens and attention every turn, so they get the hardest pruning.

## The ladder

Material sits on one of three rungs, by how soon the agent needs it:

1. **Steps in the file**: what the agent does, in order.
2. **Reference in the file**: rules and facts consulted while working.
3. **Reference behind a pointer**: a sibling file, read only when its pointer fires.

Inline what every path through the document needs, and move what only some paths need behind a pointer. A file that keeps everything inline buries its steps, and the agent attends to them by chance. Keep a concept's definition, rules and caveats together under one heading.

## Steps end on a criterion

Every step ends on a **done when**: a condition the agent can check.

- **Clear**: a vague bound ("once you understand it") lets the agent stop early, pulled by the steps that come after. Sharpen the bound first. Hide the later steps behind a hand-off or subagent only if the bound cannot be made sharp and the rush is observed.
- **Demanding**: "every call site migrated" forces the work that "list the changes" does not. The same bar works on reference: "every rule applied".

The best criteria are checkable and exhaustive.

## Leading words

A **leading word** is a compact concept the model already knows (_tight_ loop, _red_, _frontier_, _rule of two_) that stands for a whole behaviour. Repeat the word, not the explanation, and it anchors the same behaviour everywhere it appears and in the user's prompts. Prefer an existing word over a coined one, which needs its definition paid in tokens.

Look for phrases restated across a document and collapse each into one word: "fast, deterministic, low overhead" becomes _tight_.

## Say what to do

A prohibition puts the forbidden behaviour into context and makes it more likely. Write the target behaviour ("reuse or extend the existing component") instead of the ban. Keep a "never" only for a hard guardrail with no positive phrasing, and pair it with the positive target.

## Prune

- **One source of truth** per meaning. Repeating a rule in two places costs tokens, drifts on the next edit and inflates its weight.
- **The environment is a source of truth.** `package.json`, config files and `--help` already say what they say. Write down what the agent cannot find by looking: the convention, the reason, the gotcha.
- **Delete no-ops.** A sentence the model would follow anyway changes nothing; delete it whole. A word too weak to change the default (_be thorough_) needs a stronger word (_exhaustive_), not more words.
- **Delete stale lines.** Every line should still bear on what the document does. Re-read the whole file when you change behaviour, not just the lines you touched.

## Check it by running it

Whether a sentence changes behaviour is settled by running the document, not by debate. After editing a skill, run a task that should trigger it (`claude -p --plugin-dir <repo> "<prompt>" --output-format json`) and confirm it loads and follows the steps. Run one that should not, and confirm it stays quiet.
