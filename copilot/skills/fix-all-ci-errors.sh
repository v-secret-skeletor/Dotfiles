#!/bin/bash
#
# Runs bin/ci-summary and outputs the results for Copilot to interpret and fix.
# Usage: fix-all-ci-errors.sh
#
# Expects bin/ci-summary to exist in the repository root.
# The output of this skill is consumed by Copilot, which should then
# read the failing test details and apply fixes to the codebase.

set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CI_SUMMARY="${REPO_ROOT}/bin/ci-summary"

if [[ ! -x "$CI_SUMMARY" ]]; then
  echo "error: bin/ci-summary not found or not executable at ${CI_SUMMARY}" >&2
  exit 1
fi

echo "=== CI Summary ==="
CI_OUTPUT="$("$CI_SUMMARY" 2>&1)" || true
echo "$CI_OUTPUT"
echo "=== End CI Summary ==="

if echo "$CI_OUTPUT" | grep -qiE '(fail|error|FAIL|ERROR)'; then
  echo ""
  echo "ACTION REQUIRED: Failing tests detected above."
  echo "Read each failure, identify the root cause in the source code, and apply fixes."
else
  echo ""
  echo "No failures detected. All CI checks appear to be passing."
fi
