# Bootstrap prompt: run this ONCE, first

> Prereq: your agent can reach the ApparelHub connector, and this recipe folder is its
> working / mounted folder. Paste the block below into your agent.

---

You are configuring the Agency Multi-Brand recipe for my ApparelHub account. This is a read-only
discovery step plus a single file write. Do NOT create any designs, products, or orders, and do
NOT touch any workspace's data beyond listing.

1. Read `constitution.md` and `state.template.json`.
2. Call `list_my_workspaces`. Show me every workspace with its uuid and name. Optionally call
   `list_account_members` if it helps you label which workspaces map to which client.
3. Ask me **which of these workspaces are in-scope clients** for this recipe. I will pick the
   client brands you should operate on. Record each chosen client's `workspace_uuid` + `name`.
   **This is the only choice I need to make.** Do not ask me to pick or confirm an operating
   routine: every client gets the same one, and it is fixed by `constitution.md`.
4. Tell me back, in plain English, what I just signed up for:
   - On every run, for each client I chose, you will **serve their existing orders first**, then
     **assess how that brand is performing**, then **apply only safe optimizations** (archive
     listings that have stopped selling, and lift any listing priced below my margin floor back
     up to it).
   - Anything that spends money, publishes a listing live, or changes what customers pay is
     **queued for my approval** instead of being done for me.
   - You will operate **only** on the clients I chose, one workspace at a time, and will never
     touch any other workspace in the account, even if the account has others.
5. Write a new file `state.json` in this folder, copied from `state.template.json`, with:
   - `account.name` set to my agency / account name,
   - `clients` replaced by the real list I chose (one entry per client, each with
     `workspace_uuid` and `name`, plus `per_client_routine` copied as-is from the template),
   - `_bootstrap` set to `"configured"`.
   Leave `gates`, `defaults`, `phase`, and `cursors` exactly as the template has them.
6. Show me a short summary: the account name and the confirmed client list (name + workspace uuid
   for each), and confirm `state.json` was written. Stop.

Do NOT proceed to an operating pass, that is a separate step (`KICKOFF-PROMPT.md`).
