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
| **Plan** | `plan` — restate, ground in the codebase, phase the work, wait for a go-ahead |
| **Build** | `build-design` (Figma or image to code), `animate`, `animate-expo`, `mobile-native`, `pick-ui-library` |
| **Explore** | `variant` (several directions behind a picker), `state-machine` (every state of a component), `break` (worst-case content), `explain-interface` (how a site or effect was built) |
| **Polish** | `better-ui`, `better-typography`, `better-colors`, `better-layout`, `better-writing`, `better-accessibility`, `design-eng`, `apple-design` |
| **Motion** | `find-animation-opportunities`, `improve-animations`, `animation-performance`, `animation-vocabulary` |
| **Review** | `interface-review` (a branch or diff), `better-interface` (all `better-*` at once), `review-animations`, plus the `code-reviewer` and `security-reviewer` agents |

Skills marked user-invoked only run when you call them, for example `/craft:variant` or `/craft:interface-review`. The rest also trigger on their own when the task matches.

## Repository layout

```
.claude-plugin/   plugin and marketplace manifests
skills/           one folder per skill
agents/           code-reviewer, security-reviewer
global/CLAUDE.md  personal global instructions, linked by install.sh
upstream/         where adapted skills came from, pinned by commit
scripts/          check.sh (run before every push), upstream-diff.sh
```

## Maintaining

```bash
./scripts/check.sh                # validate the plugin and guard against leaks
./scripts/upstream-diff.sh        # see what changed upstream since the last sync
```

Bump `version` in `.claude-plugin/plugin.json` on every release so `/plugin update` picks it up.

## License

MIT. Some skills are adapted from other MIT-licensed projects; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
