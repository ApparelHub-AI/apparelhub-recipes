# Pending Approvals

The agent appends here anything that needs the operator's sign-off. **The agent never acts on
these items itself.** The operator reviews, then either performs the action or tells the agent it
is approved.

**Every item names the client it belongs to** (via the `Client:` field), so approvals stay scoped
to one workspace.

Three gate types:
- **PUBLISH-LIVE**: promote a DRAFT listing to live on a sales channel.
- **CONFIRM-ORDER**: confirm a paid order to production (real fulfillment spend).
- **REPRICE**: apply a discretionary price change that changes what customers pay (beyond
  restoring a sub-floor listing to the margin floor).

Format per item:

```
### [GATE-TYPE] <short title>: <date>
- Client: <client name> (workspace <uuid>)
- What: ...
- Why / evidence: ...
- Cost / risk: ...
- Exact action on approval: <the tool call the agent would run, with workspace=<that client's uuid>>
- Status: PENDING | APPROVED | DECLINED
```

---

_No pending items._
