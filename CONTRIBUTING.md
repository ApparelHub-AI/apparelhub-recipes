# Contributing a recipe

A recipe is an operating blueprint an AI agent runs against a user's own ApparelHub account.
Keep recipes safe, generic, and self-configuring.

## What every recipe must include
- `START.md`: the URL entry point. See "Distribution is a URL" below; this is the file users are
  actually given.
- `README.md`: what it does, prerequisites, the one-line URL start, the clone path, safety model.
- A charter (`constitution.md` or similar) the agent reads at the start of every run.
- `state.template.json`: the state schema with anchors left null.
- `BOOTSTRAP-PROMPT.md`: a read-only discovery step that resolves the user's own anchors (via
  `list_my_workspaces` / `list_my_stores` / `list_catalog_providers`) and writes their `state.json`.
  A recipe that must tolerate an **empty** account reads `check_setup_readiness` instead, because
  there may be nothing to discover.
- `KICKOFF-PROMPT.md`: how to start it.
- Any memory files the charter references (journal, approvals queue, etc.), shipped as generic
  templates.

## Distribution is a URL, never a clone

A user must be able to start any recipe by pasting **one line** into a fresh chat. Asking someone
to clone a git repository before they can get help is a non-starter, so `START.md` is the entry
point and it has to survive being read on its own.

- **No relative links in `START.md`.** It is fetched over HTTP by an agent with no local copy, so
  "the file next to this one" does not exist. Every companion is an absolute URL under
  `https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/<recipe>/`.
- **It must also work pasted whole**, because some chat surfaces cannot fetch a URL at all. That
  puts a hard ceiling on length (CI enforces 130 lines) and is the reason to keep the prompt thin.
  Push branching logic into a platform readiness call rather than into the paste.
- **Carry the hard gates inline.** Restate the recipe's real gates in `START.md` so safety holds
  even when the agent could not fetch the charter. An agent that cannot fetch must say so and ask
  for the charter, never proceed silently without it.
- **State without a clone:** either fetch `state.template.json` by URL, or, for a short recipe,
  make state optional and say so.
- `scripts/check_recipe_entrypoints.sh` enforces all of this, including that every in-repo URL a
  `START.md` points at resolves to a file that actually exists.

## Rules
- **No account-specific data, ever.** No real workspace / store / provider ids, no real shop
  domains, no personal or business names. Use `<placeholders>` and discover real values at
  runtime in the bootstrap. Generic example hosts like `your-store.myshopify.com` are fine.
- **Self-configuring.** A recipe must run against any account without editing files by hand.
- **Gates on by default.** Anything that spends money or publishes live must be gated behind
  explicit user approval, not done autonomously.
- **Idempotent and never-stall.** Re-running must not duplicate work; a single blocked item must
  not halt a run.

- **Never store a credential.** Where a recipe takes a pasted token or API key, it hands it to the
  connect tool and forgets it. A credential never goes into `state.json`, a journal, an approvals
  queue, or any other file, not even masked or truncated.

## CI
Two checks run on every push / PR. Run both locally before opening a PR:

```bash
bash scripts/check_forbidden_patterns.sh    # no account data: uuids, real hosts, owner tokens
bash scripts/check_recipe_entrypoints.sh    # START.md is self-contained and stays pasteable
```

## Test
Both paths, because they can break independently:

- **URL path (the one users take):** paste the recipe's start line into a fresh chat with an
  agent that has the ApparelHub connector, and confirm it fetches, configures itself, and stops
  at the gates without any local copy of this repo.
- **Clone path:** copy the folder into an agent's working folder and run bootstrap then kickoff.

Also try the no-fetch case at least once: paste `START.md` whole into a surface that cannot fetch
URLs, and confirm the agent still respects the gates and says plainly what it cannot reach.
