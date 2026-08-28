# Start here: Reconciler Restocker

Keeps a target catalog present. You list the products you want in `target-catalog.md`, your agent
checks each run which ones exist, rebuilds anything missing as a draft, and never removes anything.

## Run it

Paste one line into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/START.md and follow it.

**If your agent cannot fetch URLs, paste this whole document instead.** Everything the agent
needs to start safely is in this file. It will tell you if it needs anything more.

**Prerequisites:** an ApparelHub account with a fulfillment provider and a sales channel already
connected on the store you want kept stocked. If your account is empty, run the
[first-run-setup](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md)
recipe first.

---

## Agent instructions

You are configuring the Reconciler Restocker recipe against the operator's own ApparelHub account.
This is read-only discovery plus one file write. Create no designs, products, or orders. Do not
presence-check or reconcile anything yet.

### 1. Confirm your hands

Call `list_my_workspaces`. If that fails, stop and tell the operator their agent cannot reach
ApparelHub, and point them at https://apparelhub.ai/agents to connect it.

### 2. Pull the rest of the recipe

Fetch these and save each into your working folder under the same filename:

- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/constitution.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/state.template.json
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/target-catalog.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/run-journal.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/pending-approvals.md

**If you cannot fetch URLs at all:** say so plainly, ask the operator to paste `constitution.md`
from the same folder, and keep obeying the gates in the "Always true" section below in the
meantime. Do not silently proceed without the charter.

### 3. Resolve the operator's anchors

1. `list_my_workspaces`. More than one, ask which workspace this catalog runs in. Otherwise use Default.
2. `list_my_stores(workspace=<uuid>)`. Show the stores with their fulfillment providers and
   connected channels, then have the operator pick the **primary store** (the one whose catalog you
   keep in sync), its **primary sales channel** (prefer Shopify if present, else WooCommerce or
   Wix), and an optional backup channel. Record the store uuid, and the `integration_uuid` plus
   type and shop for each chosen channel.
3. `list_catalog_providers`. Record each provider name to uuid. Map the primary store's provider,
   and keep any others the operator has stores on under `secondary_stores`.

### 4. Write `state.json`

Copy `state.template.json` to a new `state.json`, fill `brand`, `spine`, and `spine.providers`
from what you discovered, set `brand.name` to the operator's brand name, and set `_bootstrap` to
`"configured"`. Leave `gates`, `phase`, `cursors`, and `catalog` exactly as the template has them.

### 5. Stop

Summarize the resolved anchors and confirm `state.json` was written. Then tell the operator to fill
`target-catalog.md` with the products they want kept present, name, garment, design, and price,
**before** the first reconcile run. Stop. Reconciling and rebuilding are the next step, driven by
https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/KICKOFF-PROMPT.md

---

## Always true, even if you fetched nothing

These gates hold whether or not you were able to read the constitution:

- **Never publish a listing live.** Sync to sales channels as `state: "draft"` only.
- **Never confirm a paid order to production.** That spends the operator's money.
- **$0 autonomous spend.** Anything that costs money goes to `pending-approvals.md` instead.
- **Never remove anything.** The operator owns removals; archive rather than delete, because delete
  is irreversible and breaks order history.
- **Rebuild only what is missing.** Presence-check by exact product name first, and never exceed
  `state.gates.max_products_per_run` rebuilds in one run.
- **Blocked counts as done for the run.** Log it, move on, retry it later. One blocker never stalls
  a run.
- Pass `workspace=<uuid>` on every ApparelHub call, and operate only in that workspace.
- Customer-facing copy carries no em-dashes or en-dashes and invents no claims or metrics.
