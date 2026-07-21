# Target Catalog

This is the desired-state spec: the products you want kept present in your store. **You own this
file.** Each run, the agent presence-checks every filled row by its exact **Product name** in
`list_my_products(store)` and rebuilds anything missing as a DRAFT. The agent never removes a
product on its own, so this file is the only place you add or retire targets.

How to use it:
- **Add a target:** add a row. It gets built (as a draft) on an upcoming run.
- **Force a rebuild:** delete the product in your store. Its row reads missing next run and it is
  rebuilt from the fixed pipeline. (Deleting is the rebuild signal.)
- **Retire a target for good:** remove its row here. The agent leaves any existing product alone
  and simply stops treating it as a target.

Column notes:
- **Product name (exact):** must match the built product's name character for character, so
  presence-checks stay reliable. No em-dashes or en-dashes (they become public copy).
- **Garment:** the provider plus the catalog product reference, for example
  `Printful / <product_ref>`. Use `get_garment_details` or `browse_catalog` to find the ref.
- **Design:** either an existing `design_uuid` to reuse, or a short prompt the agent generates
  from (`design_apparel` / `generate_image` + `process_transparency`).
- **Price:** your retail price. Keep it at or above your margin floor; a sub-floor price is built
  but queued rather than taken live.
- **Notes:** theme grouping (rows in the same theme are finished before the next theme starts),
  variants, or anything the agent should honor.

| # | Product name (exact) | Garment (provider + product_ref) | Design (prompt or design_uuid) | Price | Notes |
|---|---|---|---|---|---|
| 1 | <exact product name> | <provider> / <product_ref> | <prompt, or design_uuid=<uuid>> | <price> | <theme / variants / notes> |
| 2 | <exact product name> | <provider> / <product_ref> | <prompt, or design_uuid=<uuid>> | <price> | <theme / variants / notes> |
| 3 | <exact product name> | <provider> / <product_ref> | <prompt, or design_uuid=<uuid>> | <price> | <theme / variants / notes> |
