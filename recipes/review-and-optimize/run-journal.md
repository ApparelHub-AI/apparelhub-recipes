# Run Journal

Append-only. One findings entry per optimization run. Newest at the bottom. Never rewrite past
entries.

---

## Run 0: Setup (template)

- **What:** Initialized this store's optimization folder from the `review-and-optimize` recipe,
  and ran the bootstrap to discover account anchors and write `state.json`.
- **Phase:** `optimize`: ready to run the first safe cycle.
- **Gates:** money + go-live closed. `$0` autonomous spend. Archive-only and below-floor margin
  fixes are autonomous; every discretionary reprice is queued.
- **Thresholds:** `no_sales_days = 30`, `lookback_days = 90`, `margin_floor_pct = 40`.
- **Next:** run `KICKOFF-PROMPT.md` → serve open orders → assess analytics → apply safe fixes →
  queue reprices → log.

---
