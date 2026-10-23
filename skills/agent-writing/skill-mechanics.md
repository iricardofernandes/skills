# Skill mechanics

What changes when the document is a skill: frontmatter, invocation and splitting. The writing itself follows [SKILL.md](SKILL.md).

## Frontmatter

- `name` matches the folder name (`scripts/check.sh` enforces it).
- `description` is the skill's pointer: always loaded, so it carries the triggers and nothing else.
- `argument-hint` shows what follows `/name` when the user types it.
- `disable-model-invocation: true` makes the skill user-invoked.

## Model-invoked or user-invoked

- **Model-invoked** (no `disable-model-invocation`): the agent fires it on its own and other skills can call it; the user can still type `/name`. Its description stays in context every turn, so it has to earn that. Write the description for the model: what it is, then the trigger branches.
- **User-invoked** (`disable-model-invocation: true`): only the user can start it, and no other skill can reach it. It costs nothing in context, but the user has to remember it exists. Write the description for the user: one line, no trigger list.

Make a skill model-invoked only when the agent must reach it alone or another skill must call it. Reference that two user-invoked skills both need lives in a model-invoked skill or in a plain file both point to.

## When skills still do not load

Descriptions are matched against the request, and in long or busy tasks the agent often skips them. When a skill must load for a class of prompts, add a line to the plugin's `UserPromptSubmit` hook that prints a reminder to invoke it on matching words, as `hooks/ui-reminder.sh` does.

## Splitting

- **By invocation**: split out a model-invoked skill when a distinct word in the user's prompts should trigger it on its own, or another skill must call it. Each new description is a permanent cost.
- **By sequence**: split a run of steps when the later steps tempt the agent to rush the current one, and only across a real boundary (a hand-off or a subagent). An inline skill call leaves the later steps in context.

When user-invoked skills pile up past what the user remembers, a single user-invoked index skill that lists them and when to use each takes the load off.
