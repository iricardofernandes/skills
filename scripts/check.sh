#!/usr/bin/env bash
# Pre-publish checks: plugin validity, skill names, attribution scrub and leaked course material.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
status=0
fail() { echo "FAIL: $*"; status=1; }

claude plugin validate . || fail "claude plugin validate"

for f in skills/*/SKILL.md; do
  dir="$(basename "$(dirname "$f")")"
  name="$(sed -n 's/^name: *//p' "$f" | head -1)"
  [ "$name" = "$dir" ] || fail "$f: name '$name' does not match folder '$dir'"
done

# Attribution lives in THIRD_PARTY_NOTICES.md only.
if grep -rniE 'kowalski|emil|krehel|jakub|animations\.dev' skills agents global README.md \
     | grep -v 'sonner\.emilkowal\.ski'; then
  fail "author references outside THIRD_PARTY_NOTICES.md"
fi

# Paid course material and its install tokens must never be committed.
if find skills -name 'css-techniques.md' -o -name 'framer-motion.md' -o -name 'svg-animation.md' | grep -q .; then
  fail "course-only reference files found"
fi
for s in css-animations motion-react gesture-ui scroll-animations debug-animation animation-accessibility motion-brief; do
  [ -e "skills/$s" ] && fail "course-only skill '$s' found"
done
if grep -rIlE 'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}' --exclude-dir=.git . ; then
  fail "token-like string found"
fi

[ "$status" -eq 0 ] && echo "All checks passed."
exit "$status"
