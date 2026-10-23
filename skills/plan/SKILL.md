---
name: plan
description: Restate requirements, assess risks, and create a step-by-step implementation plan. WAIT for user confirmation before touching any code.
argument-hint: "[feature description | path/to/file.md]"
disable-model-invocation: true
---

# Plan

Create an implementation plan before writing any code. Run inline; do not delegate to a subagent.

## Steps

1. **Restate the requirements** in clear terms. If the input is empty or ambiguous, ask what should be planned.
2. **Ground the plan in the codebase.** Find the existing patterns the work should mirror and cite them as `path:line`: naming, component structure, styling system and tokens, data access, error handling, tests. If nothing similar exists, say so. Do not invent a pattern.
3. **Break the work into phases**, each with concrete, actionable steps and the files they touch.
4. **Name dependencies** between steps and any new packages.
5. **Assess risks** with likelihood and mitigation.
6. **Estimate complexity**: Low, Medium or High.
7. **Present the plan and stop.** Do not write code until the user confirms.

If the input is a markdown file, read it as the source of requirements.

## Output

```markdown
# Plan: {feature}

## Requirements
- ...

## Patterns to mirror
| Category | Source | Pattern |
|---|---|---|

## Phases
### Phase 1: {name}
- {step} — `path`

## Dependencies
- ...

## Risks
| Risk | Likelihood | Mitigation |
|---|---|---|

## Validation
{commands that prove it works: build, typecheck, tests, visual check}

## Complexity: {Low | Medium | High}

**Waiting for confirmation:** proceed, modify, or take a different approach?
```

The user can reply "modify: …", "different approach: …" or "skip phase N". Only an explicit yes starts the implementation.
