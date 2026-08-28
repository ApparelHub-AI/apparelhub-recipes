# Start here: First Run Setup

Takes an ApparelHub account from empty to one draft product, asking for exactly what is missing
and nothing else. This is the recipe to run before any other one.

## Run it

Paste one line into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md and follow it.

**If your agent cannot fetch URLs, paste this whole document instead.** This file is the entire
recipe. It needs no other file and no clone.

**Prerequisites:** an ApparelHub account and your agent connected to it, see
https://apparelhub.ai/agents. You do not need a store, a provider, a channel, or an account with
any provider yet. Sorting that out is the point of this recipe.

---

## Agent instructions

You are setting up an ApparelHub account that may be completely empty. You set up, you do not
operate. Work the phases in order and stop at the handoff.

### Always true

- **Never spend money.** Confirm no order to production. This recipe creates no orders.
- **Never publish live.** The one product you build syncs as `state: "draft"`, never `"live"`.
- **Never write a credential anywhere.** Tokens and API keys go straight to the connect tool and
  are then forgotten. Never into a file, a summary, or a message back to the operator.
- **One question at a time.** Never present a wall of setup questions.

### How to behave

**Read readiness first, and again after every change.** `check_setup_readiness` is authoritative,
read only, and safe to poll. It returns the three `ready_to_*` booleans, a per-store breakdown,
connectable `options` each marked `connect_mode` (`in_chat` or `browser`), plan `limits`, and an
ordered `next_steps` with `guidance`. When `next_steps` names the next action, take that one.

**Ask about the upstream account before you send anyone anywhere.** No account with that
provider, hand over the signup link and wait, so nobody discovers they have no account by staring
at an unexpected login screen.

**Re-dispatch on return.** When they come back from creating an account, you call
`start_channel_connect` again for a fresh link. Never send them to the web dashboard to restart.

**Poll, do not interrogate.** After handing over an authorization URL, poll
`check_connection_status` with the same `provider_uuid` every few seconds for about two minutes,
then announce the result: the tab they authorize in cannot report back here, so if you do not
tell them it worked, nobody does. `connected: false` means keep waiting. `needs_reconnect` means
retrying never works, so dispatch a fresh link.

**Wrong account is recoverable.** Once a connection lands, read back which upstream account or
shop attached and show it. If it is wrong, say so and dispatch a fresh link for the same provider,
which replaces the credential. Do not ask them to go undo anything.

**Plan limits are an answer, not an error.** If `limits.store.allowed` or a store's
`limits.integration.allowed` is false, the account is at its plan ceiling. Say so, give the
`upgrade_url`, and stop that phase cleanly. Do not retry or work around it.

### Phase 0: assess

Call `check_setup_readiness`. Say plainly what they already have and what is missing. **Ask for
nothing yet.** Then continue to the first phase that is not already satisfied.

### Phase 1: fulfillment

Goal: `ready_to_fulfill` is true. It comes before the store because `activate_store` requires a
connected provider.

1. Offer a choice from `options.fulfillment`. Already using a provider, offer that one. No
   provider accounts at all, prefer a `connect_mode: "in_chat"` one: it finishes without a browser.
2. Ask whether they have an account there. If not, hand over `credential_url` (or the provider's
   signup page), wait, and continue when they return.
3. A provider attaches to a store, so if there is no store yet call `create_store` with a name
   they give you. It starts `Closed`. That is expected and is not activation.
4. Connect. **In chat:** ask for the token, pointing at `credential_url` for where to generate it,
   then `connect_fulfillment_provider`. It validates before storing, so a bad token fails clean;
   if the token maps to several shops it asks you to pick one, so call again with `shop_id`.
   **Browser:** `start_channel_connect` with `kind: "fulfillment"`, omit `callback_url`, hand over
   the URL, then poll.
5. Re-read readiness to confirm `ready_to_fulfill` is now true.

### Phase 2: store

Goal: the target store's `status` is `Active`. Call `activate_store`. Confirm they are happy with
the name, since it is theirs to live with.

### Phase 3: sales channel

Goal: `ready_to_sell` is true, **or** they have explicitly chosen to be fulfillment-only for now.
Both are valid finished states; say so, so nobody feels stuck.

Same shape as phase 1: pick from `options.sales_channels`, ask about the upstream account first,
then either `connect_sales_channel` (in chat, for example WooCommerce with
`{ store_url, consumer_key, consumer_secret }` or Wix with `{ api_key, site_id }`) or
`start_channel_connect` with `kind: "sales_channel"` and poll. Shopify also needs `shop_url`, the
myshopify domain from their admin URL (for example `your-store.myshopify.com`), not their custom
storefront domain. Ask for it before calling.

### Phase 4: first product

One design, one product, as a draft. This proves the pipeline; it is not a catalog.

1. Ask what they want on it. One question, their subject.
2. `design_apparel` once. Image generation draws on a finite plan allowance, which on entry level
   plans is a **lifetime** one. Before regenerating, say plainly that it spends another of a
   limited number and let them choose.
3. `find_garments` or `browse_catalog` to pick a garment on their connected provider.
4. `ship_product` does the rest in one call. Sync to the connected channel as
   `sync_to_channels: [{ integration_uuid, state: "draft" }]`. With no channel connected, omit
   `sync_to_channels` entirely and leave the product unlisted.
5. The mockup must be photoreal and crisp. If it is a flat illustration or muddy, pick a different
   garment rather than shipping a bad preview.

### Handoff

Say plainly what now exists: an active store, a connected provider, a channel or a recorded
fulfillment-only decision, and one draft product that is not live and cost nothing. Then point
them at the next recipe and **stop**:

> https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/START.md

**Notes across sessions (optional).** If your agent has a working folder, record the phase
reached, the store, and which providers connected, so a later session resumes without re-asking.
A template is at
https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/state.template.json
Nothing is required, and **no token, key, or secret ever goes in it.** Readiness always wins over
your notes.
