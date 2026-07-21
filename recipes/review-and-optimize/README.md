# Recipe: Review and Optimize

Run a safe, read-mostly optimization pass over a store you already have on ApparelHub. Your agent
reads the analytics, flags underperformers, and applies only the changes that cannot harm the
store: archiving dead listings and correcting below-floor margins. Anything that changes what a
customer pays goes to a queue you approve. This is the safest recipe: it never creates products,
never publishes anything live, and never confirms a paid order.

Works in any agent runtime that can reach the ApparelHub connector: Claude Cowork, Claude Code,
or a custom harness.

## What you need
- An existing ApparelHub store with some sales history to read, a fulfillment provider connected
  (Printful / Printify / Gelato), and a sales channel (Shopify / WooCommerce / Wix).
- Agent access to ApparelHub: the hosted MCP connector, the local MCP server, or an Agent API
  key. See [apparelhub.ai/agents](https://apparelhub.ai/agents).

## Install
1. Copy this `review-and-optimize/` folder into your agent's working / mounted folder.
   (Copy it out of this repo so your filled-in state stays yours.)
2. Grant your agent **only** the ApparelHub connector (add Gmail if you want run-summary emails).
3. Run **`BOOTSTRAP-PROMPT.md`** once. Your agent discovers your account's anchors (workspace,
   store, channel, providers) and writes your own `state.json`. Read-only discovery plus one
   file write; nothing is built or changed.
4. Run **`KICKOFF-PROMPT.md`**. Your agent runs one optimization cycle: serves open orders,
   assesses the numbers, applies only safe changes, and queues everything else.

## How it runs
The full operating model is in **`constitution.md`**: the charter your agent reads at the start
of every run. In short, each run: Orient, Serve existing orders, Assess the analytics, Optimize
(archive-only plus below-floor margin fixes), queue discretionary reprices, Log. Run it weekly.

## Safety model (defaults)
- **Two hard gates, on by default:** publishing a listing LIVE, and confirming a paid order to
  production (real spend). Your agent queues these and never crosses them.
- **Archive-only autonomy:** `auto_optimize_listings` only ever archives (never deletes, never
  goes live), so its archive actions are applied autonomously after a dry run.
- **Below-floor margin fixes are autonomous; every discretionary reprice is queued.** Raising a
  negative or sub-floor price up to the margin floor is safe. Any other price change (for
  performance, promotions, or a bulk cascade) waits for your approval.
- **$0 autonomous spend**, and the agent never deletes a product.
- **Self-configuring:** no account data is hardcoded; your anchors live only in your local
  `state.json`.

## Files
| File | Role |
|---|---|
| `constitution.md` | The charter. Read every run. |
| `state.template.json` | Template; the bootstrap writes your real `state.json` from it. |
| `BOOTSTRAP-PROMPT.md` | Step 0: self-configure against your account. |
| `KICKOFF-PROMPT.md` | Run one optimization cycle, then repeat weekly. |
| `run-journal.md` | Append-only log of every run's findings. |
| `pending-approvals.md` | The gate queue for your sign-off, including queued reprices. |

## Phase
This recipe has one phase, **Optimize**: a recurring safe pass. It never builds a catalog and
never goes live. Manage phase by editing `phase` in `state.json`; the agent never changes it
itself.
