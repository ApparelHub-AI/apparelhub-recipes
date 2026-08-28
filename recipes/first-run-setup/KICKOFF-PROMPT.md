# Kickoff prompt: run after the bootstrap

> Prereq: you have run `BOOTSTRAP-PROMPT.md`, so `state.json` exists with
> `_bootstrap: "configured"`. If not, run the bootstrap first. Paste the block below.
>
> You can run this repeatedly. It picks up from whatever phase `state.json` records, so leaving
> to create a provider account and coming back later is a normal, supported path.

---

You are walking me through setting up my ApparelHub account, from wherever it currently is to one
draft product. This folder is your memory and rulebook.

1. Read `constitution.md` in full, then `state.json`, `run-journal.md`, and `pending-approvals.md`.
2. Call `check_setup_readiness` for `state.workspace_uuid`. **Readiness is authoritative**; if it
   disagrees with `state.json`, believe readiness and correct the file.
3. Work the phase machine in `constitution.md` §2, starting from the first phase readiness shows
   as unsatisfied: `1_fulfillment` → `2_store` → `3_channel` → `4_first_product` → `handoff`.
4. **Ask me one thing at a time.** Readiness names exactly one next action; ask only for that,
   wait for my answer, act, then re-read readiness to confirm it actually changed.
5. Before sending me to any provider, ask whether I already have an account there. If I do not,
   give me the signup link and wait. When I come back, issue a **fresh** authorization link
   yourself. Never tell me to go to the web dashboard and start over.
6. After handing me an authorization URL, poll `check_connection_status` and tell me the moment
   it lands. Do not keep asking me whether it worked.
7. After each phase completes, update `state.json` and append a short entry to `run-journal.md`.
8. Stop at the handoff and point me at the next recipe. Do not keep building.

Hard rules for the whole run: spend $0, never publish anything live, never confirm an order to
production, and **never write a token or API key into any file**. Hand credentials to the connect
tool and forget them. If a plan limit blocks a phase, tell me plainly with the upgrade link,
record it, and stop that phase cleanly rather than retrying.

## When you are done

> Setup is finished when I have an Active store with fulfillment connected, a sales channel
> connected (or fulfillment-only recorded as my choice), and one draft product that is not live
> and cost me nothing. Then hand off and stop.

To run the store from there, use the `autonomous-storefront` recipe, or pick another from
https://github.com/ApparelHub-AI/apparelhub-recipes
