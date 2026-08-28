# ApparelHub Recipes

Open-source, runnable blueprints for operating a custom-merchandise business with **your own AI
agent** on [ApparelHub](https://apparelhub.ai). Paste one line into your agent and run the
pipeline (design, product creation, listing, orders, and fulfillment) from Claude Cowork, Claude
Code, or any custom harness.

A **recipe** is a self-contained operating pattern: a charter your agent follows, a memory model
it maintains across runs, and the prompts to start it. Recipes drive the ApparelHub platform
through the agent surface; they hardcode no account data and configure themselves against your
account on first run.

## The agent surface, three ways
| Repo | What it is |
|---|---|
| **apparelhub-skills** | The playbook your agent loads on demand: how to call the API correctly. |
| **apparelhub-mcp** | The MCP tool server that exposes the pipeline to your agent. |
| **apparelhub-recipes** (this repo) | End-to-end operating blueprints you drop into your agent's runtime. |

## Use a recipe: one line, no clone

1. Give your agent access to ApparelHub (the hosted MCP connector, the local MCP server, or an
   Agent API key, see [apparelhub.ai/agents](https://apparelhub.ai/agents)).
2. Paste the recipe's start line into a fresh chat. That is the whole install:

   > Read https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md and follow it.

Your agent fetches the recipe and configures itself against your account. Nothing to clone,
nothing to copy, nothing to edit by hand.

**New to ApparelHub? Start with `first-run-setup`.** Every other recipe assumes your account
already has a fulfillment provider and a store; that one gets you there.

**If your agent cannot fetch URLs,** open the recipe's `START.md` and paste the whole file
instead. Each one is written to stay short enough for that.

## Recipes

Each `START.md` link below is the line to hand your agent.

| Recipe | Start | What it does |
|---|---|---|
| [`first-run-setup`](recipes/first-run-setup/) | [START](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/first-run-setup/START.md) | **Start here.** Takes an empty account to one draft product, asking only for what is missing. |
| [`autonomous-storefront`](recipes/autonomous-storefront/) | [START](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/autonomous-storefront/START.md) | Runs a whole store end to end, hands-off, with money + go-live gates you control. |
| [`reconciler-restocker`](recipes/reconciler-restocker/) | [START](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/reconciler-restocker/START.md) | Keeps a desired-state target catalog present; rebuilds anything missing as a draft. |
| [`seasonal-collection-builder`](recipes/seasonal-collection-builder/) | [START](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/seasonal-collection-builder/START.md) | Builds a time-boxed themed collection, then retires it on a deadline. |
| [`review-and-optimize`](recipes/review-and-optimize/) | [START](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/review-and-optimize/START.md) | Reads analytics and applies safe optimizations (archive dead listings, fix sub-floor margins); queues the rest. |
| [`agency-multi-brand`](recipes/agency-multi-brand/) | [START](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-multi-brand/START.md) | Runs a safe pass across every client workspace in an agency account, one at a time. |
| [`agency-brand-intake`](recipes/agency-brand-intake/) | [START](https://raw.githubusercontent.com/ApparelHub-AI/apparelhub-recipes/main/recipes/agency-brand-intake/START.md) | Onboards client brands from a roster spreadsheet, builds their brand identity and creative, and closes each deliverable with an email approval. |

## Prefer to clone?

Still supported, and the right choice if you want to edit a charter or keep your state in version
control. Copy a recipe folder into your agent's working folder, run its `BOOTSTRAP-PROMPT.md`,
then its `KICKOFF-PROMPT.md`. Each recipe's README has the details.

## Safety by default
Every recipe ships with guardrails on: hard gates before any real spend or going live, a margin
floor, a mockup quality gate, and bounded actions per run. Nothing is published live or charged
without your approval.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md). Every recipe must be self-configuring and contain no
account-specific data; a CI check enforces it.

## License
[MIT](LICENSE).
