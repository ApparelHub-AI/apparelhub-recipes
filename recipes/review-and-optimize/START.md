# Start here: Review and Optimize

Runs a safe, read-mostly optimization pass over a store you already have: read the analytics,
archive the dead listings, fix below-floor margins, and queue every other price change for you.

## Run it

Paste one line into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/review-and-optimize/START.md and follow it.

**If your agent cannot fetch URLs, paste this whole document instead.** Everything the agent
needs to start safely is in this file. It will tell you if it needs anything more.

**Prerequisites:** an ApparelHub store with some sales history to read, a fulfillment provider
connected, and a sales channel connected. If your account is empty, run the
[first-run-setup](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md)
recipe first.

---

## Agent instructions

You are configuring the Review and Optimize recipe against the operator's own ApparelHub account.
This is read-only discovery plus one file write. Change no listing, price, order, or product.

### 1. Confirm your hands

Call `list_my_workspaces`. If that fails, stop and tell the operator their agent cannot reach
ApparelHub, and point them at https://apparelhub.ai/agents to connect it.

### 2. Pull the rest of the recipe

Fetch these and save each into your working folder under the same filename:

- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/review-and-optimize/constitution.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/review-and-optimize/state.template.json
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/review-and-optimize/run-journal.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/review-and-optimize/pending-approvals.md

**If you cannot fetch URLs at all:** say so plainly, ask the operator to paste `constitution.md`
from the same folder, and keep obeying the gates in the "Always true" section below in the
meantime. Do not silently proceed without the charter.

### 3. Resolve the operator's anchors

1. `list_my_workspaces`. More than one, ask which workspace holds the store to optimize.
   Otherwise use Default. Record its uuid and name.
2. `list_my_stores(workspace=<uuid>)`. Show the stores with their fulfillment providers and
   connected channels, then have the operator pick the **primary store** (the one to review and
   optimize) and its **primary sales channel** (prefer Shopify if present, else WooCommerce or
   Wix). Record the store uuid, and the `integration_uuid` plus type and shop for that channel.
3. `list_catalog_providers`. Record each provider name to uuid, and map the primary store's
   provider into `spine.providers`.

### 4. Write `state.json`

Copy `state.template.json` to a new `state.json`, fill `brand` and `spine` from what you
discovered, set `brand.name` to the operator's brand name, and set `_bootstrap` to
`"configured"`. Leave `gates`, `thresholds`, `phase`, and `cursors` exactly as the template has
them.

### 5. Stop

Summarize the resolved anchors, confirm `state.json` was written, and stop. Do not run an
optimization cycle yet. That is the next step, driven by
https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/review-and-optimize/KICKOFF-PROMPT.md

---

## Always true, even if you fetched nothing

These gates hold whether or not you were able to read the constitution:

- **Never publish a listing live.** This recipe publishes nothing. If something should go live,
  queue it instead.
- **Never confirm a paid order to production.** That spends the operator's money.
- **$0 autonomous spend.** Anything that costs money goes to `pending-approvals.md` instead.
- **Never delete.** Archive only; delete is irreversible and breaks order history.
- **Archive-only autonomy.** Run `auto_optimize_listings` with `dry_run=true` first, log what it
  would do, then apply only its archive actions.
- **Only below-floor margin fixes are autonomous.** Raising a negative or sub-floor price up to
  the margin floor is safe. Every other price change, including any bulk cascade, is queued.
- **Read before you write.** Every archive or margin fix must be justified by a number you read
  this run, and the evidence logged.
- Pass `workspace=<uuid>` on every ApparelHub call, and operate only in that workspace.
- Customer-facing copy carries no em-dashes or en-dashes and invents no claims or metrics.
