#!/usr/bin/env bash
# Conformance gate for the mezze-js provider.
#
# Runs the TYPE-LEVEL gate (`mez check`) on the conformance app: it references
# every JsForeign verb + both constructor families and calls each crossing verb
# on a Result receiver, so the whole surface AND the `impl Result JsForeign`
# mirror must compile against the current toolchain. Backed by the toolchain's
# #22 foreign-kind gate, this alone proves surface completeness + mirror
# soundness. Runtime-free, so it needs no guest language — ideal for CI.
#
# The behavioural layer (`mez dev --no-watch`, which needs GraalJS) is run with
# MEZ_CONFORMANCE_BEHAVIOURAL=1.
#
# Set MEZ to the mez binary. Defaults to a sibling dev build of the toolchain.
set -euo pipefail
cd "$(dirname "$0")"

MEZ="${MEZ:-../../mezze/cli/build/install/mez/bin/mez}"
# Use the toolchain's bundled stdlib, never a stale installed one.
export MEZZE_HOME="${MEZZE_HOME-}"

echo "→ mez sync"
"$MEZ" sync

echo "→ mez check (type-level conformance: verb surface + Result mirror)"
"$MEZ" check

if [ "${MEZ_CONFORMANCE_BEHAVIOURAL:-0}" = "1" ]; then
  echo "→ mez dev --no-watch (behavioural round-trips; needs GraalJS)"
  "$MEZ" dev --no-watch
fi

echo "✓ mezze-js conformance passed"
