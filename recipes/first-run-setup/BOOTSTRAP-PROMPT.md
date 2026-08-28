# Bootstrap prompt: run this ONCE, first

> Prereq: your agent can reach the ApparelHub connector, and this recipe folder is its
> working / mounted folder. Paste the block below into your agent.
>
> Unlike every other recipe in this repo, this bootstrap does **not** assume your account already
> has anything. It reads readiness rather than discovering stores, so it works against a
> completely empty account.

---

You are configuring the First Run Setup recipe for my ApparelHub account. This is a read-only
assessment plus a single file write. Do NOT connect anything, create a store, or build a product
yet.

1. Read `constitution.md` and `state.template.json`.
2. Call `list_my_workspaces`. If I have more than one, ask which workspace to set up (otherwise
   use Default). Record its uuid.
3. Call `check_setup_readiness` for that workspace. This is the authoritative view and is read
   only. Note `ready_to_design`, `ready_to_fulfill`, `ready_to_sell`, the `stores[]` breakdown,
   the connectable `options`, the plan `limits`, and the ordered `next_steps` with its `guidance`.
4. Write a new file `state.json` in this folder, copied from `state.template.json`, with
   `workspace_uuid` set, anything readiness already shows as connected filled in, `phase` set to
   the first phase that is not already satisfied, and `_bootstrap` set to `"configured"`.
   Leave `gates` exactly as the template has them.
5. **Report phase `0_assess` to me in plain language:** what my account already has, and what is
   still missing before I can fulfill and sell. If a plan limit is already blocking something,
   say so with the upgrade link. **Ask me for nothing yet.**
6. Confirm `state.json` was written, then stop.

Never write a token, API key, or any other credential into `state.json` or any file, at any point
in this recipe.

Do NOT proceed to connecting anything, that is the next step (`KICKOFF-PROMPT.md`).
