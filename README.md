# craft

Agent skills for building interfaces that feel right, from the first plan to the final review: layout, typography, color, accessibility, interface copy, motion, and code and security review.

Built for Claude Code as the `craft` plugin. The skills are plain `SKILL.md` folders, so they also work in other agents that read the same format.

## Install

```text
/plugin marketplace add iricardofernandes/skills
/plugin install craft@skills
```

Or from a clone, which also links `global/CLAUDE.md` into `~/.claude`:

```bash
./install.sh            # from GitHub
./install.sh --local    # from this checkout
```

## The flow

| Stage | Skills |
|---|---|
| **Plan** | `plan` (restate, ground in the codebase, phase the work, wait for a go-ahead; `/plan --grill` interviews first), `grill` (rounds of questions with recommended answers until every decision is settled) |
| **Design** | `design` (the front door: brief, scope, states, drawing and self-check in the design tool before any code), `design-setup` (interview and `DESIGN.md` brief), `design-system` (tokens, components with a states matrix, open states included), `design-states` (every state a screen can be in), `design-explore` (three directions that really differ), `design-critique` (renders and checks the boards against the rules and every `better-*` domain), `design-sync` (a design system in code into the tool, and guide changes back to code). Adapters for FigCraft, Paper, Figma, pen.dev and plain HTML |
| **Build** | `components` (find and reuse before creating, one component per pattern, project inventory; `/components` audits duplicates), `component-specs` (how selects, date pickers, tables, overlays and every control should look and behave), `build-design` (FigCraft, Figma or image to code), `animate`, `animate-expo`, `mobile-native`, `pick-ui-library` |
| **Explore** | `variant` (several directions behind a picker), `state-machine` (every state of a component), `break` (worst-case content), `explain-interface` (how a site or effect was built) |
| **Polish** | `better-ui`, `better-typography`, `better-colors`, `better-layout`, `better-writing`, `better-accessibility`, `design-eng`, `apple-design` |
| **Motion** | `find-animation-opportunities`, `improve-animations`, `animation-performance`, `animation-vocabulary` |
| **Debug** | `debug` (a loop that goes red on the symptom before any theory; measuring scripts for layout shift, alignment and overlap) |
| **Review** | `interface-review` (a branch or diff), `better-interface` (all `better-*` at once), `review-animations`, plus the `code-reviewer` and `security-reviewer` agents |

Skills marked user-invoked only run when you call them, for example `/variant` or `/break` (use `/craft:variant` if another installed skill has the same name). The rest also trigger on their own when the task matches.

### Design first

New screens and flows are drawn before they are coded: `design` lays out every screen, state and component in the design tool (FigCraft by default: free, local, no quota), so you see every version of the design at once. Then `build-design` implements the boards, and the code is polished and reviewed with the motion, `better-*` and `interface-review` skills. The `better-*` skills are the standard in both phases: `design-critique` checks the boards against them before anything is built.

## Reminder hook

Skills load when the model decides they match, and in long tasks it often does not. The plugin ships a `UserPromptSubmit` hook (`hooks/ui-reminder.sh`) that, in English or Portuguese, tells the model to load `design` when a prompt asks to design or draw screens, `components` and `component-specs` when it is about UI, and `debug` when it reports a bug. It prints nothing for other prompts.

## Repository layout

```
.claude-plugin/   plugin and marketplace manifests
skills/           one folder per skill
agents/           code-reviewer, security-reviewer
hooks/            UI reminder hook
global/CLAUDE.md  personal global instructions, linked by install.sh
upstream/         where adapted skills came from, pinned by commit
scripts/          check.sh (run before every push), upstream-diff.sh
```

## Maintaining

Edit skills with `agent-writing` loaded: it covers descriptions as triggers, what to inline and what to move to a sibling file, completion criteria, and pruning.

```bash
./scripts/check.sh                # validate the plugin and guard against leaks
./scripts/upstream-diff.sh        # see what changed upstream since the last sync
```

Bump `version` in `.claude-plugin/plugin.json` on every release so `/plugin update` picks it up.

## License

MIT. Some skills are adapted from other MIT-licensed projects; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
