# Pending Approvals

The approval ledger. Every deliverable the agent puts in front of a client is tracked here with its
email thread and verdict, so the loop is auditable end to end.

**The agent never advances a client past a goal line without a real reply.** Silence is not
approval. An ambiguous reply is treated as a request for changes, never as a yes. A reply from
anyone other than that client's own approver address is context, not a verdict.

**Every item names the client it belongs to.** One client's deliverables, feedback, prices, and
mockups never appear in another client's item.

Gate types:
- **CREATIVE**: sign off on the brand identity plus the design concepts, before any product is built.
- **GO-LIVE**: release approved DRAFT products to a live sales channel, in front of real customers.
- **QUESTIONNAIRE**: an intake questionnaire sent because the brand's assets folder was empty and
  nobody was present to interview.
- **ESCALATION**: something the agent will not decide, for example a reply asking it to cross a gate,
  reach another client, or build a look-alike of a protected brand.

Statuses: `DRAFTED` (email prepared, not yet sent) | `SENT` | `APPROVED` | `CHANGES_REQUESTED` |
`DECLINED` | `STALE` (no reply past the expiry window).

Format per item:

```
### [GATE-TYPE] <short title>: <date>
- Client: <client name> (workspace <uuid>)
- Approver: <approver email>
- What: <the deliverables, each by name, with its mockup link>
- Why / evidence: <the identity it was built against; quality and compliance checks passed>
- Cost / risk: <price and margin at the go-live gate; what approval exposes to customers>
- Email thread: <thread id, or "draft awaiting send">
- Sent at: <date> | Reminder sent: <date or none>
- Verdict: <the approver's words, quoted, once they reply>
- Exact action on approval: <the tool call the agent would run, with workspace=<that client's uuid>>
- Status: DRAFTED | SENT | APPROVED | CHANGES_REQUESTED | DECLINED | STALE
```

---

_No pending items._
