# ApparelHub Recipes

Open-source, runnable blueprints for operating a custom-merchandise business with **your own AI
agent** on [ApparelHub](https://apparelhub.ai). Clone a recipe, point your agent at it, and run
the pipeline (design, product creation, listing, orders, and fulfillment) from Claude Cowork,
Claude Code, or any custom harness.

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

## Use a recipe
1. Pick a recipe under [`recipes/`](recipes/) and copy its folder into your agent's working /
   mounted folder.
2. Give your agent access to ApparelHub (the hosted MCP connector, the local MCP server, or an
   Agent API key, see [apparelhub.ai/agents](https://apparelhub.ai/agents)).
3. Run the recipe's `BOOTSTRAP-PROMPT.md` (self-configures against your account), then its
   `KICKOFF-PROMPT.md`.

## Recipes
| Recipe | Status | What it does |
|---|---|---|
| [`autonomous-storefront`](recipes/autonomous-storefront/) | Available | Runs a whole store end to end, hands-off, with money + go-live gates you control. |
| `seasonal-collection-builder` | Planned | Spins up a themed collection on a deadline, then retires it. |
| `reconciler-restocker` | Planned | Keeps a target catalog present; rebuilds anything missing. |
| `review-and-optimize` | Planned | Reads analytics and prunes / reprices underperformers. |
| `agency-multi-brand` | Planned | Runs one workspace per client across an agency account. |

## Safety by default
Every recipe ships with guardrails on: hard gates before any real spend or going live, a margin
floor, a mockup quality gate, and bounded actions per run. Nothing is published live or charged
without your approval.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md). Every recipe must be self-configuring and contain no
account-specific data; a CI check enforces it.

## License
[MIT](LICENSE).
