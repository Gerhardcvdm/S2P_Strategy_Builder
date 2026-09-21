---
description: Write the build recommendation for the sponsor from a completed portfolio and a ruled first proof — the contract first, then the proxy pass, then the document, deriving nothing new
argument-hint: [stage]
---

# Build Recommendation

Write **D#3, the build recommendation**, for the sponsor — from D#2 and the ruled first
proof. Six stages, **two gates where a human decides**.

⚠ **Load `derivation-orchestration` before anything else.** Guards (§1), state (§2), gate
batching (§3), the reviewer and proxy protocols (§4–5), markers and IDs (§6), committing (§7).
This file carries only the sequence.

## The one rule this command exists to hold

⚠ **D#3 is written *from* D#2 and never re-derives it.** If a fact is not in the portfolio or
the prototype choice, **it does not go in D#3** — go back and put it in the source, under that
source's gates, and return. A recommendation that quietly re-derives its evidence is a second
derivation with no accounting, no filter log and no gates, wearing the first one's authority.

**This command derives nothing.** It selects, orders, and argues from material already ruled.
If that feels thin, the thinness is real and belongs at a gate.

## Who reads it

**The sponsor, and only the sponsor.** D#2 is the working instrument and stays behind;
this is the document that goes into the room. **One document, one audience** — the ruling that
produced this command in the first place was that the fix for a document with two readers is to
split it, not to choose between them.

If the sponsor asks for the derivation, hand over D#2 on request. **It is never shipped by
default.**

## What This Command Does

| # | Produces | Driver |
|---|---|---|
| 0 | guards + input check | **Agent** (Bash) · `derivation-orchestration` §1 |
| 1 | `deliverables/SPEC.md` Part III | **⚠ Gate R1 first** (contract rulings) → **Agent** |
| 2 | `recommendation-outline.md` | **Agent**, from D#2 + `prototype-choice.md` only |
| 3 | `strategy/recommendation-agenda.md` | **Agent** · `stakeholder-proxy` → **⚠ Gate R2** |
| 4 | `deliverables/agentic-build-recommendation.html` | **Agent** · `html-style` · `analytical-document-build` |
| 5 | verification + confrontation worksheet | **Agent** · `analytical-document-build` §4 |

`strategy-critic` runs after every stage, per §4.

## Usage

```bash
/build-recommendation          # resume from wherever the artefacts stop
/build-recommendation 3        # re-run one stage deliberately
```

## Implementation Steps

### 0. Guards, and the input check

⭐ **First action: call `EnterPlanMode`.** Step 0 and Gate R1 are this arc's entry: the guards, the
two inputs asserted, the stop-check read, and the contract rulings put with their costs. All of it
is read-only until the contract is ruled, so the Gate R1 report is the plan and approval exits plan
mode. ⛔ **Approving the report is not the ruling** — the person rules each contract item, the plan
is rewritten to carry the rulings as made, and only that is approved. **SPEC Part III is the first
write** and carries them. On a resumed run the resume report is the plan instead.
`derivation-orchestration` §1. If the host has no plan mode or the person declines, run the same
steps read-only by instruction and record in Part III that the entry ran without it.

Run both guards from §1 against `intake.md`, then assert the two inputs exist:

```bash
[ -f deliverables/agentic-use-case-portfolio.html ] || echo "STOP: D#2 is not built"
[ -f demo/prototype-choice.md ] || echo "STOP: no first proof has been ruled"
cc="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"   # a plugin install puts agents under plugins/cache
ls .claude/agents/stakeholder-proxy.md "$cc"/agents/stakeholder-proxy.md \
   "$cc"/plugins/cache/*/s2p-strategy/*/agents/stakeholder-proxy.md 2>/dev/null | grep -q . \
  || echo "STOP: stakeholder-proxy is not installed"
```

**Both inputs, or stop.** A recommendation without a ruled first proof is a ranking with a
confident tone; `/build-portfolio` stage 7 is where that ruling happens and it cannot be made
here.

⚠ **Check the portfolio's stop-check before using it.** If `portfolio/stop-check.md` shows the
confrontation box unticked — and it will — **D#3 inherits that**, and stage 4 must say so on
the document's face. A recommendation cannot be more confronted than the portfolio it rests on.

### 1. Gate R1, then SPEC Part III — the contract before the document

**The contract is ruled first, and it is a gate.** Put the whole set in one pass: the audience,
the structure, the design identity, the constraints, and the stop condition — *what has to be
true for this document to be done.*

Write Part III into the existing `deliverables/SPEC.md`, beside the parts governing D#1 and D#2.
⚠ **Each part lists what it inherits unchanged rather than re-arguing it.** A spec that
re-states its siblings' decisions creates three places where one decision lives, and they drift.

### 2. Stage 2 — the outline, sourced line by line

Draft `recommendation-outline.md`. **Every claim names its source in D#2 or
`prototype-choice.md`** — the record ID, not the file.

**Where a claim has no source, do not write it.** Record it instead as a gap, and say which
command owns filling it. That list is the most useful output of this stage.

**Use the assumptions register for what the work is standing on.** Entries are `AS-n`, cited
**inline where load-bearing, never as a footnote.** ⚠ **An assumption is not evidence:**
registering one moves no marker, discharges nothing and moves no version. **What it does is let
the work proceed without the conversations that have not happened** — the maturity scheme
governs what may be *asserted*, not what may be *built*.

### 3. Stage 3 — the proxy pass, then Gate R2

Invoke `stakeholder-proxy` on the outline. **Give it the identity from the intake's `Sponsor`
field** — role,
what they are measured on, what they have already seen. This is the command where it belongs:
the selection is defended here, and this is the one document its reader will actually read.

Write `strategy/recommendation-agenda.md`, then fold it into **Gate R2**: the ranked questions, each
with what breaks if the answer goes the other way, plus any critic findings needing a ruling.

⚠ **Capped at `confronted · internal`, never plain `confronted`** (§5). The agenda makes the
real conversation short, ordered and hard to waste. It does not replace it, and nothing in D#3
may be marked as though it did.

### 4. Stage 4 — D#3

Write to `deliverables/`. **Never publish via the Artifact tool.**

⚠ **The version is a claim about evidence, not about the document.** It moves when a maturity
marker moves — `position` → `confronted` → `evidenced` — and **not for any amount of writing.**
A document that gained a field, a summary, a layout fix and two register passes has moved no
marker and its version does not move.

⚠ **Re-read every number that changed register.** A hedged estimate in a working file becomes a
confident finding the moment it is promoted to a headline here, and this document is nothing
but promotions.

### 5. Stage 5 — verify, then write the worksheet

```bash
python -c "
import io,re,glob
for f in glob.glob('deliverables/*.html'):
    s=io.open(f,encoding='utf-8').read()
    print(f)
    for t in ['div','p','table','tr','td','section']:
        o=len(re.findall(r'<%s[ >]'%t,s)); c=len(re.findall(r'</%s>'%t,s))
        print('  ',t,o,c,'OK' if o==c else 'MISMATCH')
"
grep -c 'src="http\|href="http\|@import\|url(http' deliverables/*.html
```

Tag counts must match; external references must be **0**. **Then re-derive every count the
document asserts about itself, from the finished file** — not from the numbers used while
drafting. Where this has been measured, roughly five of eight were wrong. Confirm the version
string matches in **both** header and footer.

Then write `deliverables/recommendation-confrontation-worksheet.md`: each claim the
recommendation stands on, where it is used, what breaks if it is false, and an empty ruling
slot. **Carry the portfolio's unticked confrontation box into it as the first row.**

## Gates

| Gate | When | The rulings |
|---|---|---|
| **R1** | Before stage 1 | The contract — audience, structure, design identity, constraints, stop condition, and what Part III inherits unchanged from Parts I and II |
| **R2** | Stage 3 | The proxy's agenda, ranked, plus any critic findings needing a ruling. Which questions go into the room, and which claims come out of the document first? |

## Important Notes

- **NEVER derive anything here.** Missing evidence goes back to its own command and its gates.
- **NEVER ship D#2 by default.** On request only.
- **NEVER move the version for writing.** Only a moved marker moves it.
- **NEVER mark anything `confronted` on the strength of the proxy pass.**
- **DO NOT auto-execute the proxy's agenda** — it is questions for a person, not a task list.
- **DO NOT push.** Commit locally after each stage.

## Error Handling

**D#2 or the prototype choice missing** — name which, and which command produces it. Stop.

**A claim in the outline has no source** — it is a gap, not a sentence to write. List it, name
the owning command, and take it to Gate R2 if it is load-bearing.

**The portfolio's stop-check has failures beyond the confrontation box** — report them and ask
whether to proceed. D#3 can be built on an incomplete portfolio; it cannot be built on one
whose incompleteness is unstated.

## Committing

Commit locally after each stage, naming the stage and what it produced. **Never push.**


## Example Output

```
## /build-recommendation — resumed at stage 3

Inputs: D#2 (V0.5, frozen) · demo/prototype-choice.md (UC-04, ruled 2026-09-04).
Portfolio stop-check: 5 of 6 boxes ticked. Confrontation box UNTICKED — inherited,
and D#3 will say so on its face.
Subagents registered: strategy-critic, stakeholder-proxy.

**Produced since last run**
  recommendation-outline.md   31 claims, each sourced to a D#2 record ID
                              4 claims had no source — listed as gaps, not written
  strategy/recommendation-agenda.md  9 questions, ranked, from the proxy pass
  critic pass on stage 2      2 findings — both fixed

**⚠ GATE R2 — three rulings, then stage 4 writes D#3**

1. The proxy's top question: "who owns the system UC-04 writes to, and
   have they agreed?" Nothing in D#2 answers it.
   Recommend: take it into the room, and mark the dependent claim
   `position` in D#3 until it comes back. Cost of asserting instead:
   the recommendation rests on an access assumption nobody has tested.

2. Four claims have no source in D#2 or the prototype choice.
   Recommend: drop three, and send the fourth back to /build-portfolio
   stage 7, where it belongs. Cost of writing them here: D#3 becomes a
   second derivation with no filter log and no gates behind it.

3. The agenda holds 9 questions; a real meeting holds about 4.
   Recommend the ranked top four. Cost: the other five stay open, and
   the document must name which claims they touch.

⚠ The agenda is questions for a person, not a task list. Nothing in it is
answered here, and no claim moves past `position` on the strength of it.

Nothing proceeds until all three are answered. Stage 3 committed as b92f5c1.
```

**What the example is showing.** The four unsourced claims are the most valuable thing stage 2
produced — **they are gaps with an owner, not sentences waiting to be written.** And the
version does not move for any of this: no marker moved.
