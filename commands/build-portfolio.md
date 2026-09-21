---
description: Derive a use case portfolio for a function — traverse or adopt, assemble, account for every candidate, score, rank, attack, and select the first proof — stopping at each gate for a human ruling
argument-hint: [phase]
---

# Build Portfolio

Run the derivation from a function to **D#2, the use case portfolio**, following
`use-case-portfolio-derivation`. Eleven stages, **five gates where a human decides**.

⚠ **Load `derivation-orchestration` before anything else.** It carries the guards (§1), the
resume rule (§2), gate batching (§3), the reviewer and proxy protocols (§4–5), the marker and
ID rules (§6) and the commit rule (§7). **This file carries only the sequence and what is true
of a portfolio and nothing else.** Where the two disagree, the skill wins and the disagreement
is a defect to report.

## Who D#2 is for

⚠ **D#2 is a working instrument. It is not shown to the sponsor, and making it
presentable is not a goal.** Comprehensiveness is its job — every candidate accounted for,
every dimension separable, the orders that disagree left disagreeing. Three attempts to make
such a portfolio sponsor-readable ended in the honest conclusion that the fix is **to split the
document, not to choose between the readers.** The sponsor's version is D#3, written *from*
this one by `/build-recommendation`, and it never re-derives it.

**So: no summarising for a reader who will not read it. No collapsing a table because it is
long.** If something here is too raw to show anyone, that is the artefact working.

## What This Command Does

| # | Produces | Driver |
|---|---|---|
| 0 | guards | **Agent** (Bash) · `derivation-orchestration` §1 |
| 0a | `portfolio/entry.md` — the entry path | **Agent** → **⚠ Gate P1** *only if ambiguous* |
| 1 | the five layers | **Agent** · skill §1 — **skipped when adopted** |
| 2 | `use-cases.md` + `filter-log.md`, arithmetic shown | **Agent** · skill §2 → **⚠ Gate P2** |
| 3 | `positioning-matrix.md` + `portfolio.md` | **Agent** · skill §3 |
| 4 | `portfolio-ranking.md` | **⚠ Gate P3 first** (the weighting) → **Agent** · skill §4 |
| 5 | `orders.md` — both, kept apart | **Agent** · skill §5 |
| 6 | `challenge-round.md` | **Agent** · skill §6 → **⚠ Gate P4** |
| 7 | `selection-criteria.md` → `demo/prototype-choice.md` | **⚠ Gate P5 first** (your criterion) → **Agent** · skill §7 |
| 8 | `deliverables/agentic-use-case-portfolio.html` | **Agent** · `html-style` · `analytical-document-build` |
| 9 | `stop-check.md` | **Agent** · skill stop condition |

`strategy-critic` runs after every stage, per §4, and files its pass at `portfolio/critic/<stage>.md`
— never in `strategy/critic/`, where D#1's stages 2 to 5 would be overwritten. Rulings go in
`portfolio/rulings.md`, one row each, identifier `P<gate>-R<n>`; the progress page reads both paths.
**`stakeholder-proxy` does not run in this command** — it reads as the sponsor, and no sponsor reads D#2. It belongs in
`/build-recommendation`, where the selection is actually defended. Running it here is a pass
with no audience.

## The join with `/build-strategy`

**Stage 0a decides the entry path and writes it to `portfolio/entry.md`.** Every later artefact
header names it, and D#2 states it on its face.

| Path | When | What it does |
|---|---|---|
| `adopted` | `strategy/` holds the maps, drivers and opportunity map | **Inherits every ID. Mints none.** The filter log reconciles against the strategy's opportunity map, so the arithmetic is checkable across both arcs |
| `traversed` | No strategy artefacts | Runs skill §1 itself into `portfolio/`, using the same filenames, and says so |

⚠ **Phase 1 of the portfolio *is* stages 3–6 of the strategy** — areas, activities, pains,
value drivers, opportunities. **Never re-traverse a function that has already been traversed.**
A second traversal mints a second set of IDs for the same work, and `derivation-orchestration`
§6 is unambiguous: IDs are the spine and are never re-minted. The two sets then both look
valid, cite different things, and nothing reports the divergence.

⚠ **Do not carry the strategy's sizing into the selection.** Stage 7a of `/build-strategy`
sizes opportunities **marginally**, and every marginal score presupposes the shared foundation
already exists — true of every candidate except the first, which is the one being chosen.
**Phase 7 re-costs finalists at full load**, and candidates that look equivalent under marginal
scoring routinely differ several-fold there. Reusing 7a figures at stage 7 is the single
easiest way to choose the wrong first proof while showing your working.

## Usage

```bash
/build-portfolio            # resume from wherever the artefacts stop
/build-portfolio 3          # re-run one stage deliberately
```

## Implementation Steps

### 0. Guards

⭐ **First action: call `EnterPlanMode`.** Steps 0 and 0a read and decide; they write nothing until
the entry path is approved. The entry report — the guards' results, the three strategy artefacts
found or not found, the path this implies and, on a partial strategy, Gate P1's three options with
their costs — is the plan. Approval exits plan mode; `portfolio/entry.md` is the first write and
carries the path as approved. On a resumed run the resume report is the plan instead.
`derivation-orchestration` §1. If the host has no plan mode or the person declines, run the same
steps read-only by instruction and record in `entry.md` that the entry ran without it.

Run both guards from `derivation-orchestration` §1 against the same `intake.md`
`/build-strategy` uses — this command does not have its own intake.

```bash
[ -f intake.md ] || { echo "STOP: intake.md missing"; exit 1; }
grep -nE '^\*\*[^:]+:\*\*[[:space:]]*(\[|$)' intake.md \
  && echo "STOP: the fields above are unfilled" || echo "intake complete"
cc="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"   # a plugin install puts agents under plugins/cache
ls .claude/agents/strategy-critic.md "$cc"/agents/strategy-critic.md \
   "$cc"/plugins/cache/*/s2p-strategy/*/agents/strategy-critic.md 2>/dev/null | grep -q . \
  || echo "STOP: strategy-critic is not installed"
```

**Two fields carry the whole of stage 7.** Field 7, the central proposition, is quoted verbatim
into the selection criteria — never paraphrased, and never written by you. Field 8, who the
transformation is for, decides what §1 traverses if the path is `traversed`.

### 0a. Decide the entry path, and write it down

```bash
ls strategy/*-opportunity-map.md strategy/*-value-drivers.md strategy/*-pain-map.md 2>/dev/null
```

All three present → `adopted`. None → `traversed`. **Some but not all → stop and ask** (Gate
P1): a partial strategy is the one case where adopting silently produces a portfolio whose
spine is half inherited and half invented.

Write `portfolio/entry.md`: the path, what was found, and — if `adopted` — the count of
opportunities inherited, which is the denominator every later accounting reconciles to.

### 1. Phase 1 — traverse, or skip

**When `adopted`, produce nothing here.** Say which strategy artefacts are standing in for this
phase and move to stage 2.

When `traversed`, follow skill §1 into `portfolio/`, one file per layer. **The opportunity count
should be uncomfortably large** — several times the expected portfolio size. If it is not, the
traversal stopped early, and a portfolio derived from a small field cannot say what it excluded.

### 2. Phase 2 — assemble, and account for every candidate

A use case is **one trigger, one output, one verifier** — not a theme and not a capability.

**Then the filter log, and it must be exhaustive.** For all *n* opportunities: which use case
absorbed it, or which named filter removed it and where the concern was routed instead.
`n_assembled + n_filtered = n_total`, **arithmetic shown.** This one table is what converts the
portfolio from an assertion into a record, and it is the artefact that survives longest.

**Name the filters before applying them, in a fixed order.** A filter invented to justify a
specific exclusion is not a filter.

⚠ **Account at every level, not only the first.** Opportunities → use cases → shortlist →
selection. Filtering discipline does not propagate down a chain of aggregation on its own, and
the failure is invisible because the early rigour is what everyone remembers.

⚠ **Report what each filter removed, by count. A filter that removed nothing has not been
applied — it has been interpreted into vacuity, and it is reported as unfiltered, never as
passed.** And **test each filter against a candidate you believe it should kill**: running a
filter over things it happens to pass proves it runs, not that it discriminates.

⛔ **If the commercial model requires the first proof inside a fixed time budget, that budget is
one of the named filters here — never a scoring dimension in Phase 3.** Where a demonstration
must stand up in a meeting, in an afternoon, or in ten minutes, it is a **precondition of the
first proof**, and scoring lets a high total outvote it while a filter cannot be outvoted. A use
case can otherwise rank first on value and traceability and be unbuildable in the time the model
allows — and the speed is what makes the portfolio credible, so a proof that misses it fails at
the thing it was for.

- State the budget **as a number** in `filter-log.md`, so a reader can disagree with it.
- ⛔ **Removed is not discarded** — rank the excluded set separately and keep it. **Those are
  portfolio items; they are simply not the proof.**

**Record bundling as the judgement it is.** Where a bundle could reasonably have been two use
cases, say so — aggressive bundles are the most attackable decisions here and should be the
easiest for a reader to find. That is Gate P2.

### 3. Phase 3 — score profiles, and refuse to collapse them

Score each dimension separately and **keep them separate.** A collapsed score is a weighting,
and the weighting is not yours to choose.

### 4. Gate P3, then Phase 4 — collapse only on a ruling

**The weighting is the sponsor's.** Put it at Gate P3 before any collapse, and when you
collapse, **mark the translation** — which weighting, whose, and that the arithmetic is yours.

### 5. Phase 5 — keep the orders apart

Where two defensible orders disagree, **publish both and treat the disagreement as the
finding.** Say which order governs what. ⚠ **Re-ranking is not evidence** — a second ordering
over the same unconfronted judgements inherits their uncertainty in full and makes the
portfolio feel more examined than it is.

### 6. Phase 6 — attack it, and be honest about what the attack is worth

Run the adversarial pass, then **state inside the artefact that it discharges nothing.** It is
the same author attacking their own work. ⚠ **If it retires the conversation with a
practitioner, it has made things worse** — a document that reads like confrontation and is not
is more dangerous than one that never claimed to be. Gate P4 asks which findings need a ruling.

### 7. Gate P5, then Phase 7 — select one

⚠ **A portfolio that cannot be selected from is not finished, and nothing earlier notices.**
Phases 1–6 produce a defensible list; a list is not a decision.

**Do not select on the ranking.** A ranking orders things under a weighting; it does not answer
*which do we build*. Different questions, different criteria, kept apart.

**Derive the criteria from the constraint that actually binds the build** — synthetic data, a
system nobody may touch, a regulator, an unavailable dataset. Three or four, **named before
anything is scored.** ⚠ **Expect them to go silent**: after the field is filtered they often
separate none of the survivors, which is not failure but **what a filter looks like when it has
finished its work.** Report it as a finding, and say plainly that choosing now needs a criterion
that still cuts.

**Gate P5 gathers what the method cannot supply**, and it comes *before* any scoring — written
after, it is a rationalisation indistinguishable from one:

1. **Does this candidate prove the argument, or merely that the technology works?** Quote
   **the central proposition** verbatim on its own line — ruled at `/build-strategy`'s Gate 0 and
   recorded in `strategy/frame.md`, *not* read off the intake form — and put the question against
   it. **Do not answer it for them.**
2. **Has this room already seen this demonstrated three times?** Market saturation is real,
   appears on no record, and **a plausible-sounding guess here removes the strongest
   candidate.** Ask; never infer.

**Then re-cost every finalist at full load** — the whole cost of every shared component it
touches, plus its own marginal cost. Check whether ordering changes the total; it usually does
not, because the same infrastructure gets built either way. ⚠ **The defensible claim is
therefore about how much is spent before anything is visible, not about programme cost** —
anyone told the stronger version will find the weaker one and stop trusting the analysis.

Write `demo/prototype-choice.md` as a record someone can disagree with at a named step: the
funnel as counts reconciling to the total · the proposition quoted verbatim · the criteria
stated before they are applied · **every exclusion naming the criterion that removed it** —
⚠ *"the others scored lower"* is not an exclusion, and a selection is made of exclusions · the
strongest objection beside the decision rather than at the end, with the unanswered part named
· and **what was declined**, because a decision showing only the option taken cannot be
re-judged once the live alternatives are gone.

### 8. Stage 8 — D#2

Write to `deliverables/`. **Never publish via the Artifact tool.** Re-read every number that
changed register on the way in: ⚠ **a hedged estimate in a working file becomes a confident
finding when it is promoted to a headline.**

### 9. Stage 9 — the stop condition

Write `portfolio/stop-check.md` against the skill's stop condition, box by box:

- [ ] Every original candidate is accounted for
- [ ] Every entry traces to the function
- [ ] Every score is separable from every other
- [ ] The weighting is the sponsor's and the arithmetic is marked as yours
- [ ] ⚠ **Every level of aggregation has excluded something, or is reported as unfiltered**
- [ ] At least one claim has been confronted by someone who works there

⚠ **The last box will be unticked and must stay unticked** — no subagent can tick it. **Until
then the portfolio is a well-built hypothesis, and D#2 says so.** The fifth box is the one whose
absence went unnoticed for weeks: a portfolio in which nothing was ever ruled out passes every
other check while that is true.

## Gates

| Gate | When | The rulings |
|---|---|---|
| **P1** | Stage 0a, only if partial | The strategy is incomplete — adopt what exists, traverse fresh, or finish the strategy first? |
| **P2** | Stage 2 | The filter log reconciles at *n*. Which bundles are too aggressive, and which filters removed nothing? |
| **P3** | Before stage 4 | The weighting — whose, and what weights? Nothing collapses until this is answered. |
| **P4** | Stage 6 | The attack landed *N* findings. Which need a ruling before the selection? |
| **P5** | Before stage 7 | Does this prove the argument · has this room seen it before · and the criteria, before anything is scored. |

## Important Notes

- **NEVER re-traverse an already-traversed function.** Adopt the IDs or stop.
- **NEVER carry marginal sizing into the first-build decision.**
- **NEVER make D#2 presentable.** Its comprehensiveness is the point; D#3 is the readable one.
- **NEVER report a filter that removed nothing as passed.** It is unfiltered.
- **DO NOT select on the ranking**, and do not let a second ranking retire a question.
- **DO NOT answer Gate P5's first question.** The proposition is the human's, quoted not
  paraphrased.
- **DO NOT push.** Commit locally after each stage.

## Error Handling

**Intake missing or unfilled** — `/build-strategy` owns the template. Point at it and stop.

**A partial strategy** — Gate P1, always. Never adopt part of a spine.

**The filter log does not reconcile** — stop and report the gap as a number. Do not adjust the
total to make it balance; the discrepancy is a finding about the traversal.

**Phase 7 criteria separate nobody** — that is a result. Report it, and ask for a criterion that
still cuts rather than inventing one.

## Committing

Commit locally after each stage, naming the stage and what it produced. **Never push.**


## Example Output

A gate is one pass — its own question, the critic's rulings, each with a recommendation and
what the other answer costs.

```
## /build-portfolio — resumed at stage 2

Inputs: [organisation] · [function] · sponsor SOLE · for: the function.
Entry path: ADOPTED — 86 opportunities inherited from strategy/dg-opportunity-map.md.
Stage 1 skipped: the strategy's maps stand in for phase 1. IDs inherited, none minted.
Subagents registered: strategy-critic.

**Produced since last run**
  portfolio/use-cases.md     29 use cases, one trigger / output / verifier each
  portfolio/filter-log.md    29 assembled + 57 filtered = 86  ✓ reconciles
  critic pass on stage 2     5 findings — 3 fixed, 2 need you (2 and 4 below)

**⚠ GATE P2 — four rulings, then stage 3 runs**

1. Filter F3 "outside the function's control" removed 0 of 86.
   Logged as UNFILTERED, never as passed. Recommend: name the candidates
   it should have killed and re-run it, or withdraw it. Cost of leaving
   it: the log shows five filters and only four ever did anything.

2. UC-11 bundles seven opportunities across two areas.  [critic, stage 2]
   Recommend splitting it. Cost of not: it is the most attackable entry
   in the portfolio and a sceptic finds it first.

3. UC-04 and UC-19 share a verifier and could be one record.
   Recommend keeping both, marked as a live merge. Cost: two records
   that may collapse anyway at stage 4 once the weighting is ruled.

4. Three opportunities were routed to "governance, not AI".  [critic, stage 2]
   That destination is not a filter in the log. Recommend adding it as F6.
   Cost of leaving it: three candidates left the field through a door
   the accounting does not have.

Nothing proceeds until all four are answered. Stage 2 committed as 4a71e0d.
```

**What the example is showing.** Ruling 1 is not a defect to fix — it is a filter reporting
honestly that it did nothing, which the method requires and which reads like a failure. Rulings
2 and 4 came from the critic; **it reported them and made no call on either.** The sorting into
*fixed*, *ruled* and *discarded* is this command's, always.
