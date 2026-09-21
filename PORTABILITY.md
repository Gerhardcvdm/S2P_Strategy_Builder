# The target matrix — what actually survives the port

Written once. Read before authoring anything you intend to run on more than one host,
because the constraints below are what make a skill portable or not.

## The shape every host shares

A markdown body of instructions · some metadata · optionally some bundled material ·
optionally some tool bindings. That is the whole common denominator. Author to it.

## Where they diverge — and this is the part that bites

| | Claude Code skill | M365 declarative agent |
|---|---|---|
| **Instruction budget** | Effectively unbounded; `SKILL.md` plus `references/` loaded on demand | **~8,000 characters, hard.** One flat block, always loaded |
| **Progressive disclosure** | Yes — the core file points at reference files, loaded only when an episode fires | **None.** Everything the agent knows is in the 8k, or it is in a knowledge source |
| **Bundled files** | `references/`, templates, scripts, all in the package | No package files. The nearest thing is a *knowledge source* — a SharePoint/OneDrive document the agent retrieves |
| **How it activates** | Automatically, by description matching against the user's request | **The user picks the agent by name** before they type |
| **Tools** | Full harness: Bash, file edit, web, MCP | `capabilities[]` (web search, SharePoint/OneDrive, Graph connectors, code interpreter, image gen) and `actions[]` — API plugins described by an OpenAPI spec |
| **Grounding** | Whatever is in the repo | The Microsoft Graph — mail, files, chats, meetings, under the caller's own permissions |

## The four rules that follow

**1. The 8k limit is an authoring constraint, not an export problem.** A skill whose
`SKILL.md` is already 12,000 characters cannot be ported — it can only be rewritten. If you
know a method is going to M365, write the core at ≤6,000 characters from the start and push
the depth into reference files that become knowledge documents.

**2. `references/*.md` become uploaded knowledge documents, not instruction text.** This is
the single most important adapter rule. A Claude skill says "load `references/weekly-review.md`
when a review triggers"; the declarative agent equivalent says "when the user asks for a
review, consult *Weekly Review Procedure*" — where that document sits in SharePoint. The
retrieval is fuzzier and the agent may not consult it. Write the pointer as an instruction
the agent cannot miss, and keep anything load-bearing in the 8k itself.

**3. One skill ≠ one agent.** Claude loads a skill because the request matched its
description; a user selects an agent because they went looking for it. Users will not
maintain a picker with fifteen agents in it. **Several related skills collapse into one
agent with a broader remit** — a "Document Analyst" agent that carries the method from
three skills, not three agents nobody can tell apart.

**4. Grounding cuts both ways.** An M365 agent can see the user's mail and files, which is
most of its value — and means an agent's *instructions* may be public while its *behaviour*
is not. Never write an instruction that would embarrass you if the transcript were read.
Nothing about a real client's content comes back to this repo (`transfer/INBOUND.md`).

## What a declarative agent package actually is

A Teams app package — a zip — containing:

```
manifest.json          Teams app manifest; points at the agent file via
                       copilotAgents.declarativeAgents[].file
declarativeAgent.json  name, description, instructions, conversation_starters[],
                       capabilities[], actions[]
instructions.md        the 8k body (inlined into the agent file at build time)
color.png              192x192
outline.png            32x32
```

Two ways to get there, and they are not equivalent:

- **Agent builder**, inside Copilot chat — low-code. Name, description, instructions,
  knowledge, starter prompts. **No actions, no OpenAPI, no package.** Fastest route to a
  working agent; a dead end if you later need an API call.
- **Microsoft 365 Agents Toolkit** for VS Code — the real thing. Produces the package above,
  supports actions, sideloads for test, publishes to the org catalogue. **Start here if the
  agent is meant to last**, because the agent-builder version cannot be upgraded into one.

Publishing to the org catalogue is an admin action. Assume a review, and assume it takes
longer than you planned.
