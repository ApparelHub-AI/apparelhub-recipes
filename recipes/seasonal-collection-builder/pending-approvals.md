# Pending Approvals

The agent appends here anything that needs the operator's sign-off. **The agent never acts on
these items itself.** The operator reviews, then either performs the action or tells the agent
it is approved.

Three gate types:
- **PUBLISH-LIVE**: promote the DRAFT collection (or a listing) to live on a sales channel.
- **CONFIRM-ORDER**: confirm a paid order to production (real fulfillment spend).
- **RETIRE-LIVE**: take a LIVE product down (or archive a product blocked by pending orders) when
  the deadline passes.

Format per item:

```
### [GATE-TYPE] <short title>: <date>
- What: ...
- Why / evidence: ...
- Cost / risk: ...
- Exact action on approval: <the tool call the agent would run>
- Status: PENDING | APPROVED | DECLINED
```

---

_No pending items._
