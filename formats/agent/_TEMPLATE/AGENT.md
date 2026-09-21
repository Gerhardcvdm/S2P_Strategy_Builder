---
name: 
description: 
sources:          # the skills this agent carries; paths under skills/
  - 
targets:          # hosts this is built for
  - copilot-m365
---

# Remit

What this agent is for, in the words a colleague would use when going looking for it.

# Out of scope

State this before the capabilities. An agent that names its limits gets trusted; one that
attempts everything gets abandoned after the first bad answer. Be specific — "does not draft
client-facing text", not "has limitations".

# Procedure

The steps, in order. This is the part that must survive into the 8k instruction budget
intact, so write it tight from the start.

1. 
2. 

# Hard rules

Rules that must never be violated. These go in the instructions, never in a knowledge
document — retrieval is fuzzy, instructions are not.

- 

# Knowledge

Documents the agent consults rather than follows. Each row becomes an uploaded file on the
M365 side, referenced from the instructions **by exact title**.

| Document | Consulted when |
|---|---|
|  |  |

# Tools

What the agent needs beyond its own text. On M365 these are `capabilities[]` (web search,
SharePoint/OneDrive, Graph connectors, code interpreter) and `actions[]` (HTTP calls
described by an OpenAPI spec). Every action is an approval conversation with someone —
name the ones you actually need.

- 

# Conversation starters

Real opening requests, not category labels. "Score this portfolio against the Part 0
weighting" — not "Portfolio analysis".

- 
