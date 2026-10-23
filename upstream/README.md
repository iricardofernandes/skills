# Upstream tracking

`sources.tsv` maps every adapted file in this repo to the upstream path and the commit it was last synced from.

```bash
./scripts/upstream-diff.sh            # what changed upstream since each pin, for every source
./scripts/upstream-diff.sh better-ui  # full diff for one local skill
```

After porting an upstream change by hand, bump that row's `pinned_commit` to the upstream commit you synced to.

`skills/plan` and the two agents were rewritten rather than copied, so treat their upstream diffs as ideas, not patches.
