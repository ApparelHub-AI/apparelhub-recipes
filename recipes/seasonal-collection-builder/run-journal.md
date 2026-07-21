# Run Journal

Append-only. One entry per autonomous run. Newest at the bottom. Never rewrite past entries.

---

## Run 0: Setup (template)

- **What:** Initialized this collection's operating folder from the `seasonal-collection-builder`
  recipe, and ran the bootstrap to discover account anchors and write `state.json`.
- **Status:** `setup`: ready to create the collection on the first kickoff run.
- **Gates:** money + go-live closed. `$0` autonomous spend. `max_products_per_run = 2`.
- **Next:** fill `collection-brief.md` (theme, deadline, target count) → run `KICKOFF-PROMPT.md`
  → agent creates the collection, builds DRAFT products up to the target, stops for go-live
  approval.

---
