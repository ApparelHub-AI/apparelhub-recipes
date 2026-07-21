# Contributing a recipe

A recipe is an operating blueprint an AI agent runs against a user's own ApparelHub account.
Keep recipes safe, generic, and self-configuring.

## What every recipe must include
- `README.md`: what it does, prerequisites, install (copy, bootstrap, kickoff), safety model.
- A charter (`constitution.md` or similar) the agent reads at the start of every run.
- `state.template.json`: the state schema with anchors left null.
- `BOOTSTRAP-PROMPT.md`: a read-only discovery step that resolves the user's own anchors (via
  `list_my_workspaces` / `list_my_stores` / `list_catalog_providers`) and writes their `state.json`.
- `KICKOFF-PROMPT.md`: how to start it.
- Any memory files the charter references (journal, approvals queue, etc.), shipped as generic
  templates.

## Rules
- **No account-specific data, ever.** No real workspace / store / provider ids, no real shop
  domains, no personal or business names. Use `<placeholders>` and discover real values at
  runtime in the bootstrap. Generic example hosts like `your-store.myshopify.com` are fine.
- **Self-configuring.** A recipe must run against any account without editing files by hand.
- **Gates on by default.** Anything that spends money or publishes live must be gated behind
  explicit user approval, not done autonomously.
- **Idempotent and never-stall.** Re-running must not duplicate work; a single blocked item must
  not halt a run.

## CI
`scripts/check_forbidden_patterns.sh` runs on every push / PR. It fails on any embedded uuid and
on a maintainer-configured token list (the `FORBIDDEN_TERMS` repo secret). Run it locally before
opening a PR:

```bash
bash scripts/check_forbidden_patterns.sh
```

## Test
Copy your recipe folder somewhere, point an agent with the ApparelHub connector at it, and run
bootstrap then kickoff end to end. Confirm it configures itself and stops at the gates.
