# Recipe: Autonomous Storefront

Run a custom-merch store end to end from your own AI agent. Your agent designs, builds products,
drafts listings, monitors orders, reconciles fulfillment, and optimizes, pausing only at the two
money / go-live gates you control.

Works in any agent runtime that can reach the ApparelHub connector: Claude Cowork, Claude Code,
or a custom harness.

## Start it with one line

Paste this into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/START.md and follow it.

Your agent fetches the recipe, discovers your account's anchors, and writes its own `state.json`.
Then run the kickoff it points you at to begin Phase 1.

If your agent cannot fetch URLs, open
[`START.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/START.md)
and paste the whole thing instead.

## What you need
- An ApparelHub account with at least one fulfillment provider connected (Printful / Printify /
  Gelato) and a sales channel (Shopify / WooCommerce / Wix) on the store you want to run. If your
  account is empty, run [`first-run-setup`](../first-run-setup/) first.
- Agent access to ApparelHub: the hosted MCP connector, the local MCP server, or an Agent API
  key. See [apparelhub.ai/agents](https://apparelhub.ai/agents).

## Running it from a clone (advanced)

The one-line URL above is the supported path. Clone instead if you want to edit the charter or
keep your state in version control.

1. Copy this `autonomous-storefront/` folder into your agent's working / mounted folder.
   (Copy it out of this repo so your filled-in state stays yours.)
2. Grant your agent **only** the ApparelHub connector (add Gmail if you want run-summary emails).
3. Run **`BOOTSTRAP-PROMPT.md`** once. Your agent discovers your account's anchors (workspace,
   store, channels, providers) and writes your own `state.json`. Read-only discovery plus one
   file write; nothing is built.
4. Run **`KICKOFF-PROMPT.md`**. Phase 1 begins: your agent validates a niche, fills
   `niche-brief.md`, and stops for your approval.

## How it runs
The full operating model is in **`constitution.md`**: the charter your agent reads at the start
of every run. In short, each run: Orient, Serve existing orders, Assess, Optimize, Create up to
N DRAFT products, queue gated decisions, Log.

## Safety model (defaults)
- **Two hard gates, on by default:** publishing a listing LIVE, and confirming a paid order to
  production (real spend). Your agent queues these to `pending-approvals.md` and never crosses
  them autonomously.
- **$0 autonomous spend**, a margin floor, a photoreal-mockup quality gate, and bounded creation
  per run.
- **Self-configuring:** no account data is hardcoded; your anchors live only in your local
  `state.json`.

## Files
| File | Role |
|---|---|
| `START.md` | The one-line URL entry point. Self-contained; works with no clone. |
| `constitution.md` | The charter. Read every run. |
| `state.template.json` | Template; the bootstrap writes your real `state.json` from it. |
| `BOOTSTRAP-PROMPT.md` | Step 0: self-configure against your account. |
| `KICKOFF-PROMPT.md` | Start Phase 1 (niche validation) and normal runs. |
| `niche-brief.md` | The niche the agent validates, then you approve. |
| `run-journal.md` | Append-only log of every run. |
| `pending-approvals.md` | The gate queue for your sign-off. |

## Phases
1. **Draft catalog (default):** validate niche, ship ~6 to 10 DRAFT products. Prove the loop.
2. **Go live:** you approve the first batch; real selling begins (paid-order confirmation stays gated).
3. **Steady state:** self-optimizing loop; you review the journal + queue on your rhythm.

Advance phases by editing `phase` in `state.json`. The agent never advances phases itself.
