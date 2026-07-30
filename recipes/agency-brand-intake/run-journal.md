# Run Journal

Append-only. One entry per run, with one line per client. Newest at the bottom. Never rewrite past
entries.

---

## Run 0: Setup (template)

- **What:** Initialized this agency's creative intake folder from the `agency-brand-intake` recipe,
  and ran the bootstrap to check the agency entitlement, resolve the email mode, and write
  `state.json` plus `client-roster.csv`.
- **Roster:** created, empty apart from the example row. Clients are discovered from it on the first
  real run.
- **Email mode:** `send_tool` or `gmail_draft` (see `state.approvals.outbound`). If `gmail_draft`,
  every approval email needs one operator click to send.
- **Phase:** `intake`: ready for the first pass.
- **Gates:** delivery + go-live closed. `$0` autonomous spend. No deletes. Nothing advances without
  a real approver reply.
- **Next:** add client rows to `client-roster.csv`, then run `KICKOFF-PROMPT.md`.

<!--
Per-run template (copy for each real run):

## Run <n>: <date>
- **Replies applied:** <n> (approved <n>, changes requested <n>, declined <n>, questionnaires
  returned <n>); still waiting on <n>
- **Roster:** <n> rows; <n> new discovered this run (cap <n>); <n> retired
- **Client: <name>** (workspace <uuid>): stage <from> -> <to>; identity <inferred from assets /
  generated interactively / questionnaire emailed>; built <n concepts / n draft products>; emailed
  <CREATIVE | GO-LIVE | QUESTIONNAIRE> to <approver> (thread <id> | draft awaiting send); revision
  round <n>
- **Client: <name>** (workspace <uuid>): blocked -> <reason>, counted done for this run
- **Unsent drafts needing an operator click:** <client names, or none>
- **Cursor:** last_client_index -> <n>; clients_onboarded -> <n>; clients_delivered -> <n>
-->

---
