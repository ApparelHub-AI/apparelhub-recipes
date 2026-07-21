# Run Journal

Append-only. One entry per autonomous run, with one line per client. Newest at the bottom. Never
rewrite past entries.

---

## Run 0: Setup (template)

- **What:** Initialized this agency's operating folder from the `agency-multi-brand` recipe, and
  ran the bootstrap to choose the in-scope client workspaces and write `state.json`.
- **Clients:** configured for N client workspaces (see `state.clients`), one workspace per client.
- **Phase:** `agency_ops`: ready for the first agency pass.
- **Gates:** money + go-live + discretionary reprice closed. `$0` autonomous spend. Archive-only
  lifecycle.
- **Next:** run `KICKOFF-PROMPT.md` → one pass across the configured clients (Serve, Assess,
  Safe-optimize per client) → portfolio snapshot → queue anything customer-affecting per client.

<!--
Per-run template (copy for each real run):

## Run <n>: <date>
- **Portfolio:** <cross-client snapshot from analytics_portfolio: totals + notable clients>
- **Clients processed this run:** <count> of <total> (round-robin from index <start>)
- **Client: <name>** (workspace <uuid>): served <orders reconciled / holds / issues>; assessed
  <winners / dead listings / thin-margin>; safe-optimized <archived N, restored M sub-floor>;
  queued <count> (see pending-approvals.md).
- **Client: <name>** (workspace <uuid>): ... (unavailable / blocked -> reason, counted done)
- **Cursor:** last_client_index -> <n>; clients_processed -> <n>
-->

---
