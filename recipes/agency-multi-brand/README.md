# Recipe: Agency Multi-Brand

Run a safe operating pass across **each of your client brands**, one workspace at a time, from
your own AI agent, with strict isolation between clients. This is a **meta-recipe**: per client it
serves paid orders, triages issues, assesses performance, and applies only safe optimizations
(archive dead listings, restore sub-floor prices), while queuing anything that publishes live,
confirms a paid order, or changes what customers pay. It also produces a cross-client portfolio
snapshot.

For agencies and Enterprise accounts that manage several brands as separate workspaces. Works in
any agent runtime that can reach the ApparelHub connector: Claude Cowork, Claude Code, or a custom
harness.

## Start it with one line

Paste this into a fresh chat with your agent:

> Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/START.md and follow it.

If your agent cannot fetch URLs, open
[`START.md`](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/START.md)
and paste the whole thing instead. It carries every gate the agent needs, and it needs no clone.

## What you need
- An ApparelHub agency / Enterprise account with **multiple workspaces**, one per client brand,
  each with its own stores, providers, and sales channels.
- Agent access to ApparelHub: the hosted MCP connector, the local MCP server, or an Agent API
  key. See [apparelhub.ai/agents](https://apparelhub.ai/agents).

## How it runs
The full operating model is in **`constitution.md`**: the charter your agent reads at the start of
every run. In short, each run: read the cross-client portfolio, then for **each** configured
client workspace (round-robin for fairness), pin that client's workspace on every call and run a
Serve, Assess, Safe-optimize routine, queue anything customer-affecting per client, and log a
per-client line.

## Isolation model
The defining rule: your agent operates on the **configured clients only, one workspace at a
time**, and passes `workspace=<that client's uuid>` on every call. It **never** touches a
workspace that is not in your configured client list, even if the account has others.

## Safety model (defaults)
- **Three hard gates, on by default, per client:** publishing a listing LIVE, confirming a paid
  order to production (real spend), and applying a discretionary reprice. Your agent queues these
  to `pending-approvals.md` (each tagged with its client) and never crosses them autonomously.
- **$0 autonomous spend**, a margin floor, and **archive-only** lifecycle actions.
- **Read-mostly:** this recipe does not create designs or products. Its only writes are safe:
  reconcile paid orders, approve no-spend holds, resolve informational issues, archive dead
  listings, restore sub-floor prices to the floor.
- **Self-configuring:** no account data is hardcoded; your client list lives only in your local
  `state.json`.

## Running it from a clone (advanced)

The one-line URL above is the supported path. If you would rather keep the files locally:

1. Copy this `agency-multi-brand/` folder into your agent's working / mounted folder.
   (Copy it out of this repo so your filled-in state stays yours.)
2. Grant your agent **only** the ApparelHub connector (add Gmail if you want run-summary emails).
3. Run **`BOOTSTRAP-PROMPT.md`** once. Your agent lists your workspaces, you choose which ones are
   in-scope clients, and it writes your own `state.json` with the real client list. Read-only
   discovery plus one file write; nothing is built.
4. Run **`KICKOFF-PROMPT.md`**. It runs one agency pass across your configured clients and stops at
   the gates.

## Files
| File | Role |
|---|---|
| `START.md` | The one-line URL entry point. Self-contained; carries the gates in one pasteable file. |
| `constitution.md` | The charter. Read every run. |
| `state.template.json` | Template; the bootstrap writes your real `state.json` (with your client list) from it. |
| `BOOTSTRAP-PROMPT.md` | Step 0: choose your in-scope client workspaces and self-configure. |
| `KICKOFF-PROMPT.md` | Run an agency pass across your clients. |
| `run-journal.md` | Append-only log of every run (one line per client). |
| `pending-approvals.md` | The gate queue for your sign-off (every item tagged with its client). |

## Phase
- **`agency_ops` (default):** the standing operating mode. Each run serves, assesses, and
  safe-optimizes every configured client, snapshots the portfolio, and queues anything
  customer-affecting. All gates closed.

Change the phase, or the configured client list, by editing `state.json` or re-running the
bootstrap. The agent never changes them itself.
