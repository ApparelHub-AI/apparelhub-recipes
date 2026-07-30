# Bootstrap prompt: run this ONCE, first

> Prereq: your agent can reach the ApparelHub connector and an email capability, and this recipe
> folder is its working / mounted folder. Paste the block below into your agent.

---

You are configuring the Agency Brand Intake recipe for my ApparelHub account. This is a read-only
discovery step plus two file writes. Do NOT create any workspaces, designs, products, or orders. Do
NOT send or draft any email yet.

1. Read `constitution.md`, `state.template.json`, and `client-roster.template.csv`.

2. **Check the entitlement this recipe needs.** Call `list_my_workspaces` and
   `get_account_overview`. This recipe creates a workspace per client brand, which needs the
   account-wide agency feature. If my account does not have it, `create_workspace` will return
   `feature_unavailable`. Tell me now if that is the case, and stop, rather than letting a run
   discover it later. Show me the workspaces I already have, with names and uuids, so we can tell
   which clients are already set up.

3. **Resolve how this runtime sends email.** Do not just scan your tool list: a send capability
   often is not a tool at all. Check all three shapes, in this order, and stop at the first hit:
   - **A send tool.** Any connector tool that genuinely sends (not one that only drafts). Record
     `outbound: "send_tool"` and the tool name.
   - **A script, module, or CLI you can invoke.** If this runtime has a shell and a local mail
     helper is available (for example a Python module exposing a `send(...)` function, a mail CLI, or
     an SMTP or provider API credential in the environment), that counts as sending. Verify it is
     really there before claiming it, then record `outbound: "send_tool"` and the exact command or
     import you would call. **Ask me if you are unsure whether a helper you found is the right one
     to use.**
   - **Draft only.** If all you have is a tool that **creates a draft** (the normal case with the
     Gmail connector, which has no send tool), record `outbound: "gmail_draft"`.
   - If you have none of the three, tell me. This recipe closes its loop over email and cannot run
     without at least drafting plus reading replies.
   Confirm you can also **read** replies (thread search and thread read). Tell me plainly which mode
   I am in, what you will actually call to send, and if it is `gmail_draft`, that I will need to
   click send on each approval email you prepare.

4. **Ask me for the default approver email address.** This is who gets sign-off requests for any
   client row that does not name its own approver. **This and the roster are the only things I need
   to fill in.** Do not ask me to design the operating routine: every client gets the same one and
   it is fixed by `constitution.md`.

5. **Create the roster.** Copy `client-roster.template.csv` to a new file `client-roster.csv` in
   this folder, keeping the header row and the example row so I can see the shape. If I would rather
   keep the roster as a real `.xlsx` or as a Google Sheet, say so and record the choice in
   `state.roster.format`, but note the tradeoff: with a Google Sheet you can read my rows but cannot
   write the status columns back, so status will live in the journal instead.

6. **Tell me back, in plain English, what I just signed up for:**
   - I keep a roster spreadsheet. Each row is one client brand and points at that brand's assets
     folder.
   - On every run, you pick up new rows, give each brand **its own isolated workspace**, and never
     touch a workspace the roster did not name.
   - If a brand's folder **already has assets**, you read them and write up the brand identity you
     inferred. If the folder is **empty**, you stop and establish the identity first: you interview
     me if I am here, or you email that client's approver an intake questionnaire if I am not, and
     you never invent a brand on your own.
   - Once a brand has an identity, you build design concepts and mockups, then **email the approver
     for creative sign-off**. Only after they reply approving it do you build DRAFT products, and
     then you email again for the go-live decision.
   - **Nothing goes live, nothing spends money, and nothing advances past a goal line without a real
     reply from that client's approver.** Silence is never approval, and an ambiguous reply is
     treated as a request for changes.
   - You will onboard at most a few new clients per run, so a long roster comes on over several
     runs instead of all at once.

7. **Write `state.json`** in this folder, copied from `state.template.json`, with:
   - `account.name` set to my agency / account name, and `account.agency_feature` set to what you
     found in step 2,
   - `approvals.default_approver_email` set to the address from step 4, and `approvals.outbound`
     (plus `approvals.send_tool` if any) set from step 3,
   - `roster.path` and `roster.format` set from step 5,
   - `clients` set to an **empty list** (the kickoff discovers clients from the roster),
   - `_bootstrap` set to `"configured"`.
   Leave `gates`, `defaults`, `phase`, and `cursors` exactly as the template has them.

8. Show me a short summary: the account name, whether the agency feature is present, my email mode
   and what it means for me, the default approver, the roster file you created, and confirmation
   that `state.json` was written. Then tell me to fill in the roster and stop.

Do NOT proceed to an intake pass, that is a separate step (`KICKOFF-PROMPT.md`).
