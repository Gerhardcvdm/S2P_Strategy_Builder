---
description: Write the build recommendation for the sponsor from a completed portfolio and a ruled first proof — the contract first, then the proxy pass, then the document, deriving nothing new
argument-hint: [stage]
---

# Build Recommendation

Write **D#3, the build recommendation**, for the sponsor — from D#2 and the ruled first
proof. Six stages, **two gates where a human decides**.

⚠ **Load `derivation-orchestration` before anything else.** Guards (§1), state (§2), gate
batching (§3), the reviewer and proxy protocols (§4–5), the specification step (§6), markers and
IDs (§7), committing (§8), the cost model (§9). This file carries only the sequence.

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
| 0 | guards + input check · `recommendation/`, its register, registry rows and timings row created | **Agent** (Bash) · `derivation-orchestration` §1–2 |
| 1 | `deliverables/SPEC.md` Part III | **⚠ Gate GR1 first** (contract rulings) → **Agent** |
| 2 | `recommendation/recommendation-outline.md` | **Agent**, from D#2 + `prototype-choice.md` only |
| 3 | `recommendation/recommendation-agenda.md` | **`stakeholder-proxy`** writes it → **⚠ Gate GR2** |
| 4 | `deliverables/agentic-build-recommendation.html` | **Agent** · `html-style` · `analytical-document-build` |
| 5 | `recommendation/tools/verify.py` + `deliverables/recommendation-confrontation-worksheet.md` | **Agent** · `analytical-document-build` §4 · `derivation-orchestration` §6 |

**This arc has a directory of its own: `recommendation/`.** `strategy-critic` runs after every
stage, per §4, and files its pass at `recommendation/critic/<stage>.md` — never in
`strategy/critic/` or `portfolio/critic/`, where the earlier arcs' stages 2 to 5 would be
overwritten. Rulings go in `recommendation/rulings.md`, one row each, identifier `GR<gate>-R<n>`.
*(Before 0.6.0 this command named no directory, no register and no series; the map expected
`R1-R<n>`, one hyphen from D#1's `R1`–`R28`. The watcher accepts either form.)*

## Usage

```bash
/build-recommendation          # resume from wherever the artefacts stop
/build-recommendation 3        # re-run one stage deliberately
```

A resume across a context boundary enters plan mode with the resume report as the plan, re-runs the
guards and compares the plugin version against the one Part III recorded; a resume that follows a
gate ruled in this session does not re-enter plan mode (`derivation-orchestration` §1–2).

## Implementation Steps

### 0. Guards, and the input check

⭐ **First action: call `EnterPlanMode`.** Step 0 and Gate GR1 are this arc's entry: the guards,
the two inputs asserted, the stop-check read, and the contract rulings put with their costs. All of
it is read-only until the contract is ruled, so the Gate GR1 report is the plan and approval exits
plan mode. ⛔ **Approving the report is not the ruling** — the person rules each contract item, the
plan is rewritten to carry the rulings as made, and only that is approved. **The first writes, in
order: `recommendation/rulings.md` with Gate GR1's rows, the arc's series appended to the identifier
registry, the arc's header in the timings file, then SPEC Part III**, which cites the rows
(`derivation-orchestration` §1–2). On a resumed run across a boundary the resume report is the plan
instead.
`derivation-orchestration` §1. If the host has no plan mode or the person declines, run the same
steps read-only by instruction and record in Part III that the entry ran without it.

Run both guards from §1 against `intake.md`, then assert the two inputs exist:

```bash
[ -f deliverables/agentic-use-case-portfolio.html ] || echo "STOP: D#2 is not built"
[ -f portfolio/demo/prototype-choice.md ] || echo "STOP: no first proof has been ruled"
mkdir -p recommendation/critic
cc="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"   # a plugin install puts agents under plugins/cache
ls .claude/agents/stakeholder-proxy.md "$cc"/agents/stakeholder-proxy.md \
   "$cc"/plugins/cache/*/s2p-strategy/*/agents/stakeholder-proxy.md 2>/dev/null | grep -q . \
  || echo "STOP: stakeholder-proxy is not installed"
```

**Both inputs, or stop.** A recommendation without a ruled first proof is a ranking with a
confident tone; `/build-portfolio` stage 7 is where that ruling happens and it cannot be made
here. ⚠ **The path in the guard is the path stage 7 writes, as one string.** A guard that names a
path is an interface contract with the step that writes the file; an earlier version tested
`demo/prototype-choice.md` while the upstream command wrote under `portfolio/`, and it printed
*no first proof has been ruled* on every repository the upstream command had ever produced — the
one message that will be believed.

⚠ **Check the portfolio's stop-check before using it.** If `portfolio/stop-check.md` shows the
confrontation box unticked — and it will — **D#3 inherits that**, and stage 4 must say so on
the document's face. A recommendation cannot be more confronted than the portfolio it rests on.

### 1. Gate GR1, then SPEC Part III — the contract before the document

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

**Use the assumptions register for what the work is standing on.** The register is the frame's:
cite its ids (`A<n>`), and where D#3 must register a new assumption, continue that series and
record the extension in the identifier registry — never mint a second series for a register the
frame already keeps (`derivation-orchestration` §7; an earlier version of this line said `AS-n`).
Cite **inline where load-bearing, never as a footnote.** ⚠ **An assumption is not evidence:**
registering one moves no marker, discharges nothing and moves no version. **What it does is let
the work proceed without the conversations that have not happened** — the maturity scheme
governs what may be *asserted*, not what may be *built*.

### 3. Stage 3 — the proxy pass, then Gate GR2

Invoke `stakeholder-proxy` on the outline. **Give it the identity from the intake's `Sponsor`
field** — role,
what they are measured on, what they have already seen — **and its output path,
`recommendation/recommendation-agenda.md`.** The proxy writes that file itself; it has the tool
and its contract confines it to that one path. ⚠ **Do not transcribe its report into the file
from the hand-back.** An earlier version had the proxy return its agenda as a message and the
parent re-type ~150 lines into a file nobody compared against the message; a copy step nobody names
is a copy step nobody verifies. This is the command where the pass belongs: the selection is
defended here, and this is the one document its reader will actually read.

Then fold the agenda into **Gate GR2**: the ranked questions, each with what breaks if the answer
goes the other way, plus any critic findings needing a ruling.

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

⛔ **The ask says what its authors want.** In a targeted engagement the sponsor reads cold and has
commissioned nothing; the contract rightly forbids a fee, an engagement shape and a commercial
proposal — and none of that is a prohibition on candour about interest. **One sourced sentence,
beside what the document does not ask for**, stating what the authors want from the meeting, taken
from the frame's operating-model statement. On the run this comes from, three critic passes read the
ask and missed the hole; the proxy, reading as the sponsor, found it in four minutes: *he is being
offered a free demonstration by people who have not said what they want from him — a cold reader
supplies a motive, and never the flattering one.*

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

**The verifier is a script under `recommendation/tools/`, and it holds three properties**
(`derivation-orchestration` §6, the verification clause):

1. **Two denominators for every completeness check.** The annexe of rulings is checked against
   Part III's map *and* against every `GR<n>-R`, `GP<n>-R` and post-arc id in the registers; the
   assumptions annexe against the frame's `A` register. On the run this comes from, the check was
   transitive through the author's outline, and a ruling applied to the page without an outline edit
   passed with its row missing.
2. **Expected counts derived, never typed.** Every count the page asserts about itself is
   recomputed from the page's own rows or from an upstream file; the script then lists every number
   word in the prose that no derivation covers, so the coverage denominator is visible. The author's
   drafting numbers typed into the script and compared to the page is the drafting run twice.
3. **The mutations it was shown, listed in the worksheet.** Before this stage is called done, apply
   single defects to a copy of the page — drop an annexe row, un-strike a withdrawn clause, swap
   two citations, change a count by one, add a second version string, remove a source attribute —
   and record which the verifier caught. Ones it passed are findings. `strategy-critic` runs the
   same harness on this stage.

Then write `deliverables/recommendation-confrontation-worksheet.md`: each claim the
recommendation stands on, where it is used, what breaks if it is false, and an empty ruling
slot. **Carry the portfolio's unticked confrontation box into it as the first row.**

## Gates

| Gate | When | The rulings |
|---|---|---|
| **GR1** | Before stage 1 | The contract — audience, structure, design identity, constraints, stop condition, and what Part III inherits unchanged from Parts I and II |
| **GR2** | Stage 3 | The proxy's agenda, ranked, plus any critic findings needing a ruling. Which questions go into the room, and which claims come out of the document first? |

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
the owning command, and take it to Gate GR2 if it is load-bearing.

**The sponsor's context arrives after the document** — the four-hour conversation this document
exists to open — and no stage of any arc takes it as input. Walk the confrontation worksheet with
it, mark each claim discharged, overturned or still open, and say what re-derives and what is only
annotated. That re-entry is not yet a command; until it is, the worksheet's ruling column is where
the harvest lands, and nothing else may absorb it informally.

**The portfolio's stop-check has failures beyond the confrontation box** — report them and ask
whether to proceed. D#3 can be built on an incomplete portfolio; it cannot be built on one
whose incompleteness is unstated.

## Committing

Commit locally after each stage, naming the stage and what it produced. **Never push.**


## Example Output

```
## /build-recommendation — resumed at stage 3

Inputs: D#2 (V0.5, frozen) · portfolio/demo/prototype-choice.md (UC-04, ruled 2026-09-04).
Portfolio stop-check: 5 of 6 boxes ticked. Confrontation box UNTICKED — inherited,
and D#3 will say so on its face.
Subagents registered: strategy-critic, stakeholder-proxy.

**Produced since last run**
  recommendation-outline.md   31 claims, each sourced to a D#2 record ID
                              4 claims had no source — listed as gaps, not written
  recommendation/recommendation-agenda.md  9 questions, ranked, written by the proxy
  critic pass on stage 2      2 findings — both fixed

**⚠ GATE GR2 — three rulings, then stage 4 writes D#3**

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
