# Recipe: First Run Setup

Phase zero. Takes an ApparelHub account from empty to **one draft product**, asking for exactly
what is missing and nothing else, then hands off to a recipe that runs the store.

Every other recipe in this repo assumes your account is already set up. This is the one that does
the setting up, so it is the only recipe that works against an account with no stores, no
fulfillment provider, and no sales channel.

Works in any agent runtime that can reach the ApparelHub connector: Claude Cowork, Claude Code,
or a custom harness.

## Start it with one line

Paste this into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md and follow it.

If your agent cannot fetch URLs, open
[`START.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md)
and paste the whole thing instead. It is the entire recipe in one file, and it needs no clone.

## What you need

- An ApparelHub account, and your agent connected to it. See
  [apparelhub.ai/agents](https://apparelhub.ai/agents).
- That is all. You do **not** need a store, a fulfillment provider, a sales channel, or an
  account with any provider yet. Sorting that out is what this recipe is for.

## What it does

| Phase | Goal |
|---|---|
| `0_assess` | Reads your account's readiness and tells you plainly what exists and what is missing. Asks nothing. |
| `1_fulfillment` | Gets one fulfillment provider connected. Prefers one that finishes in chat if you have no provider accounts yet. |
| `2_store` | Creates and activates your store. |
| `3_channel` | Connects a sales channel, or records that you are fulfillment-only for now. |
| `4_first_product` | One design, one product, as a draft. |
| `handoff` | Points you at the next recipe and stops. |

Four of the seven connectable providers finish entirely in chat with a pasted token. The other
three need a browser step, and the agent hands you a link and then polls for it rather than
asking you whether it worked.

## What it will not do to you

- **Never spends money.** No order is confirmed to production. This recipe creates no orders.
- **Never publishes live.** Your first product is a draft.
- **Never asks twice.** One question at a time, driven by what the platform reports is actually
  missing.
- **Never sends you backwards.** Leave to create a provider account, come back, and the agent
  issues a fresh authorization link. You never return to the web dashboard to restart a flow.
- **Never stores your credentials.** A pasted token goes straight to the connect tool and is then
  forgotten. It is never written to `state.json`, the journal, or any other file.

If your plan will not allow another store or another connection, that is reported plainly with
the upgrade link and the phase stops cleanly. It is an answer, not an error.

## Running it from a clone (advanced)

The one-line URL above is the supported path. If you would rather keep the files locally:

1. Copy this `first-run-setup/` folder into your agent's working / mounted folder.
2. Run **`BOOTSTRAP-PROMPT.md`** once. It reads readiness and writes your `state.json`. Unlike
   every other recipe here, it assumes nothing exists.
3. Run **`KICKOFF-PROMPT.md`**. You can run it repeatedly; it resumes from whatever phase
   `state.json` records, so leaving and coming back later is a supported path.

## Files

| File | Role |
|---|---|
| `START.md` | The one-line URL entry point. Self-contained; the whole recipe in one pasteable file. |
| `constitution.md` | The charter. Read every run. |
| `state.template.json` | Template; the bootstrap writes your real `state.json` from it. |
| `BOOTSTRAP-PROMPT.md` | Step 0: readiness-driven assessment. |
| `KICKOFF-PROMPT.md` | Works the phase machine. Re-runnable. |
| `run-journal.md` | Append-only log of every run. |
| `pending-approvals.md` | Plan limits and decisions only you can make. |

## After the handoff

Setup is done when you have an Active store with fulfillment connected, a sales channel connected
(or fulfillment-only recorded as your choice), and one draft product that is not live and cost you
nothing.

From there, run [`autonomous-storefront`](../autonomous-storefront/) to operate the store, or pick
another recipe from the [repo index](../../README.md).
