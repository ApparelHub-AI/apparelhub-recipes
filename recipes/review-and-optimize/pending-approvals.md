# Pending Approvals

The agent appends here anything that needs the operator's sign-off. **The agent never acts on
these items itself.** The operator reviews, then either performs the action or tells the agent
it is approved.

Three item types:
- **PUBLISH-LIVE**: promote a DRAFT listing to live on a sales channel. (This recipe never
  publishes; it only queues.)
- **CONFIRM-ORDER**: confirm a paid order to production (real fulfillment spend).
- **REPRICE**: a discretionary price change (raise or lower for performance, or a bulk cascade).
  Below-floor margin fixes are applied autonomously, so they are NOT queued here; only
  discretionary reprices are.

Format per item:

```
### [GATE-TYPE] <short title>: <date>
- What: ...
- Why / evidence: ...
- Cost / risk: ...
- Exact action on approval: <the tool call the agent would run>
- Status: PENDING | APPROVED | DECLINED
```

For a REPRICE item, always include the product, its current price, the proposed price, and the
rationale:

```
### [REPRICE] <product name>: <date>
- What: change price on <product name>.
- Current price: <old price>
- Proposed price: <new price>
- Rationale: <why: sales trend, margin headroom, promotion, cascade set>
- Cost / risk: changes what customers pay; not a below-floor correction.
- Exact action on approval: <set_prices_by_margin / cascade_price_change / update_product call>
- Status: PENDING | APPROVED | DECLINED
```

---

_No pending items._
