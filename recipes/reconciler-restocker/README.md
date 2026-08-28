# Recipe: Reconciler Restocker

Keep a target catalog present. You define the products you want in `target-catalog.md`; your AI
agent checks each run which ones already exist, rebuilds anything missing as a DRAFT, and never
removes anything. Delete a product and it comes back next run through the same fixed pipeline. Your
agent pauses only at the two money / go-live gates you control.

This is the desired-state reconciler pattern: idempotent, one theme finished before the next, a
blocked target counted done for the run and retried later, and a run that never stalls.

Works in any agent runtime that can reach the ApparelHub connector: Claude Cowork, Claude Code,
or a custom harness.

## Start it with one line

Paste this into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/START.md and follow it.

If your agent cannot fetch URLs, open
[`START.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/START.md)
and paste the whole thing instead. It carries everything the agent needs to start safely, and it
needs no clone.

After it configures your account anchors, fill `target-catalog.md` with the products you want kept
present, then run
[`KICKOFF-PROMPT.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/KICKOFF-PROMPT.md)
to start reconciling.

## What you need
- An ApparelHub account with at least one fulfillment provider connected (Printful / Printify /
  Gelato) and a sales channel (Shopify / WooCommerce / Wix) on the store you want to keep stocked.
- Agent access to ApparelHub: the hosted MCP connector, the local MCP server, or an Agent API
  key. See [apparelhub.ai/agents](https://apparelhub.ai/agents).

## Running it from a clone (advanced)

The one-line URL above is the supported path. If you would rather keep the files locally:

1. Copy this `reconciler-restocker/` folder into your agent's working / mounted folder.
   (Copy it out of this repo so your filled-in state stays yours.)
2. Grant your agent **only** the ApparelHub connector (add Gmail if you want run-summary emails).
3. Run **`BOOTSTRAP-PROMPT.md`** once. Your agent discovers your account's anchors (workspace,
   store, channels, providers) and writes your own `state.json`. Read-only discovery plus one
   file write; nothing is built.
4. Fill **`target-catalog.md`** with the products you want kept present (name, garment, design,
   price).
5. Run **`KICKOFF-PROMPT.md`**. Phase 1 begins: your agent reconciles the target catalog and
   rebuilds any missing targets as DRAFTs.

## How it runs
The full operating model is in **`constitution.md`**: the charter your agent reads at the start
of every run. In short, each run: Orient, Serve existing orders, Reconcile (presence-check every
target and rebuild up to N missing ones as DRAFTs), queue gated decisions, Log.

## Forcing a rebuild
Deleting a product is the rebuild signal. Remove it from your store and the next run sees its
target as missing and rebuilds it from the fixed pipeline. To retire a product for good, remove
its row from `target-catalog.md` (the agent never removes products on its own).

## Safety model (defaults)
- **Two hard gates, on by default:** publishing a listing LIVE, and confirming a paid order to
  production (real spend). Your agent queues these to `pending-approvals.md` and never crosses
  them autonomously.
- **$0 autonomous spend**, a margin floor, a photoreal-mockup quality gate, and a bounded number
  of rebuilds per run.
- **Never removes anything.** The agent only ever rebuilds missing targets; you own removals.
- **Self-configuring:** no account data is hardcoded; your anchors live only in your local
  `state.json`.

## Files
| File | Role |
|---|---|
| `START.md` | The one-line URL entry point. Self-contained; needs no clone. |
| `constitution.md` | The charter. Read every run. |
| `state.template.json` | Template; the bootstrap writes your real `state.json` from it. |
| `BOOTSTRAP-PROMPT.md` | Step 0: self-configure against your account. |
| `target-catalog.md` | The desired-state spec: the products you want kept present. You fill it. |
| `KICKOFF-PROMPT.md` | Start Phase 1 (reconcile to draft) and normal runs. |
| `run-journal.md` | Append-only log of every run. |
| `pending-approvals.md` | The gate queue for your sign-off. |

## Phases
1. **Reconcile to draft (default):** presence-check the target catalog and rebuild missing targets
   as DRAFTs over as many runs as it takes.
2. **Go live:** you approve drafts live; the reconciler keeps the target set present and reprices
   (paid-order confirmation stays gated).
3. **Steady state:** the reconciler idles when everything is present and rebuilds only what you
   delete or newly add to `target-catalog.md`.

Advance phases by editing `phase` in `state.json`. The agent never advances phases itself.
