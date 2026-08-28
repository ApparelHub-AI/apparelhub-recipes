# Pending Approvals

The agent appends here anything that needs the operator's decision. **The agent never acts on
these items itself.**

This recipe is deliberately narrow: it spends nothing and publishes nothing, so most of the usual
gates can never be reached from here. What does land in this queue:

- **UPGRADE-NEEDED**: a plan limit stopped a phase (no more stores, or no more integrations on
  this plan). Not an error, and not something to retry. The operator decides whether to upgrade.
- **AWAITING-UPSTREAM**: setup is paused because the operator needs an account with a provider
  before anything can connect.
- **DECISION**: a fork only the operator can settle, for example choosing to stay
  fulfillment-only for now instead of connecting a sales channel.

Never record a token, API key, or any other credential in an item here.

Format per item:

```
### [TYPE] <short title>: <date>
- What: ...
- Why it stopped here: ...
- What the operator needs to do: ...
- Upgrade link (if a plan limit): ...
- Status: PENDING | RESOLVED
```

---

_No pending items._
