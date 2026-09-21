---
description: Derive an agentic transformation strategy for a function end to end — frame, research, maps, drivers, opportunities, audit, basis, and the client-facing deliverable — stopping at each gate for a human ruling
argument-hint: [stage]
---

# Build Strategy

Run the full derivation from a function to a client-facing strategy paper, following
`function-to-strategy-derivation` and the discipline in `derivation-orchestration`.
**Sixteen stages, ten gates where a human decides.** *(The table below has seventeen rows: **Gate 0
is shown in sequence** because it falls between stage 0 and stage 1 and a resume that lands past it
would otherwise skip it silently. It is a gate, not a stage.)*

**This command runs until it reaches a gate, then stops.** It is not a single
unattended run — the pipeline produces roughly a quarter of a megabyte of interlocking
analysis, and generating that in one pass is the condition under which asserted counts
fail most often.

**Steps 0 to 0b run in plan mode, and nothing else does.** The host's plan mode is read-only: the
agent may read, search and run read-only commands, and may not write until a plan is approved. That
is exactly the shape of the entry — intake read, guards asserted, Gate 0 candidates costed — so the
command's **first action is to call `EnterPlanMode`**, and the person consents with one prompt. The
Gate 0 report *is* the plan; approving it exits plan mode, and that approval is the moment the first
write becomes legal. ⛔ **Plan mode ends before stage 1 and is not re-entered at Gates 1–8.** Those
gates rule on an artefact already written and critiqued, and plan mode would block the critic's file
and the stage commit. The one other use is the resume report in step 1. `derivation-orchestration` §1.

## What This Command Does

| # | Produces | Driver |
|---|---|---|
| 0 | `intake.md` read · guards run — **in plan mode, read-only** | **Manual input** — the eight fields in `templates/intake.md`, completed *before* invocation |
| **0b** | **the proposition and the unit of analysis** · then `CLAUDE.md` written | **⚠ Gate 0, as the plan** — agent proposes costed candidates, **human rules**, approval exits plan mode and the first write follows. `derivation-orchestration` §1 |
| 1 | `strategy/frame.md` | **Agent** · skill §0 → **⚠ Gate 1** |
| **1p** | `strategy/frame-agenda.md` | **`stakeholder-proxy` on the frame** — the early stance pass. `derivation-orchestration` §5 |
| 2 | `client/*.md` · the record grade | **Agent** · WebSearch → **⚠ Gate 2** |
| 3 | function · activity · pain maps | **Agent** · skill §1–3 → **⚠ Gate 3** |
| 4 | value drivers **+ the eliminated-areas list** | **⚠ Gate 4 first** (sponsor ruling) → **Agent** · skill §4 |
| 5 | applicability framework | **Agent** · skill §4a |
| 6 | opportunity map — `Displaces:`, `Verifier:`, **all four Layer-B values** | **Agent** · skill §5 |
| 7 | audit of stage 6 | **Agent** · skill §5b → **⚠ Gate 5** |
| 7a | **sizing** — build effort · running cost · benefit | **Agent** · skill §5c → **⚠ Gate 5a** |
| 8 | strategy basis | **Agent** · skill §6 → **⚠ Gate 6** |
| 8p | `strategy/sponsor-agenda.md` | **`stakeholder-proxy` on the basis** — the late stance pass |
| 9 | approach review | **Agent** · skill §review → **⚠ Gate 7** |
| 10 | `deliverables/SPEC.md` | **⚠ Gate 8 first** (contract rulings) → **Agent** |
| 11 | the HTML deliverable | **Agent** · `html-style` · `analytical-document-build` |
| 12 | verification + confrontation worksheet | **Agent** · `html-style` hard rule 7 · `analytical-document-build` §4 |

**Two subagents run inside this, and neither is optional.**

- `strategy-critic` fires **after every stage**, on that stage's artefact, before the next
  stage or its gate. Its findings arrive with the gate report. It reports; it never edits,
  and it never rules.
- `stakeholder-proxy` fires **twice — at 1p on the frame, and at 8p on the basis.** ⭐ **The
  early pass is the point of the change**: a reviewer can only find errors inside the chain's own
  frame of reference, so the one pass capable of surfacing a *missing category* must run before the
  traversal commits to a scope and a unit. On the run this wiring comes from, a single late proxy
  pass at 2m38s found a fatal constraint that five reviewer passes at 7–9 minutes each had all
  missed — and it found it after every decision that constraint would have changed.

Each runs in its own context, so their iterations cost you the reading of their findings and
nothing else.

**Where this command stops: D#1**, the client-facing strategy paper. The use-case portfolio
is a different arc under a different skill. **Do not begin it here** — not because it does
not follow, but because it has its own gates and this command holds none of them.

⚠ **What this command cannot do.** It cannot confront anything. Every claim it produces
is `position`. The output is **a well-built hypothesis**, and stage 12 requires the
document to say so.

## What it costs — so it can be scheduled honestly

Observed on one complete run. ⛔ **The agent phases are measured; the human phases are not, and
saying so is the point.**

| Phase | Observed | Note |
|---|---|---|
| A stage artefact | 10–20 min | ✅ Bounded by tool activity |
| A critic pass | 7–10 min | ✅ Trending **up** — each pass reads more of the chain |
| **Applying its findings (the rebuild)** | **10–13 min** | ✅ ⛔ **The largest phase, and the least budgeted** |
| Intake + Gate 0 | ⛔ **`not separable`** | Elapsed 250 min on the observed run, **but that span contains platform waits as well as thinking.** What *is* evidenced: the two decision fields failed three consecutive passes before Gate 0 existed |
| A gate | ⛔ **`not separable`** | Elapsed up to ~2 hours. **Attention was a fraction of it and nothing recorded which fraction** |

⛔ **A stage is written, reviewed and usually rebuilt.** A run planned as "sixteen stages" is
planned at roughly a quarter of its true size, and the phase dropped first under time pressure is
the one carrying most of the value.

⛔ **Do not quote an elapsed human span as a cost.** It measures the environment, not the person —
deliberation, absence and rate limits are indistinguishable in a timestamp. **Ask the operator
what the span contained, or write `not separable` and why.**

⛔ **Critic findings do not fall as the chain matures** — 9, 18, 14, 12, 12, 10, 18, 13, 16, 12,
14, 15 across twelve consecutive passes, mean 13.6, no trend. **Read that as evidence per-stage
review is still necessary at the end of a chain, never as the reviewer padding.**

## Getting started — the whole sequence, from nothing

⛔ **Shipping the form is not the same as making the route obvious.** This is the sequence; run it
in a terminal, not in a session.

```bash
mkdir my-engagement && cd my-engagement
git init                                     # the command refuses to run without this
cp "$CLAUDE_PLUGIN_ROOT/templates/intake.md" intake.md
# ...now open intake.md and fill it in. Nothing else is needed first.
```

Then, in Claude Code from that directory:

```bash
/s2p-strategy:build-strategy
```

**Three things a first-time reader gets wrong**, so say them:

1. **The file must be named `intake.md`, in the repository root.** Nowhere else is read.
2. **Filling it in is a separate act from invoking anything.** The command reads the form; it does
   not interview you.
3. **You do not write the central proposition or the unit of analysis.** They are not on the form —
   the command puts them to you at **Gate 0** with candidates. See step 0b.

⛔ **The missing-intake branch of step 0 must print this exact sequence**, not merely write the
file — that branch is where an unprepared user actually lands, and writing a file they cannot find
is the failure this replaced.

**To exercise the arc without a live engagement**, copy `templates/intake-specimen.md` to
`intake.md` instead. In that mode the agent may supply fields it otherwise may not, **on condition
that `strategy/frame.md` records the run as synthetic** — the same treatment given to a run with no
critic pass.

## Usage

```bash
/build-strategy            # resume from wherever the artefacts stop
/build-strategy 5          # re-run one stage deliberately
```

## Implementation Steps

### 0. Read the intake — refuse to start without it

⭐ **First action: call `EnterPlanMode`.** Steps 0, 0a and 0b are read-only by design, and plan mode
makes that a property of the host rather than an instruction to the agent. The person consents once;
if they decline, or the host has no plan mode, see *Error Handling*. Nothing below this line writes
to disk until the Gate 0 plan is approved — not `CLAUDE.md`, not the frame, not a commit.

Check that `intake.md` exists in the repository root **and that every field is filled**.
Both, in that order — existence alone is not the test:

```bash
[ -f intake.md ] || { echo "STOP: intake.md missing"; exit 1; }
grep -nE '^\*\*[^:]+:\*\*[[:space:]]*(\[|$)' intake.md \
  && echo "STOP: the fields above are unfilled" \
  || echo "no unfilled placeholders — fields not yet read"
```

⛔ **The success string says what was tested and nothing more.** A placeholder detector that
prints `intake complete` has reported a semantic verdict on a mechanical check — and it will print
it over a boundary field answered with a description of the client's IT estate, a proposition that
is a heading, and a function that contradicts the mandate. A user who has read *"complete"* will
then read every later objection as the agent being difficult, rather than as this step's field
notes doing the actual work.

If it is **missing**, copy `templates/intake.md` to `intake.md`, tell the user to complete it, and
**STOP**. If it exists with **unfilled fields**, name exactly which and **STOP**. Do not infer any
field. Do not start with partial information.

⚠ **Existence is not the check, because step 0 creates the file that would satisfy it.**
The remedy for a missing intake is to write the template — so the very next invocation
finds `intake.md` present, and an existence-only test passes it straight through to stage 1
with `[name — as it should appear in the deliverable]` as the organisation. The second run
is the normal path, not an edge case: run it, fill the template in, run it again. **The
guard must therefore reject the artefact this step itself produces.** The `grep` above
matches a field whose value is empty or still wrapped in the template's square brackets; a
value merely *containing* brackets mid-sentence passes.

⚠ **Fields are addressed by name, never by number.** Earlier versions numbered them 1–8 and every
downstream artefact cited the number; inserting a field then changed what six other documents
meant. **Write `the Data boundary field`, not "field 6".** *(Migration: old 1 → `Organisation`,
2 → `Function`, 3 → `Sponsor`, 4 → `Mandate, verbatim`, 5 → `Trigger`, 6 → `Data boundary`,
7 → the central proposition, now Gate 0, 8 → the unit of analysis, now Gate 0.)*

**The template's field notes, and what each costs to get wrong:**

**`Data boundary` comes first, and that ordering is the rule.** ⛔ **A permission question must be
asked before the material it governs is created.** Asked after the organisation and the verbatim
mandate, it arrives to govern a working tree that already holds them — and once the first commit
captures that material, the boundary can no longer be enforced by deletion.

⚠ **It is a permission rule, not a description.** *"Limited data management and systems exist"*
is a fact about the client and licenses nothing; the field must name what may enter and what may
never. This is the field stages 2 and 5 both defer to, so **a wrong answer here is not recoverable
by any later gate.**

**`Client processing permission` is a different question with a different owner.** `Data boundary`
protects *this repo*; this field asks **whether the client may lawfully feed its own operational
material to a model at all.** ⛔ **It is a hard gate on the entire opportunity set**, and for any
firm that works on someone else's material — agencies, contract manufacturers, law firms, MSPs,
brokers, logistics providers — it decides what may be built before anything is ranked. `unknown`
is the normal answer before the sponsor conversation; it then becomes **the highest-ranked
assumption in the pack and the first item on the stakeholder agenda.** On the run this field comes
from, it blocked five of ten recommended capabilities and **the entries that survived it were the
ones the instrument ranked last — the order inverted rather than degraded.**

**`Engagement mode` changes how every gate is phrased.** In `commissioned` the sponsor is
reachable throughout: the mandate is verbatim theirs, and Gate 1 asks *"would they recognise this
restatement as theirs?"* In `targeted` there is no contact until the work is largely done, so the
mandate is **as inferred, with the evidence it was inferred from**, the proposition is openly the
consultant's hypothesis, and Gate 1 asks *"is this defensible enough to put in front of them
cold?"* ⛔ **An unanswerable gate is talked past rather than removed**, and that teaches the
operator that every guard is an obstacle. The rulings are the same; only the source of the answer
changes.

**`Sponsor` is the expensive one.** Building for two sponsors and later collapsing to one
forces every driver to be re-tagged or dropped. Ask which it is before stage 4, not after.

**`Mandate, verbatim` must be verbatim.** Gate 1 asks whether the sponsor would recognise the
restatement as theirs. That check is worthless against a mandate already smoothed.

**`Organisation` does not require a public record.** A privately held company, a subsidiary that
files nothing, a partnership, a firm that has never issued a release — all are in scope. Stage 2
still runs the scrape and grades what comes back. **A thin record changes what the deliverable
may claim, not whether the work can start.**

### 0a. Assert the guards — a missing check does not fail, it passes

```bash
git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || echo "STOP: not a git repository — commits ordered by this command will silently not happen"
cc="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"   # a plugin install puts agents and hooks under plugins/cache
for a in strategy-critic stakeholder-proxy; do
  f=$(ls .claude/agents/$a.md "$cc"/agents/$a.md "$cc"/plugins/cache/*/s2p-strategy/*/agents/$a.md 2>/dev/null | head -1)
  [ -n "$f" ] && echo "$a: $f" || echo "STOP: subagent $a is not installed"
done
grep -qs PreCompact "$cc"/settings.json .claude/settings.json \
     "$cc"/plugins/cache/*/s2p-strategy/*/hooks/hooks.json 2>/dev/null \
  && echo "PreCompact hook: registered" \
  || echo "WARN: no PreCompact hook found — the context boundary is unguarded; record this in the frame"
```

**The third guard is a warning, not a stop**, because the run can complete without it; what it
cannot do is claim the context boundary was guarded. See *The context boundary* under *Committing*
for what the hooks do and why they ship inside the plugin rather than in one machine's settings.

⛔ **The repository guard exists because this command orders commits.** In a plain directory every
one of them silently does not happen, and the run produces a quarter of a megabyte of interlocking
artefacts with no history and no recovery point between stages — the exact condition under which a
later stage overwrites an earlier one unrecoverably. Offer `git init` before stage 1, or take a
ruling to run without history and **record that ruling in the frame.**

If a subagent is missing, **report it and STOP.** The user may rule to run without it; if they do,
**that ruling goes in the frame**, because a run with no critic pass is not the same artefact
as a run with one, and nothing else records the difference.

⚠ **Presence is necessary and not sufficient. Subagents are read at session start** — skills
reload live, agents do not. One installed *during* this session sits on disk unregistered, and
this check will pass on it. If either file's timestamp is younger than the session, say so and
recommend a restart before stage 1.

⛔ **And installation is not invocation.** A host policy — *"do not spawn agents unless the user
asks"* — silently outranks this command's *"neither is optional"*, and then Gate 1 is presented
against an unreviewed frame with nothing reporting it. Observed: the critic ran two stages late
and returned **nine findings, six of them defects in the frame Gate 1 had already been answered
against.** Two consequences, and the first is the load-bearing one:

1. ⛔ **No gate may be presented for stage N while `strategy/critic/<N>.md` is missing.** State the
   missing pass as the gate's first item instead of proceeding. **The absence of a mandated step
   is detected downstream by the artefact it failed to produce, never upstream by the capability
   it would have used.**
2. At this step, **note that a host may forbid spawning** and take a standing authorisation from
   the user, recorded in the frame, rather than discovering the conflict mid-run.

**Why this guard exists at all:** an orchestrator whose critic is absent does not fail. It
proceeds, and it produces work that looks reviewed. **A check that cannot find its input does
not fail — it passes**, which is the same reason step 0 must reject the intake it wrote itself.

### 0b. ⚠ GATE 0 — the two fields that are rulings, not facts

⛔ **Do not put these on the intake form.** A blank field and a ruling between costed options are
not the same request, even when the answer is identical — and these two are the ones that fail
repeatedly, because they are **decisions between competing theories** posed as blank essay prompts
before any analysis exists to inform them. The loop that follows is: the user writes something
plausible, the guard passes it, the agent rejects it citing the same words that failed to prevent
it, repeat. ⛔ **Observed cost of that loop: three consecutive unusable attempts, while the six
factual fields were right by the second pass.**

⚠ **The evidence for Gate 0 is the failure rate, not a clock.** An earlier version of this file
argued it from *"most of the 250 minutes intake consumed"* — a span that also contained platform
waits, so it cannot carry the argument. **What it does not need to:** on the observed run these two
fields came back unusable on three consecutive attempts, each time in the same shape, while the six
factual fields were right by the second pass. **A field that fails three times against a
well-written definition is a field posed as the wrong kind of question.**

So: **read the intake, then present both as a batched gate with named alternatives.**

**Ruling 0.1 — the central proposition.** Propose **three or four candidate claims**, each in the
sponsor's terms, each with what it steers the derivation toward and what it costs if wrong. The
human picks one, edits one, or writes their own. ⛔ **The agent may not choose.**

⚠ **Give them the two form tests, because a prohibition plus a definition is not enough** — the
person producing the wrong answer is the person the definition did not reach:

1. ⭐ **Check the grammatical subject.** *"AI should help us do [list of good things]"* has the
   technology as its subject: it describes an intent and cannot be contradicted. **A claim about
   where the firm loses time or money has the firm as its subject.** This single test broke a loop
   that two rounds of restating the standard had not.
2. **Could the named sponsor answer *"no, that is not where our problem is"*?**

⚠ **Later steps quote this sentence; they never paraphrase it** — including the criterion that
selects what gets built and the claim the deliverable has to prove. Record it **verbatim, on its
own line, in `strategy/frame.md`**. And ⛔ **do not read the argument off the traceability later**:
when downstream items are tagged to positions it is tempting to take the argument to be whichever
position the most items point at. **Mass tells you where the work concentrated, not what the work
is claiming.** The human names it; the counts do not.

**Ruling 0.2 — who the transformation is for.** An explicit binary: **the function**, or **the
people it serves** — or `both`, which is a real answer and the most expensive one. Present each
with what it makes the traversal look at and what it makes the traversal blind to.

⛔ **This is irreversible — nothing downstream can revisit it.** Every stage from the function map
onward takes its unit from this answer — the function's tasks, its failures, its sponsor's metrics
— so the analysis will find *that actor's* savings and nothing else. **Not because anyone chose
that: because no stage can see past its own unit.** Discovering it wrong at stage 6 costs the whole
chain. ⭐ **The cheapest detector that it is wrong: a process that produces zero pains.**

**Both rulings are recorded in the frame with who made them.** ⛔ **In synthetic mode the agent may
supply both — and `strategy/frame.md` must record that it did**, because a deliverable that later
says *"you told us"* about an agent-written field hands the reader a sentence they can flatly deny.

**How the gate is put as the plan.** Write the Gate 0 report — the candidates for 0.1 with their
costs, the binary for 0.2 with what each makes the traversal blind to, the engagement mode read from
the intake, and the published cost of the arc — to the plan file, and call `ExitPlanMode`. The host
offers *approve* or *keep planning*. ⛔ **Approval of a list of candidates is not a ruling.** The
person answers by choosing — in conversation, or by editing the plan directly — and the agent rewrites
the plan so it carries **the two rulings as made**, with who made them; only that plan is submitted
for approval. Approval is the ruling event, and the first writes of the run follow it in this order:
⛔ **the ruling register rows for 0.1 and 0.2 — mode `chosen from written options`, who ruled, the
date — then `CLAUDE.md` (step 0z), then stage 1.** The plan file lives outside the repository and no
resume reads it; a ruling that exists only there is a ruling from memory.

### 0z. Write the project instruction file, if it is absent

**After Gate 0 is approved and before stage 1** — it is the first write of the run — write `CLAUDE.md`
in the repository root from `templates/CLAUDE.md`, substituting from the intake: organisation,
function and slug, sponsor, engagement mode, and — ⛔ **quoted verbatim, never paraphrased** — the
data boundary and the client processing permission.

⛔ **Only if it is absent.** If a `CLAUDE.md` already exists:

- **Do not overwrite it.** Diff the generated half against what is there, and **report any drift as
  an item at the next gate.** An operator's own additions live under `## Local notes` and must
  survive untouched.
- Where the file predates this template entirely, say so and offer the merge as a gate ruling.

**In the same step, make sure `.gitignore` carries `RUN-PROGRESS.html`.** The watcher regenerates
that page on every turn; committed, it would dirty the tree after every gate report and trip the
close-out hook for nothing.

```bash
grep -qxF 'RUN-PROGRESS.html' .gitignore 2>/dev/null || echo 'RUN-PROGRESS.html' >> .gitignore
```

**Why the command writes it at all.** Every fact in that file is already known here or stated on the
form: the arc and what each command consumes, the directory layout the resume scan globs, the
close-out list, the never-push and never-artifact rules — and **the data boundary, which governs
what may be written to disk and was previously copied by hand into a file nothing checks.** Left to
the operator it is written late, written differently each time, and drifts from the command it
describes.

⚠ **The generated file says its generic half is generated and that fixes belong upstream.** A local
correction diverges silently, keeps working, and hands the bug to the next engagement.

### 1. Determine the resume point from the filesystem

**Do not keep a state file.** Every artefact declares its own stage in its header, so
state is derivable. Read the function slug from the intake's `Function` field, then:

```bash
ls strategy/ strategy/critic/ client/ deliverables/ 2>/dev/null
```

**On a resumed run this step is in plan mode too.** Call `EnterPlanMode`, read the artefacts, and
write the resume report as the plan: the stage each artefact maps to, the computed resume point,
which gate a resume onto that point must stop at first, and any stage holding an artefact with no
critic file. `ExitPlanMode` puts it to the person; approval exits plan mode and the run proceeds to
the named point. A wrong resume point re-runs finished work or skips a gate, and this is the one
cheap moment to catch it. **A single-stage invocation (`/build-strategy 5`) takes the same shape**:
the plan names what stage 5 will overwrite.

Map artefacts to stages: `frame.md`→1 · `frame-agenda.md`→1p · `client/`→2 · `*-pain-map.md`→3 ·
`*-value-drivers.md`→4 · `ai-applicability-framework.md`→5 · `*-opportunity-map.md`→6 ·
`step5-audit.md`→7 · `*-sizing.md`→7a · `*-strategy-basis.md`→8 · `sponsor-agenda.md`→8p ·
`approach-review.md`→9 · `SPEC.md`→10 · `deliverables/*.html`→11 ·
`confrontation-worksheet.md`→12 · `strategy/critic/<stage>.md`→*which stages were critiqued*.

**7a sorts between 7 and 8**, so a repo with an audit but no sizing file resumes at 7a, not
at 8. **`1p` and `8p` — the proxy passes — sort the same way.** A stage the map cannot name is a
stage every resume skips silently.

**Both subagents write, and that is what makes a resume checkable.** The command keeps no
state file because every artefact declares its own stage — so a pass that leaves no artefact
makes its own state underivable, and "the critic already ran on stage 5" becomes a claim from
memory.

⛔ **Critic pass files are named by *this command's* stage number, not the skill's step number.**
The skill's steps `4a` and `5` are this command's stages `5` and `6`; filed under both schemes,
one filename means a different stage from the one the resume rule reads it as, and two stages
appear to have no pass at all. **Each pass's header records both** — `step 5b · stage 7` — so a
human reading one file can resolve the other without opening this command.

⛔ **On a resume, a stage with an artefact and no critic file is reported as a question at the next
gate — never silently re-run.** Re-running a pass is not free and is not idempotent: a second
reading finds different things, and they look like new information. A stage critiqued in an earlier
run is not re-read; its defects were already ruled on.

> ⚠ **The tell that this mechanism has already broken is not an error — it is a workaround that
> keeps succeeding.** If a hand-maintained handoff note is what makes the resume land correctly,
> the documented resume has stopped working and nothing will report it, because the note works.

**Resume at the stage after the highest artefact present.** Report the resume point before
doing any work. If a stage number was passed as an argument, run that stage only.

⚠ **Four gates do not sit after a stage, and a resume lands past all of them.** Gate 0 precedes
stage 1, Gate 4 precedes stage 4, Gate 8 precedes stage 10, and **Gate 6 sits between stage 8 and
stage 9**, behind the 8p proxy pass that feeds it. Running from the start you reach them in order.
**Resuming *into* stage 1, 4, 9 or 10 skips them silently**, because the resume rule points at a
stage and a gate is not a stage. So: if the computed resume point is 1, 4, 9 or 10, put that gate
first and stop on it before producing anything — and at 9, run the 8p proxy pass first, because
Gate 6 is not answerable without it. The same applies to `/build-strategy 1`, `4`, `9` and `10`.

The scan above covers all **fifteen** mapped artefacts plus the critic files. **If a stage writes
outside the directories this `ls` names, the scan stops being complete and the resume point
silently reads low**, re-running finished work. So: **a stage that adds an artefact adds a line to
the map, a directory to this `ls`, one to the count in this sentence, and a row to the watcher's
`arc-map.tsv`** — all four, in the same edit. Two of the first three were missed the first time the
critic files were added, which is how this note came to exist. The watcher renders the same map as
`RUN-PROGRESS.html` and lists any file in the scanned directories that no row claims — **that sweep
is the check that the map and this step still agree.** `arc-watcher` skill.

### 2. Load the method

Invoke the `function-to-strategy-derivation` skill and follow it. **Do not improvise the
derivation from this command file** — the command sequences the work; the skill defines it.

### 3. Run stages until a gate, then STOP

Every artefact header records: **step number, `Status`, `Input` (the artefact it derives
from), and the date.** A step whose input is not named cannot be checked.

**After every stage, before the next one starts, invoke `strategy-critic` on the stage just
completed.** Give it the artefact and the artefact that artefact names as its input. It reads
in its own context, so this costs you the reading of its findings and nothing else.

Its findings split three ways, and **the split is yours to make, not its**:

| What it reports | What you do with it |
|---|---|
| A method defect it can name and you can fix | Fix it before the next stage, and say so at the gate |
| A defect that needs a human decision | **Carry it to the gate**, as one of that gate's rulings |
| That a claim looks right to it | **Discard it.** It cannot confront anything, and it is told not to say this |

⚠ **A critic pass that returns nothing is a finding about the pass, not a compliment to the
work** — the same standing suspicion stage 7 applies to an audit that changed nothing.

**Write each pass to `strategy/critic/<stage>.md`** — the findings, which were fixed, which
went to the gate, and which were discarded. It is the only record that the pass happened.

At every gate: **stop, report what was produced, put every open decision at that point, and
wait.** Never answer a gate question and continue.

**Gates are batched, and that is the point of them.** What consumes a person's day is rulings
arriving one at a time — not the analysis. ⛔ **The argument is context switches, not a duration:**
serialising *n* rulings costs the human *n* returns to a document they had put down and *n*
reconstructions of what the run was doing, **whatever each ruling takes.** Batching removes *n−1*
of them, and that holds whether the gate takes two minutes or two hours.

*(An earlier version argued this from a measured 6.6× gate-to-work ratio. The timestamps were real
and the figure was contaminated — the span contained a rate limit resetting as well as thinking.
The rule survives; the evidence for it was wrong.)*

So a gate presents all of it in one pass: the gate's own question, every ruling the critic passes
threw up, and anything an earlier gate deferred. **Each carries a recommendation and what it costs
to go the other way.**

⛔ **Do MORE preparation per gate, not less.** A short gate is not a cheap gate. A gate that asks
one question and comes back an hour later for the next has failed, even if both answers were
right.

| Gate | After | The question |
|---|---|---|
| **0** | Step 0a | The central proposition, and who the transformation is for. **Candidates offered; you rule.** |
| **1** | Stage 1 | *Commissioned:* would the sponsor recognise this restated mandate as theirs? *Targeted:* is it defensible enough to put in front of them cold? |
| **2** | Stage 2 | Is this the right entity · is every source public · the record graded *G* — proceed on labelled `sector` material, on an empty `client/`, or do you supply internal material inside the data boundary? |
| **3** | Stage 3 | Does this look like the function? **Recognition is not evidence** — a nod means plausible, not true. |
| **4** | Before stage 4 | One sponsor or several, and what are they measured on? |
| **5** | Stage 7 | The audit changed *N* entries. Which findings need a ruling before the basis is written? |
| **5a** | Stage 7a | Here is what each figure was derived from. Is that basis good enough to fund from — and where should I have declined to assert instead? |
| **6** | Stage 8 | Here is the assumption made and the correction that matters most. Confirm or overturn. |
| **7** | Stage 9 | The review recommends *N* changes, several reversing decisions already taken. Which, if any? |
| **8** | Before stage 10 | The contract rulings — sponsor, structure, design identity, constraints, stop condition. |

**Gate 7 is the one most likely to be violated.** The approach review names weaknesses in
work just completed, and acting on them feels like diligence. **Never auto-execute its
recommendations** — several are reversals of decisions the human already took.

#### ⛔ Every gate report reconciles escalations in against rulings out

A gated process records what was decided and, by default, **records nothing about what was asked
and not answered** — so an unanswered question is indistinguishable from a settled one the moment
the next stage begins. Observed: a critic pass escalated **three** questions to Gate 6; one was
ruled; the next two stages each recorded one of the survivors as settled — the first by reading
*the previous artefact's own label for its decision* as a human's ruling, the second by settling it
implicitly through the order in which it arranged its sections. **Both stages had clean arithmetic
and resolving citations.**

1. **Close every gate report with an accounting**: *N escalations received, N ruled, N deferred,
   N declined.* Every deferred item gets an identifier and a named destination. **An escalation
   that reaches a gate and is not answered appears in the record as unanswered.**
2. **Record every ruling in a ruling register** — one row each: identifier, question, answer, who
   ruled, date. **No downstream stage may cite a ruling identifier absent from it.** Grep to check.
3. ⛔ **An artefact's own label for its decision is not a ruling.** The register is the authority.
4. ⛔ **No gate report may carry a "not rulings" category.** Anything placed in one is moved out of
   the decision set while looking accepted. Observed: a live defect filed under *"not rulings —
   stated so they are not mistaken for open"* passed three further gates untouched, and every later
   artefact called it *carried* — which reads as though a human had accepted it. **Nobody had ever
   been asked.**
5. ⛔ **The register records *how* each ruling was taken** — *chosen from written options*, *batch
   authorisation of the agent's recommendation*, or *declined*. An authorisation of recommendations
   not yet written is closer to *proceed on your judgement* than to a decision, so **a later choice
   from written options supersedes it without a stop; the reverse direction stops.** Observed: the
   same five decisions answered *"take your recommendations"* once and from written options once,
   and one reversed with no new evidence between. `derivation-orchestration` §3.

### 4. Stage 2 — research, the record grade, and the boundary

**First, ask what instruments this machine has.** Run skill discovery — `find-skills`, or the host's
equivalent — for research, evidence-gathering, filings or OSINT capability, and use what it returns
alongside the web search.

⛔ **Then record, in `client/README.md`, which instruments were used and which were looked for and
not found.** This is what makes the grade interpretable: **`absent` after one web search is a
different claim from `absent` after three instruments**, and nothing else in the artefact
distinguishes them. A thin search and a thorough one both produce a graded record, and the grade
describes what was found, never how hard anyone looked.

⚠ **Any discovered instrument is still bound by the data boundary and the public-record rule.** A
skill that reaches non-public sources is **declined, and the refusal is recorded** — do not let a
better tool quietly widen the boundary.

Use WebSearch against **public sources only**. Gather what the organisation has said publicly
about AI, its posture, its peers, and anything bearing on trust in its output.

**Run the scrape whatever the organisation is.** Private company, subsidiary that files
nothing, partnership, a firm that has never put out a release — the search still runs, because
**you cannot know a record is thin until you have looked.** "They're private, there won't be
anything" is a prediction, and this stage exists to produce a result instead.

Write to `client/`, and mark every statement `fact`, `inference` or `position` — that marker
records **how far the claim has been taken**, and it is the only axis the rest of the method
reads.

**Then grade the record in `client/README.md`, in one of these three words:**

| Grade | What came back | What it licenses |
|---|---|---|
| `substantial` | Enough, from the organisation itself, to characterise its posture | Cited claims about this organisation's public posture |
| `thin` | A handful of items — a site, a filing, a mention — nothing sustained | Narrow cited claims only. **No characterisation drawn from volume** |
| `absent` | The search ran and returned nothing usable about the entity | Nothing about this organisation. The deliverable says so |

⚠ **Silence is not a finding.** Record what you searched and what returned nothing **as a
record of the search, never as a characterisation of the organisation.** *"They have published
nothing on AI"* is a fact about publication. *"They have no AI posture"* is a claim about the
company, and no scrape can support it — **the absence you found for a private firm doing a
great deal is the same absence you would find for one doing nothing.**

**Sector material may stand in, labelled, and may never be promoted.** *(Ruled 2026-09-05.)*
Every statement in `client/` also carries `client` or `sector` — **a second and independent
axis, recording *who the statement is about*, not how well established it is.** A `sector`
statement can be a hard `fact` and still say nothing about this organisation; that is exactly
the pair that gets misread. Apply the label at the moment the statement is written, and carry
it through every downstream citation. **The failure to guard against is one edit:
a `sector` line loses its label and becomes what this organisation is doing.** If at the point
of citation you cannot tell whether a statement is about the entity or about its sector, the
failure has already happened.

⚠ **Never write anything into the repo that is confidential, internal, or supplied outside the
data boundary.** If a source cannot be confirmed public, leave it out and say so at Gate 2.
**A thin record raises the pressure on this rule, not the licence** — the moment to reach for
internal material is exactly when there is nothing public, and the boundary governs whether you
may.

⚠ **Public research is evidence of public posture, never of internal reality.** Write that
warning into `client/README.md` alongside the grade.

⚠ **The thin record is not the dangerous case — it is the visible one.** A strategy superbly
sourced on public material and never tested internally is *more* dangerous than a rough one,
because the citations disguise the gap. At `thin` or `absent` there are no citations to disguise
anything and the gap is where anyone can see it. **What makes the thin case dangerous is
papering over it with sector material**, which is the whole reason the label may never drop.

**A thin record moves weight onto the people, so say where it landed.** At `thin` or `absent`,
every organisation-specific claim in the deliverable rests on what the sponsor and the people in
the function say and on nothing else. Carry the grade into the stage-12 confrontation worksheet
and name the claims that have no external source at all.

### 4a. Stage 4 — publish what the sponsor ruling eliminated

Gate 4 settles who the sponsor is. **That ruling then removes areas of the function
silently**, because an opportunity whose drivers were all dropped cannot enter any later
stage — it simply never appears again, and nothing distinguishes it from an area nobody
thought of.

So after the ruling and before stage 5, write a short list into the value-drivers artefact:
**every area whose drivers were all dropped, and what it was.** Put one question to the
sponsor for each — *was a driver for this never written, or is this genuinely not your
problem?* — and carry the unanswered ones forward as open items.

⚠ **Watch for the candidate that would have measured this programme's own results.** A
scoping rule will remove benefit tracking as readily as anything else, and that is the one
elimination worth escalating: recommend it as a governance obligation rather than letting
it disappear with the rest.

### 4b. Stage 6 — the opportunity map must emit what stage 7 checks

Follow `function-to-strategy-derivation` §5. ⛔ **Every entry records all four Layer-B constraint
values and the binding one**, inherited with a citation where the task was calibrated at stage 5,
derived and stated where it was not.

⛔ **This is a required field, not prose.** Stage 7's audit mandates a check that each entry's cap
equals the worst of its four values — the instrument calls it the only mechanical check on the
anti-pattern it names — **and that check is unrunnable unless this stage emits its input.**
Observed: 11 of 23 entries were derived fresh, the values did not exist, and the audit reported the
check unrunnable for half the portfolio. When a gate two stages later ordered them derived, **four
caps were wrong and three were wrong in the permissive direction** — precisely what the
anti-pattern describes. **The method's own safeguard would have shipped unrunnable.**

> **When a later stage mandates a check, the earlier stage producing its input must be required to
> emit that input.** A promise with no slot to fill is not kept.

### 4c. Stage 7a — sizing, and what a figure must carry

Follow `function-to-strategy-derivation` §5c. Size **only what survived the stage-7 audit**,
and write `strategy/<slug>-sizing.md` so the resume map can see it.

Three quantities per surviving opportunity — build effort, running cost, benefit in the
sponsor's own step-4 metric — and for each, **the basis it was derived from**.

⚠ **A figure with no stated basis is a decoration, and it will be believed.** Write how it
was derived, or write `not sized` and why. Both are honest; a bare number is not.

⚠ **Erring high is not the safe direction.** An inflated cost argues against an option
under an appearance of caution and looks careful while doing it.

⚠ **Running cost is not only money.** It is attention — specifically, whose. An entry whose
`Verifier:` line commits an expert to reviewing every output has a running cost measured in that
person's hours, and **a role name per entry answers *whose*, not *how much*.** Compute the
gradient from `cap` × `load`, which is already in the input.

**If sizing is skipped, it is a ruling, and the basis must say so in those words** — never
a silence. Stage 8 will otherwise argue a priority order while implying money was
considered.

### 4d. Stage 8 → 9 — run the skill's pre-flight before calling the basis done

`function-to-strategy-derivation` closes with a pre-flight. **Run it against the artefacts, report
every box individually, and name the ones that fail rather than summarising a pass.** ⚠ **Report
the tally too, and check it sums** — one run reported *"16 clean"* over 18 boxes and a second
version's tally came to 19.

⚠ **The confrontation box — *at least one claim has been confronted by someone who works in the
function* — will be unticked, and it must stay unticked.** Neither subagent can tick it: the
critic is told it cannot move a claim past `position`, and the proxy is capped below plain
`confronted`. **Until it is ticked the strategy is a well-built hypothesis, and stage 11 must
say so in the document.**

### 4e. The proxy passes — 1p and 8p, and the marker they may not support

**Invoke `stakeholder-proxy` twice.** Give it the sponsor's identity from the intake's `Sponsor`
field — role, what they are measured on, what they have already seen. Without it you get a generic
sceptic, and a generic sceptic is worth nothing here.

**1p — on the frame, before stage 2.** Write `strategy/frame-agenda.md`. ⭐ **This is the only
mechanism in the method that can surface a constraint nobody thought of while it is still cheap to
act on.** The critic asks a **closed** question — are the counts right, was the instrument applied,
did a quoted position keep its clauses — so it can only find defects the chain's own vocabulary can
express, and **everything the chain never thought to ask about stays invisible however many passes
run.** The proxy asks an **open** one: what would the person on the other side need to be true.

**8p — on the strategy basis, before Gate 6.** Write `strategy/sponsor-agenda.md`, then fold it
into Gate 6's batch — it is what makes that gate answerable in one pass instead of three.

⚠ **The strongest marker either output may support is `confronted · internal`. Never plain
`confronted`.** It is the same author attacking their own work through a persona: simulated
challenge reliably finds internal inconsistency and reliably misses the thing the author did
not know. **If a proxy report retires the conversation with a practitioner, it has made the work
worse** — a document that reads like confrontation and is not is more dangerous than one that
never claimed to be.

### 4f. Stage 10 — the SPEC, and the sweep no count can replace

**Review the SPEC before anything is built against it.** ⛔ **A specification does not reduce the
defect rate — the critic still raised fifteen findings against the artefact built from one, in line
with every other pass in the run. It reduces what each defect *costs*, roughly fivefold**, because
a finding against a specified artefact is an **edit** where against an unspecified one it is a
**re-derivation**. ⛔ **That saving holds only if the specification is itself reviewed**: the one
measured was wrong in fourteen places, four of them omissions that would have propagated silently.

⛔ **Run the omission sweep. A contract omits by silence, and anything not specified will not be
built.** Every other check compares what an artefact *says* against its sources; none can see what
it fails to say.

> For each input artefact the contract names, enumerate its load-bearing elements — tensions,
> registers, dependencies, unresolved questions, and **any sentence phrased as an instruction to
> the deliverable** — and assert each has a named destination in the contract's structure, or an
> explicit written decision to exclude it.

⛔ **The sweep has a shape: one section per input, a count of elements enumerated from that input,
then dispositions.** A flat list across inputs is rejected on form — it is a list of what you
already had in mind, and its scope is your recall. Observed: thirteen elements correctly placed and
three inputs with no row at all; rebuilt per input, forty elements and seven with no destination.
**A sweep that removed nothing is read as unapplied**, and the per-input count is what lets that be
said. `derivation-orchestration` §6.

⛔ **And a step that shortens a list it inherited publishes the count before and after.** Observed:
a nine-row caveat register arrived as six, with no number stated anywhere — **inside the section
that declared shortening forbidden.**

### 5. Stage 12 — verify before declaring done

Run the structural checks:

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

Tag counts must match; external references must be **0**.

**Then run all three checks from `analytical-document-build` §4, not only the first.** Arithmetic
alone is demonstrably insufficient: on this run every self-asserted count in an artefact reconciled
and the artefact was still wrong in thirteen places, none of them arithmetic.

- **Arithmetic** — re-derive every count from the finished file, not from the drafting numbers.
  Roughly five of eight are wrong when measured. Confirm the version string matches in **both**
  header and footer.
- **Provenance** — diff every quoted position, assumption and hedged statement against its register
  **verbatim**; a qualifier attached at the source must appear at the point of use or be explicitly
  withdrawn.
- **Coverage** — grep the upstream registers for anything naming this document as its test point,
  and assert each appears by name.

⛔ **And run the promotion grep.** Sweep the deliverable for second-person constructions — *you
told us*, *you asked for*, *your decision*, *as you said* — and **require each hit to name its
source artefact.** Observed: one pronoun attributed the chain's most consequential and irreversible
decision to the sponsor it was addressed to, who had said no such thing. **That grep alone would
have caught the worst finding of its pass.**

⚠ **A script not checked against a hand-derived answer is not a verification.** Print the members,
never only the count, and assert one member you independently know belongs is present. Three
verification scripts in one run were wrong before they were right — one missed eight identifiers
because its regex assumed a fixed-width area code.

Finally, write `deliverables/confrontation-worksheet.md`: the claims the document stands
on, each with where it is used, what breaks if it is false, and an empty ruling slot.

## Important Notes

- **NEVER pass a gate.** Report, ask, stop. A gate answered by the agent is the whole
  method defeated.
- **NEVER present the output as confirmed.** Every claim is `position` until a person who
  works in the function says otherwise.
- **NEVER record a critic or proxy pass as confrontation.** Both are the same head that wrote
  the work, reading it again. They discharge nothing, and the artefacts must say so.
- **NEVER write a duration you did not measure.** A timings file is an instrument, and a
  reconstructed figure wearing the word *measured* corrupts it silently. **No critic pass can catch
  this** — a critic reads an artefact against its inputs, and a timestamp has no input. Take
  timings from `git log`, or write `not measured`.
- **DO NOT skip a critic pass because a stage went well.** The stage that reads cleanest is
  the one whose defect surfaces fourteen prompts later, which is the failure the critic exists
  to prevent.
- **DO NOT skip stage 5.** Without the applicability framework, every class and autonomy
  level in stage 6 is asserted rather than derived. It is the easiest stage to skip and
  the highest-leverage one.
- **DO NOT skip stage 7.** An audit that changes nothing should be suspected, not
  celebrated.
- **DO NOT skip stage 7a.** It is the likeliest stage to be quietly passed over, because
  it is the only one whose output is numbers nobody has yet — and its absence is what
  leaves a complete, traceable, well-ranked strategy that nobody can fund.
- **DO NOT re-rank in place of confronting.** A second ordering over the same unchecked
  judgements inherits their uncertainty in full and makes the work feel more examined than
  it is. Where two defensible weightings disagree, publish both and call the disagreement
  the finding.
- **DO NOT delete anything a ruling drops.** Mark it dropped in place — later stages cite
  its identifier, and a deleted ID becomes an unresolvable reference.
- **DO NOT mint an identifier series without checking it against every series already in play.**
  One run had `S1`–`S3` as gate rulings and `S1`–`S32` as sector statements simultaneously, in
  artefacts that quote each other.
- **DO NOT publish the deliverable via the Artifact tool.** Write it to the repo.
- **DO NOT push.** Stage and commit locally after each stage; pushing is the user's.

## Error Handling

If `intake.md` is missing or has an incomplete field:

- Copy `templates/intake.md`, name the missing fields, and STOP. Do not infer them.

If a stage's input artefact is missing:

- Report which artefact is absent and which stage produces it. Offer to run that stage
  instead. Do NOT generate the missing input inline — it would skip that stage's gate.

If research at stage 2 returns nothing usable about the organisation:

- **That is grade `absent`, and it is a result, not a failure.** Record what was searched,
  write the grade, and take it to Gate 2 with the three options. A strategy with an empty
  `client/` is legitimate; a fabricated one is not — and neither is one whose `sector`
  material has quietly become the client.

If a gate question is answered ambiguously:

- Restate what was heard and ask again. Do NOT pick a reading and continue — a misfiled
  answer propagates through every downstream stage.

If the host forbids spawning subagents:

- Say so at step 0a and take a standing authorisation from the user, recorded in the frame.
  **Do not proceed to a gate for a stage whose critic file is missing.**

If the host has no plan mode, or the person declines to enter it:

- Say so, take a standing authorisation to run steps 0–0b under the same read-only discipline by
  instruction, and **record in the frame that the entry ran without plan mode.** The rulings are the
  same rulings; what is lost is the host enforcing that nothing was written before they were made.

## Committing — and the close-out that makes conventions survive

⛔ **A stage is not complete until its commit carries all four:**

| | What | If there is nothing to record |
|---|---|---|
| 1 | The **artefact** and its critic pass at `strategy/critic/<stage>.md` | — |
| 2 | Its row in the **timings file** — produce · review · rebuild · gate wait, **from commit timestamps, never reconstructed** | Write *"not separable"* and why |
| 3 | Any **observations about the method** | ⛔ **Write an explicit `none for this stage`** |
| 4 | The **handoff / resume document** updated, every open item carrying the condition that closes it | — |

**The commit message names 2, 3 and 4.** ⭐ **The commit is the hook because it already happens.**

⛔ **Require the explicit "none".** Silence may not pass for compliance — it is indistinguishable
from the convention having been forgotten, which is what actually happens. Observed: a timing
convention and an observation convention were each honoured once, early, then dropped precisely as
the work got richest. **Every artefact was still committed and every check still run. Nothing in
the work product showed the gap.**

**Commit per stage-phase — produce / review / rebuild — where you can.** It costs one timestamp per
boundary and is the only way the rebuild ratio can be known; reconstructed afterwards the three are
indistinguishable. **Never push.**

#### ⛔ The context boundary — the one place work is actually lost

**Commits are not automatic.** They are an instruction executed at the agent's discretion at a stage
boundary, which is the class of obligation this method has already watched get dropped under load.
The close-out list above is the hook, and it works because a stage boundary is observable.

⛔ **A context clear or compaction is not observable to the agent, and it is the boundary where the
*reasoning* dies.** The artefacts survive; why a gate was ruled the way it was, what it was asked,
and which findings were carried does not — and `handoff.md` is exactly what is supposed to carry it.
⚠ **The ordering is adversarial**: the moment the context must be summarised is the moment it is
about to be discarded, so anything firing *after* the clear has nothing to write from.

**Three mitigations, in order of reliability. The first two ship in the plugin as `hooks/hooks.json`
and fire without anyone remembering them; the third is an instruction.**

1. ⭐ **Before the boundary — `hooks/precompact-closeout.sh` on `PreCompact`.** While the context
   still exists it checks for uncommitted changes and for a `handoff.md` behind `HEAD`, and warns.
   ⚠ **Its warning reaches the person, not the agent** — a `PreCompact` hook's output is not added
   to the context and it cannot block the compaction — so it is a prompt to the operator to say
   *"commit and update the handoff first"*. ⛔ **It does not fire on `/clear`**, which discards the
   context without compacting it; nothing can run before a clear with the context still in hand.

2. ⭐ **After the boundary — `hooks/sessionstart-resume.sh` on `SessionStart` (`clear`, `compact`,
   `resume`).** A `SessionStart` hook's stdout *is* read into the agent's context, so this one
   re-injects `handoff.md`, bounded, with an instruction to derive the resume point from the
   filesystem rather than from the document. It is the recovery half: what the first hook could not
   save, this one reads back from the file the close-out list obliged the agent to write.

3. **Surface a close-out prompt at every gate.** Gates are the natural session boundaries in this
   arc — the run stops there anyway — so a gate report ends with the close-out state: what is
   uncommitted, whether the timings row is written, whether `handoff.md` is current.

⛔ **The hooks ship with the method or they do not exist.** Observed: the first hook lived for four
days in one machine's `~/.claude/settings.json` while this file printed a one-line copy of it that had
already diverged — present where it was least needed, absent everywhere the plugin travelled, and the
only record of it was the author's memory. So: **the scripts live in `hooks/`, this file points at
them and copies nothing**, and step 0a checks that a `PreCompact` hook is registered. The development
install (`adapters/claude/install.ps1`) registers the same two files in user settings; if both the
plugin and the junction install are active the warning appears twice, which is harmless and is how
you know.

⚠ **Say which of these the host actually supports.** A method depending on a lifecycle event the
host does not expose fails silently, which is the same shape as the reviewer that never ran.

## Example Output

A gate is one pass. The gate's own question, the critic's rulings, and anything deferred —
each with a recommendation and what the other answer costs.

```
## /build-strategy — resumed at stage 4

Intake read: [organisation] · [function] · sponsor SOLE · mode: targeted.
Gate 0 rulings on file: proposition (0.1, ruled by GvdM), unit = the function (0.2).
Subagents registered: strategy-critic, stakeholder-proxy (both installed 3d ago).
Artefacts present through stage 3. Resuming at gate 4.

**Produced since last run**
  strategy/dg-pain-map.md    126 pains, 8 recurring shapes, mechanisms stated
                             every pain anchored to step-2 task IDs
  critic pass on stage 3     4 findings — 2 fixed, 2 need you (below)

**⚠ GATE 4 — three rulings, then stage 4 runs**

1. One sponsor or several?  [the gate's own question]
     (a) [named sponsor] only — drivers in their language, the
         second role's dropped
     (b) both sponsors — tracked and tagged by owner
   Recommend (a): intake says SOLE. Cost of being wrong: every driver
   re-tagged or dropped at stage 6, and the eliminated-areas list rebuilt.

2. P-31..P-38 record a symptom, not a mechanism.  [critic, stage 3]
   Recommend: rewrite before stage 4 — a driver citing a symptom cannot be
   traced back. Cost: half a stage now, versus eight untraceable drivers.

3. The pain map has no inclusion rule stated.  [critic, stage 3]
   Recommend: state it as "recurring and owned by the function". Cost of
   leaving it: nothing downstream can say what was deliberately left out.

Escalations: 3 received · 0 ruled · 0 deferred · 0 declined — all three open.
Nothing proceeds until all three are answered. Stage 3 committed as 9f2c114.
```

**What that example is not.** Item 2 was fixed by the agent because it is a defect with a
named remedy; item 3 is a ruling because it changes what the map claims. **The critic made
neither call.** It reported three findings and this command sorted them — and the sorting is
the part that must never be delegated back to it.
