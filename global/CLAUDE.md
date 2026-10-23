# Global instructions

## Communication
- Reply in Brazilian Portuguese. Code, commits, comments and identifiers stay in English.
- Be direct. Give a recommendation, not a survey of options.

## How I work
- Mostly frontend and UI: Astro, Next.js, React, Tailwind, pnpm. Interface quality matters as much as correctness.
- Before building, read how the project already does it (components, tokens, styling system) and match it. Never introduce a second styling system or a new dependency without asking.
- For anything that spans several files or is ambiguous, plan first (`/plan`) and wait for my go-ahead.

## Code
- Small, focused files and functions; early returns over deep nesting.
- Handle errors explicitly; never swallow them silently. Validate input at system boundaries.
- No hardcoded secrets — environment variables only, and never put secrets in public env prefixes.
- No leftover debug logging.
- Add tests where logic is non-trivial (data transforms, server actions, utilities). UI work is verified by running it and looking at it.

## Review
- After a meaningful code change, run the `code-reviewer` agent. For auth, forms, API routes, payments or anything touching secrets, also run `security-reviewer`.
- For UI changes, run `interface-review` before calling the work done.

## Git
- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `perf:`, `test:`, `ci:`.
- Commit or push only when I ask.
