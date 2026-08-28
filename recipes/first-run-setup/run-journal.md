# Run Journal

Append-only. One entry per setup run. Newest at the bottom. Never rewrite past entries.

**Never record a token, API key, or any other credential here.** Record that a provider is
connected and its name, nothing more.

---

## Run 0: Setup (template)

- **What:** Initialized this folder from the `first-run-setup` recipe, and ran the bootstrap to
  read account readiness and write `state.json`.
- **Phase:** `0_assess`.
- **Account state:** (what readiness reported: what exists, what is missing)
- **Next:** run `KICKOFF-PROMPT.md` to work the first unsatisfied phase.

---

Format for later entries:

```
## Run N: <phase worked>: <date>

- **Phase:** `1_fulfillment` → `2_store`
- **Asked for:** the one thing requested this run
- **Result:** what readiness reported afterwards
- **Blocked by:** plan limit / awaiting an upstream account / none
- **Next:** the single next action
```
