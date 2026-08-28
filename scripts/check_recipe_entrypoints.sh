#!/usr/bin/env bash
#
# Recipes are distributed by URL, not by clone. A recipe's START.md is fetched and read
# STANDALONE by an agent that has no local copy of this repo, so it must be self-contained.
#
# This guard enforces that. Four checks:
#   1. Every recipe ships a START.md (it is the entry point users are given).
#   2. No relative links in a START.md. "The file next to this one" does not exist when the
#      document is read over HTTP, so every companion must be an absolute URL.
#   3. Every in-repo raw URL a START.md points at resolves to a file that actually exists.
#      This is what catches drift when a recipe file is renamed or removed.
#   4. START.md stays short enough to paste whole, because some chat surfaces cannot fetch
#      URLs at all and pasting the entry point is the only fallback.
#
set -uo pipefail

RAW_PREFIX="https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/"
# Soft ceiling. A START.md is a paste target, not a manual; past this it stops being one.
MAX_LINES=130

fail=0
checked=0

for recipe_dir in recipes/*/; do
  recipe=$(basename "$recipe_dir")

  # 1) Every recipe needs an entry point.
  start="${recipe_dir}START.md"
  if [ ! -f "$start" ]; then
    echo "::error::${recipe} has no START.md. Every recipe needs a URL entry point; see CONTRIBUTING.md."
    fail=1
    continue
  fi
  checked=$((checked + 1))

  # 2) No relative links. Any markdown link target that is not http(s) or an anchor is one.
  rel=$(grep -noE '\]\([^)]+\)' "$start" \
    | sed -E 's/\]\(/\t/; s/\)$//' \
    | awk -F'\t' '$2 !~ /^https?:\/\// && $2 !~ /^#/ { print $0 }' || true)
  if [ -n "$rel" ]; then
    echo "::error::${recipe}/START.md contains a relative link. It is read standalone over HTTP, so companions must be absolute URLs."
    printf '    line %s\n' $(echo "$rel" | cut -f1)
    fail=1
  fi

  # 3) Every in-repo raw URL must resolve to a real file.
  while read -r url; do
    [ -z "$url" ] && continue
    path="${url#"$RAW_PREFIX"}"
    if [ ! -f "$path" ]; then
      echo "::error::${recipe}/START.md points at a file that does not exist in this repo: ${path}"
      fail=1
    fi
  done < <(grep -oE "${RAW_PREFIX}[A-Za-z0-9._/-]+" "$start" | sed 's/[.,]$//' | sort -u)

  # 4) Keep it pasteable.
  lines=$(wc -l < "$start" | tr -d ' ')
  if [ "$lines" -gt "$MAX_LINES" ]; then
    echo "::error::${recipe}/START.md is ${lines} lines (limit ${MAX_LINES}). It must stay short enough to paste whole for agents that cannot fetch URLs. Move detail into constitution.md."
    fail=1
  fi
done

if [ "$checked" -eq 0 ]; then
  echo "::error::No recipes found to check. Run this from the repo root."
  exit 1
fi

if [ "$fail" -ne 0 ]; then
  echo "Recipe entry-point check FAILED."
  exit 1
fi
echo "Recipe entry-point check passed (${checked} recipes)."
