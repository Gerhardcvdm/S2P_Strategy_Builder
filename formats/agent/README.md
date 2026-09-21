# formats/agent/

Host-neutral agent definitions. One folder per agent, each with an `AGENT.md`.

**An agent is not a skill.** A skill is loaded automatically because the request matched its
description; an agent is **selected by name** by a person who went looking for it. That one
difference drives the whole design:

- One agent usually carries the method from **several** skills. Nobody maintains a picker
  with fifteen entries in it.
- The name has to be the noun a colleague would search for.
- The description has to say what the agent **does not** cover, because nothing else will.

Start from `_TEMPLATE/AGENT.md`. `adapters/copilot-m365/` turns one into a declarative agent
package.

---

## ⚠ Two agent formats live in this repo, and a persona belongs to exactly one

Added 2026-09-04.

| Folder | Format | Selected by | Built for |
|---|---|---|---|
| **`formats/agent/`** | `<name>/AGENT.md` — host-neutral, remit · out-of-scope · procedure · hard rules · knowledge · tools | **a person**, by name | M365 declarative agents, via `adapters/copilot-m365/` |
| **`agents/`** | `<name>.md` — flat, with Claude Code subagent frontmatter (`name`, `description`, `tools`) | ⭐ **usually a command**, not a person | **Claude Code subagents** — own context window, own tool budget, and what the `s2p-strategy` plugin ships |

**Why they are not merged.** The frontmatter differs, the file layout differs (folder versus
flat file), and the selection model differs: an `AGENT.md` is chosen by a colleague who went
looking for it, while a Claude subagent is most often invoked by an orchestrating command and
never seen. **Writing one file to satisfy both would produce something that is a poor version
of each**, and the M365 8,000-character budget applies to only one of them.

⚠ **A persona lives in one folder, never both.** If a Claude subagent later needs an M365 form,
that is a deliberate conversion with a `sources:` line pointing back — not a copy.

**`agents/` is junctioned to `~/.claude/agents/` by `adapters/claude/install.ps1`**, so
a subagent authored here is available in every project.
