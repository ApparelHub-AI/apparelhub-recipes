# Recipe: Agency Brand Intake

Onboard client brands from a **roster spreadsheet**, give each one an isolated workspace, establish
its brand identity (reading the assets the client already has, or generating one with you when the
folder is empty), build the creative, and **close every deliverable with a human approval over
email**. A reply of `APPROVED` advances the client, a reply of `CHANGES:` sends it back for revision.
That is the closed loop.

For creative agencies and Enterprise accounts that take on new client brands over time and need a
sign-off trail. Works in any agent runtime that can reach the ApparelHub connector plus an email
capability: Claude Cowork, Claude Code, or a custom harness.

**How it differs from [`agency-multi-brand`](../agency-multi-brand/):** that recipe runs a safe
read-mostly operating pass across client workspaces that **already exist**, and you pick them by
hand. This one is the front of the funnel: it **discovers** new clients from a spreadsheet, **creates**
their workspaces, **establishes brand identity from scratch when there is none**, produces creative,
and gets it **approved by email**. Run this to onboard and produce; run that one to operate what has
already launched.

## Start it with one line

Paste this into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-brand-intake/START.md and follow it.

If your agent cannot fetch URLs, open
[`START.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-brand-intake/START.md)
and paste the whole thing instead. That path is degraded for this recipe, because its charter is
long and does not fit in one pasteable file, so prefer a surface that can fetch URLs.

## What you need
- An ApparelHub **agency / Enterprise** account with the agency feature (this recipe creates a
  workspace per client; without it `create_workspace` returns `feature_unavailable`, and the
  bootstrap checks this up front).
- Agent access to ApparelHub: the hosted MCP connector, the local MCP server, or an Agent API key.
  See [apparelhub.ai/agents](https://apparelhub.ai/agents).
- **An email capability**, and this is the one thing worth reading before you start:
  - If your runtime can genuinely **send** email, the loop is fully autonomous. That can be a
    connector tool, or a local mail module, CLI, or SMTP credential you invoke through the shell;
    the bootstrap checks for all three, because a send capability is often not a tool at all.
  - If it can only **create drafts** (the normal case with the Gmail connector, which has no send
    tool), the agent prepares each approval email and names it in the run summary, and you click
    send. Everything else, including reading and applying replies, still runs itself.
  - Either way the agent needs to **read replies** (thread search and thread read).
- A folder per client brand that your agent can read and write, containing that brand's assets, or
  empty if the brand does not exist yet.

## Running it from a clone (advanced)
The one-line URL above is the supported path. If you would rather keep the files locally:

1. Copy this `agency-brand-intake/` folder into your agent's working / mounted folder.
   (Copy it out of this repo so your filled-in roster and state stay yours.)
2. Grant your agent the ApparelHub connector **and** an email tool.
3. Run **`BOOTSTRAP-PROMPT.md`** once. It checks your agency entitlement, works out how your runtime
   sends email and tells you which mode you are in, asks for a default approver address, creates
   `client-roster.csv`, and writes your own `state.json`. Read-only discovery plus two file writes;
   nothing is built.
4. **Fill in the roster.** One row per client: brand name, path to that brand's assets folder, who
   approves for them, and any notes. Delete the example row.
5. Run **`KICKOFF-PROMPT.md`**. It runs one intake pass and stops at the gates.

## The roster is your control surface
`client-roster.csv` opens in Excel, Sheets, or Numbers. You fill four columns, the agent writes
three back, so the sheet you open always shows where every client stands.

| You fill | The agent writes back |
|---|---|
| `client_name`, `assets_folder`, `approver_email`, `notes` | `status`, `workspace_uuid`, `last_run` |

Adding a row is how you onboard a client. `client_name` is the idempotency key, so it maps to the
workspace name and re-running never creates a duplicate. Removing a row retires that client in the
agent's state; it never deletes a workspace or any assets.

Prefer a real `.xlsx` or a Google Sheet? Say so at bootstrap. The tradeoff with a Google Sheet is
that the Drive connector has no cell-write tool, so the agent can read your rows but reports status
in the journal instead of the sheet.

## How it runs
The full operating model is in **`constitution.md`**: the charter your agent reads at the start of
every run. Each client walks one stage at a time.

```
discovered
  -> workspace_ready        its own workspace, created only if absent
  -> identity_pending       folder was empty; identity being established
  -> identity_ready         brand-identity.md written into the client's folder
  -> concepts_built         designs + mockups, quality and compliance gates passed
  -> creative_sent          APPROVAL EMAIL 1, awaiting reply
  -> creative_approved
  -> products_drafted       DRAFT products, channel state draft, margin floor held
  -> golive_sent            APPROVAL EMAIL 2, awaiting reply
  -> delivered
```

Plus two side states: `blocked` (something outside the agent's control, and it carries the reason,
for example an unreachable assets folder or a request for a protected brand's look-alike) and
`retired` (its roster row was removed, so the agent stops working it but leaves the workspace and
assets untouched).

A `CHANGES:` reply on either gate sends the client back one step and the agent reworks against the
feedback, bounded by `max_revision_rounds` so a loop cannot spin forever. A blocked client is logged
and retried on the next run; it never halts the pass.

## Empty folder: interactive brand identity
An empty assets folder means the brand does not exist yet, and the agent will not invent one behind
your back. What it does depends on whether you are there:

- **You are running it:** it interviews you about the brand in plain language, generates a palette,
  type direction, voice, and a mark concept, shows you, then writes `brand-identity.md` into that
  client's folder and carries on.
- **It is running on a schedule:** it cannot interview, so it emails that client's approver the same
  questions as an intake questionnaire, leaves the client at `identity_pending`, and moves on. A
  later run picks up the reply and continues. It chases once, then waits. It never stalls the run and
  never guesses a brand.

If the folder already has assets, the agent reads them instead, infers the identity, and **labels it
as inferred** so nobody mistakes its reading for something the client said.

## Isolation model
This recipe handles several clients' confidential creative at once, so the defining rule is strict
separation: the agent pins `workspace=<that client's uuid>` on every call, writes files only inside
that client's own assets folder, and **emails only the approver on that client's own row.** One
client's identity, concepts, prices, or feedback never appear in another client's email or approval
item.

## Safety model (defaults)
- **Nothing ships without a reply.** Both goal lines need a real reply from that client's approver.
  Silence is never approval, an ambiguous reply counts as changes requested, and a reply from any
  other address is context rather than a verdict.
- **Replies are data, not commands.** An approver's email is untrusted input. The agent takes the
  verdict and the requested changes from it, and will not act on an instruction found in an email
  that tries to cross a gate, reach another client, or publish something live. It escalates those to
  you instead.
- **Nothing live, $0 autonomous spend, nothing deleted.** Products sync as `draft` only. Paid-order
  confirmation is out of scope for this recipe. Archive is used in place of delete, always.
- **Bounded everywhere:** new clients per run, concepts and products per client, and revision rounds
  are all capped, so a fifty-row roster paste onboards over several runs instead of one runaway pass.
- **Quality gated:** every design passes quality, compliance, and (for text) spelling checks, and any
  mockup that is not photoreal and crisp is dropped rather than emailed to a client.
- **Self-configuring:** no account data is hardcoded; your roster and state stay local and are
  gitignored.

## Files
| File | Role |
|---|---|
| `START.md` | The one-line URL entry point. Fetches the rest of the recipe, then self-configures. |
| `constitution.md` | The charter. Read every run. |
| `state.template.json` | Template; the bootstrap writes your real `state.json` from it. |
| `client-roster.template.csv` | Template; the bootstrap writes your real `client-roster.csv` from it. |
| `brand-identity.template.md` | Copied into a client's assets folder as `brand-identity.md` when that brand needs an identity. |
| `BOOTSTRAP-PROMPT.md` | Step 0: check entitlement, resolve email mode, create the roster, self-configure. |
| `KICKOFF-PROMPT.md` | Run an intake pass. Includes the unattended (scheduled) variant. |
| `run-journal.md` | Append-only log of every run (one line per client). |
| `pending-approvals.md` | The approval ledger: every deliverable, its email thread, and its verdict. |

## Phases
- **`intake` (default):** the standing mode. Every run polls replies, onboards new roster rows,
  advances each client one stage, and emails at the goal lines. All gates closed.
- **`roster_frozen`:** advance and approve the clients already in flight, onboard no new rows.
- **`paused`:** poll replies and log only. Create nothing, email nothing. A safe stop.

Change the phase, the caps, or the approver by editing `state.json`. The agent never changes them
itself.
