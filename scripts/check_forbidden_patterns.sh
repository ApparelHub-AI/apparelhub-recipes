#!/usr/bin/env bash
#
# Fail if any tracked file embeds account-specific or internal data that must never ship publicly.
# Four layers:
#   1. Structural (always on): no account-specific UUIDs. Public recipes use <placeholders>
#      and discover real ids at runtime via the bootstrap.
#   2. Structural (always on): no real *.myshopify.com host. Only the generic example is allowed.
#   3. Owner tokens (maintainer CI): a pipe-delimited FORBIDDEN_TERMS repo secret, kept OUT of
#      this public file so real names / domains never appear in the workflow itself.
#   4. Private references (maintainer CI): a pipe-delimited FORBIDDEN_REFS repo secret covering
#      internal repo names, internal ticket refs, and internal filesystem paths.
#
# LOG SAFETY: in CI, every check is QUIET (grep -q) and reports only the category plus the
# offending filenames, never the matched value. A public build log must never echo the very
# string the guard exists to keep out of the repo. Run locally (without CI set) to see the
# actual matches while you fix them.
#
set -uo pipefail

# Verbose locally so contributors can see what to fix; quiet in CI so nothing leaks publicly.
if [ -n "${CI:-}${GITHUB_ACTIONS:-}" ]; then VERBOSE=0; else VERBOSE=1; fi

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

# report <category> <hint> <matching-files>
# Names the category and the files, never the matched value. Locally, also shows the matches.
report() {
  local category="$1" hint="$2" hits="$3"
  echo "::error::${category} ${hint}"
  echo "  offending file(s):"
  printf '    %s\n' $hits
  fail=1
}

# 1) Structural guard: any UUID is account-specific and must not be embedded.
uuid_re='[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'
hits=$(echo "$files" | xargs -r grep -IlE "$uuid_re" 2>/dev/null || true)
if [ -n "$hits" ]; then
  report "Found a UUID." \
    "Public recipes must not embed account-specific ids. Use <placeholders>; discover real ids at runtime via BOOTSTRAP-PROMPT.md." \
    "$hits"
  [ "$VERBOSE" -eq 1 ] && echo "$files" | xargs -r grep -HInoE "$uuid_re"
fi

# 2) Structural guard: a real *.myshopify.com host. Only the generic example is allowed.
# -H -o (filename + matched host) so the allowed generic example can be filtered out.
# NOTE: do NOT add -l here; it suppresses -o, leaving an empty host and flagging every file.
hits=$(echo "$files" | xargs -r grep -IHoE '[a-z0-9-]+\.myshopify\.com' 2>/dev/null \
  | while IFS=: read -r f host; do
      [ "$host" = "your-store.myshopify.com" ] || echo "$f"
    done | sort -u || true)
if [ -n "$hits" ]; then
  report "Found a real *.myshopify.com host." \
    "Use the generic example your-store.myshopify.com." \
    "$hits"
fi

# 3) Owner-token guard (only when the secret is configured).
if [ -n "${FORBIDDEN_TERMS:-}" ]; then
  hits=$(echo "$files" | xargs -r grep -IlniE "$FORBIDDEN_TERMS" 2>/dev/null | cut -d: -f1 | sort -u || true)
  if [ -n "$hits" ]; then
    report "Found a forbidden account/owner token." \
      "Scrub it and use a generic placeholder (e.g. Acme Co, your-store.myshopify.com). The term list is the FORBIDDEN_TERMS repo secret; grep your working tree against your own copy to find it." \
      "$hits"
    [ "$VERBOSE" -eq 1 ] && echo "$files" | xargs -r grep -HIniE "$FORBIDDEN_TERMS"
  fi
else
  echo "note: FORBIDDEN_TERMS not set; skipped the owner-token scan (structural scans still ran)."
fi

# 4) Private-reference guard (only when the secret is configured).
if [ -n "${FORBIDDEN_REFS:-}" ]; then
  # This repo's OWN public URLs are not private references, and they have to appear: recipes are
  # distributed by URL, so every START.md and README carries them. They trip this scan anyway,
  # because the public GitHub org (ApparelHub-AI) is case-insensitively identical to a private
  # repo name in the pattern list, and this scan is deliberately case-insensitive.
  #
  # So neutralize just the host + org + repo prefix before matching. The rest of the path is
  # left intact and still scanned, so a private reference in a URL PATH is still caught.
  self_prefix='https?://(raw\.githubusercontent\.com|github\.com)/ApparelHub-AI/apparelhub-recipes'
  hits=""
  for f in $files; do
    if sed -E "s#${self_prefix}#PUBLIC_SELF_URL#g" "$f" 2>/dev/null | grep -qIiE "$FORBIDDEN_REFS"; then
      hits="${hits}${f} "
    fi
  done
  if [ -n "$hits" ]; then
    report "Found a private-repo reference (internal repo name / ticket ref / internal path)." \
      "Refer to internal work generically, e.g. 'an internal platform ticket'. The pattern list is the FORBIDDEN_REFS repo secret; grep your working tree against your own copy to find it." \
      "$hits"
    if [ "$VERBOSE" -eq 1 ]; then
      for f in $hits; do
        sed -E "s#${self_prefix}#PUBLIC_SELF_URL#g" "$f" | grep -nIiE "$FORBIDDEN_REFS" | sed "s#^#${f}:#"
      done
    fi
  fi
else
  echo "note: FORBIDDEN_REFS not set; skipped the private-reference scan (structural scans still ran)."
fi

if [ "$fail" -ne 0 ]; then
  echo "Forbidden-pattern check FAILED."
  exit 1
fi
echo "Forbidden-pattern check passed."
