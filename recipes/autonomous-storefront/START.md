# Start here: Autonomous Storefront

Runs a whole custom-merch store end to end from your own AI agent: design, build, list, serve
orders, optimize. It stops at the two gates you control (publishing live, and spending money).

## Run it

Paste one line into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/START.md and follow it.

**If your agent cannot fetch URLs, paste this whole document instead.** Everything the agent
needs to start safely is in this file. It will tell you if it needs anything more.

**Prerequisites:** an ApparelHub account with a fulfillment provider and a sales channel already
connected. If your account is empty, run the
[first-run-setup](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md)
recipe first.

---

## Agent instructions

You are configuring the Autonomous Storefront recipe against the operator's own ApparelHub
account. This is read-only discovery plus one file write. Create no designs, products, or orders.

### 1. Confirm your hands

Call `list_my_workspaces`. If that fails, stop and tell the operator their agent cannot reach
ApparelHub, and point them at https://apparelhub.ai/agents to connect it.

### 2. Pull the rest of the recipe

Fetch these and save each into your working folder under the same filename:

- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/constitution.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/state.template.json
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/niche-brief.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/run-journal.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/pending-approvals.md

**If you cannot fetch URLs at all:** say so plainly, ask the operator to paste `constitution.md`
from the same folder, and keep obeying the gates in the "Always true" section below in the
meantime. Do not silently proceed without the charter.

### 3. Resolve the operator's anchors

1. `list_my_workspaces`. More than one, ask which workspace this store runs in. Otherwise use Default.
2. `list_my_stores(workspace=<uuid>)`. Show the stores with their fulfillment providers and
   connected channels, then have the operator pick the **primary store**, its **primary sales
   channel** (prefer Shopify if present, else WooCommerce or Wix), and an optional backup channel.
3. `list_catalog_providers`. Record each provider name to uuid.

### 4. Write `state.json`

Copy `state.template.json` to a new `state.json`, fill `brand`, `spine`, and `spine.providers`
from what you discovered, set `brand.name` to the operator's brand name, and set `_bootstrap` to
`"configured"`. Leave `gates`, `phase`, `cursors`, and `catalog` exactly as the template has them.

### 5. Stop

Summarize the resolved anchors, confirm `state.json` was written, and stop. Niche validation and
building are the next step, driven by
https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/KICKOFF-PROMPT.md

---

## Always true, even if you fetched nothing

These gates hold whether or not you were able to read the constitution:

- **Never publish a listing live.** Sync to sales channels as `state: "draft"` only.
- **Never confirm a paid order to production.** That spends the operator's money.
- **$0 autonomous spend.** Anything that costs money goes to `pending-approvals.md` instead.
- **Never delete.** Archive instead; delete is irreversible and breaks order history.
- Pass `workspace=<uuid>` on every ApparelHub call, and operate only in that workspace.
- Customer-facing copy carries no em-dashes or en-dashes and invents no claims or metrics.
