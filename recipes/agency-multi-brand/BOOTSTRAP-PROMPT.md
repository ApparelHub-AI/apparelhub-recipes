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
   client brands you should operate on. Confirm the `sub_pass` for each (default:
   `serve_assess_optimize`). Record each chosen client's `workspace_uuid` + `name`.
4. Emphasize back to me, in one line, that this recipe will operate **only** on the clients I
   chose, one workspace at a time, and will never touch any other workspace in the account, even
   if the account has others.
5. Write a new file `state.json` in this folder, copied from `state.template.json`, with:
   - `account.name` set to my agency / account name,
   - `clients` replaced by the real list I chose (one entry per client, each with
     `workspace_uuid`, `name`, and `sub_pass`),
   - `_bootstrap` set to `"configured"`.
   Leave `gates`, `defaults`, `phase`, and `cursors` exactly as the template has them.
6. Show me a short summary: the account name and the confirmed client list (name + workspace uuid
   for each), and confirm `state.json` was written. Stop.

Do NOT proceed to an operating pass, that is a separate step (`KICKOFF-PROMPT.md`).
