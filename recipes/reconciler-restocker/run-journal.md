# Run Journal

Append-only. One entry per reconcile run. Newest at the bottom. Never rewrite past entries.

---

## Run 0: Setup (template)

- **What:** Initialized this catalog's operating folder from the `reconciler-restocker` recipe,
  and ran the bootstrap to discover account anchors and write `state.json`.
- **Phase:** `reconcile`: ready for Phase 1 (presence-check the target catalog, rebuild missing
  targets as drafts).
- **Gates:** money + go-live closed. `$0` autonomous spend. `never_delete = true`.
  `max_products_per_run = 2`.
- **Targets:** waiting on `target-catalog.md` to be filled with the products to keep present.
- **Next:** fill `target-catalog.md`, then run `KICKOFF-PROMPT.md` → reconcile → rebuild missing
  targets as drafts → stop for review.

---
