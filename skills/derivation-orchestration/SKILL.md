---
name: derivation-orchestration
description: The discipline a multi-stage derivation command must hold — how it guards its own entry, derives its resume point from artefacts instead of a state file, batches its human gates, reconciles what a gate was asked against what it answered, runs its reviewer and proxy subagents, specifies its own deliverable, and marks what it has and has not tested. Use when building, editing or reviewing an orchestrating slash command that runs a long derivation and stops for human rulings; when a command must resume mid-run; when wiring a reviewer or proxy subagent into a command; when deciding what a run may assert about its own output; or when budgeting how long an arc takes. Triggers on "build the orchestrator", "add a stage to the command", "wire in the critic", "where should the gate go", "how does it resume", "can it run unattended", "how long does this take".
tier: universal
---

# Derivation orchestration

**Created by Gerhard van der Merwe.** Licence: by invitation only, see `LICENSE`; do not share or redistribute.

A command carries its own **sequence**; this file carries the **discipline** every one of them
shares. Commands cite it by section rather than restating it — five rules copied into three
commands drift, and nothing reports it.

⚠ **Most rules here exist because the stated version of them failed.** A warning written in
the right file, on the right day, in the right words, is not a mechanism. Where a rule below
reads as a step that runs or a grep that fails rather than as advice, that is deliberate and
it is the difference between the two versions of this file.

---

## §1 · Guards — all of them run before stage 1, and any one stops the run

**The intake guard.** Check the intake file exists **and that every field is filled** — in that
order, because existence alone is not the test.

⚠ **The guard must reject the artefact the command itself produces.** The remedy for a missing
intake is to write the template, so the next invocation finds it present and an existence-only
check waves the placeholders through. Two runs is the normal path, not an edge case. Match any
field left empty or still wrapped in the template's brackets, name exactly which, and stop.
**Never infer a field, and never start on partial information.**

⚠ **Ship the intake template as a real file, not only as a block inside the command.** A form
a human is expected to arrive with must be reachable without running anything. Where the
template lives only inside the procedure that emits it, the only way to obtain the questions is
to invoke the command and have it fail its own guard — every user is routed through a
deliberate failure to get the form. Ship `templates/intake.md`, have the guard copy it, and name
the path in the command's usage block.

⚠ **A guard's success message may not claim more than the guard tested.** A placeholder
detector that prints `intake complete` has reported a semantic verdict on a mechanical check.
It will print those words over a boundary field answered with a description, a proposition that
is a heading, and a unit of analysis contradicting the function — and the user, having read
that step 0 passed, will read every later objection as the agent being difficult rather than as
the procedure working. Print what was tested: `no unfilled placeholders — fields not yet read`.

**The permission ordering rule.** ⛔ **Ask a permission question before the material it governs
is created, not after.** Where the intake asks both *who the client is* and *what material may
touch this repo*, the second must come first. Answered fifth, it arrives to govern a working
tree that already holds the organisation's name, a verbatim mandate and a trigger — and once the
first commit captures them, the boundary can no longer be enforced by deletion.

**The repository guard.** Assert the working directory is under version control —
`git rev-parse --is-inside-work-tree`. ⛔ **An instruction to commit presupposes a repository,
and in a plain directory every commit the procedure orders silently does not happen.** The run
then produces a quarter of a megabyte of interlocking artefacts with no history and no recovery
point between stages, which is exactly the condition under which a later stage overwrites an
earlier one unrecoverably. On failure, offer `git init` before stage 1, or take a ruling to run
without history and record that ruling in the frame.

**The registration guard.** Assert every subagent the run depends on is installed. **Presence
is necessary and not sufficient** — subagents are read at session start; skills reload live,
agents do not. One installed *during* the session sits on disk unregistered and this check
passes on it, so compare timestamps against the session and recommend a restart if younger.

⛔ **And installation is not invocation.** A host policy can forbid spawning agents, and it
silently outranks a command that calls its reviewer non-optional — the gate is then presented
against an unreviewed artefact, and nothing reports it. **Where an external policy can veto a
mandated step, the step's absence must be detected downstream by the artefact it failed to
produce, never upstream by the capability it would have used** (§2, §4). At stage 0, note that
a host may forbid spawning and take a standing authorisation from the user, recorded in the
frame, rather than discovering the conflict mid-run.

⚠ **Why the guards exist at all: an orchestrator whose reviewer is absent does not fail. It
proceeds, and produces work that looks reviewed.** A check that cannot find its input does not
fail — it passes.

⚠ **A guard that shells out to a named tool asserts the tool exists before trusting the reading.**
A missing binary does not fail the check; it produces empty output that every downstream comparison
treats as agreement, and the idiom `<check> && echo PASSED` then prints a verdict the author wrote
rather than one the check computed. Observed: a settings diff run through a JSON tool that was not
installed compared nothing against nothing and printed a clean bill. Open every such step with
`command -v <tool> >/dev/null || { echo "VERIFICATION NOT RUN: <tool> missing"; exit 1; }`, prefer a
validator that ships with the runtime already in use, and have the check print a verdict from data
it computed.

⚠ **Error handling describes the response, never the detection.** A condition named only in a
command's error-handling section is a wish: that section is read after something has already gone
wrong, so it cannot enforce a check that must run on the success path. Observed: an error-handling
section that read *"or has an incomplete field"* above a step 0 that tested existence only — both
sections correct, contradicting each other, with no passage in which the gap was visible. **For
every condition error handling names, find the step that detects it and confirm the detection is
written there.**

### Where a field is the human's alone, supply a test they can run alone

A procedure that forbids the agent from writing a field takes on an obligation with it. **A
prohibition plus a definition is not enough**: the person producing the wrong answer is, by
definition, the person the definition did not reach, so restating the standard produces another
attempt with the same shape. Give them a check on the **form** of their answer, which supplies
no content and so leaves the prohibition intact.

The one that worked for a central proposition: **check the grammatical subject.** A sentence
whose subject is the technology describes an intent and cannot be contradicted; a claim about
where the firm loses time or money has the firm as its subject. Second test: could the named
sponsor answer *"no, that is not where our problem is"*?

### A blank field and a ruling between costed options are not the same request

⛔ **The fields that fail repeatedly are the ones that are decisions, not facts.** An intake
mixing identity, context and permission — all things the sponsor holds and can state — with one
or two fields that are **choices between competing theories, each with a different cost of being
wrong**, is asking four kinds of question in one format. The decisions are the ones that come
back wrong, and they come back wrong because they are posed as blank essay prompts before any
analysis exists to inform them.

**A command that already has gate machinery should use it on those fields.** Keep the facts as
intake, filled before invocation. Turn the decisions into a **Gate 0** the command runs: the
agent reads the facts, proposes candidate answers with what each steers the derivation toward
and what it costs if wrong, and the human rules. The prohibition survives where it matters —
the human still chooses — but now between named alternatives instead of facing a blank line.

⚠ **The evidence is the failure rate, not a clock.** On the run this rule comes from, the two
decision fields came back unusable on **three consecutive attempts, each time in the same shape**,
while the six factual fields were right by the second pass. ⛔ **A field that fails three times
against a well-written definition is a field posed as the wrong kind of question.**

⚠ **Do not reach for the elapsed figure here, however tempting.** Intake did dominate that run's
wall-clock — 250 minutes against 68 for all the analytical stages and their reviewer passes — but
**that span also contains platform waits and absence, and nothing in it separates them from
thinking.** The failure-rate argument needs no such disclaimer. *(See §9.)*

### Ship a way to exercise the arc without a real engagement

A procedure whose entry conditions can only be satisfied by a live sponsor has no supported way
to be run for evaluation, for tuning a skill, for a demo, or for onboarding. **The only route
left is to defeat the guards, which teaches exactly the habit the guards exist to prevent.**

Ship a filled specimen intake for a synthetic organisation, have the command detect it or accept
an explicit flag, and in that mode permit agent-supplied fields **on condition that the frame
records the run as synthetic** — the same treatment already given to a run with no reviewer pass.
The frame exists to carry *"this run differs from a normal one, and here is how"*.

### Gates encode where the author expects a human to be reachable

⛔ **Before writing any gate, decide which operating model the arc serves**, because the gates
are where the two diverge and nothing else in the method is affected.

| | **Commissioned** | **Targeted** |
|---|---|---|
| The sponsor is | reachable throughout | unreachable until the work is largely done |
| The mandate is | quoted verbatim from them | **inferred, with the evidence it was inferred from** |
| The central proposition is | theirs, and the agent may not write it | **openly the consultant's hypothesis** — the agent may draft candidates, and the artefact records that it did |
| A gate asking *"would the sponsor recognise this?"* | is answerable | ⛔ **is not** — it becomes *"is this defensible enough to put in front of them cold?"* |
| An unanswerable question | goes to the sponsor | becomes a **registered assumption plus an agenda item**, ranked by cost of being wrong |

⛔ **A field the agent may not supply, supplied by the agent under a ruling, is re-put to the person
in plain words at the very next gate — before anything quotes it.** Recording the deviation is not
arresting it. Observed: an agent-drafted proposition accepted with *go with the defaults* was
quoted verbatim through twenty-one stages and thirteen gates, owned the deliverable's first screen
and filtered half the portfolio; every check recorded the exposure and none could stop the run,
because only a gate can refuse, and the first gate to put the sentence in plain words was the second
arc's fifth. The frame's deviation entry stays; the next gate is the step that acts on it.

**The rulings are the same rulings; only the source of the answer changes.** ⛔ **An
unanswerable gate is bypassed rather than removed** — it stalls the run once, is talked past the
second time, and thereafter trains the operator to treat every guard as an obstacle. Phrase each
gate for the person who will actually be in the room, and **declare the mode in the intake** so
the phrasing is not a judgement call taken mid-run.

### A host's read-only planning mode belongs at the entry and the resume, and nowhere a stage writes

Where the host offers a planning mode — read, search and run read-only commands, but write nothing
until a plan is approved — **the guards, the entry gate and the resume report are exactly that
shape**, and the mode turns *"nothing is written before the entry rulings are made"* from an
instruction into a property of the host. So: **the command's first action enters it**, the entry
gate's report *is* the plan, and approval is the event after which the first write is legal. On a
resumed run the resume report is the plan — the artefacts found, the stage each maps to, the gate a
resume onto that point must stop at — because a wrong resume point re-runs finished work or skips
a gate and this is the one cheap moment to catch it.

⛔ **The trigger is the context boundary, not the word *resume*.** Plan mode on a resume exists to
catch a lost context. When the stage being resumed follows a gate ruled *in the current session*,
nothing has been lost: the register holds the rulings and the inputs are in context. Observed: a
resume immediately after a same-session gate re-put, as a plan, the content the person had ruled
minutes earlier; they approved what they had just decided, and the stage's produce span carried a
round trip that produced no information. Fired on the name of the step, the checkpoint teaches the
operator that it is a formality — which is what makes them wave through the one that matters. So:
**a resume across a clear, a compaction or a new session enters plan mode; a resume that follows a
gate ruled this session writes a one-line statement in the gate close-out — *stage N starts;
inputs: …* — and proceeds.**

⛔ **It ends before the first stage and is not re-entered at mid-arc gates.** Those gates rule on an
artefact already written and reviewed; a read-only mode there blocks the reviewer's file and the
stage commit, which are the two things the method most needs written.

⛔ **Approval of a list of candidates is not a ruling, and the plan file is not an artefact.** The
person chooses; the plan is rewritten to carry the rulings as made; only that is approved. The plan
lives outside the repository and no resume reads it, so **the first write after approval is the
ruling register**, before the instruction file, before the frame. A ruling that exists only in the
plan is a ruling from memory.

**The entry cannot be made automatic, and say so.** No frontmatter field on a command or skill sets
the mode, a plugin's subagents may not declare one, and a hook cannot switch it. What a command can
do is call the host's enter-plan-mode action as its first step, so the person consents with one
prompt rather than remembering a keystroke. If the host has no such mode or the person declines,
run the same steps read-only by instruction and **record in the frame that the entry ran without
it** — the rulings are the same; what is lost is the enforcement.

---

## §2 · State — derive it from artefacts, never from a state file

Every artefact declares in its header **its step, its `Status`, its `Input` — the artefact it
derives from — and the date.** A step whose input is not named cannot be checked. State is then
derivable from a directory listing and no session has to remember anything.

Three obligations follow, each violated in practice:

1. **Every step must leave an artefact.** One that writes nothing is not merely unrecorded, it
   is unresumable, and the gap surfaces as confident memory rather than as an error. Adding a
   step is therefore a change to the **state model**, not just to the sequence.
2. **Anything inserted between two numbered stages needs its own sort key** (`8p` between 8 and
   9). A resume rule that points at stages cannot see a step that is not one.
3. ⛔ **No gate is visible to an artefact scan — not only the ones that do not sit after a
   stage.** A stage that has been produced, reviewed and rebuilt looks exactly like one that has
   also been ruled: same artefact, same reviewer file, same commit shape. Approval leaves no trace
   on the thing approved. An earlier version of this rule named only the gates that precede a
   stage, and a run paused at an ordinary post-stage gate with seven rulings open would have been
   resumed past it, correctly by the scan's logic and wrongly in fact. **The register is what makes
   a gate visible** (below): the resume is a join — for each completed stage, is a gate defined
   after it, and does the register carry that gate's rulings? **A completed stage with a gate
   after it and no rulings on file is a stop, not a question** — the resume lands on the gate and
   produces nothing until it is ruled. Gates that precede a stage are still listed, because they
   are the ones a resume onto that stage would otherwise land past.

### Three artefacts every command creates at entry, before stage 1

⛔ **A rule that checks one artefact against another is only as real as the second artefact's
existence, and stating what it should contain does not make anything create it.** Three files in
this discipline are referees for other rules, and on the run that produced this section none of
them was created by any step: the rules that depended on them were unrunnable, and a hand-maintained
resume document filled the gap — which is the tell, below, that the mechanism has already broken.
So the entry step of every command writes all three, empty, as its first writes after the entry
ruling, and the pre-flight asserts them:

| File | Referee for | Created |
|---|---|---|
| **The ruling register** — one row per ruling: identifier, question, answer, mode, who, date | §3 rules 2, 3 and 5; the resume join above | At the entry gate, holding that gate's rulings as its first rows |
| **The identifier registry** — every series in play, its prefix, its range and its owner | The collision rule below; §7 | At entry, seeded with the series the command mints and every series its inputs already carry |
| **The timings file** — one row per stage-phase, from commit timestamps or `not measured` | §8's close-out; §9 | At entry, header only |

The gate's accounting line (§3 rule 1) is **computed from the register**, never narrated; the
collision check is a grep against the registry, never a recollection; the timings row is a
condition of the commit. **Every stage header also records the plugin version it ran under** — see
the resume rule below.

**A stage that adds an artefact adds a line to the resume map, a directory to the scan, one to
any count stated in prose, and a row to any rendered view of the map** — all of them, in the same
edit. ⭐ **A view that lists what it found and could not map is the check that the map is still
complete**; a prose map has no such check, which is how two of three were missed the first time.

### A directory an orchestrator globs is an interface, and its naming belongs to the reader

⛔ **Where a command's stage numbering differs from the skill's step numbering, the reviewer
artefacts will be filed under both.** It happens without anyone deciding: early passes take the
skill's numbers, later ones the command's, and the result is a directory in which one filename
means a different stage from the one the resume rule will read it as — while two stages appear
to have no pass at all.

- **Require the pass filename to carry the orchestrator's own stage identifier**, since the
  orchestrator is what reads it — and say so in the same sentence that defines the write, not in
  a separate convention elsewhere. ⛔ **Where more than one orchestrator writes into the same
  repository, the pass carries the orchestrator's identity as well as its stage** — a directory
  per arc, named in the command. Three commands running in sequence in one repo each have a
  stage 2, 3, 4 and 5; a shared reviewer directory overwrites the first arc's passes silently, and
  the author who notices invents a directory the next engagement will invent differently. **Every
  arc has a directory of its own before its first artefact**, and the view that reports on the run
  reads from it.
- **Require the pass's header to record both schemes** (`step 5b · stage 7`), so a human reading
  one file can resolve the other without opening the command.
- ⛔ **Never mint a new identifier series without checking it against every series already in
  play.** One run had `S1`–`S3` as gate rulings and `S1`–`S32` as sector statements
  simultaneously, in artefacts that quote each other, and an artefact's own verdict read
  *"conditional on S3"* meaning the other one. ⛔ **And a prohibition on minting is not a check on
  minting.** Identifiers are chosen as a side effect of writing something else — a table header, a
  gate's criteria list, a generator's constant — and nothing between choosing one and committing
  asks whether it is a series. On one run the registry existed, was cited, and ended *do not add a
  series without checking this table*; the same agent minted four colliding series that afternoon.
  So the check has a moment: **any gate or stage that introduces a series opens the identifier
  registry first and either takes a free prefix or records the collision at the moment of naming**
  — never at the moment of recording, because by then the colliding name is in a document a
  person has ruled on. A hyphenated series is still a series: `R1-R1` is one hyphen from `R1`.
  **An artefact that continues an existing series reads the series' current maximum from the
  registry at generation time and asserts its own first identifier is max+1**; a hardcoded
  continuation is a defect. Observed: a generator drafted in one session against `G1`–`G3`
  carried `G4`–`G6`; the next session's rebuild registered its own `G4`–`G5`; two different
  questions would have been `G4` in two committed artefacts. The second extender always believes
  the range it saw. §8 puts the grep on the commit.
- **Add a self-test to the resume step:** a stage with an artefact and no reviewer file is
  reported as a **question at the next gate**, not silently re-run. Re-running a pass is not free
  and is not idempotent — a second reading finds different things and they look like new
  information.
- ⛔ **A resume re-runs the entry guards, and compares the plugin version against the one the
  entry artefact recorded.** A guard that runs once at entry protects the entry, not the arc.
  Observed: a plugin updated between two stages of one arc changed what a later stage scored and
  what the register had to carry, and no artefact said so — the cost model then compared stages
  measured on two instruments as if on one. On a mismatch, write a version-change note into the
  next stage's header and the timings file, naming which method sections changed. **Every stage
  header records the plugin version it ran under**, so the instrument a measurement was taken on
  can always be named.

> ⭐ **The tell that a stateless resume has already broken is not an error — it is a workaround
> that keeps succeeding.** If a hand-maintained note is what makes the resume land correctly,
> the documented mechanism has stopped working and nothing will report it, because the note works.

### The resume document — durable and transient content need different addressing

A long arc acquires a handoff or resume document carrying what the artefacts cannot: why things
were ruled as they were, and what is still open. It is not the state and must not become it.
Two rules keep it usable.

**1 · A work order must not be addressable by a name that outlives it.** Durable context —
goals, operating model, rulings taken — is stable and may be cross-referenced by number. The
next-stage work order is transient and is correctly deleted once executed; give it a **fixed
heading at a fixed position and never a number**, so a pointer reads *"see the work order at the
foot of this file"* and cannot dangle. After deleting a consumed work order, grep the document
for references to it. ⚠ **A work order that also acts as a scope instruction will narrow the
conventions around it** — one naming a single stage silently defeated a standing rule reading
*"review after every stage"*.

**2 · Every open item must state the condition that closes it.** ⛔ A document holding both a
running narrative and a standing open-items list will drift, because appending to the narrative
is the natural act of finishing a stage and re-reading the list is not — and it drifts in the
dangerous direction, the narrative advancing while the summary keeps issuing stop instructions
from the past. Write each item as *"closed when `critic/9.md` exists"*, *"closed when the gate's
rulings are recorded"*, so close-out is a check that runs rather than a re-read that is skipped.

**3 · An open item whose artefact lives in another repository names that repository and the
path.** ⛔ A status claim is closed by an event, and the event has to happen where the claim is
recorded. Where the method is authored in one repo and consumed in another, the commit that
finishes the work is invisible to the consuming repo's resume document, and the item stays open by
default however completely it was done. Observed: *rewrite the orchestrating command* stood as
item 1 for two sessions after two commits of 600 lines had done it elsewhere. Name the repo and
path so the resume step can `git log` it rather than trust it.

---

## §3 · Gates — batch them, reconcile them, and never answer one

At a gate: **stop, report what was produced, put every open decision, and wait.**

**Batching is the point.** What consumes a person's day is rulings arriving one at a time, not
the analysis. A gate presents the whole set in one pass — its own question, every ruling the
review passes raised, anything an earlier gate deferred — and **each carries a recommendation
and what it costs to go the other way.** A gate that asks one question and returns an hour
later for the next has failed, even if both answers were right.

⚠ **Never answer a gate and continue** — that is the method defeated. ⚠ **Never auto-execute
the recommendations of a self-review**: acting on them feels like diligence, and several will
be reversals of decisions the human already took. **If an answer is ambiguous, restate what you
heard and ask again** — do not pick a reading, because a misfiled answer propagates through
every downstream stage.

### Why batching holds — and it is not a ratio

⛔ **Do not justify batching with a measured gate duration.** It is the obvious move and it does
not survive contact with the data. An earlier version of this file argued from *"gate open to
first ruling: 119 minutes, against 13 to apply the rulings and 5 to produce the stage it
blocked — 6.6×."* The timestamps were real and the figure was still wrong for the claim, because
**elapsed time across a human is a measurement of the environment, not of the person.** That span
contained deliberation, absence, **and a rate limit that had not yet reset** — and only the
operator knew which. *(See §9, and the same contamination in the intake figure.)*

**The argument that does survive needs no clock.** Serialising *n* rulings costs the human *n*
context switches — *n* returns to a document they had put down, *n* reconstructions of what the
run was doing — **whatever each ruling takes.** Batching removes *n−1* of them. That holds if the
gate takes two minutes and it holds if it takes two hours, so it cannot be undercut by a faster
operator or a better connection.

⛔ **The consequence still inverts the intuition.** Every instinct says to spend agent time
carefully and human time freely, because agent output is what gets inspected. **The human's
attention is the scarce resource and the analysis is the cheap one** — so **do more preparation
per gate, not less.** Sweep every deferred item, every reviewer finding and every downstream
dependency into the batch, each with its cost of being wrong. **A short gate is not a cheap
gate.**

### A gate report reconciles escalations in against rulings out

⛔ **A gated process records what was decided and, by default, records nothing about what was
asked and not answered** — so an unanswered question is indistinguishable from a settled one the
moment the next step begins. On the run this rule comes from, a reviewer escalated three
questions to a gate, one was ruled, and the next two steps each recorded one of the survivors as
settled: the first by reading *the previous artefact's own label for its decision* as a human's
ruling, the second by settling it implicitly through the order in which it arranged its sections.
Both steps had clean arithmetic and resolving citations.

Five rules, all mechanical:

1. **A gate report closes with an accounting, not a list**: *N escalations received, N ruled,
   N deferred, N declined.* Every deferred item gets an identifier and a named destination. **An
   escalation that reaches a gate and is not answered must appear in the record as unanswered.**
2. **A downstream step may not cite a ruling identifier absent from the ruling register.** Grep
   the register for each cited identifier.
3. ⛔ **An artefact's own label for its decision is not a ruling.** The ruling register is the
   authority, never the artefact — the failure mode is reading a step's self-description as a
   human's decision.
4. ⛔ **A gate report may not carry a "not rulings" category.** Anything placed in one is thereby
   moved out of the decision set while looking accepted: on the run this rule comes from, a live
   defect filed under *"not rulings — stated so they are not mistaken for open"* passed through
   three further gates untouched, and every later artefact described it as *carried*, which reads
   as though a human had accepted it. **Nobody had ever been asked.** If a category like this is
   kept at all, every item in it is **put for** an *accepted* or *deferred* mark, **and the mark is
   the ruler's**. ⛔ An earlier wording — *every item must carry a mark* — was satisfied by the
   artefact writing the mark itself and citing this rule as its authority; rule 3 forbids exactly
   that, but it is stated about rulings and an *accepted* beside an agenda item does not read as
   one to the author writing it. A rule phrased as a property the record must have will be
   satisfied by whoever writes the record. **Until the mark is in the register, the item counts as
   put in the accounting**, and the accounting is computed from the register, so an artefact
   cannot mark anything without writing to a file it is not permitted to write.
5. ⛔ **The register records *how* each ruling was taken, not only what it was.** Three modes:
   *chosen from written options* · *batch authorisation of the agent's recommendation* ·
   *declined*. As rows they look identical — an identifier, a question, an answer — and they carry
   different weight: an authorisation of recommendations not yet written is closer to *proceed on
   your judgement* than to a decision. Observed: a five-decision gate answered *"take your
   recommendations on all five"* before any recommendation existed; the same five put again later
   with each option written, sourced and costed, and **one answer reversed with no new evidence,
   because the alternatives had been laid out.** So **a later choice from written options
   supersedes an earlier batch authorisation without a stop; the reverse direction stops** — the
   reversal was not a contradiction but the first real ruling. And present options with costs
   before asking: *take your recommendations* is the answer an unenumerated gate invites.

   ⛔ **A recommendation is one answer.** Batch authorisation delegates the choice to the
   recommendation, so the recommendation has to have made one. A row that offers two — *"M1 only,
   or none"* — converts the ruler's shortcut into the agent's decision, and the register cannot
   tell the two apart. Such a row is marked **requires a choice** and is not batch-authorisable;
   the gate report's accounting counts *N batch-authorisable · N requiring a choice*. ⛔ **And an
   option is authorised as a rule, not as a description.** A ruler consents to what the option
   says it does; where the option's stated effect is later found wrong on the records — a promote
   list that named the wrong entries — record a *description corrected* note against the ruling,
   re-put only if the rule itself would change, and **generate the effect list from the records
   wherever the records exist**, because a computed effect cannot be wrong on them. Two further
   modes follow from this: *batch authorisation on a corrected description* and *requires a
   choice — not yet taken*.

   ⭐ **What the mode column shows, read across a run: a gate that puts written options with costs
   gets real rulings; one that does not gets *"take your recommendations"*.** On one run 28 of 32
   rulings were batch. The gate report states its batch share beside the accounting, so the
   weakness is visible where the ruling is taken and not only in the register afterwards.

**This presupposes a ruling register exists, and §2 makes the entry step create it**: a single
file, one row per ruling, each with an identifier, the question, the answer, **the mode it was
taken in**, who ruled and the date. Without it, rules 2, 3 and 5 have nothing to check against —
and the register is also what tells a later session which decisions may not be re-litigated, and
what makes a gate visible to a resume.

### A question reserved for a person is put in the person's language

⛔ **The questions a method reserves for a human are the ones most at risk of being put in machine
shorthand**, because by the time they are reached the agent has been speaking the record's language
for hours. Observed: the one gate question the command forbids the agent to answer was put as a
six-row table of identifiers and record fields to a ruler who had taken fifty rulings without
pausing — and who answered the rest of the batch, then said of that one: *it is unclear to me
exactly what each of these does.* A gate item is put to a person, not to the record; **if it cannot
be decided without re-reading the derivation, it has not been put yet.**

So a gate item the agent may not answer is put **in plain words with a worked example**. Minimum,
per candidate: the situation today · what changes · whose hour is saved · whose hour is created ·
what the demonstration shows · and one concrete example each of what *yes* and *no* would look like
in the room. The identifier table accompanies it and never replaces it. The reviewer's gate check
asks: *is each reserved item decidable by a reader who has not opened the artefacts?*

### When two rulings contradict, ask whether one object is being made to satisfy both

⚠ A contradiction gate that offers only *which ruling stands* will systematically miss the
commonest resolution. Observed: an earlier ruling existed because one artefact had been given two
incompatible audiences; the fix was to **split the artefact**, after which both rulings held on
their own halves. So a contradiction gate offers three outcomes — the earlier stands · the newer
stands · **both stand once the thing they disagree about is split** — and records *which grounds
changed*, since a ruling reinstated on new grounds is not a reversal. And **a gate that protects
against assumed consent must not fire when consent has demonstrably been given**: where the ruler
has already been shown both positions in this session and chosen, record the contradiction and its
resolution instead of re-asking. Weight the two rulings by their mode (rule 5).

---

## §4 · The reviewer pass

Run the reviewer **after every stage, before the next begins**, on that stage's artefact and the
artefact it names as input. It runs in its own context, so it costs the human reading and
nothing else. **Write each pass to disk** — it is the only record the pass happened. ⛔ **And
write a stub the moment the reviewer is spawned** — the pass file with a header and `Status:
running`, replaced by the findings on completion — because a reviewer killed partway through by a
host rate limit leaves no record at all, and an absent file cannot distinguish *never ran* from
*found nothing* from *died on its first tool call*. The filesystem is the only state this method
trusts; give the interrupted pass a shape it can see.

⛔ **A reviewer pass has two levers on its finding count — what it reads and what it runs on — and
only one may move between passes if either count is to stay interpretable.** A subagent that
declares no model inherits the session's, and an inherited setting is not a constant; it is a
variable nobody wrote down. Twenty-two passes on one run were compared as a band before any of
them recorded the model it ran on. So **every pass header carries a `Model:` row beside its
`Read:` line.** Recording the variable is nearly free and is what makes leaving it free to move a
safe choice rather than an invisible one. Where a cheaper model is considered for the reviewer,
note that the reviewer is the one subagent run often enough for a downgrade to save anything and
the one whose findings are the product — so the saving lands exactly where a capability drop costs
most.

**Point it at the artefact and the inputs the artefact names, and let it open the rest by
lookup.** The pass's cost is its reading, and on one run that reading grew with every stage
because each pass opened whole files it needed a section of. The reviewer's own reading budget
lists what it may open by lookup: the method section for the stage, the ruling rows cited, the
resume document's section for the gate the stage feeds, an earlier pass the artefact says it
answered, the commit log where the artefact asserts a time. It reports each file as *full* or
*lookup* with line counts. ⚠ **Narrow the reading, never the checks.** A budget tight enough to
skip the earlier pass, the register or the method section loses findings, and a pass that finds
less looks like a stage that got better. Test any budget against past passes before shipping it:
list which findings needed which files. Where a check needs a file outside the budget, the pass
names it under *Untestable by me* and the command decides whether a wider pass is worth it. The
proxy (§5) is narrower still: it reads the artefact as the sponsor would, and the sponsor never
saw the working files.

**The three-way split of its findings is the command's to make, never the reviewer's:**

| It reports | You do |
|---|---|
| A defect it names and you can fix | Fix it now, and say so at the gate |
| A defect needing a human decision | Carry it to the gate as a ruling |
| That something looks right to it | Discard it — it cannot confront anything |

⚠ **A pass returning nothing is a finding about the pass, not a compliment to the work.**

**On a resume, review only what this run produced**, plus any earlier stage whose pass file is
missing. Re-reading settled work finds different things and looks like new information.

### Corrections propagate forward and never backward — instrument the return trip

⛔ **Every reviewer pass reads the stage it reviews and that stage's declared input. It looks
upstream.** Nothing at any point re-reads an upstream artefact after a downstream ruling changed
what that artefact says. So corrections travel in exactly one direction, and **the artefact that
introduced a withdrawn claim keeps asserting it — with the confidence of a source rather than
the hedging of a citation.** A reader consulting the earliest artefact, which is the natural
first file, gets the superseded version stated most strongly.

This is a third failure class, distinct from the two usually instrumented: count reconciliation
compares an artefact with itself, a provenance diff compares it with its inputs, and **nothing
compares an artefact with its own downstream corrections.**

Two obligations, and both must be mechanical:

1. **At the moment a ruling is recorded**, the same edit strikes the withdrawn thing **in place
   in the artefact that introduced it**, and the gate report names which upstream files were
   touched. A withdrawal that edits only downstream artefacts is incomplete by definition.
2. **In the reviewer contract**, add a required check: grep every artefact for identifiers,
   counts and claim-phrases that a later artefact records as struck, superseded or withdrawn, and
   report each surviving instance. The corpus is already greppable — chains write these as
   *"— withdrawn"*, `~~struck~~`, *"read N until \<date\>"*.

> ⛔ **The cheap remedy does not work and has been tried.** On the run this rule comes from, the
> artefact owning a changed count wrote *"every artefact quoting the old figure is stale after
> \<date\>"* — in the right file, on the right day, in greppable form. **Ten locations were still
> stale hours later, including the owning artefact's own header.** The defect was not an absent
> rule but an unexecuted one, so adding a sentence saying *propagate corrections backwards*
> reproduces exactly the sentence that already failed.

Add a pre-flight box: **no artefact asserts a claim that a later artefact records as withdrawn.**

### Review economics — budget the rebuild, and do not expect findings to fall

⛔ **A stage is not written-then-checked. It is written, reviewed and usually rebuilt, and the
rebuild is the largest part.** Measured with the phases separated at the time: producing an
artefact 4.8 minutes, the reviewer 7.2, rebuilding after its findings plus writing the pass
record about 13. **A run planned as "fourteen stages" is planned at roughly a quarter of its
true size** — and the phase dropped first under time pressure is the one carrying most of the
value.

⛔ **Findings do not fall as the chain matures.** Across twelve consecutive passes on one run:
**9, 18, 14, 12, 12, 10, 18, 13, 16, 12, 14, 15 — mean 13.6, no trend.** Each stage introduces
new claims, new quotations from upstream registers and new instruments; maturity in the *earlier*
artefacts does not protect the *next* one. **Read a flat rate as evidence that per-stage review
is still necessary at the end of a chain, never as evidence the reviewer is padding — and do not
set a declining rate as a goal, because a rate that falls may mean the reviewer was narrowed.**

⛔ **And findings do not track how much the stage derived.** The unstated assumption under the
band above was that a light stage would be cheap to review. The thirteenth pass on that run
falsified it: an entry-path declaration — no traversal, no scoring, only inherited figures and a
path decision — returned 13 findings in 11 minutes, none discarded on sorting. A step that only
quotes and inherits is doing the one thing this method's defects concentrate in: carrying a claim
across a boundary, where hedges drop, counts go stale and provenance is asserted. **Budget a
reviewer pass per stage boundary, not per kilobyte** — roughly ten to fifteen minutes and roughly a
dozen findings whatever the stage is made of — and do not insert a "light" stage to tidy a join on
the assumption that it is free. Through 32 passes on three arcs, on two plugin versions, two
reading budgets and a 64 KB page, the band held.

⚠ **Generated artefacts invert the ratio below.** The rebuild figures in this section were measured
on hand-written artefacts. On four consecutive stages produced by a generator script, the rebuild
took 2–6 minutes and the reviewer pass 13–16: **review is then the largest phase**, because a
finding against a generated table is a one-line change to the generator and a re-run. State which
kind of stage a published figure was measured on, or the wiring page will plan the wrong phase.

**Commit per stage-phase — produce / review / rebuild — so the split stays measurable.** It
costs one timestamp per boundary and is the only way the ratio can be known; reconstructed
afterwards the three phases are indistinguishable. ⚠ **That presupposes the phases are
sequential.** The rational move while a reviewer runs is to draft the next stage's generator, and
the moment an agent does that the commit timestamps still exist and still look like boundaries —
but stage N+1's produce span has moved inside stage N's review span, and the timings file records a
real figure that measures a script run. **Where work on stage N+1 begins before stage N's review
returns, the timings rows of both stages record the overlap and stage N+1's produce span reads
`not separable — authored during stage N's review`.** ⛔ **And never write a duration you did not
measure.** A timings file is an instrument, and a reconstructed figure wearing the word
*measured* corrupts it silently — no reviewer pass can catch this, because a reviewer reads an
artefact against its inputs and **a timestamp has no input.** Take timings from the commit log,
or write `not measured`.

---

## §5 · The proxy pass — and why it must fire early as well as late

A proxy reads the work as a named sponsor and produces **the agenda for the real
conversation** — ranked questions, each with what breaks if the answer goes the other way.
**Give it the sponsor's identity**: role, what they are measured on, what they have already
seen. Without it you get a generic sceptic, which is worth nothing. **This presupposes the
sponsor's identity was captured at intake** — require the field.

⚠ **The strongest marker its output may support is `confronted · internal`. Never plain
`confronted`.** It is the same author attacking their own work through a persona: simulated
challenge reliably finds internal inconsistency and reliably misses the thing the author did not
know. Only the second needs a person. **If its report retires the conversation with a
practitioner, it has made the work worse.** ⛔ **And there is no fourth marker.** One run wrote
`confronted · proxy` into a register because the three-value scale had no place for the proxy's
own statements; the place is `position`. What the proxy asserts about the sponsor is the author's
inference wearing a persona, and a worksheet row resting on it rests on a position.

### Method review and stance review are different questions, not different depths

⭐ **The reviewer asks a closed question** — are the counts right, was the instrument applied,
did a quoted position keep its clauses, did this step discharge what earlier steps assigned it.
It can only find defects the method's own vocabulary can express, and **everything the chain
never thought to ask about stays invisible however many passes run**, because each pass shares
the chain's frame of reference.

⭐ **The proxy asks an open one** — what would the person on the other side of this need to be
true. That is what finds a **missing category** rather than an error inside an existing one.

The cost asymmetry is the striking part. On one run, five reviewer passes at 7–9 minutes and
105–147k tokens each found 10–18 defects apiece; **a single proxy pass at 2m38s and 63k tokens
surfaced a whole class of constraint no reviewer had touched** — whether the client was
contractually permitted to put its counterparties' material into a third-party service, which
five of ten recommended capabilities depended on. It was registered as the run's only fatal
assumption.

⛔ **The usual wiring gets this backwards**: the reviewer fires after every stage, the proxy
fires once and late, after the argument is written — so the one pass capable of finding a missing
category runs after every decision that category would have changed.

**Run the proxy twice.** Once **against the frame**, before the traversal commits to a scope and
a unit of analysis, and again against the finished argument as now. The early pass is cheap and
is the only mechanism in the method that can surface an unthought-of constraint while it is
still cheap to act on. **Run it where the work is defended, not where it is derived** — a proxy
over a working instrument its sponsor will never read is a pass with no audience.

---

## §6 · The specification step — what a contract is actually worth

Where an arc ends in a built deliverable, put a **specification** between the analysis and the
build: the step where the chain stops deriving and starts instructing.

⭐ **State its benefit in the terms the measurement supports, because the intuitive case is
wrong.** Rebuild-to-production ratios across three consecutive stages ran **1.3×, then 4.8×,
then 0.9×** — and the stage that broke the pattern was the largest artefact in the run and the
only one built against a specification.

> **A specification does not reduce the defect rate.** The reviewer still raised fifteen findings
> against the specified artefact, in line with every other pass in the run. **It reduces what
> each defect costs**, because a finding against a specified artefact is an **edit**, where
> against an unspecified one it is a **re-derivation**. Expect the same number of findings and
> roughly a fifth of the rework.

⛔ **The precondition is what makes that true: the specification must itself be reviewed before
anything is built against it.** The one measured above was, and was wrong in fourteen places —
four of them omissions that would have propagated silently into the build. **An unreviewed
contract relocates the re-derivation one step earlier and adds a step.**

### The omission sweep — the one defect class no other check can reach

⛔ **A contract omits by silence, and anything not specified will not be built.** Every
verification a chain accumulates — count reconciliation, provenance diffs, partition checks —
compares what an artefact **says** against its sources. **None can see what it fails to say.**

Make this a required check on any specification or contract step:

> For each input artefact the contract names, enumerate its load-bearing elements — tensions,
> registers, dependencies, unresolved questions, and **any sentence phrased as an instruction to
> the downstream artefact** — and assert that each has a named destination in the contract's
> structure, or an explicit written decision to exclude it.

Make the enumeration mechanical where the format allows: these are already marked with
consistent tokens — a tension heading, a register table, a flagged instruction.

⛔ **The sweep has a required shape, and a sweep without it is rejected on form: one section per
input, a count of elements enumerated from that input, then the disposition of each.** A flat
list of placed elements across all inputs is not a sweep — it is a list of what the writer already
had in mind, and an omission is by definition outside that. Observed: thirteen elements, each
correctly placed, and **three named inputs with no row at all** — nothing distinguished *this
input contributed nothing* from *this input was never opened*. Rebuilt input by input with a count,
the same sweep found forty elements and seven with no destination, among them the strongest
recorded objection to the thing the document was being built to lead with. **The tell is the
missing denominator**: a list of found items with no count of items examined reports its hit rate
as its coverage. And **a sweep that removed nothing is read as unapplied, never as satisfied** —
the per-input count is what makes *removed nothing* a statement that can be made at all.

⛔ **And a step that shortens a list it inherited must publish the count before and after.** One
run's caveat register went from nine rows to six with no number stated anywhere — inside the
section that declared shortening forbidden — and only a row-by-row diff against the source found
it.

⛔ **A pointer is not a placement, and a truncation is a paraphrase.** The sweep counts an element
placed only when its content is reproduced at the destination; *"see `orders.md` §4"* is a
pointer, and nine of them passed one run's sweep as placements. A cell cut to a fixed length with
an ellipsis is a paraphrase the count-based verifier cannot see, because qualifications live in the
tail of a sentence and identity lives at its head — on the same run the cuts removed *it
contradicts the proposition itself* and *SC4 is not re-added*, so a criterion vanished from the page
while every count reconciled. **A quoted cell is reproduced in full or is not quoted.**

Add a pre-flight box: **every load-bearing element of every input has a destination or a stated
exclusion.**

### The verification clause — a check is only as independent as its denominator

⛔ **A verifier whose expected set comes from a file the same author wrote for the same page
confirms consistency, not completeness.** Observed: a page's completeness check was *transitive* —
the expected rulings were the ids named in the author's outline — so when a late ruling was applied
to the page without an outline edit, the page lacked it and the check passed. The denominator had
moved with the numerator. And a check implemented as the author's numbers typed into the script and
compared to the page is the drafting computation run twice. So the specification's verification
clause requires:

1. **Two denominators for every completeness check** — the author's map *and* a register the
   author did not write for this page (every ruling id in the register must have a row; every
   assumption cited must exist in the frame).
2. **Expected counts derived from the page's own rows or from an upstream file, never from a
   literal**, and a list of every number word in the prose that no derivation covers, so the
   coverage denominator is visible.
3. ⭐ **The verifier ships with the list of mutations it was shown.** A verifier that has never
   been handed a wrong page is a script that agrees with its author. Before a verification stage is
   called done, single defects are applied to a copy of the artefact — drop a row, un-strike a
   withdrawn clause, swap two citations, change a count by one, add a second version string,
   remove a source attribute — and the ones the verifier passes are findings. On the run this rule
   comes from, the reviewer built that harness on its own initiative and seven of its ten findings
   came from it; the verifier had passed a dropped ruling, an un-struck clause and five untested
   counts, and its output read `ALL CHECKS PASS`. **An instrument is reviewed by what it fails to
   catch, not by what it reports.** §4's reviewer contract names the mutation pass for
   verification stages.

---

## §7 · Markers, identifiers and hazards

**Mark every claim** `position` (asserted) · `confronted` (tested against someone who knows) ·
`evidenced`, and hold a standing rule that every session moves one forward or says why not.
Without it the work drifts into a brochure while appearing to improve.

**IDs are the spine** — stable at every layer, cited forward, **never renamed and never
deleted.** ⚠ **Never delete what a ruling drops**; mark it dropped in place, because later
stages cite its identifier and a deleted ID is an unresolvable reference.

⚠ **Never mint a second set of IDs for something already identified.** Where one command
inherits another's output it adopts those identifiers, **and records in the artefact header
that it did** — the reader cannot otherwise tell derived work from inherited, and the
difference changes what the output may claim. ⛔ **The same holds column by column.** A table
that mixes inherited fields with fields authored at this step — a trigger derived here beside a
verifier carried from upstream — marks which is which and states the rule that produced the
authored ones; authored fields inside an inherited table are the least examined content in the
artefact, because the rows around them carry the source's authority.

⛔ **Verbatim is a property of bytes, not of intent.** An agent transcribing prose normalises it —
capitalises an opening, corrects a typo — and calls the result verbatim; on one run a ruled
proposition was written into three files within fifteen minutes and produced three different
strings, each labelled verbatim, with the project's *verbatim, untidied* rule in the loaded
instructions while it happened. A rule against tidying has no moment at which it fires. So **text
that later stages must quote verbatim is written to one file and every other location cites it, or
the same edit copies it with a byte-compare assertion** — `grep -cF` of the exact string across the
files, the expected count printed in the commit — and the reviewer's contract keeps the cross-file
byte comparison of quoted fields as a standing check. An intake field that must be verbatim says
*paste; do not retype*.

### A hazard named without a trigger is discharged by being mentioned

Writing *"⚠ this may be wrong"* against a defect reads as rigour, costs nothing at the time, and
creates no obligation on anyone later. **Every carried hazard, caveat or known-unknown must name
(a) the step or moment that must test it and (b) what the test is.** A hazard that can be given
neither is not a hazard being carried — it is a defect being disclosed, and it should be fixed or
ruled on now.

⛔ **And a discharge condition written against an instrument's *contents* rather than its
*application* discharges nothing.** One frame required a step to *"carry a class for X"*; the
step created the class, wrote that the hazard was thereby discharged, and then applied the class
to **zero** of fifteen tasks and zero of twenty-three opportunities — while one item matched its
definition exactly. Nothing distinguished *carried and correctly never applicable* from *carried
and overlooked*.

- **Require every discharge to name its instance, or to record the search that found none.**
  The register's discharge column holds an identifier, never a tick.
- **Any instrument that defines a category reports that category's usage count**, and ⭐ **a
  category used zero times is a finding to investigate, not a neutral outcome** — either it is
  unnecessary or it was missed.

---

## §8 · Committing, and the close-out that makes conventions survive

**Commit locally after each completed stage**, naming the stage and what it produced. **Never
push** — that is the human's.

⛔ **Attach every standing obligation to an action that already occurs.** A convention stated as
a purpose has no moment at which it is due, so under cognitive load it is dropped with no signal
— the work still looks complete, because nothing it produces is missing. On the run this rule
comes from, a timing convention and an observation-logging convention were each honoured once,
early, and then dropped precisely as the work got richest. **Every artefact was still committed
and every check still run. Nothing in the work product showed the gap.**

In a repo that commits per stage, the commit is the hook because it already happens:

> ⛔ **A stage is not complete until its commit carries all of:** the artefact and its reviewer
> pass · its row in the timings file, **taken from commit timestamps or written `not measured`** ·
> any observations about the method, **or an explicit written `none for this stage`** · the
> resume document updated · **and the identifier grep: the series the stage minted, checked
> against the registry, or an explicit `no new series`.** **The commit message names them.**

⛔ **Require the explicit "none".** Silence may not pass for compliance — it is
indistinguishable from the convention having been forgotten, which is what actually happens.

⛔ **A hook that rides on a commit is silent for the commit a session never makes.** Observed: a
produce commit was made with a message naming neither timings nor observations — the hook fired
and was ignored — and the session then stopped between produce and review, so the commit that would
have carried the timings row, the observation line and the open gate items was never made. The
obligation anchored on *finishing a session at a gate* never matched, because the session finished
between two phases. Two moves, and both phrase the trigger as a condition on the record rather
than on the session:

1. **The close-out is asserted at the next action that must happen, not only at the one that
   should have.** Before producing stage N+1, or launching its reviewer, assert that stage N's
   commit message names the close-out items, that the timings file has a stage-N row, and that
   every item a stage-N artefact carried to a gate appears in the resume document — and fail
   loudly if not. A resume-time assertion runs in the session that exists; a session-end
   obligation runs in the one that may not.
2. **The resume-document obligation's trigger is *an artefact carried an item to a gate*** —
   checkable by grep — never *the session ended at a gate*, which nothing can check.

⚠ **This holds even when the convention is the reason the project exists, and even for an agent
that has just written down the general form of the failure.** That is the observed case, in the
same session, an hour apart.

**The context boundary is the one boundary no commit convention reaches**, because a clear or a
compaction is not observable to the agent and the reasoning dies there while the artefacts survive.
Two host hooks cover it, and they are mechanism rather than instruction: one **before** a
compaction, which can only warn the person that work is uncommitted or the resume document is
behind; one **after** a clear, compaction or resume, whose output the agent does read, and which
re-injects the resume document. ⚠ **Know what each can and cannot do** — the first cannot block
and does not fire on a clear; the second has nothing to inject if the close-out list above was not
honoured. The command names the files.

⛔ **A mechanism the method depends on ships inside the package the method ships in, or the method
says it does not.** Installed by hand on the authoring machine it is present exactly where it is
least needed and absent everywhere the package travels, and its absence produces no signal — the
hook that did not fire looks the same as the compaction that did not happen. Observed: the first
hook lived four days in one machine's settings while the command printed a one-line copy of it that
had already diverged, and the only record of it was the author's memory. So the scripts live in the
plugin's `hooks/`, the command points at them and copies nothing, and a guard checks the hook is
registered before stage 1.

⚠ **A mechanism that can be registered twice must be safe to fire twice.** The package registers
its hooks; a development install registers the same files a second way; the host runs both, and a
presence check cannot tell one registration from two. Observed the day after the hooks shipped: the
resume document was injected into the fresh context twice, the page rendered twice a turn, and the
only hook the doubling had been thought about for was the one whose output the agent never reads.
So every hook script is idempotent per session and event — it reads the session id the host hands
it and a second fire within seconds exits before doing anything — and the cost of a duplicate is
stated per hook, not waved through because the first one was harmless.

---

## §9 · What the arc costs — publish an expectation

⛔ **A multi-stage procedure that stops for human rulings must publish a time expectation, and
must measure the human stages separately from the machine ones.** Without it the arc cannot be
scheduled against a client commitment and there is no way to tell a slow run from a normal one.

⛔ **But publish only what the instrument can actually see, and classify a span by what happened
inside it, never by who was nominally responsible for it.** An earlier version of this rule
quarantined spans *across a human* and exonerated agent phases as *bounded by tool activity*. A
host rate limit falsified that: a reviewer pass was spawned, made one tool call, died on a 429,
and resumed 145 minutes later when the limit reset — a single stage's produce-to-review span now
holds two hours of which perhaps three minutes were work, and nothing in the commit log
distinguishes it from an expensive pass. *An agent was running* is not evidence that time was
spent working, only that nobody was asked a question. So: **quarantine any span containing a
platform wait, whoever was waiting** — rate limits, quota resets, API errors stretch agent phases
as readily as absence stretches human ones. A stage whose reviewer pass was retried records the
failed attempt as its own line marked `platform wait — not separable`, and the measured pass is the
successful attempt alone. The stub pass file (§4) is what makes the failed attempt visible on disk.
**An entry gate taken inside a host's plan mode is un-timeable by design** — the guards, the
candidates, the ruling and the first write share one span with no commit inside it — and the
published expectation says so rather than offering a produce figure for the entry.

Observed on one full arc, and offered as a starting expectation rather than a standard:

| Phase | Observed | Trustworthy? |
|---|---|---|
| A stage artefact, hand-written | 10–20 min | ✅ Bounded by tool activity, **unless the span holds a platform wait** |
| A stage artefact, generated | 2–6 min once the generator exists — and the generator's authoring span is usually inside the previous stage's review (§4) | ⚠ Only if the overlap is recorded |
| A reviewer pass | 7–10 min on an unbudgeted reviewer; **13–16 min on a reading budget, flat with artefact length** — it scales with what the artefact cites | ✅ |
| Applying a pass's findings (the rebuild) | **10–13 min on a hand-written artefact, and the largest phase; 2–6 min on a generated one, where review is the largest** | ✅ |
| The entry gate inside plan mode | ⛔ **`not separable`** | Guards, candidates, ruling and first write in one span with no commit inside it |
| Intake | ⛔ **`not separable`** | Elapsed 250 min, but it contains platform waits. **What is evidenced is that the two decision fields failed three consecutive passes** — not a duration |
| A gate | ⛔ **`not separable`** | Elapsed up to ~2 hours. **Attention was a fraction of it and nothing recorded which fraction** |

⛔ **The instrument the method still lacks is one line from the operator.** Timestamps cannot
distinguish waiting from thinking; the person who was waiting can. **Require any elapsed span
across a human to state what else it could contain, and exclude it from every ratio unless the
operator confirms it was attention.**

⚠ **A hedge attached to a figure does not protect the figure.** The contaminated ratio above was
published *with* the words *"wall-clock, not attention"* attached — and the number travelled into
three artefacts as a headline while the qualifier stayed behind. If a qualifier cannot be made
part of the number's own statement, **do not publish the number as a ratio.**

**The same discipline this method demands of a client's benefit tracking applies to the method
itself: without a baseline, every claim about how long it takes is an assertion — and a baseline
that measures the environment instead of the process is worse than none, because it is
quotable.**

---

## Pre-flight for a command built on this file

**Guards**

- [ ] All guards run before stage 1, and the intake guard rejects its own template
- [ ] The intake template ships as a reachable file, named in the command's usage block
- [ ] Every guard's success message states what it tested, not what it implies
- [ ] The permission question is asked before the material it governs is created
- [ ] Version control is asserted, or a ruling to run without history is recorded
- [ ] Every condition named in error handling has a step that detects it
- [ ] Every field the agent may not supply carries a test the human can run alone
- [ ] The operating mode — commissioned or targeted — is declared in the intake, and the gates are phrased for it
- [ ] A synthetic or specimen path exists, and it records itself in the frame
- [ ] The host's read-only planning mode, where one exists, covers the guards, the entry gate and the resume report, ends before the first stage, and its approved plan is copied into the ruling register before any other write
- [ ] Plan mode on a resume fires on a context boundary; a resume after a gate ruled this session does not re-enter it
- [ ] The entry step creates the ruling register, the identifier registry and the timings file before stage 1
- [ ] A resume re-runs the guards and compares the plugin version to the entry artefact; every stage header records the version
- [ ] Every host mechanism the method depends on — a hook, a subagent, a template — ships inside the package, or the command says it does not, and a guard checks for it

**State and resume**

- [ ] Every stage leaves an artefact, and the resume map names each one
- [ ] Gates not sitting after a stage are listed, and a resume onto one stops there
- [ ] The resume joins completed stages to the register, and stops at any completed stage whose following gate has no rulings on file
- [ ] Every arc has its own reviewer directory, named in the command where the write is defined
- [ ] Any stage or gate that mints a series opened the registry first, and a continued series read its maximum from the registry
- [ ] Reviewer pass filenames carry the orchestrator's stage identifier, and their headers record both schemes
- [ ] A stage with an artefact and no reviewer file is raised as a question, not silently re-run
- [ ] Every open item in the resume document states the condition that closes it
- [ ] Every open item whose artefact lives in another repository names the repository and path

**Gates**

- [ ] Every gate is batched, with a recommendation and a cost per ruling
- [ ] A ruling register exists, and every gate report reconciles escalations in against rulings out
- [ ] No gate report carries a "not rulings" category
- [ ] No downstream step cites a ruling identifier absent from the register
- [ ] Every register row records the mode the ruling was taken in — chosen from options, batch authorisation, declined, batch on a corrected description, or requires a choice
- [ ] Every gate row carries exactly one recommended answer or is marked *requires a choice*; the accounting counts both, and the gate report states its batch share
- [ ] Any mark on a carried item is the ruler's, recorded in the register; the artefact says only *put*
- [ ] Every question the agent may not answer is put in plain words with a worked example
- [ ] A contradiction gate offers *both stand once split* as a third outcome, and does not re-ask a choice already made this session

**Review**

- [ ] The reviewer runs after every stage and writes its pass to disk, and a stub is written when it is spawned
- [ ] Every pass header records the model beside what it read
- [ ] On a verification stage the reviewer ran a mutation pass, and the verifier names the mutations it was shown
- [ ] The reviewer's contract includes the backward check — no artefact asserts what a later artefact records as withdrawn
- [ ] Any proxy pass is capped at `confronted · internal` in the artefact carrying it
- [ ] A proxy pass runs against the frame, before the traversal commits to a scope and a unit
- [ ] Produce / review / rebuild are committed separately, and no timing is written that was not measured
- [ ] Any overlap of stage N+1's authoring with stage N's review is recorded in both timings rows
- [ ] Any span containing a platform wait is marked not separable, whoever was waiting

**Specification and close-out**

- [ ] The specification is itself reviewed before anything is built against it
- [ ] The omission sweep ran: every load-bearing element of every input has a destination or a stated exclusion
- [ ] No placement in the sweep is a pointer, and no quoted cell is truncated
- [ ] Every completeness check names two denominators, and every expected count is derived, never typed
- [ ] Verbatim text lives in one file and is cited, or every copy was byte-compared in the same edit
- [ ] The sweep is shaped one section per input with a count per input, and a sweep that removed nothing is marked unapplied
- [ ] Every hazard names the step that tests it and what the test is, and every discharge names its instance
- [ ] The close-out list is named in each stage's commit message, with an explicit `none` where there is nothing to record, including `no new series`
- [ ] Stage N's close-out is asserted before stage N+1 is produced
- [ ] Counts stated in the command's prose match the tables beneath them
