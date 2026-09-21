---
name: analytical-document-build
description: Build a long analytical document that derives its conclusions from an explicit chain of evidence rather than asserting them — and keep it honest as it grows across sessions. Use when constructing a portfolio, assessment, scored ranking, options paper or any document whose findings rest on an instrument you also authored; when promoting internal working files into a client-facing or published deliverable; when a decision has been ruled and must be propagated through instruments and artefacts; or when a document asserts counts about its own content. Triggers on "build the portfolio", "score and rank these", "turn the working files into the deliverable", "apply this ruling across the analysis", "derive rather than assert", or a document whose prose quantifies its own tables.
---

# Analytical Document Build

**Created by Gerhard van der Merwe**

A method for building documents whose conclusions are derived rather than
asserted: the derivation order that keeps filters meaningful, the checks that
catch an instrument contradicting itself, and the verification a document owes
about its own contents. Written from repeated failures in multi-session
analytical builds, where the errors are fluent, plausible and invisible on
reading.

**Licence:** Copyright (c) 2026 Gerhard van der Merwe. All rights reserved. Used by invitation
only, under the terms in this folder's `LICENSE`; do not share or redistribute it.

**Feedback & Support:** If questions arise about the methodology, or the user
gives constructive feedback on output derived from this skill, log it and offer
to pass it to the author. If the problem is the agent not following the skill's
rules, acknowledge and correct rather than revising the methodology.

---

## The failure this addresses

An analytical document is dangerous in a specific way: **it reads best exactly
where it is most wrong.** A count computed from memory is fluent. A ruling
rounded to the nearest available field looks complete afterwards. A filter
applied one level too late still produces output. None of these announce
themselves, and the finished document's register supplies a confidence its
contents never earned.

Every rule below exists because the error it prevents survived a careful read.

---

## 1. A filter must run at the level where its evidence lives

Analytical builds aggregate: fine-grained items become composites, candidates
become entries, observations become findings. Exclusion rules are usually
written against the composites and read attributes carried by the leaves.

**Sequence the derivation so any filter reading a leaf-level attribute runs
against the leaf set BEFORE aggregation. Then aggregate the survivors.**

Applied after grouping, the test silently becomes *"does any member qualify"* —
a weaker rule nobody chose, and one that lets a composite carry excluded
members through on the strength of a single surviving one.

Where a composite would inherit eligibility from one member, **decide
explicitly whether that is intended and record the decision.** That is the
exact point where an exclusion rule stops working.

**Worked example.** A rule — *drop anything whose only justification has been
withdrawn* — was written against composites while the justification attribute
lived on the leaves. Bundles were designed first; during scoring it emerged
that several leaves qualified for exclusion and that bundles containing one
surviving leaf would carry the excluded ones through invisibly. The derivation
order had to be reworked mid-build.

---

## 2. An instrument's own constraints are untested claims

When you author the framework and then apply it, its internal contradictions
surface only during execution — and by then the output exists and there is
pressure to keep it.

**Before executing an instrument, list its structural constraints and test them
pairwise for conflict against a few real cases.**

When a conflict appears, **report it as a finding about the instrument
alongside the output** — state which constraint you favoured and what that
cost. Do not silently resolve it.

**A framework that predicts its own output range is making a falsifiable
prediction.** A large miss is evidence about the framework, not merely about
the work. Say so rather than adjusting the work to fit.

**Worked example.** A framework required every output unit to belong to exactly
one category and separately defined a grouping rule based on shared properties.
Several natural groups spanned categories. Obeying both produced roughly 40%
more units than the framework's own stated expected range. The two constraints
had never been checked against each other.

### Verifying that an instrument was applied correctly does not verify the instrument

⛔ **A correctly-applied wrong instrument passes every check in this file, and passes it with a
clean bill that raises confidence.** It is worse than an arithmetic error, which at least
announces itself as an inconsistency — a valid-looking score computed faithfully from an invalid
criterion looks exactly like diligence.

The observed case: a reviewer independently re-derived all twenty scores of a four-criterion
ranking, confirmed every one was computed correctly, **and then found the third criterion was
measuring something invalid.** It awarded a point for *"benefit is prospectively measurable"*,
read off a marker that in every instance meant *"not sized, pending an instrument that does not
exist"* — a reading the previous step had withdrawn by name. It also decided which entries
reached the top tier.

Two tells were available and both are mechanical. Run them **before** verifying application:

1. **Criterion provenance.** For each criterion, name the artefact and field it reads from, and
   confirm that artefact **still asserts what the criterion assumes**. A field whose meaning was
   narrowed, withdrawn or hedged upstream invalidates the criterion however well it was applied.
2. **Circularity.** Assert that no criterion's value for any item depends on another item in the
   same ranked set. In the case above six entries were scored on a measure whose availability
   depended on another entry in the ranking — including that entry itself, so the ranking was
   partly ranking itself.

Then **state in the artefact what each criterion actually tests, as distinct from what it is
named.** The name is where the drift hides.

---

## 3. A ruling the instrument has no field for is a missing field, not an awkward value

When a decision-maker's answer does not fit the schema, the instinct under time
pressure is to pick the closest available value or write the nuance into prose
the scoring never reads. **Both discard the part of the ruling that did not
fit, and that part is reliably the informative half** — it is why the question
was worth asking.

**Test every recorded decision: does the answer fit the field's cardinality and
domain?** If not, extend the schema — a second field, a second permitted value,
an explicit qualifier — rather than rounding the answer.

- **Record the new field on every item, even where it is currently uniform**,
  and say why it is recorded despite discriminating nothing. A field that is
  universal today is exactly the field that gets forgotten when it stops being
  universal.
- **State explicitly whether the new field enters any weighting.** An unweighted
  field silently becomes a weighted one the first time somebody sorts on it.

**A footnote does not propagate; a field does.**

**Worked examples.** One ruling answered a single-valued classification with a
two-layer answer — who owns the logic is not who may authorise it to run. Another
made a constant attribute vary by calendar period, so autonomy became a function
of *when* rather than only of *what*. Rounded to the nearest existing value,
both would have looked complete and lost the distinction that made them worth
ruling.

---

## 4. Verify three things, not one — arithmetic, provenance, and coverage

A number a document states about its own content is a **testable claim**, and
the test must run against the finished artefact — never against the working
memory that produced it. Re-using the drafting computation repeats the work
rather than checking it.

**Where this has been measured, roughly five of eight asserted aggregate counts
were wrong when re-derived mechanically.** All read as fluent; one was wrong by
a margin that would have changed a stated conclusion.

**So treat mechanical re-derivation as mandatory, not as good practice.**
Spot-checking is insufficient at that failure rate.

⛔ **And it is demonstrably not sufficient.** On one run, a step was written with count
verification applied throughout and every one of its six self-asserted counts verified by script
before it was committed. A reviewer then found **thirteen defects in it, and not one was an
arithmetic error.** The findings sorted into five classes:

| Class | Reachable by count-checking? |
|---|---|
| A **hedge dropped on promotion** — a source's *"inference, not observation"* marker absent from the table quoting it | ⛔ No |
| A **position quoted with a clause removed** — a two-clause position quoted with one, changing a derived count | ⛔ No |
| A **label asserted over correct arithmetic** — *"the largest group"* where the document's own table showed a larger one | ⚠ Sometimes |
| A **figure with no stated basis** — an adjective repeated three times as the document's only spend recommendation | ⛔ No |
| A **mandated step not run** — a hazard whose test point was assigned to this artefact, never mentioned | ⛔ No |

⭐ **An agent that has just spent hours verifying arithmetic feels verified, and that feeling is
what makes the other four classes dangerous.** So run three checks, all mechanical:

**1 · Arithmetic.** Every count re-derived from extracted identifiers, against the finished file.
Prefer generating summary tables from the records programmatically over writing them by hand.

**2 · Provenance diff.** Every position, assumption, hazard or hedged statement **quoted** from
another artefact is diffed against its register **verbatim**, and any qualifier attached at the
source — an `inference` marker, a second clause, a named scope — must appear at the point of use
or be explicitly withdrawn. **Quoting is the operation that loses qualifiers, so it is the
operation to check.**

**3 · Coverage.** Grep the upstream registers for anything whose declared test point, owner or
trigger names **this** artefact, and assert each appears in it by name. ⚠ **A hazard assigned to
a step and never mentioned there is indistinguishable from one that was tested and passed.**

> **Counts are checkable by extraction; qualifiers by diffing against source; obligations by
> looking for your own name upstream. All three are mechanical, and only doing the first feels
> like doing all three.** Whenever a check is institutionalised, name the classes of defect it
> cannot see — that is where the next failure will be.

### Re-derivation presupposes identifiers and a record shape

Everything in this section extracts records from the finished file, and **that is only possible
if the artefact carries a stable identifier on every record and a consistent record shape.** Nothing
above states that prerequisite; it was assumed. So, as a rule of its own: **an analytical document
that will be verified mechanically declares its record format — the identifier pattern and the
fields a record must have — before the first record is written.** A document without one cannot be
re-derived, only re-read.

⛔ **Identify a record by its structure, never by its identifier alone.** In any document that both
holds records and summarises them, an identifier appears more often than the record does — in an
executive table, a ruling log, a cross-reference — **and the first appearance is the summary.** An
extractor that keeps the first match per ID parses a table cell as a record, emits empty fields,
and reports what looks like a defect in the *document*. Observed, and the hand-written cross-check
had the identical bug, so the verification agreed with the error. Require the block to contain the
fields a real record has; assert exactly one such block per ID; assert the extracted population
against an independently known total; and **write the cross-check with a different mechanism from
the extractor** — a second implementation of the same assumption confirms the assumption.

### Verify the leaves, not the summary

⛔ **A true sentence can sit on a false table, and checking the prose passes.** Observed: the
headline drawn from a summary table — *fourteen of twenty-nine are the same capability* — verified
against the records. So did the other headline. What was wrong was the table's *membership*: one
group under-counted by four, another wrongly including a record whose own entry named different
groups. The grouping presented everywhere as the largest was not, the whole reuse argument pointed
at the wrong thing, and it had reached two published deliverables.

**Re-derivation runs against the leaf records, never against an intermediate summary, however
authoritative repetition has made it.** Where a summary table is the input to further work,
re-derive the whole table and diff it row by row before building on it, and state in the new
artefact which source it used. On promotion (§7), re-source a quantity to the records, not to the
working file that last stated it — a working file's tables are exactly the intermediate that
acquires authority without being re-tested.

### Count what should be there, and show the zero

⛔ **A count computed over the records that exist cannot report a record that is missing.**
Observed: a board iterated the *register* — everything due — and rendered a due item with no record
as an explicit gap; the summary tiles beside it iterated the *records produced* and tallied their
outcomes. When a due item produced nothing, the board showed it and the tiles did not: 16 / 3 / 2,
total 21, the categories summing exactly to the total, the missing item nowhere. **The denominator
had moved with the numerator.** Internal consistency is not completeness; the two are unrelated,
and consistency is what makes the omission unremarkable.

For every count, **name its denominator and ask what a missing item does to it.** A count meant to
reveal absence iterates the set that defines what *should* be present — the register, the plan,
the population — never the set of artefacts produced. If a missing item shrinks the denominator,
the count cannot report absence and must not be presented as coverage.

⛔ **And a figure that reports absence renders at zero.** Rendering it only when non-zero is the
same defect one level up: a reader who does not see the figure cannot tell *zero* from *never
computed*, and a regression that stops computing it produces a page identical to a healthy one.
The test: **if this number were never computed, would the page look any different?** If not, it is
being volunteered, not reported. Conditional rendering is for emphasis — styling, position, a note
— never for existence. The same holds for *no issues found* lines, empty sections and skipped
checks in a summary.

### Never hand-write a derived figure — and never repair one by hand

⛔ **Never hand-write a count or a set membership that is computable from the record.** Observed
in one file: funnel counts asserted 4/11/14 against an actual 4/10/15; a shortlist whose heading
named a criterion three of its members failed and three non-members passed; and, when the totals
would not reconcile, **a parenthetical explaining the discrepancy written faster than a recount.**
Parse the finished artefact, compute every derived figure, and assert a partition — categories sum
to the total, no overlaps, nothing missing — before publishing. **A reconciliation note explaining
why numbers do not add up is a defect signal, never a fix.**

⛔ **When a self-reported figure is found wrong, replace the method, not the number.** Observed: a
document asserted 41 claims and held 46; the rebuild correcting it asserted 48 and held 58. The
repair was performed in the same mode as the error, and carried a confidence the first attempt did
not, because it felt like the careful pass. **A defect of method cannot be repaired by a more
careful instance of that method.** Where the artefact cannot compute its own figure, delete the
figure or record how it was obtained; a better-typed number is rejected at review.

⛔ **A figure quoted inside a ruling goes stale the moment the ruling is propagated.** Observed: a
ruling cited a document's word count; three sibling rulings in the same batch then rewrote four of
its sections, and the cited figure was already in the contract, the register and the handoff as
current. Where a decision record quotes a measurement of an artefact the same batch will edit,
**either record it as *at ruling* with the date and re-measure after the last edit, writing both
figures, or place the measurement after every edit in the batch.** A single figure will be wrong by
the time anyone reads it, and it will look precise.

⭐ **Generate every table that reads a computation from the structure that computed it.** When a
re-ranking must reach a working table, a one-pager, an HTML table and a set of group means, emit
all of them from the same data structure in one script, with an assertion on each figure the prose
will cite. A generated table cannot drift from its data; **a sentence about the data always can** —
so treat prose citations as a separate sweep with a grep denominator, never a remembered list, and
run the residue grep after patching as the exit condition. Observed: the memory-built list of prose
citations was short by three until the grep ran.

### A number about a document is not a judgement of it

⛔ **Mechanical re-derivation is mandatory for claims a document makes about its own contents. It
is not a substitute for reading when the question is how the document reads.** Observed: asked
whether a client document was too hard for its audience, an agent grepped for jargon, codes and
markers and reported three findings before reading a line — all three wrong. *98 identifier codes
in prose*: 64 were table cells where a code column is correct. *24 markers never explained*: they
were explained, in a box the grep window missed. *Mean 26 words per sentence*: the longest
"sentences" were a CSS block. Two sections read end to end settled in minutes what an hour of
counting got backwards, and the real defects were of a different kind.

Register, audience fit and clarity are judged by reading a representative section end to end, in
the form the reader receives it. A proxy metric may be used only after it has been validated
against a read sample, and a metric computed over stripped markup is unverified until the stripping
is checked. **A proxy measurement is most confident exactly where it is least valid, because it
returns a precise number either way.**

### A view that collapses records decides something

⛔ **"Latest wins" is a finding-destroying policy chosen for display convenience.** Observed: a
page kept the most recent record per key. The system had processed one subject twice on identical
input and returned two opposite, coherently argued answers; the page showed the later one, and
nothing indicated a disagreement had occurred. The underlying store held both. **A one-line
dedup silently settled whether the system's outputs are reproducible.**

When collapsing records to one per key, ask: **can these records disagree, and if they do, is the
disagreement the finding?** If yes, the view detects divergence, marks the collapsed row as
*contested* rather than replacing its value — instability is a statement about how much weight
the value bears, not a competing value — and shows every underlying record unabridged. And per the
zero rule above, **report reproducibility even when nothing has been repeated**: silence reads as
*stable*, which is a claim nobody has earned.

### An extractor is a claim too — test it before trusting it

Replacing a narrative count with a computed one moves the error from the prose into the
extractor, where it is harder to see and looks authoritative. **A wrong extractor returns a wrong
number just as confidently as wrong prose, and the number is usually plausible.**

Observed: identifiers of the form `P-<AREA>-<nn>` where AREA was three letters in six of seven
areas and two letters in the seventh. The regex required exactly three letters, so **an entire
subpopulation was dropped silently** — reported 24 against a true 29, with no error and no
warning.

Two rules, before trusting any extractor:

1. ⛔ **Print the extracted members, never only the count.** A total cannot be eyeballed; a
   membership can. Had that script printed only its count, it would have passed.
2. ⛔ **Assert positively that at least one member you independently know belongs is present**,
   chosen from a different part of the space than the obvious cases.

⚠ **The specific trap: identifier schemes whose segments vary in width.** A fixed-width pattern
drops a whole subpopulation rather than erroring.

**A script not checked against a hand-derived answer is not a verification.**

### A total must not outlive the membership it describes

⛔ **When a rebuild replaces an enumeration with a summary, the count that enumeration supported
must be deleted in the same edit, or the enumeration must be kept.**

Observed: a section headed *"Non-AI candidates — 8"* held an eight-row table. A rebuild triggered
by a reviewer pass on an unrelated axis replaced it with a four-line prose summary naming four of
the eight, **and kept the heading's count at 8.** Four candidates then existed nowhere in the
document asserting they existed; recovery required git history.

This is worse than a stale total over a changed membership. The usual case leaves the membership
inspectable and merely wrong; here **the membership was destroyed while the total continued to
assert it.** Deleting a list silently promotes every count over it from derived to asserted.

Add to the arithmetic pass: for every count in a heading or prose, **locate the enumeration it is
derived from in the current document** — not in memory of an earlier version — and fail if it is
absent.

---

## 5. Completing a classification is the point — the finding is in the distribution

A mapping exercise where most rows are obvious invites spot-checking: establish
the pattern on a sample, assert the rest, move on. **That reasoning is sound
about each link and wrong about the exercise.**

The value of a traceability or classification field is almost never in any one
link. It is in the shape of the whole — **which categories are crowded, which
are empty, which items map to nothing.** Those are properties of the complete
set and are invisible in any subset.

**So: complete it exhaustively, then compute the distribution and read it as a
result rather than as a checksum.** Report the counts, the empty categories and
the unmappable items as findings in their own right.

**Where an item maps to nothing, treat the absence as evidence about the
classification scheme before treating it as a defect in the item.** A scheme
authored earlier than the item is usually the thing that is out of date — and
the honest correction is to extend the scheme, not to delete the item.

**Worked example.** A field linking each of ~30 records to one of five
strategic positions looked clerical; most links were obvious. Completed, it
showed that more than half the records mapped to a single position, while the
position the whole argument rested on had two. Neither fact existed in any
individual link.

### A new dimension's value is where it disagrees with an old one

⭐ **Before reporting a new dimension's distribution, cross-tabulate it against the nearest
existing dimension and report the cells where they disagree.** Agreement adds a column;
disagreement locates a distinction the analysis had been collapsing. Observed: a new *where does
it sit* dimension against an existing *who reads its output* grouping agreed on six of eight
overlapping items and disagreed on four — and every disagreement was real: one item had a rich
interface used only internally, another reached the widest audience with no interface at all.
That undercut a pending ruling on whether to weight *reach*, because the cross-tab showed *reach*
was two independent properties pointing opposite ways on the same items.

Two rules for the result: **disagreements are findings, not errors to reconcile** — resolve one
only when the stakeholder asks; and **where two near-neighbour dimensions rank the same items
oppositely, any pending measure that names only their shared intuition is under-specified**, and
that is reported against the pending decision by name, before the measure is adopted.

---

## 6. Propagating a ruling is two operations, and only one of them feels like work

Applying a decision's *consequence* — amending the instrument, rescoring,
reordering — is visible and gets done. **Retracting the decision from
everywhere it was recorded as open does not, because open-items lists are
maintained in parallel with the decisions record rather than derived from it.**

The failure is asymmetric and invisible from inside the writing session: adding
a ruling feels like the work; striking it does not. The cost lands on the next
reader, who takes the blocker list at face value and proposes work on a settled
question.

**When recording any ruling:**

- **Grep the identifier**, across every file. Do not rely on your memory of the
  document's structure.
- **Reconcile every hit** — decision tables, blocker lists, "what matters next"
  orderings, deliverable prose, published exports.
- **Prefer striking through with the ruling date over deleting**, so a reader
  can see the item was closed rather than lost.
- Where a section is a *list of open things*, **say what it derives from**, so
  a reader finding a contradiction knows which side is authoritative.

**The same rule covers any value recorded in two places.** A version in a header
and a footer, a count in prose and in a table, a date in a file and its export:
these drift, and the drift is silent.

### A summary may record that a ruling was *taken*. Never that it was *applied*

⛔ **Application is a property of the target artefact, and is asserted only by that artefact or
by a check run against it.**

Observed: three documents disagreed and none could detect it. An audit stated a ruling in its own
voice (*"OPP-01 is re-framed here"*), a handoff summarised it as *applied*, and the target
artefact still carried the struck driver. A later rebuild of the target — triggered by a reviewer
pass on a different axis — **reproduced the stale value, because a rebuild reads the artefact's
own inputs, not the summary claiming to describe its state.**

- **A summary or handoff may record a ruling as taken, and by whom.** Where it needs to track
  application, it carries an **explicit unchecked box per target file**, discharged only by
  reading the target.
- **Every ruling names its target artefacts at ruling time**, and is not closed until each named
  target has been re-read.

**A document that describes another document's state is a cache, and a cache with no invalidation
will be wrong at exactly the moment it is trusted.**

### A ruling is discharged against the set it governs, not the clause that states it

⛔ Observed: one contract governed two deliverables. A ruling — remove internal filenames, the
reader cannot open them — was clarified in the contract and executed on the newer deliverable only.
Two days later the older one still carried sixteen of them and a stale version, and nobody had
recorded that the pass was partial, because the clarification was written against the *clause*
rather than against the *artefacts the clause governs*. The trail read complete; the set was not.

**The propagation record names every artefact the clause governs and the state of each** —
executed · not applicable · outstanding, with a reason — not only the artefacts changed. A ruling
over *N* artefacts is not discharged until the record accounts for *N*, the same way a filter log
accounts for every candidate and not only the survivors. An artefact deliberately left inconsistent
is a finding to publish, not an omission to carry.

### A status assertion needs a periodic check, not only a triggered one

⚠ **The rule above hooks onto a ruling event. Work that accumulates has no event.** Observed: a
review document headed *"nothing here is executed"* while five of its seven recommendations had
been acted on across several sessions as ordinary work, one of them three days earlier by the
same agent — and it was cited by eight other documents. No single moment presented itself as *now
update the status line of the file that recommended this*, because the document that says what is
outstanding is almost never the one being edited when something stops being outstanding.

**Any header that asserts a state about the project — not executed, outstanding, open, draft,
superseded — is a checkable claim, and the check belongs to the routine that closes a session,
not to the edit that invalidates it.** At wrap-up, grep for status assertions across the project's
documents and reconcile each against what the session did. Prefer a disposition table to a prose
status line: a table has a row per item and an unfilled row is visible, while a sentence that has
become false looks exactly like one that is true.

### Re-running an instrument invalidates every sentence that ever quoted it

⛔ Observed twice in one project: a portfolio re-ranked on new criteria, the new table correct, and
prose elsewhere in the same document still calling one entry *second of twenty-eight* when it had
become sixth and another *sixth* when it had become fifteenth — printed beside the right figures
for three versions. Neither instance was found by a check; both were found by a person reading for
another reason.

**An instrument's output is a table; its footprint is every sentence that ever quoted it.** Treat
re-running an instrument as producing a **derived-claims sweep**, not just a new table: grep the
whole document set for every ordinal, count, share and superlative in the instrument's vocabulary
— positions, ranks, *largest*, *most*, *only*, *first* — and reconcile each against the new run,
including in sections about other topics. Cheaper and more durable: **stop restating derived
figures in prose.** Say *in the top ten* or point at the table, and let the one place that
computes the number be the only place that states it. Where a figure must be repeated, mark it as
derived so a later sweep can find it mechanically.

### Before reporting a propagation complete, check the governing model can register it

⛔ **Evidence about a dimension the governing model omits changes nothing, and the model reports
success.** Observed: a ranking had been rebuilt on a sponsor's three stated criteria, replacing an
in-house weighting that led on a dimension the sponsor's criteria did not name. Months later the
strongest evidence the project had produced — a built artefact contradicting a scored claim —
demoted exactly that dimension on the highest-profile entry. **The governing rank moved zero
places**, because the formula has no term for it; only the superseded view registered the change.
Instrument extended, records rewritten, contract amended, every citation swept — and a report of
what moved would have read as complete success while the one number a reader consults was untouched
by the one piece of hard evidence in the project.

**After any ruling that changes a scored dimension, state whether that dimension appears in the
governing model at all, either way** — and when it does not, that is the headline of the report,
recorded in the ranking file beside the ruling, because a reader comparing two views will otherwise
conclude the evidence was weak rather than unrepresented. Do not repair it by re-weighting; adopting
the criteria set was itself a ruling. **Record every criteria set with the terms it omits**, so a
later *no change* can be read as *unrepresented* rather than *unaffected* — opposite findings with
identical output.

### After re-deriving a ranking, diff the whole order, not the records you changed

⛔ **In a ranking with conditional rules, the blast radius of a correction is not the set of
records corrected.** Observed: five records each dropped one band on one dimension. Eleven of
twenty-eight entries moved, and **the two largest moves belonged to entries that were not
corrected** — they rose six places each. A floor rule (*no low-value entry outranks a high-value
one*) was anchored by one of the five, which happened to be the lowest-ranked entry above the
threshold; dropping it one band dragged a whole block below it. Nothing was re-scored and no rule
changed. A report of the five corrections would have been true, complete on its face, and unable
to explain the biggest movers.

So: **report every entry that moved, with the reason.** Where the reason is a constraint rather
than a score, name the constraint and the entry that anchors it — floors, caps, tie-breaks and
exclusions all have anchor entries whose movement relocates the constraint for everyone. Identify
them before the edit, so the blast radius is predicted rather than discovered. And **validate the
re-sort by reproducing the published order from the unchanged inputs first**: an implementation
that cannot regenerate what is on the page must not be trusted to generate what replaces it.

---

## 7. Hedges do not survive a change of medium

The boundary between an internal working file and a published deliverable is
where quantities must be **re-sourced, not merely copied**.

A number written as *"roughly eight or nine"* in a working note becomes a
finding when it is promoted to a heading, because the deliverable's register
supplies a confidence the number never had.

**When promoting content into a deliverable, treat every quantity as
un-sourced until re-derived.** For each, ask: what is the most defensible
source, and does the new phrasing carry the confidence that source supports?

**Where the honest answer is a range or an unknown, say so.** Declining to
assert is always available and usually stronger than picking the midpoint.

**Worked example.** A hedged estimate carried from a working file into a
client-facing document became a section headline, losing the hedge and gaining
the authority of a deliverable. An upstream document already held a firmer,
derived figure for the same quantity that nobody had reconciled against it. It
surfaced only because an unrelated completeness check made the two counts
disagree.

### Internal shorthand becomes, on promotion, a claim about the reader

⛔ **Internal artefacts are written for readers who share the context that makes their shorthand
true, and a deliverable is defined by having a reader who does not.** A ruling is *taken*, a
field is *ruled*, a unit of analysis is *settled* — none of that shorthand carries the decision's
**provenance**, because internally everyone knows it.

⛔⭐ **The most dangerous are attributions.** Observed, and the worst finding of its pass: a
unit-of-analysis decision re-ruled internally became, in the client's document,
***"You told us this transformation is for the function and for the investigators it serves."***
He had told them no such thing — the field as supplied said something narrower, the broader
reading was the analysis team's, and the field was one the agent had written rather than the
sponsor. **One pronoun attributed the chain's most consequential and irreversible decision to
the person the document is addressed to**, and a reader who says *"I never told you that"* takes
the whole structure resting on that decision with them.

Four more of the same class arrived in the same promotion step: a review count internally
understood as *"passes so far"* became a fixed claim, stale by one; *"partly argued against"*
became *"two were tested"* inside the section whose subject is that nothing was tested; a
`sector`-labelled statement about *a site* became a statement addressed to *you*; and a
nine-row caveat register arrived as six.

**Run a promotion check as its own pass:**

> For every statement in the deliverable that attributes a decision, a preference or a piece of
> knowledge to the client, find the artefact it came from and **confirm the client is actually
> its source.** Where the source is the analysis, say so in the sentence. Where a field was
> supplied by the client and then re-read, **publish both the supplied wording and the reading.**

⭐ **Pair it with a grep that is cheap and catches most of the class: sweep the deliverable for
second-person constructions** — *you told us*, *you asked for*, *your decision*, *as you said* —
and require each hit to name its source artefact. In the case above, that grep alone would have
caught the worst finding in the pass.

### "Plain language" needs a test the writer can fail

⛔ **A summary written from the working files summarises the method, because the method is what
the working files contain.** Observed: with the correction *this reads as jargon* still in
context, and agreeing with it, an agent wrote an executive summary of seven sentences carrying
*build order versus funding order*, *hard stops*, *the trigger*, *capabilities* and a count of
internal scoring judgements. Accurate, sourced, and unreadable by its audience. Every term felt
like precision at the moment of writing — which is why an instruction to use plain language does
not survive drafting, and why a prose review by the same writer does not catch it either.

Two tests, and the second is stronger:

1. **List every noun phrase in the section that would not appear in the sponsor's own speech, and
   replace it or delete the sentence.** A term with no plain equivalent is a signal the idea has
   not been reduced far enough for a sponsor to act on.
2. ⭐ **Draft the summary from the audience's questions, not from the document** — what is the
   ask, what is it for, what do we do first, who does it help, what do we not know. A summary
   organised by the reader's questions cannot be organised by the project's concepts.

### A caveat that reaches the record but not the reader has not been made

⛔ **Honesty is a property of the last surface, not of the record.** Observed: a build recorded its
own shortfalls with care and lost them twice on the way to the page. A producer set a structured
flag marking a record as fallback-generated; the writer copied fields by name and did not copy
that one, so the caveat survived only inside a prose field no view could filter on. A second
caveat — three of twenty-two records had a malformed field repaired — was written into the record
and never referenced by the view, so the page displayed the repaired content as the agent's own.
Both times the record was honest and the reader was not, and neither break could fail a test,
because the information existed at every point except the last.

**At the promotion step, list every caveat the working records can carry and point at where each
appears in the reader-facing artefact.** Trace each one producer → writer → store → view, and treat
a link that drops it as a defect of the same severity as losing the content.

⛔ **Then ask who encounters it without going looking.** Observed on the repair: each caveat was
rendered on the record it belonged to — inside a collapsed panel, so **visible exactly to the
reader who already suspected something and invisible to the one who did not.** Presence is
verifiable by inspection; discoverability only by asking who reads what without being told to.
For each caveat, **name the reader who meets it unprompted.** If the answer is *someone who
expands the right section* or *someone who scrolls to the end*, it needs a second placement at a
surface nobody can skip — a summary line, a count, a banner — and it belongs **above** the content
it qualifies, because a warning printed after the thing it warns about has already been ignored.

### Derive what a document may claim from its source's own disclaimers, first

⛔ **The strongest constraints on what a work may claim are usually already written inside it, by
whoever was closest to its limits.** Observed: a may/may-not table bounding what a sponsor summary
could say about a build was drawn carefully from the author's own sense of what was risky — and
missed the one prohibition the build's specification had already numbered for itself: no claim to
have *discovered* anything, because the discovering party planted what was found. The structure the
same author specified then led with *"two results nobody designed"* — the disclaimed claim, on the
sponsor's second screen.

**Enumerate the source's own disclaimers first** — its limitations list, its *what this is not*
section, its unmet conditions — and derive a prohibition from each, visibly, so an item with no
corresponding prohibition can be seen. Only then add prohibitions from judgement. **A self-authored
boundary is a second opinion, never the first.**

---

## 8. Mark maturity, and make the document move

A long analytical document drifts toward brochure: rewriting, restyling and
re-ranking all feel like progress and none of them tests a claim.

**Mark every claim** — asserted / tested against someone who knows / evidenced —
and **hold a standing rule that every session touching the deliverable moves at
least one claim forward, or states why it did not.**

**Changing the instruments and the order is not confronting anything.** A second
ranking applied to the same unchecked judgements inherits their uncertainty in
full, and can make a document *feel* more examined than it is.

**An adversarial pass you run yourself does not discharge this.** A critique
produced by the instrument that built the document can only surface what that
instrument already sees. Its use is triage — it finds the questions cheaply so
a real reviewer's attention is not spent discovering them. **Say that in the
document, or it will quietly retire the review it was meant to prepare for.**

### The scale grades what backs the claim, not who checked it

⚠ **A three-value scale has no honest place for the commonest way an analysis improves: the same
author checking against evidence the analysis did not previously hold.** Observed: an earlier
self-run adversarial pass over the same inputs had rightly discharged nothing. Then a pass by the
same author against internal source documents the analysis had never seen confirmed eight claims
and corrected two outright. Calling that *verified* overstated it; leaving it *asserted* discarded
a real advance — and with no value for it, the result rounds to whichever neighbour the author
prefers, undetectably.

**Qualify the middle by the evidence's auditability:** *asserted* → *confirmed against sources
only the author can see* → *confirmed against sources any reader can check* → *survived someone
outside the work* → *demonstrated*. State the ordering rule, because it is not obvious: **a
publicly checkable source outranks a privately held one even when the private one is stronger
evidence, because a reader can verify the first and must trust the second.** And **state in the
stop condition which value the deliverable needs**, or a qualified marker will be read as meeting
it.

### The scheme governs what may be asserted, never what work may proceed

⛔ Observed: asked to open a session, an agent read the backlog through the maturity scale and
offered four options, all document refinement, three framed as blocked on stakeholder
conversations. The user corrected it outright — the next milestone was a working demonstration,
reached by *assuming and refining*; the sponsor conversation is what the deliverable triggers, not
an input to it. The milestone's own folder was empty and had not been looked at before the backlog
was ranked. **The evidence scheme had quietly become a reason not to build.**

Unconfirmed inputs do not block downstream work; they enter it as labelled assumptions (the
register below) and the marker stays where it is. **And when the declared next milestone is an
artefact rather than a claim, inspect that artefact's location before ranking any backlog** — an
empty folder outranks every refinement item in the queue.

### Where the output rests on assumptions, assumptions need their own register

Maturity markers record **how far a claim has been taken**. They have no first-class object for
**an assumption made deliberately in order to proceed** — which, wherever the subject cannot be
reached until late, is the majority of what the document rests on.

⛔ **Left without a register, assumptions disperse into positions, inferred constraints and open
questions — three registers with three dispositions, and none of them ordered by what it would
cost to be wrong.** The next conversation's whole value is decided by which assumptions get
tested in it, and nothing ranks them for that.

**Carry a single assumption register through every stage.** Each entry: an **ID**, **what it
licenses downstream**, **what breaks if it is false**, and **how expensive it is to check** —
ranked by cost of being wrong. It is the natural input to any proxy pass and the natural spine of
the meeting agenda: the conversation becomes a ranked list to knock over rather than a discussion.

---

## 9. Any step that reduces a count needs a stated rule for the reduction

⛔ **The reduction is what gets quoted**, so it is the number most worth being able to re-derive —
and it is routinely the one produced by assertion.

Observed: a consolidation step required reducing opportunities to *"a small set of reusable
capabilities"* and called the gap between the two counts *"usually the most useful number in the
document"*. It supplied no rule for deciding when two items share a capability. The first attempt
produced nine groups by assertion; a reviewer found three that did not survive inspection, and a
fourth surfaced when a rule was finally written and applied. **The headline number moved twice.**

⭐ **An instrument at one layer does not protect the layer above it, and the layer above is
usually where the headline lives.** The same method invested heavily in making each individual
verdict re-derivable, one layer down, while the number built on top of those verdicts was pure
assertion.

The failure mode is specific: **grouping by surface similarity.** Three of the nine groups were
held together by what the entries sounded like rather than by what would actually be built once.
And **merging always improves the ratio**, so without a rule there is no principled stopping point
and no way to see what a refusal costs.

**So:**

- **Write the membership rule into the artefact before the groups.** The one that worked: *two
  entries share a capability when one build serves both and only its configuration differs* —
  checked on three axes that must **all** hold: **same input shape · same output shape · same
  verification pattern** (what the output is checked against).
- **Require each group to name which axis binds it.**
- **Publish the count three ways** — raw, excluding single-member groups (*a group of one is an
  item with a grander name*), and excluding groups that cannot be built because their members are
  blocked.
- **Carry the standing caveat** that the grouping is a judgement whose headline number moves if a
  reader draws the boundaries differently.

⛔ **And a grouping is an index of exactly one thing.** The moment it exists it becomes the most
convenient vocabulary for describing anything else about its members, so a later constraint of a
different kind gets expressed in it by default — silently inheriting a partition built for a
different question. State what the grouping is an index **of**, and therefore what it is not
valid for. See `function-to-strategy-derivation` §6 for the worked failure.

---

## Pre-flight — run before calling an analytical document done

Re-read this list and check the output against it.

**Derivation order:**

- [ ] Every filter reading a leaf-level attribute ran before aggregation
- [ ] Where a composite inherits eligibility from one member, the decision is
      explicit and recorded
- [ ] The instrument's structural constraints were tested pairwise for conflict,
      and any conflict is reported as a finding

**Recording decisions:**

- [ ] Every ruling was tested against the field's cardinality and domain; where
      it did not fit, the schema was extended rather than the answer rounded
- [ ] Any new field is recorded on every item, with its weighting status stated
- [ ] Every ruling's identifier was grepped across all files, and every
      open-items list naming it was reconciled
- [ ] The propagation record names every artefact the clause governs and the state of each
- [ ] Status assertions in headers were reconciled at wrap-up against what the session did
- [ ] Re-running an instrument was followed by a derived-claims sweep for every ordinal,
      count and superlative in its vocabulary
- [ ] After a ruling on a scored dimension, the report states whether the governing model
      contains that dimension; every criteria set is recorded with the terms it omits
- [ ] After re-deriving a ranking, the whole order was diffed, every mover explained, and the
      published order was first reproduced from unchanged inputs

**Self-referential claims — all three checks, not only the first:**

- [ ] The artefact declares its record format — identifier pattern and required fields —
      and the extractor matches records by structure, exactly one per identifier
- [ ] **Arithmetic** — every count the prose asserts about the document's own
      content was re-derived mechanically from the finished file, **against the leaf
      records and never an intermediate summary**
- [ ] Every count names its denominator, and any count meant to reveal absence iterates the
      set that defines what should be present
- [ ] Every figure that reports absence renders at zero
- [ ] No count or set membership was hand-written; the partition check ran; no prose
      absorbs a discrepancy
- [ ] Any corrected figure was corrected by changing the method, not by re-typing the number
- [ ] Any measurement quoted in a ruling that the same batch edits carries two figures or a date
- [ ] Every table reading a computation was generated from the structure that computed it, and
      prose citations were swept with a grep denominator and a residue grep
- [ ] Questions about how the document *reads* were answered by reading, not by counting
- [ ] Any view collapsing records to one per key can detect and mark disagreement, and reports
      reproducibility even where nothing was repeated
- [ ] Every count in a heading or prose has its enumeration **present in the
      current document**, not only in an earlier version
- [ ] Every extractor printed its members, not only its total, and was tested
      against at least one independently known member
- [ ] **Provenance** — every quoted position, assumption, hazard or hedged
      statement was diffed verbatim against its register, and every qualifier
      attached at the source appears at the point of use or is explicitly withdrawn
- [ ] **Coverage** — the upstream registers were grepped for anything naming this
      artefact as its test point or owner, and each appears by name
- [ ] Summary tables were generated from the records rather than written by hand
- [ ] Any value appearing in two places — version, date, count — was checked
      against its twin

**Instruments and reductions:**

- [ ] Each criterion names the artefact and field it reads from, and that artefact
      still asserts what the criterion assumes
- [ ] No criterion's value for any item depends on another item in the same ranked set
- [ ] The artefact states what each criterion actually tests, as distinct from its name
- [ ] Any step that reduced a count wrote its membership rule before the groups,
      named the binding axis per group, and published the count three ways

**Classification and traceability:**

- [ ] Completed exhaustively, not spot-checked
- [ ] The distribution was computed and read as a result
- [ ] Any new dimension was cross-tabulated against the nearest existing one, and the
      disagreements reported as findings
- [ ] Unmappable items are reported, and the scheme was questioned before the
      item was

**Promotion into a deliverable:**

- [ ] Every quantity re-sourced, not copied
- [ ] No hedge silently upgraded by a change of register
- [ ] Every statement attributing a decision, preference or knowledge to the
      client names the artefact it came from, and the client is actually its source
- [ ] The deliverable was grepped for second-person constructions, and each hit
      names its source
- [ ] Summary sections were drafted from the audience's questions, and every noun phrase the
      sponsor would not say was replaced or cut
- [ ] Every caveat the records carry has a rendering path, and a named reader who meets it
      unprompted, above the content it qualifies
- [ ] Prohibitions on what the document may claim were derived from the source's own
      disclaimers before any were added from judgement
- [ ] The stop condition names which maturity value the deliverable needs, and no
      self-verification against private sources is marked above *confirmed · internal*
- [ ] Maturity markers current, and this session moved a claim forward or said
      why not
- [ ] Any self-run adversarial pass states in the document that it discharges
      nothing
- [ ] No summary or handoff records a ruling as *applied* — only as *taken*
- [ ] The assumption register is current, ranked by cost of being wrong
