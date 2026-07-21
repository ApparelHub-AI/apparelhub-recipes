#!/usr/bin/env bash
#
# Fail if any tracked file embeds account-specific data that must never ship publicly.
# Two layers:
#   1. Structural (always on): no account-specific UUIDs. Public recipes use <placeholders>
#      and discover real ids at runtime via the bootstrap.
#   2. Owner tokens (maintainer CI): a pipe-delimited FORBIDDEN_TERMS repo secret, kept OUT of
#      this public file so real names / domains never appear in the workflow itself.
#
set -uo pipefail

# Tracked files, excluding binaries/lockfiles and this guard's own files (which contain the
# very patterns it searches for).
files=$(git ls-files \
  | grep -vE '\.(png|jpg|jpeg|gif|webp|ico|lock)$' \
  | grep -vE 'scripts/check_forbidden_patterns\.sh|\.github/workflows/forbidden-patterns\.yml' \
  || true)

fail=0

if [ -z "$files" ]; then
  echo "No files to scan."
  exit 0
fi

# 1) Structural guard: any UUID is account-specific and must not be embedded.
if echo "$files" | xargs -r grep -HInoE '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'; then
  echo "::error::Found a UUID. Public recipes must not embed account-specific ids. Use <placeholders>; discover real ids at runtime via BOOTSTRAP-PROMPT.md."
  fail=1
fi

# 2) Owner-token guard (only when the secret is configured).
if [ -n "${FORBIDDEN_TERMS:-}" ]; then
  if echo "$files" | xargs -r grep -HIniE "$FORBIDDEN_TERMS"; then
    echo "::error::Found a forbidden account/owner token. Scrub it and use a generic placeholder (e.g. your-store.myshopify.com)."
    fail=1
  fi
else
  echo "note: FORBIDDEN_TERMS not set; skipped the owner-token scan (structural UUID scan still ran)."
fi

if [ "$fail" -ne 0 ]; then
  echo "Forbidden-pattern check FAILED."
  exit 1
fi
echo "Forbidden-pattern check passed."
