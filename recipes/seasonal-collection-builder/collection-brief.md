# Collection Brief

**STATUS: PENDING**

> Fill this out, then change STATUS to `READY`. While it reads `PENDING`, the agent may build
> using concepts it generates itself, but it keeps everything in draft and logs that the brief is
> unconfirmed. Set the theme, deadline, and target count in `state.json` (`collection.theme`,
> `collection.deadline`, `collection.target_count`) too, or ask the agent to copy them from here.
>
> Copy rules apply to everything public: no em-dashes or en-dashes, benefit-led, honest. A real
> seasonal deadline is a legitimate reason to buy, state it plainly, do not manufacture urgency.

---

## Theme
_The occasion or season and its mood (for example: a winter-holiday gift set, a summer-festival
run, a back-to-school drop). One or two sentences._

## Deadline
_The ISO date (YYYY-MM-DD) the collection retires. After it, a live collection moves to
`retiring`._

**Retire behavior when the deadline passes:**
- DRAFT products (never published, no orders): the agent archives them autonomously (reversible
  with `restore_product`).
- LIVE products, or anything blocked by pending orders: the agent queues a RETIRE-LIVE item for
  your approval and does not archive them itself.

## Target buyer
_Who this is for and the moment they buy in. Be specific._

## Positioning
_The honest, benefit-led angle. What the buyer gets and why it fits the occasion. No invented
claims, metrics, or reviews._

## Launch concepts
_The products to build for the collection. Leave rows blank to let the agent propose and validate
concepts itself on the first build run._

| # | Design concept | Garment (provider + product_ref) | Why it fits | Target price / est. margin |
|---|---|---|---|---|
| 1 |  |  |  |  |
| 2 |  |  |  |  |
| 3 |  |  |  |  |
| 4 |  |  |  |  |

## Risks / watch-items
_Trademark or licensed-character risks (seasonal themes attract look-alikes), thin-margin
garments, print-quality quirks to eyeball, timing risks around the deadline._
