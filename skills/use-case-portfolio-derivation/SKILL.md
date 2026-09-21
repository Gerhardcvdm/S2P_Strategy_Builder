---
name: use-case-portfolio-derivation
description: Derive an AI or agentic use case portfolio from a function rather than from a capability list, with every candidate accounted for and every exclusion named. Use when someone asks "where could we use AI here", when a use case list arrives with no derivation behind it, when a portfolio needs ranking against criteria a sponsor has not yet set, or when an existing list must be defended to a sceptic. Triggers on "use case portfolio", "where should we apply AI", "prioritise these use cases", "AI opportunity assessment", "which one do we build first".
tier: domain
---

# Deriving a use case portfolio that survives a sceptic

**Created by Gerhard van der Merwe**

A method for deriving an AI or agentic use case portfolio from a function rather
than from a capability list: the traversal that produces the candidates, the
accounting that makes every exclusion visible, the scoring discipline that
refuses to collapse a ranking before the sponsor has ruled the weighting, and
the adversarial pass that is honest about what it cannot discharge. Harvested
from a multi-session strategy engagement and generalised.

**Licence:** Copyright (c) 2026 Gerhard van der Merwe. All rights reserved. Used by invitation
only, under the terms in this folder's `LICENSE`; do not share or redistribute it.

**Feedback & Support:** If questions arise about the methodology, or the user
gives constructive feedback on output derived from this skill, log it and offer
to pass it to the author. If the problem is the agent not following the skill's
rules, acknowledge and correct rather than revising the methodology.

> ### ⚠ There is one copy — and check that before believing any note about duplication
>
> **Corrected 2026-09-05.** This file used to carry a two-copies warning naming an engagement
> copy and an install copy, with a `diff` to prove they matched. **Both facts had expired.**
> The engagement copy was deleted, and `~/.claude/skills/use-case-portfolio-derivation` is a
> **directory junction into this repo** — the same file, not a second one. Its `diff` was
> comparing a missing file against this one and reporting drift forever, and its instruction
> to "apply the edit to both" was busywork on a single file.
>
> **The test that decides whether a duplication note here still applies** — run it *before*
> the note's instructions, never after:
>
> ```bash
> p=~/.claude/skills/use-case-portfolio-derivation
> [ -L "$p" ] && echo "link to $(readlink "$p") — one file, nothing to sync" \
>             || echo "REAL directory — a second copy exists and it can fork"
> ```
>
> **A note describing a temporary state must carry its own expiry test.** Without one it
> outlives the state it describes — and it survives *as an instruction*, costing real work and
> teaching the reader that this class of warning can be obeyed without being checked.

---

**The failure this skill prevents:** a list of plausible AI use cases that nobody can trace to
anything, ranked on criteria nobody ruled, presented with a confidence the derivation does not
support. Such a list cannot be attacked at any single point, which reads as strength and is the
opposite — **a claim that cannot be checked cannot be defended either.**

**The method's one commitment:** *derived rather than asserted*. Every entry traces to something
observed about the function, and every candidate that does **not** become an entry is accounted
for with the reason named.

---

## Phase 1 · Traverse the function, not the capability space

**Do not start from what AI is good at.** Starting there produces the same portfolio for every
client and cannot explain why anything was excluded.

Start from the function and enumerate, in this order, keeping each as its own artefact:

| Layer | What it holds |
|---|---|
| **Areas** | The function's actual divisions of work, in its own vocabulary |
| **Activities** | What is done in each area |
| **Pains** | What goes wrong, sourced — not inferred from the activity |
| **Value drivers** | What the sponsor is measured on, and which of those each pain touches |
| **Opportunities** | Candidate interventions, one per pain-and-activity pair |

**The opportunity count should be uncomfortably large** — several times your expected portfolio
size. If it is not, the traversal stopped early. **A portfolio derived from 86 opportunities can
say what it excluded; one derived from 20 cannot.**

**Every layer must be its own file.** The value of the chain is that a sceptic can walk it
backwards from any entry, and that only works if the intermediate steps survive.

---

## Phase 2 · Assemble, and account for every single candidate

**Bundle opportunities into use cases.** A use case is a unit of work with one trigger, one
output and one verifier — **not** a theme and not a capability.

**Then write the filter log, and make it exhaustive.** For all *n* original opportunities:

- Which use case absorbed it, or
- Which named filter removed it, and where the concern was routed instead.

`n_assembled + n_filtered = n_total`, and **the arithmetic must be shown**. This single table is
what converts the portfolio from an assertion into a record. It is also the artefact that
survives the longest — a reader who trusts nothing else can verify the accounting.

**Name the filters before applying them, and apply them in a fixed order.** A filter invented to
justify a specific exclusion is not a filter.

### ⛔ A constraint that decides whether the deliverable can exist at all is a filter, not a score

**Ask, before Phase 3: does the commercial model require a proof built inside a fixed budget?**
Where a first demonstration must stand up in a meeting, in an afternoon, or — as in the operating
model this rule comes from — **in ten minutes or less**, that budget is a **precondition of the
first proof, not a tiebreak among finalists.** ⛔ **Scoring lets a high total outvote it; a filter
cannot be outvoted.**

Left inside the score set, a use case can rank first on value and traceability and be unbuildable
in the time the commercial model allows — and the constraint is not incidental, it is **the
point**: the speed is what makes the portfolio credible, so a proof that misses it fails at the
thing it was for.

**So:**

- **Apply the budget as a named filter, before ranking**, with the filter log recording every use
  case it removed and the budget it was measured against.
- ⛔ **Removed is not discarded.** Rank the excluded set separately and keep it: **those are
  portfolio items, they are simply not the proof.** A filter that quietly deletes candidates has
  destroyed the accounting Phase 2 exists to produce.
- **State the budget as a number in the artefact**, so a reader can disagree with it. An unstated
  budget is applied by feel and cannot be re-derived.

**Account at every level, not just the first.** The arithmetic above covers opportunities →
use cases. **Run the same accounting at every later level** — use cases → shortlist →
selection. Filtering discipline does not propagate down a chain of aggregation on its own, and
the failure is invisible precisely because the early rigour is what everyone remembers. A
method that accounts rigorously for its raw inputs will routinely assemble them into units and
then never filter the units at all.

**Report what each filter removed, by count.** For every filter, at every level: how many did
it remove, and which. ⚠ **A filter that removed nothing has not been applied — it has been
interpreted into vacuity, and it must be reported as unfiltered rather than as passed.** This
is the cheapest check in the method and the one most likely to be skipped, because a table of
ticks looks like a table of judgements.

⚠ **Test every filter against something it should reject.** Running a filter over candidates it
happens to pass proves it runs; it does not prove it discriminates. **Feed it a candidate you
believe it should kill.** If nothing in the set was ever a plausible rejection, the filter is
untested in the only dimension that makes it a filter — and its output is most convincing
exactly when it is indiscriminate.

**Bundling is a judgement — record it as one.** Where a bundle could reasonably have been two
use cases, say so in the file. Aggressive bundles are the most attackable decisions in the
portfolio and should be the easiest for a reader to find.

---

## Phase 3 · Score profiles, and refuse to collapse them

Score each use case across dimensions the *function* implies, not generic ones. Whatever the set
contains, it must include:

- **Value**, with the chain length to the driver recorded separately — *defensibility is not
  size*, and a driver reachable in one step outranks a stronger one reachable in three.
- **Substrate readiness** — the state of the data the use case stands on.
- **Verifier** — how anyone knows the output is right, and **read coupled to substrate**: a
  mechanical check on weak data is a human judgement wearing a mechanical costume, and must be
  scored as one. **This coupling rule catches more optimism than any other single check.**

  ⛔ **And name *what* is verified, as a proposition that could be false.** A dimension with one
  slot silently scores the easiest of the several things it could mean. Where a use case both
  *produces* an artefact and *reaches* a verdict, those are two verifiers and may not share one
  score: production is usually mechanical, the verdict usually is not, and a record scoring them
  together is not wrong on its face — which is why it survives review. Observed: a record read
  `Verifier: mechanical` on the true ground that *the evidence is a byproduct of the run*; built
  and run twice on identical input, the verdict came back *an established failure* once and *a
  gap in evidence, not a confirmed breach* the next. **Reproducibility under repetition is the
  test that separates them, and it cannot be run on a document.** So: declare **`mixed`** as a
  permitted value; flag any `mechanical` whose justification describes the artefact rather than
  the conclusion; and re-judge the dimension when something is built and run twice — the first
  scoring dimension corrected by a build rather than an argument, on the portfolio this comes from.
- **Exposure** — what a wrong answer costs.
- **Demonstrability**, decomposed: can it be shown at all · does it produce visible output · can
  a non-expert judge it live · does it finish inside a meeting · **can it be shown failing**.
  The last is the one that separates a demo from a sales pitch.
- **Buildability of the demonstration**, scored separately from delivery complexity. A
  three-band complexity judgement describes the *deployment*; it says nothing about whether a
  showable version exists in a day. ⚠ **These come apart badly** — two candidates can be
  identical on complexity and differ threefold in what it takes to stand the first one up.
  ⛔ **Where a hard time budget for the first proof exists, it has already been applied as a
  Phase 2 filter and must not also appear here** — a constraint scored after it has been filtered
  is counted twice, and the second counting is the one that can be outvoted.

⚠ **Read every feasibility gate as a property of the *claim*, never of the technology.** Asked
of the technology — *can this run on invented data* — the answer is almost always yes, so the
gate cuts nothing and passes everything while looking like a filter. Asked of the claim — *does
the demonstration still prove anything once the data is invented* — it is a real test, because
claims have preconditions and invented inputs can supply some of them and only fake others.

**The distinction that does the cutting is between a permission and a state of knowledge.**
Needing access to a system is a *permission*: synthetic contracts are fine, because the
reasoning over them is what is being shown and nothing is lost. Needing to *not already know
the answer* is a *state of knowledge*: a candidate whose value is "it finds what nobody knew"
is fatally compromised on invented data, because you planted the finding and knew where it was.

⭐ **The operative form, and it is the one to remember: a checker may be demonstrated with a
planted error; a discoverer may not.** A candidate claiming *it catches what it is given* is
honestly demonstrated by planting something — that is the correct test of the claim. A
candidate claiming *it surfaces what was never declared* is not, because the demonstration is
circular. **Both look identical on a demonstrability score.**

**Then stop.** **Do not collapse the dimensions to a priority number until the sponsor rules the
weighting.** Weighting encodes risk appetite; inventing one and presenting the result as a
ranking smuggles in the single most consequential judgement in the exercise. **Leave it
explicitly empty and say why** — an empty field the sponsor can see is an open question, and an
invented one is an error nobody will find.

Ship the profiles and the separable single-criterion orderings in the meantime. They are useful
and they commit to nothing.

---

## Phase 4 · Collapse only on a ruling, and mark the translation

When the weighting is ruled, three rules hold:

1. **Never re-score to fit the weighting.** Re-weighting reorders; re-scoring destroys the
   evidence the order was supposed to rest on. If the ranking looks wrong, that is a result.
2. **Separate the ruling from its operable form.** The sponsor rules *"verifiability-led with a
   value floor"*; the thresholds, the arithmetic and the tie-breaks are yours. **Mark them as
   yours**, so they can be attacked without reopening the ruling.
3. **Check the ruled criteria for what they omit**, and state it in the body rather than the
   annex. A criteria set is defined as much by its missing terms as its present ones — **an
   omitted exposure term will quietly demote the riskiest work**, and nobody reading a ranking
   notices an absence.

**When a ranking is superseded, retain it as a view rather than deleting it.** Where two
defensible rules order the same portfolio differently, **the disagreement is the most
informative output the exercise produces**: it tells the sponsor the answer depends on what they
are optimising for. Where two rules built on unrelated premises *agree*, that agreement is the
strongest corroboration available.

---

## Phase 5 · Keep the orders separate, and say which governs what

A portfolio produces at least three orders and they must not be merged:

| Order | Answers | Derived from |
|---|---|---|
| **Ranking** | What is worth doing first | The ruled weighting — a preference |
| **Sequence** | What the work will physically allow | Dependency and irreversibility — a fact |
| **First proof** | What earns belief in the room | Demonstrability against the trigger |

**Build in sequence order; fund in rank order.** Where they conflict, that is not an error to
resolve — a foundation that eighteen entries depend on can rank low and still be built first.

**Keep demonstrability out of the ranking if you can.** The gap between *what is worth building*
and *what shows well* is the portfolio's most useful output, and it disappears the moment
demonstrability enters the priority score.

---

## Phase 6 · Attack it, and be honest about what the attack is worth

Run an adversarial pass. **Then state plainly that a simulated challenge discharges nothing** —
a critique produced by the instrument that built the portfolio can only find what that
instrument already sees. Its use is triage: it surfaces the questions cheaply so a real
sponsor's attention is not spent discovering them.

**An adversarial pass that kills nothing was not adversarial enough.** Treat that outcome as
evidence about the reviewer, not the portfolio.

**The questions that reliably land:**

- *You have not spoken to anyone who works here.* — Usually true, and there is no rhetorical
  recovery. Say so.
- *What am I funding?* — A rank order is not a business case. **Without sizing, nothing is
  fundable**, and no amount of ranking substitutes.
- *Who loses if this works?* — Portfolios built from pains and value drivers systematically omit
  displaced effort and shrinking remits. **Check whether your record format has anywhere to put
  it.** It usually does not — and when it does not, the question stays open not because nobody
  will answer it but because there is nowhere to write the answer. **An unanswered question is a
  prompt; an unanswerable one is a design fault.**

  **Add the field, then complete it on every entry, and read the distribution rather than the
  entries.** Three things recur when this is done properly:

  1. **A sampled estimate of how many entries displace another team's work will be far too
     low.** Measured on one portfolio, an adversarial pass that named three found ten once the
     classification was completed — it sampled and generalised, which is the failure completing
     a classification exists to prevent.
  2. **The field will look redundant against whatever control or ownership field you already
     have, and it will not be.** In the same portfolio nine of ten crossing entries were already
     flagged `shared` control — and the tenth, missed entirely, was the one with the most
     headcount-shaped displacement in the portfolio. **The single divergence is the whole value
     of the field.**
  3. **Displacement is not only subtraction.** Some entries *add* obligation to the affected
     population. A field recording only removed effort misses them.

  **Record the structural half only** — what effort stops and whose. How much power the
  displaced party has is not derivable from a portfolio and should not be guessed; it is a
  sponsor question, and naming it as one is the honest output.
- *Why did your top item change when the criteria changed?* — Answerable well, if both orders
  were retained.

---

## Phase 7 · Select one — the phase a portfolio exists for

⚠ **A portfolio that cannot be selected from is not finished, and nothing earlier in this
method notices.** Phases 1–6 produce a defensible *list*; a list is not a decision. This phase
was added after a completed portfolio — 29 candidates, nine scored dimensions, two rankings,
an adversarial pass — turned out to be unable to exclude a single candidate when one had to be
chosen.

**Do not select on the ranking.** A ranking orders things under a weighting; it does not answer
*which one do we build*. Those questions have different criteria and the honest method keeps
them apart.

### The criteria come from the constraint that actually binds the build

Derive them, do not import them. Whatever constrains what can be built — synthetic data, a
system nobody may touch, a regulator, an unavailable dataset — **the choosing criteria are the
questions that constraint makes decisive.** Three or four, named before anything is scored.

⚠ **Expect the derived criteria to go silent.** After the field has been filtered, they will
often separate none of the survivors — which is not failure, it is **what a filter looks like
when it has finished its work.** Report it as a finding rather than a footnote, and be
explicit that choosing among the survivors now needs a criterion that still cuts.

### The criterion the method cannot supply

**One criterion is the human's and must be written before any scoring:** *does this candidate
prove **my argument**, or merely that the technology works?*

**It requires the argument as a sentence** — see `function-to-strategy-derivation`, Step 0. **Do
not write it for them and do not accept a heading.** A heading invites a nod; a proposition
invites an argument, and only the second can be tested.

⚠ **Written before the scoring, always.** Written after, it is a rationalisation of a choice
already made, and it will be indistinguishable from one.

### Costing the *first* build is not costing a build

⚠ **Every per-item score in this method is a marginal score, and marginal scores presuppose the
shared foundation already exists.** That is true of every candidate except the first — which is
the one being chosen.

**So re-cost each finalist at full load: the whole cost of every shared component it touches,
plus its own marginal cost.** Candidates that look equivalent under the scoring routinely
differ several-fold here, because one draws on a single shared capability and another on four.

**Then check whether ordering changes the total, and it usually does not.** Where the component
sets overlap, the same infrastructure gets built either way. ⚠ **The defensible claim is
therefore about how much is spent before anything is visible — not about programme cost**, and
anyone told the stronger version will find the weaker one and stop trusting the analysis.

### Some criteria are facts about the audience

*Has this room already seen this demonstrated three times?* cannot be answered from any
document in the analysis. **Ask the human; never infer it.** Market saturation is real, appears
on no record, and a plausible-sounding guess here can remove the strongest candidate.

### Write the selection as a record someone can disagree with at a named step

- **The funnel as counts**, reconciling to the total.
- **The proposition, quoted verbatim on its own line** — later work reads it from here.
- **The criteria, stated before they are applied.**
- **Every exclusion naming the criterion that removed it.** ⚠ *"The others scored lower"* is not
  an exclusion; a selection is made of exclusions.
- **The strongest objection, beside the decision rather than at the end** — the one that would
  be uncomfortable to hear from a client, not the one that is easy to answer. **If it has no
  full answer, say which part is unanswered and what would have answered it.**
- **What was declined.** A decision showing only the option taken cannot be re-judged later,
  because the alternatives that were live at the time are gone.

⚠ **This phase ends at the selection, and what follows is not in this skill.** Specifying the
proof — three or four claims each paired with an action that falsifies it, rejection rules, a
limitations list that shrinks only by construction, and **a stop condition the author cannot
discharge by succeeding, in which *not attempted* is a distinct state from *passed*** — is a
separate discipline, and it is not yet harvested. Say so in the selection record rather than
letting the selection read as the plan: a selection presented as a specification hands the
builder a decision wearing a contract's name.

---

## The standing hazards

**The access hazard.** Public and derived material is cited, external-looking and feels like
evidence. It is evidence of *what is publicly said*, never of *what happens inside*. The
dangerous version of this work is superbly sourced and has never been checked against a single
thing a practitioner knows — **more dangerous than an obviously rough draft, because the
citations disguise the gap.**

**The hedge does not survive a change of medium.** A hedged estimate in a working file becomes a
confident finding when it is promoted to a headline in a deliverable. **Re-read every number
that changes register.**

**Maturity markers, on every claim.** Mark each as *position* (asserted), *confronted* (tested
against someone who knows) or *evidenced*. **Then hold a standing rule: every session touching
the deliverable moves at least one claim forward, or states why not.** Without it the document
drifts into a brochure while appearing to improve.

---

## Stop condition

The portfolio is done when **every original candidate is accounted for**, every entry traces to
the function, every score is separable from every other, the weighting is the sponsor's and the
arithmetic is marked as yours — and **at least one claim has been confronted by someone who
works there.**

⚠ **And one more, added because its absence was invisible for weeks: every level of aggregation
has excluded something, or is reported as unfiltered.** A portfolio in which nothing was ever
ruled out cannot be selected from, and it will pass every other test in this list while that is
true.

**Until that last one, the portfolio is a well-built hypothesis.** Say so in the document.
