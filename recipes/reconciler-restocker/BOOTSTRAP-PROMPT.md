# Bootstrap prompt: run this ONCE, first

> Prereq: your agent can reach the ApparelHub connector, and this recipe folder is its
> working / mounted folder. Paste the block below into your agent.

---

You are configuring the Reconciler Restocker recipe for my ApparelHub account. This is a
read-only discovery step plus a single file write. Do NOT create any designs, products, or
orders.

1. Read `constitution.md` and `state.template.json`.
2. Call `list_my_workspaces`. If I have more than one, ask me which workspace this catalog should
   run in (otherwise use Default). Record its uuid + name.
3. Call `list_my_stores(workspace=<that uuid>)`. Show me the stores with their fulfillment
   providers and connected sales channels, then help me pick:
   - the **primary store** (the one whose catalog you keep in sync),
   - its **primary sales channel** (prefer Shopify if present, else WooCommerce / Wix),
   - an optional **backup channel**.
   Record the store uuid, and the `integration_uuid` + type + shop for each chosen channel.
4. Call `list_catalog_providers`. Record each provider's name to uuid. Map the primary store's
   provider, and keep any others I have stores on under `secondary_stores`.
5. Write a new file `state.json` in this folder, copied from `state.template.json`, with
   `brand`, `spine`, and `spine.providers` filled from what you discovered, `brand.name` set to
   my brand name, and `_bootstrap` set to `"configured"`. Leave `gates`, `phase`, `cursors`, and
   `catalog` exactly as the template has them.
6. Show me a short summary of the resolved anchors and confirm `state.json` was written. Then
   remind me to fill `target-catalog.md` with the products I want kept present **before** the
   first kickoff. Stop.

Do NOT reconcile, presence-check, or build anything, that is a separate step
(`KICKOFF-PROMPT.md`), and it needs `target-catalog.md` filled first.
