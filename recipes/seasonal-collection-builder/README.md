# Recipe: Seasonal Collection Builder

Build a time-boxed themed collection from your own AI agent. Your agent designs on-theme products,
drafts listings, groups them in one collection, monitors orders while it sells, and then retires
the collection on a deadline, pausing only at the two money / go-live gates you control.

Works in any agent runtime that can reach the ApparelHub connector: Claude Cowork, Claude Code,
or a custom harness.

## Start it with one line

Paste this into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/seasonal-collection-builder/START.md and follow it.

If your agent cannot fetch URLs, open
[`START.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/seasonal-collection-builder/START.md)
and paste the whole thing instead. It carries everything the agent needs to start safely, and it
needs no clone.

Once it has written your `state.json`, fill **`collection-brief.md`** (theme, deadline, target
count) and set its `STATUS` to `READY`, then run
[`KICKOFF-PROMPT.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/seasonal-collection-builder/KICKOFF-PROMPT.md).
Your agent creates the collection, builds on-theme DRAFT products up to your target, groups them,
and stops for your go-live approval.

## What you need
- An ApparelHub account with at least one fulfillment provider connected (Printful / Printify /
  Gelato) and a sales channel (Shopify / WooCommerce / Wix) on the store you want to run.
- Agent access to ApparelHub: the hosted MCP connector, the local MCP server, or an Agent API
  key. See [apparelhub.ai/agents](https://apparelhub.ai/agents).

## How it runs
The full operating model is in **`constitution.md`**: the charter your agent reads at the start
of every run. In short, each run: Orient, Serve existing orders, then act by lifecycle status,
Assess, queue gated decisions, Log. The collection moves through
`setup → building → ready → live → retiring → retired`.

## The lifecycle
| Status | What your agent does |
|---|---|
| `setup` | Creates the collection, records its uuid, moves to `building`. |
| `building` | Ships on-theme DRAFT products up to your target count, groups them in the collection. |
| `ready` | Queues the full DRAFT collection for one go-live approval; monitors meanwhile. |
| `live` | You approved it. Monitors and serves orders. Watches the deadline. |
| `retiring` | Past the deadline. Archives DRAFT products; queues any live-product retirements. |
| `retired` | Everything retired. The collection is done. |

## Safety model (defaults)
- **Two hard gates, on by default:** publishing the collection LIVE, and confirming a paid order
  to production (real spend). Your agent queues these to `pending-approvals.md` and never crosses
  them autonomously.
- **Retiring is scoped:** archiving a DRAFT product (never published, no orders) is autonomous and
  reversible with `restore_product`; retiring a LIVE product, or archiving anything blocked by
  pending orders, is queued for your approval.
- **$0 autonomous spend**, a margin floor, a photoreal-mockup quality gate, and bounded creation
  per run.
- **Self-configuring:** no account data is hardcoded; your anchors live only in your local
  `state.json`.

## Running it from a clone (advanced)

The one-line URL above is the supported path. If you would rather keep the files locally:

1. Copy this `seasonal-collection-builder/` folder into your agent's working / mounted folder.
   (Copy it out of this repo so your filled-in state stays yours.)
2. Grant your agent **only** the ApparelHub connector (add Gmail if you want run-summary emails).
3. Run **`BOOTSTRAP-PROMPT.md`** once. Your agent discovers your account's anchors (workspace,
   store, channels, providers) and writes your own `state.json`. Read-only discovery plus one
   file write; nothing is built.
4. Fill **`collection-brief.md`**: the theme, the deadline, and how many products you want. Set
   `STATUS: READY` at the top when it is done.
5. Run **`KICKOFF-PROMPT.md`**. Your agent creates the collection, builds on-theme DRAFT products
   up to your target, groups them, and stops for your go-live approval.

## Files
| File | Role |
|---|---|
| `START.md` | The one-line URL entry point. Self-contained; needs no clone. |
| `constitution.md` | The charter. Read every run. |
| `state.template.json` | Template; the bootstrap writes your real `state.json` from it. |
| `BOOTSTRAP-PROMPT.md` | Step 0: self-configure against your account. |
| `KICKOFF-PROMPT.md` | Create the collection and run normal runs. |
| `collection-brief.md` | The theme, deadline, target, and launch concepts you fill in. |
| `run-journal.md` | Append-only log of every run. |
| `pending-approvals.md` | The gate queue for your sign-off. |
