---
name: debug
description: Diagnosis loop for bugs, regressions and visual glitches. Use when something is broken, throwing, failing, slow, or looks wrong, including layout that shifts, jumps, flickers, overlaps or misaligns, and when the user says debug, diagnose, "why does", "não funciona", "quebrou" or "bug".
argument-hint: "[symptom]"
---

# Debug

Find the cause before touching the code. Every phase ends on a check you can show; move to the next phase only when it passes.

Redact secrets in every command and output you show: write `<REDACTED>` in their place and keep credentials in env vars.

## 1. Build a loop that goes red

**This is the skill.** A loop is one command that drives the real code path and asserts the user's exact symptom. With a loop the cause falls out of bisection and hypothesis testing; without one, reading code only produces theories.

Pick the cheapest loop that reaches the bug:

1. A failing test at the seam that reaches it (unit, integration, e2e).
2. A `curl` or HTTP script against the dev server.
3. A CLI run on a fixture, diffed against a known-good output.
4. A headless browser script (Playwright) that drives the UI and asserts on the DOM, layout, console or network. **Visual bugs use this branch**: read [visual.md](visual.md).
5. A captured request, payload or event log replayed through the code path.
6. A throwaway harness: the smallest slice of the system that runs the path in one call.
7. A fuzz loop for "sometimes wrong": many random inputs, watch for the failure.
8. A bisection harness when it broke between two known states: `git bisect run <loop>`.
9. A differential loop: the same input through the old and the new version, outputs diffed.
10. A human in the loop, last: a script that tells the user exactly what to click and captures what they report.

Then make the loop **tight**: seconds instead of minutes, the assertion on the specific symptom, the same verdict every run (pin time, seed randomness, wait for the right event). For flaky bugs, raise the reproduction rate (repeat 100×, add load, narrow the timing) until it fails often enough to work with.

**Done when** you have run one command, shown its invocation and output, and it is:

- **red** on this bug, asserting the user's symptom, and able to go green once fixed;
- **deterministic**;
- **fast**;
- **unattended**.

If you cannot build one, say so, list what you tried, and ask for access to the environment that reproduces it, a captured artifact (HAR, logs, screen recording with timestamps) or permission to add temporary instrumentation. Hypotheses wait until the loop exists.

## 2. Reproduce and minimise

Run the loop and confirm it fails the way the **user** described, not with a neighbouring bug, across several runs. Capture the exact symptom (message, wrong value, pixel delta, timing) to verify the fix against.

Then shrink: cut inputs, components, props, config and steps one at a time, re-running after each cut. **Done when** every remaining element is load-bearing: removing any one turns the loop green.

## 3. Hypothesise

Write **3 to 5 ranked hypotheses** before testing any. Each one is falsifiable:

> If X is the cause, then changing Y makes the bug disappear, and changing Z makes it worse.

A hypothesis without a prediction is a hunch: sharpen it or drop it. Show the ranked list to the user, since they may already know one is ruled out, then continue with your ranking without waiting.

## 4. Instrument

Each probe tests one prediction and changes one variable. Prefer a debugger or REPL, then targeted logs at the boundaries that separate the hypotheses. Tag every temporary log with one prefix, such as `[DEBUG-a4f2]`, so cleanup is one grep.

For performance, measure instead of logging: a baseline (`performance.now()`, profiler, query plan), then bisect.

## 5. Fix with a regression test

Turn the minimised repro into a test at a seam that exercises the real pattern, before the fix:

1. Watch it fail. If you forced the red by editing code or a fixture, diff against a pristine copy to prove the edit landed.
2. Apply the fix.
3. Watch it pass.
4. Re-run the original, unminimised loop from phase 1.

If the only seam available is too shallow to catch the real pattern, that is a finding: report it instead of shipping a test that would pass anyway. For visual bugs, the measurement script from [visual.md](visual.md) is the regression check.

## 6. Clean up

Done when:

- the phase 1 loop is green;
- the regression test passes, or the missing seam is reported;
- `grep` for the debug prefix returns nothing;
- throwaway harnesses are deleted;
- the hypothesis that was right is stated in the summary and in the commit message, if the user asks for a commit.
