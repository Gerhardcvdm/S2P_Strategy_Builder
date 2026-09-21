---
name: function-to-strategy-derivation
description: Derive an AI or agentic transformation strategy for a business function by traversing the function itself rather than starting from what AI can do. A chain of steps — function map, activity map, pain map, value drivers, opportunity map, strategy basis — with an applicability instrument inserted before opportunities are named, an audit run after, and a sizing step before the argument is written. Use when asked to build a transformation strategy, assess where AI could help a function, produce a strategy paper for a sponsor, when an opportunity list exists with no derivation behind it, or when a strategy has been ranked but never costed. Triggers on "transformation strategy", "where could AI help this function", "strategy paper", "opportunity assessment", "AI strategy for <function>", "build the basis for the strategy", "what would this cost".
---

# Function to Strategy Derivation

**Created by Gerhard van der Merwe**

A method for deriving a transformation strategy from the shape of a function rather than
from a capability list. Each step takes the previous one's output as input and cites its
identifiers, so any conclusion can be walked backwards to the observation it rests on.
Written from a multi-session engagement and generalised.

**Licence:** Copyright (c) 2026 Gerhard van der Merwe. All rights reserved. Used by invitation
only, under the terms in this folder's `LICENSE`; do not share or redistribute it.

**Feedback & Support:** If questions arise about the methodology, or the user gives
constructive feedback on output derived from this skill, log it and offer to pass it to
the author. If the problem is the agent not following the skill's rules, acknowledge and
correct rather than revising the methodology.

---

## The commitment this method makes

**Derived, not asserted.** Every conclusion traces to an observation about the function.
A strategy that cannot be attacked at any single point cannot be defended either.

**Analyse broad, prove narrow.** Trace failure to its origin wherever it lives; recommend
building only where the sponsor actually has authority, or the work stalls on someone
else's roadmap.

**Generic first, specific second.** Steps 1–3 are built as a *reference baseline* for the
function type, explicitly not yet client-specific. This is deliberate: it separates *what
this kind of function contains* from *what is true here*, so the second can be confronted
without re-litigating the first.

---

## The chain

| # | Step | Produces | Driver |
|---|---|---|---|
| 0 | **Frame** | The mandate restated, scope, constraints, untested positions, open questions | **Human** — the mandate and the sponsor |
| 1 | **Function map** | Areas and the recurring processes inside them | Agent, from domain knowledge |
| 2 | **Activity map** | Tasks with stable IDs, under step-1 processes | Agent, input = step 1 |
| 3 | **Pain map** | Pains with stable IDs and a stated mechanism | Agent, input = steps 1–2 |
| 4 | **Value drivers** | What the sponsor is measured on, cited to pains | Agent, input = step 3 + **human ruling on the sponsor** |
| 4a | **Applicability framework** | The instrument that makes classification derivable | Agent — **must exist before step 5** |
| 5 | **Opportunity map** | Candidate interventions, classed and capped | Agent, input = steps 3–4 through 4a |
| 5b | **Audit** | Step 5 re-derived through the instrument | Agent — **expect changes; they are the point** |
| 5c | **Sizing** | Build effort · running cost · benefit, each with its stated basis | Agent, input = step 5 audited — **the step most often skipped** |
| 6 | **Strategy basis** | Consolidate → harmonise → prioritise | Agent, input = steps 5 audited + 5c |

**Each step file states, in its header: which step it is, its `Status`, its `Input`, and
the date.** A step whose input is not named cannot be checked.

---

## Step 0 · Frame — before any map

Only the human can supply this. Do not infer it and proceed.

- **The mandate as given**, then **as you will work it.** If the restatement would not be
  recognised by the sponsor as theirs, it is changing the subject.
- **Scope**, split into what is analysed and what is proven. These are different widths.
- ⚠ **Who the transformation is *for* — the function, or the people it serves.** Decide it
  here, explicitly, because **step 1 decides it by default and nothing downstream can revisit
  it.** Every step from the function map onward takes the function's own work as its unit —
  its tasks, its failures, its sponsor's metrics — so the analysis will find that actor's
  savings and nothing else. **Not because anyone chose that: because no step can see past its
  own unit.** If the answer is the end user, that must change what step 1 traverses, and the
  cost of discovering it at step 5 is the whole chain.
- **Constraints**, and ⛔ **there are two data questions, not one.**

  | | The question | Whose it is |
  |---|---|---|
  | **The analysis boundary** | What material may touch **this work** at all | Yours — it protects your working environment |
  | ⛔ **The client's permission** | **Whose material does this function handle, under whose terms, and what do those terms say about processing by third-party services?** | The client's, answerable only from contracts that are not public |

  ⛔ **The second is the one methods omit, and it is a hard gate on the entire opportunity set.**
  A method that asks who may see the analysis has answered a question about *itself*. Agencies,
  contract manufacturers, law firms, MSPs, brokers, logistics providers — any professional-services
  business holds most of its operating material under someone else's terms, and for those firms
  *"may this data go to a model at all"* decides what may be built before anything is ranked.

  ⚠ **A privacy anti-pattern does not cover it.** Subject-identifiable data is a regulatory filter;
  **contractual confidentiality owed to a commercial counterparty is a different constraint with a
  different owner**, and it is the far more common blocker.

  Where it cannot be answered before the work — the normal case in a targeted engagement — it
  becomes **a registered assumption with the highest cost of being wrong in the pack**, plus the
  first-ranked item on the stakeholder agenda. In the engagement this rule comes from, it blocked
  five of ten recommended capabilities, and **the entries that survived it were the ones the
  instrument ranked last: the priority order did not degrade, it inverted.**
- **Early positions**, written down *so they can be attacked later, not defended.* Mark
  every one as untested.
- ⭐ **The central proposition — one sentence, in the human's words, stated as a claim a
  sceptic could disagree with.** Not a heading. **Do not write it for them.**
- **Open questions for the verifier** — the ones only a person in the room can answer.
  Whose budget. What triggered this now. Who loses if it works. What was tried before.
- ⭐ **An assumption register**, and it is load-bearing rather than administrative. Wherever the
  sponsor is not reachable until late, **most of what the deliverable rests on is an assumption
  made deliberately in order to proceed** — and the method's other machinery has no object for
  that. Left unregistered, assumptions disperse into positions, inferred constraints and open
  questions: three registers, three dispositions, **and none of them ordered by what it would cost
  to be wrong.** Each entry carries an **ID · what it licenses downstream · what breaks if it is
  false · how expensive it is to check**, ranked by cost of being wrong. It is the natural input to
  a proxy pass and the natural spine of the sponsor meeting — the conversation becomes a ranked
  list to knock over rather than a discussion.

- **A hazard register**, and ⛔ **every hazard names the step that must test it and what the test
  is.** A hazard given neither is not being carried, it is being disclosed — fix it or rule on it
  now. ⛔ **And write the discharge condition against the instrument's *application*, never its
  *contents*.** One frame required step 4a to *"carry a class for the firm cannot yet describe its
  own process"*; the step created the class, declared the hazard discharged, **and applied the
  class to zero of fifteen tasks and zero of twenty-three opportunities** — while one pain matched
  its definition exactly. Nothing distinguished *carried and correctly never applicable* from
  *carried and overlooked*. **The discharge column holds an identifier, never a tick.**

- **A stop condition.** Frame is not done until the restated mandate survives contact with
  a sponsor.

### ⚠ Which operating model is this — and it changes the frame, not the chain

**Commissioned:** the sponsor is reachable throughout. The mandate is quoted verbatim, the central
proposition is theirs and you may not write it, and the frame's stop condition is answerable.

⛔ **Targeted:** the sponsor is unreachable until the work is largely done, by design. Then the
mandate is **the mandate as inferred, with the evidence it was inferred from**; the central
proposition is **openly the consultant's hypothesis**, and the artefact records that the agent
drafted candidates; and the frame's stop condition cannot be met until the meeting. ⛔ **An
unanswerable question does not stop the work — it becomes a registered assumption plus an agenda
item, ranked by cost of being wrong.**

**Declare which one this is in the frame.** The rulings are the same rulings; only the source of
the answer changes — and an unanswerable gate is talked past rather than removed, which teaches
the operator that guards are obstacles.

**Write the positions even though they are unevidenced.** They are the thing later work is
tested against, and a position never written is never disproved.

⚠ **But a set of positions is not an argument, and it is a convincing substitute for one.**
**The test for each one: a proposition invites an argument; a heading invites a nod.** A
heading cannot be disagreed with, so it can never be tested.

⚠ **And passing that test on every position is not the same as having an argument.** The
observed failure was subtler than bad positions: **five good, genuinely disagreeable
propositions, and none of them ever named as *the* one.** Downstream work then read the
argument off the traceability counts and reported the resulting asymmetry as a finding it
could not resolve — **unresolvable because there was no proposition to check either count
against.** **Write the positions, then name which single claim the work is making.**

**Record the sentence verbatim, on its own line, in the frame artefact.** Every later step that
needs it must quote rather than paraphrase — including, eventually, the criterion that selects
what gets built and the claim a specification has to prove.

⚠ **And do not read the argument off the traceability.** When downstream work is tagged to
positions, it is tempting to take the argument to be whichever position the most items point
at. **Mass tells you where the work concentrated, not what the work is claiming**, and the two
diverge exactly when the argument is about a *constraint* rather than a *workload* — which is
the case worth having a proposition for. **The human names it; the counts do not.**

---

## Steps 1–3 · Traverse the function

### Step 1 · Function map

Name the **areas** the function contains and, inside each, the **recurring processes**
people actually perform. Group areas into a small number of clusters that mean something
operationally.

Keep it **generic to the function type**. Mark it as a reference baseline. Add explicit
caveats about what the map does not capture, and a *held back deliberately* section for
what was left out and why.

### Step 2 · Activity map

Go one level below step 1: the **tasks** inside each process.

**State the inclusion rule explicitly, in the document.** *"The rule I used for what counts
as a task"* is not throat-clearing — it is what makes the count defensible and the omissions
visible. Without it, a reader cannot tell a deliberate exclusion from an oversight.

Give every task a **stable identifier** scoped to its area. Every later layer will cite
these, and renaming one silently breaks the chain.

Expect a large number. A traversal that stops early produces a strategy that cannot say
what it excluded.

### Step 3 · Pain map

For each area, what goes wrong.

**State the inclusion rule for a pain, and require a mechanism, not a symptom.** Each pain
records **what breaks · why it recurs · who feels it**. "Reporting is slow" is a symptom;
"the reconciliation between two systems is manual and repeats every cycle because neither
owns the mapping" is a mechanism. Only the second suggests an intervention.

- **Anchor every pain to the task IDs it attacks.**
- **Mark where it is felt** — inside the function, outside it, or both. The split matters:
  pain felt outside is the sponsor's argument; pain felt inside is the team's.
- **Compress into recurring shapes** at the end, and say how many distinct shapes there
  really are. A hundred pains that reduce to eight shapes is a finding.

⚠ **Carry an explicit warning that recognition is not evidence.** A practitioner nodding at
a generic pain map confirms the map is plausible, not that it is true here.

---

## Step 4 · Value drivers — the sponsor's language

Convert pains into what the sponsor is **measured on**. This is the step that decides
whether the strategy is fundable.

**Requires a human ruling first: who is the sponsor, and are there one or two?** Building
for two audiences and later collapsing to one is expensive — every driver has to be
re-tagged or dropped, and the record must show which.

For each driver record:

- A **stable ID**, cited back to the step-3 pains it derives from
- A **value logic** — cost-out · capacity · risk · decision quality · growth
- A **causal chain length** — how many links from the pain to the thing the sponsor sees

**Chain length is defensibility, not size.** A driver reachable in one step outranks a
larger one reachable in three, because the sponsor can follow the first without trusting
you. Record chain length *separately* rather than folding it into a score.

**Use the sponsor's own metric vocabulary**, drawn from public or general industry
knowledge for that sector — never from confidential material.

**When drivers are dropped by a ruling, mark them dropped in place. Never delete them.**
Later steps cite these IDs, and a deleted ID becomes an unresolvable reference.

### After the sponsor ruling, publish what the ruling just eliminated

A sole-sponsor ruling does not merely narrow the audience — **it silently removes whole
areas of the function from consideration**, because an opportunity with no surviving
driver cannot enter any downstream step. Nobody decides this. The rule does it, invisibly,
and the areas simply never appear again.

So immediately after the ruling, before step 4a, produce a short list: **every area whose
drivers were all dropped, and what that area was.** Then put one question to the sponsor
for each: *was a driver for this never written, or is this genuinely not your problem?*

**It should be one or the other deliberately.** In the engagement this method comes from,
a sole-sponsor ruling removed master-data stewardship's entire value case, along with
licence reclamation, maturity evidence and role-contextual material. It also removed
**benefit tracking — the one candidate that would have verified the programme's own
claims.** That last one is the tell: the rule that scopes the work will also, given the
chance, scope out the work's own accountability. Recommend such a candidate as a
governance obligation rather than letting it vanish.

**An area that disappears by rule looks identical to an area nobody thought of.** Only
this list distinguishes them.

---

## Step 4a · The applicability framework — insert it *before* step 5

**This is the highest-leverage step in the method, and the easiest to skip.**

Without an instrument, the class and autonomy assigned to each opportunity in step 5 are
*asserted*. With one, they are *derived* and can be re-derived by someone else. Build it
before naming a single opportunity.

**The unit of assessment is the task, not the area.** Areas are too coarse — an area
almost always contains tasks of different classes.

**Layer A · Which class applies.** Independent tests, not a spectrum. Distinguish classical
prediction, generative work, and genuinely agentic work. Make the agentic test strict: it
should require *both* a variable sequence *and* acting across systems. Most things fail it,
and that is the useful result.

**Layer B · How far it can go.** Independent constraints that cap autonomy:

- **Verifiability** — can we tell it was right, and at what cost?
- **Reversibility** — what does undoing it cost?
- **Consequence reach** — who is exposed if it is wrong?
- **Judgement character** — what kind of call is being made?

**Combine worst-of, never average.** Averaging lets a strong score on one constraint
license autonomy that another forbids. Name the **binding constraint** per task — that is
the design lever, and it tells you what to change to earn more autonomy.

⛔ **Record all four values per unit, not just the resulting cap.** The cap alone is an assertion;
the four values are the only form in which the worst-of rule is checkable at all, and §5b's audit
is written to check exactly that. ⚠ **A rule whose inputs are not recorded is not an instrument** —
one run stored one value per row instead of four and had to rebuild the step.

**Layer C · The verdict**, including an explicit *no class applies*. A framework that
cannot return "this is not an AI problem" will find AI problems everywhere.

**Record the anti-patterns** the framework rejects, so step 5 can be checked against them.

⛔ **One anti-pattern that is routinely missing and is usually the largest:** *an opportunity
operating on material the firm holds under a third party's terms* returns a **precondition
verdict** until permissibility is established — exactly as a missing system does. See step 0's
second data question.

---

## Step 5 · Opportunity map

Now name the candidate interventions, one per pain-and-task pairing where the framework
returns a verdict.

Each opportunity carries a **stable ID**, its **class**, its **autonomy level**, **all four
Layer-B constraint values and the binding one**, the **drivers it serves**, the **pains it
attacks**, a **`Verifier:` line stating what makes its output checkable, and by whom** — the
field that shapes everything downstream — and a **`Displaces:` line.**

⛔ **The four constraint values are a required field, not prose.** §5b mandates a check that each
entry's cap equals the worst of its four values — described in the instrument as the only
mechanical check on the anti-pattern it names — and **that check is unrunnable unless this step
emits its input.** Inherit the values with a citation where the task was calibrated at 4a; derive
and state them where it was not.

⚠ **This is the failure to avoid, and it is structural rather than careless.** In one run, 11 of
23 entries were derived fresh, so the values did not exist and the audit reported the check
unrunnable — for half the portfolio. When a gate two steps later finally ordered them derived,
**four caps were wrong and three were wrong in the permissive direction**, which is precisely what
the anti-pattern describes. The method's own safeguard would have shipped unrunnable.

> ⭐ **The general rule: when a later step mandates a check, the earlier step producing its input
> must be required to emit that input.** A check specified only where it is performed will be
> unrunnable exactly when it matters, and it fails politely — the auditor writes *"cannot run"*
> and the chain continues, which reads like diligence rather than an unguarded gap. **A promise
> with no slot to fill is not kept.**

**`Displaces:` — who loses if this works.** Name the effort that stops being spent, the
role whose remit shrinks, and whether the work being taken out belongs to a team the
sponsor's function does not run. `None` is a legitimate value and must be written, not
left blank; a blank is indistinguishable from an unasked question.

**Add this field at step 5, not later.** It cannot be retrofitted honestly. In the
engagement this method comes from, "who loses if this works" was raised at step 0 and
stayed open through seven sessions — not because nobody would answer it, but because the
record format had nowhere to put an answer. Three entries took work out of teams the
function did not run, and nothing in the schema made that visible. **An unanswered
question in a document is a prompt; an unanswerable one is a design fault**, and the fault
is discovered only when someone finally tries to answer.

A displacement that crosses a team boundary is also a feasibility fact, not merely a
political one: it needs a stakeholder the sponsor may not command.

**Keep the classes apart on purpose.** Publishing that only a minority are genuinely
agentic is a credibility move, not a weakness. Inflating the agentic count is the first
thing a sceptic will test.

**Autonomy is where the risk lives**, not class. Record it per opportunity and expect the
highest band to be empty. An empty band, stated, is more credible than a populated one.

### Step 5b · Audit step 5 through the framework — do not skip this

Re-derive the classifications independently against the 4a instrument.

**Expect the audit to change a substantial minority of entries.** In the engagement this
method comes from, roughly a quarter changed, and the agentic share nearly halved. If an
audit changes nothing, suspect the audit rather than celebrating the work.

Record the audit as its own artefact: its method, its findings, the splits and merges it
produced, the revised tallies, what was applied — and **where the audit is itself weak.**
The auditor is usually the same agent that produced the work, which is a real limitation
and must be stated.

---

## Step 5c · Sizing — before the basis, not after the deliverable

**Size what survived the audit, before writing the argument that depends on it.** This
step exists because its absence is the most reliable failure in this method: a complete,
traceable, well-ranked strategy in which **no artefact anywhere carries a cost, an effort
figure or a benefit estimate** — so nothing is fundable, and the business case cannot be
started. It is easy to defer because every other step produces something and this one
produces numbers nobody has yet.

**Do not defer it to the business case.** The business case is downstream of the basis,
and the basis will already have argued a priority order without it.

For each opportunity that survived step 5b, record three quantities and, for each, **the
basis on which it was derived**:

| Quantity | What it must say |
|---|---|
| **Build effort** | How long to a working version, and of whose time. Without it, "which proof goes first" is being decided on appeal rather than cost |
| **Running cost** | What it consumes once live — licences, compute, and the human review the `Verifier:` line commits you to |
| **Benefit** | In the sponsor's own metric from step 4, tied to the driver ID. Not "efficiency" — the measure they are held to |

**Three rules, and they matter more than the numbers:**

1. **A figure without a stated basis is not an estimate, it is a decoration.** Write how
   it was derived — a comparable, a rate card, a headcount times a fraction — or write
   `not sized` and why. Both are honest; a bare number is not.
2. **Erring high is not the safe direction.** An inflated cost argues against an option
   under an appearance of caution, and it will be believed precisely because it looks
   careful. Check the estimate against the artefact before writing it.
3. **Declining to assert is always available and usually stronger.** A named range with a
   basis beats a point estimate with none. A whole class marked `not sized, pending X`
   tells the sponsor exactly what to ask for.

**If sizing is skipped, that is a ruling and it goes in the basis in those words** — *"no
opportunity in this portfolio has been sized; the priority order is therefore an argument
about value and feasibility, not about return"* — never a silence. A strategy that does
not mention money reads as though money was considered.

---

## Step 6 · Strategy basis — the only step that is an argument

Steps 1–5 are references. This one takes a position.

**Consolidate.** Reduce the opportunities to a small set of **reusable capabilities** —
what actually gets built once and pointed at many targets. Verify the mapping is
exhaustive and non-overlapping: every opportunity assigned, no duplicates, no gaps, and
say so with the arithmetic shown. **The gap between the opportunity count and the build
count is a finding**, and usually the most useful number in the document.

⛔ **Write the membership rule into the artefact before the groups.** This layer sits *above* the
4a instrument, produces the number the deliverable and every downstream arc will quote, and — left
without a rule — is pure assertion. Nobody can re-derive it, nobody can test a refusal to merge,
and a reader cannot tell a real shared build from a shared adjective. ⚠ **Grouping by surface
similarity is the natural failure**: in one run three of nine groups were held together by what the
entries sounded like rather than by what would be built once, and the headline number moved twice.

**The rule that worked:** *two entries share a capability when one build serves both and only its
configuration differs* — checked on three axes that must **all** hold:

| Axis | The test |
|---|---|
| **Same input shape** | The same kind of thing goes in |
| **Same output shape** | The same kind of thing comes out |
| **Same verification pattern** | The output is checked against the same kind of artefact |

**Require each group to name which axis binds it**, and **publish the count three ways** — raw ·
excluding single-member groups (*a group of one is an opportunity with a grander name*) ·
excluding groups that cannot be built because their members are blocked. ⚠ **Merging always
improves the ratio**, so without a rule there is no principled stopping point and no way to see
what a refusal costs. Carry the standing caveat that the grouping is a judgement whose headline
number moves if a reader draws the boundaries differently.

### ⛔ A capability grouping is an index of exactly one thing

> **A capability grouping partitions on input/output form. It is not a valid index for any
> constraint about provenance, ownership, jurisdiction, timing or cost. A constraint of a different
> kind must be derived per entry against a stated rule, never expressed in the capability
> vocabulary.**

⛔ **The moment a grouping exists it becomes the most convenient vocabulary for describing anything
else about its members**, so a later constraint gets expressed in it by default — silently
inheriting a partition built for a different question. Observed: a fatal constraint about what may
lawfully be sent to a third party was published as *"it blocks C1, C3, C4, C6, C7"*. It failed in
**both** directions — one capability blocked although a member consumes only the client's own
material, another left unblocked although its entire input is a document type the constraint names.
A proxy pass had cut the same constraint on the correct axis and produced a **third**, also-wrong
set. **Three descriptions of one constraint circulated across three artefacts for a full day, each
internally consistent, so no count check fired.** The tell is never an arithmetic error — it is a
single member that obviously contradicts the grouping.

**When a constraint arrives on a new axis:** derive it **per entry** against a written rule, and
give it an explicit **`undetermined`** value for entries the record cannot settle. ⛔ **`undetermined`
counts as *not surviving*** — the permissive default taken by silence is what the audit step exists
to catch, and it caught four such caps in one run.

**Harmonise.** Name the genuine merges, the dependency spine, and the tensions that must
be **resolved rather than averaged**. A tension averaged is a decision nobody made.

**Prioritise.** Into tiers, including an explicit tier for *not an AI problem*.

⛔ **Before scoring anything, validate the criteria — checking that a rule was followed is not
checking that the rule was right, and the first produces confidence that suppresses the second.**
Observed: a reviewer re-derived all twenty scores of a four-criterion ranking, confirmed every one
correct, **then found the third criterion was measuring something the previous step had withdrawn
by name** — and it decided the top tier. Two checks, both mechanical:

1. **Criterion provenance** — name the artefact and field each criterion reads from, and confirm
   that artefact still asserts what the criterion assumes. A field narrowed, withdrawn or hedged
   upstream invalidates the criterion however well it was applied.
2. **Circularity** — assert that no criterion's value for any item depends on another item in the
   same ranked set. Six entries in that run were scored on a measure whose availability depended on
   another entry in the ranking, including that entry itself.

Then **state what each criterion actually tests, as distinct from what it is named.** The name is
where the drift hides.

**State the assumption you have made and the sponsor should correct**, at the top. And
**state the correction that matters most before anyone else finds it** — a strategy that
publishes its own biggest weakness is far harder to dismiss than one that waits to be
caught.

---

## Review the approach, not just the output

After step 6, write an honest assessment of the approach itself: what it gets right, and
its weaknesses. The recurring ones in this method:

1. **Nothing in the traversal makes it *theirs*.** Steps 1–3 are generic by design, and a
   generic map is recognisable without being true here.
2. **Sizing was skipped, or its figures have no stated basis.** Step 5c exists precisely
   to prevent this, and it is the step most likely to be quietly passed over, because it
   is the only one whose output is numbers nobody has yet. Check that 5c ran and that each
   figure names how it was derived. **A rank order is not a business case** — and if
   nothing was sized, the basis must say so in those words rather than omitting money.
3. **The funnel opens rather than closes.** Each step produces more items than the last
   until something forces a cut.
4. **Feasibility and control are absent** unless deliberately added — who owns the systems,
   and what the function may actually change.
5. **No thread to the proof.** The analysis and the thing that will be built can drift apart.
6. **Single-source risk.** Every artefact is one agent's work, reviewed by the same agent.
7. ⛔ **Corrections have propagated forward and never backward.** Every reviewer pass reads the
   step it reviews and that step's declared *input* — it looks upstream — so **nothing ever
   re-reads an upstream artefact after a downstream ruling changed what that artefact says.** The
   earliest artefacts keep asserting exactly the claims the chain has retired, and they assert them
   with the confidence of a source rather than the hedging of a citation.

**Two required checks at this step, because it is the first that reads every artefact at once:**

- ⛔ **The backward sweep.** Grep every artefact for identifiers, counts and claim-phrases that a
  later artefact records as struck, superseded or withdrawn, and report each surviving instance.
  The corpus is already greppable — chains write these as *"— withdrawn"*, `~~struck~~`,
  *"read N until \<date\>"*. In one run this found the step-0 artefact still presenting a
  withdrawn claim, unstruck, as *"the strongest signal this derivation has produced"* — while five
  downstream artefacts cited its withdrawal as settled precedent.
- ⛔ **The omission sweep.** For each input artefact, enumerate its load-bearing elements —
  tensions, registers, dependencies, unresolved questions, and **any sentence phrased as an
  instruction to a downstream artefact** — and assert each has a destination downstream or an
  explicit written exclusion. **Omission is the one defect class no count, diff or partition check
  can reach**, because every one of them compares what an artefact *says* against its sources.

> ⛔ **A written warning is not a mechanism.** The chain that suffered the backward-propagation
> failure had *stated the rule*: the artefact owning a changed count wrote *"every artefact quoting
> the old figure is stale after \<date\>"*, in the right file, on the right day, in greppable form.
> **Ten locations were still stale hours later, including that artefact's own header.** The remedy
> has to be a step that runs or a grep that fails.

**Do not execute the recommendations from this review automatically.** Present them and let
the human choose — several will be reversals of decisions already taken.

---

## The standing hazards

**Recognition is not evidence.** The most dangerous output of this method is a beautifully
derived strategy that has never been checked against one thing a practitioner knows. It
will be nodded at, and the nod will be mistaken for confirmation.

**Public research is evidence of public posture, never of internal reality.** It is real,
useful and constraining on behaviour — and it says nothing about what happens inside the
function. A strategy superbly sourced on public material and never tested internally is
*more* dangerous than an obviously rough one, because the citations disguise the gap.

**Mark every claim's maturity** — asserted / tested against someone who knows / evidenced —
and hold a standing rule that every session moves at least one claim forward or states why
not. Without it the document drifts into a brochure while appearing to improve.

**IDs are the spine.** Stable identifiers at every layer, cited forward, never renamed and
never deleted. Everything the method promises about traceability rests on this alone.

**Re-ranking is not evidence.** A second ordering applied to the same unconfronted
judgements inherits their uncertainty in full, and it is worse than neutral: **it makes a
portfolio feel more examined than it is.** Producing one is real work, it changes what
appears at the top, and it discharges nothing — the underlying scores have still never met
anyone who knows the function. Where two defensible weightings disagree, publish both and
treat the disagreement as the finding; do not let the newer one retire the question.

The same applies to any adversarial pass run by the agent that produced the work. **State
inside the artefact that it discharges nothing.** If it retires the conversation with a
practitioner, it has made things worse — a document that reads like confrontation and is
not is more dangerous than one that never claimed to be.

⛔ **Internal shorthand becomes, on promotion to a deliverable, a claim about the reader.**
Internally a ruling is *taken*, a field is *ruled*, a unit is *settled* — and none of that carries
the decision's **provenance**, because internally everyone knows it. Observed: a unit-of-analysis
decision the analysis had re-ruled became, in the client's document, ***"You told us this
transformation is for the function and for the investigators it serves."*** He had told them no
such thing. ⭐ **One pronoun attributed the chain's most consequential and irreversible decision to
the person the document is addressed to** — and an MD who says *"I never told you that"* invalidates
every structure resting on it.

**So, at the promotion step:** for every statement attributing a decision, a preference or a piece
of knowledge to the client, find the artefact it came from and confirm the client is actually its
source; where the source is the analysis, say so in the sentence; where a field was supplied and
then re-read, publish both the supplied wording and the reading. ⭐ **Then grep the deliverable for
second-person constructions** — *you told us*, *you asked for*, *your decision* — and require each
hit to name its source.

---

## Pre-flight — run before calling a strategy basis done

- [ ] Frame exists, its positions are marked untested, and its stop condition is stated
- [ ] The frame declares the operating model — commissioned or targeted
- [ ] Both data questions are answered: what may touch this work, **and** what the client may
      lawfully feed a model — the second registered as an assumption if it cannot be answered
- [ ] The assumption register exists and is ranked by cost of being wrong
- [ ] Every hazard names the step that tests it and what the test is, and every discharge names
      the instance it fired on — or records the search that found none
- [ ] Every step file names its step number, status, input and date
- [ ] Steps 2 and 3 each state their inclusion rule in the document
- [ ] Every pain records a mechanism — what breaks, why it recurs, who feels it — not a symptom
- [ ] Every driver cites the pains it derives from, and records value logic and chain length separately
- [ ] Dropped drivers are marked in place, not deleted
- [ ] The applicability framework existed **before** the opportunity map was written
- [ ] Layer B combines worst-of, and the binding constraint is named per item
- [ ] **All four Layer-B values are recorded per opportunity**, so 5b's worst-of check is runnable
- [ ] The anti-pattern set includes material held under a third party's terms
- [ ] Every opportunity carries a `Verifier:` line
- [ ] Every opportunity carries a `Displaces:` line — `None` written out, never left blank
- [ ] The areas eliminated by the sponsor ruling are listed, each with its open question
- [ ] The audit ran, its findings are recorded, and its own weakness is stated
- [ ] Sizing ran, and every figure names the basis it was derived from — or the basis
      states in words that nothing was sized and the order is not about return
- [ ] No re-ranking is presented as though it confronted anything
- [ ] Consolidation arithmetic is shown: every opportunity assigned, no duplicates, no gaps
- [ ] The consolidation membership rule is written **before** the groups, each group names its
      binding axis, and the count is published three ways
- [ ] No constraint of a different kind is expressed in the capability vocabulary; any such
      constraint is derived per entry, with `undetermined` counted as not surviving
- [ ] Every ranking criterion names its source field, that field still asserts what the criterion
      assumes, and no criterion depends on another item in the same ranked set
- [ ] Tensions are resolved, not averaged
- [ ] The approach review is written and its recommendations are **not** auto-executed
- [ ] **The backward sweep ran**: no artefact asserts a claim that a later artefact records as
      withdrawn
- [ ] **The omission sweep ran**: every load-bearing element of every input has a destination or a
      stated exclusion
- [ ] Every second-person construction in the deliverable names its source artefact
- [ ] At least one claim has been confronted by someone who works in the function

**Until that last box is ticked, the strategy is a well-built hypothesis. Say so in the
document.**
