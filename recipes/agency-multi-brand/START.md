# Start here: Agency Multi-Brand

Runs a safe operating pass across each of your client brands, one workspace at a time, from your
own AI agent. Per client it serves orders, assesses performance, and applies only safe fixes, with
strict isolation between clients.

## Run it

Paste one line into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/START.md and follow it.

**If your agent cannot fetch URLs, paste this whole document instead.** Everything the agent
needs to start safely is in this file. It will tell you if it needs anything more.

**Prerequisites:** an ApparelHub agency or Enterprise account with several workspaces, one per
client brand, each already having its own stores, providers, and sales channels. If a client's
workspace is empty, run the
[first-run-setup](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md)
recipe inside that workspace first.

---

## Agent instructions

You are configuring the Agency Multi-Brand recipe against the operator's own ApparelHub account.
This is read-only discovery plus one file write. Create no designs, products, or orders, and touch
no workspace's data beyond listing it.

### 1. Confirm your hands

Call `list_my_workspaces`. If that fails, stop and tell the operator their agent cannot reach
ApparelHub, and point them at https://apparelhub.ai/agents to connect it.

### 2. Pull the rest of the recipe

Fetch these and save each into your working folder under the same filename:

- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/constitution.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/state.template.json
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/run-journal.md
- https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/pending-approvals.md

**If you cannot fetch URLs at all:** say so plainly, ask the operator to paste `constitution.md`
from the same folder, and keep obeying the gates in the "Always true" section below in the
meantime. Do not silently proceed without the charter.

### 3. Choose the in-scope clients

1. `list_my_workspaces`. Show every workspace with its uuid and name. Optionally call
   `list_account_members` if it helps label which workspace belongs to which client.
2. Ask the operator **which of these workspaces are in-scope clients**. Record each chosen
   client's `workspace_uuid` and `name`. **This is the only choice they need to make.** Do not ask
   them to pick or confirm an operating routine: every client gets the same one, fixed by
   `constitution.md`.
3. Tell them plainly what they signed up for: on every run, for each chosen client you serve
   existing orders first, then assess that brand's performance, then apply only safe fixes
   (archive listings that stopped selling, lift sub-floor prices back to the margin floor).
   Anything that spends money, publishes live, or changes what customers pay is queued for their
   approval, and you never touch a workspace outside the chosen clients.

### 4. Write `state.json`

Copy `state.template.json` to a new `state.json`. Set `account.name` to the operator's agency or
account name, replace `clients` with the real chosen list (one entry per client, each with
`workspace_uuid` and `name`, plus `per_client_routine` copied as-is from the template), and set
`_bootstrap` to `"configured"`. Leave `gates`, `defaults`, `phase`, and `cursors` untouched.

### 5. Stop

Summarize the account name and the confirmed client list (name plus workspace uuid for each), and
confirm `state.json` was written. Stop. The operating pass is the next step, driven by
https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/KICKOFF-PROMPT.md

---

## Always true, even if you fetched nothing

These gates hold whether or not you were able to read the constitution:

- **Operate on the configured clients only, one workspace at a time.** Pass
  `workspace=<that client's uuid>` on every ApparelHub call. There is no default pass and no
  cross-workspace pass.
- **Never touch a workspace that is not in the configured client list**, even if the account has
  others. Never mix clients: finish one client before opening the next.
- **Never publish a listing live.** Leave channel state `draft`.
- **Never confirm a paid order to production.** That spends the operator's money.
- **Never apply a discretionary reprice.** Restoring a sub-floor listing to the margin floor is a
  safe fix; any other change to what customers pay is gated.
- **$0 autonomous spend.** Anything that costs money goes to `pending-approvals.md` instead,
  tagged with the client it belongs to.
- **Archive, never delete.** Delete is irreversible and breaks order history.
- **Blocked or unavailable counts as done for the run.** Log it and move to the next client. One
  client never stalls the run.
- Customer-facing copy carries no em-dashes or en-dashes and invents no claims or metrics.
