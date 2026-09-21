# Adapter — Microsoft 365 Copilot (declarative agent)

Turns an `agents/<name>/AGENT.md` — and the skills it draws on — into a declarative agent
you can sideload from VS Code and publish to the org catalogue.

Read `PORTABILITY.md` first. The three constraints that shape everything here: **8,000
characters of instructions, no bundled files, and the user picks the agent by name.**

## The conversion, step by step

**1. Decide the remit — this is a judgment call, not a transform.** One agent usually carries
the method from *several* skills. Ask: what would a colleague go looking for in the agent
picker? That noun is the agent. Three near-identical agents nobody can distinguish is the
common failure.

**2. Split each source skill into instruction vs knowledge.**

| Goes into the 8k `instructions.md` | Goes into a knowledge document |
|---|---|
| The procedure — the steps, in order | Worked examples and long-form rationale |
| Hard rules and refusals | Reference tables, checklists, templates |
| When to consult which knowledge document, **by document title** | Anything over ~500 words that is consulted rather than followed |

If a rule is load-bearing — the agent must never violate it — it goes in the 8k. Retrieval
from a knowledge source is fuzzy and may not fire.

**3. Upload the knowledge documents to a SharePoint site or OneDrive folder** and point the
agent's `OneDriveAndSharePoint` capability at it. **Check the boundary before you upload:**
these documents came from this repo, so they are public/synthetic/original — but confirm it,
because this is the one step that moves content into the tenant.

**4. Write `instructions.md` and count the characters.** `wc -c instructions.md` — if it is
over 8,000, cut. Cut examples first, then rationale, never the hard rules.

**5. Build the package** with the Microsoft 365 Agents Toolkit in VS Code
(`Create New App` → `Declarative Agent`). Copy `template/` here as the starting point.
Sideload to test; publish through the admin catalogue when it holds up.

## What you lose, and should say so out loud

- **On-demand loading.** Everything is in the 8k or in a document the agent may or may not
  retrieve.
- **Automatic activation.** Nobody gets the method unless they picked the agent first.
- **Executable steps.** No Bash, no file edits. Actions are HTTP calls described by an
  OpenAPI spec, and each one is an approval conversation with someone.

An agent that quietly does 60% of what the skill did is worse than one that does 100% of a
narrower remit and says what it does not cover. Narrow the remit.

## Agent builder vs the toolkit

The low-code **agent builder** inside Copilot chat is the fast path — instructions,
knowledge, starter prompts, working in minutes. It supports **no actions and produces no
package**, and an agent built there cannot be upgraded into a toolkit agent later. Use it to
test whether a remit is worth having. Build the keeper in the toolkit.
