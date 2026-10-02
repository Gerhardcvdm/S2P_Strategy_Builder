---
name: storyline-review
description: Read a multi-stage derivation backwards and judge whether its stages still hang together as one argument. One verdict per handoff between consecutive stages (holds · weakens · breaks), one verbatim quotation from each side checked against its file, where the judgment sat at every stage, value followed through, and the weakest link with its smallest repair. Use when a run has two or more stages on file, before a deliverable goes into a room, when someone asks "does this still add up", "where did value drop out", "did anyone actually rule that", or after a long derivation nobody has read end to end. It judges handoffs, not stages; it names a repair and does not make one.
tier: domain
---

# Storyline review

**Created by Gerhard van der Merwe.** Licence: by invitation only, see `LICENSE`; do not share or
redistribute. The shape of this review was learned from the week-07 storyline review of the S2P
programme; the method is stated here in its own words and quotes nothing from that programme.

## What it is

A derivation that runs for weeks passes through a handful of **stages**: a strategy, a portfolio, a
prioritisation, a choice of what to prove, a specification, a build. Each stage was reviewed as it
was made, one step at a time, by the critic. **Nobody read the chain backwards.** This review does.
It asks whether the stages hang together as one argument, by judging the **handoffs** between
consecutive stages. The unit is the handoff, never the stage.

## What every handoff carries

- **A verdict on a three-value scale.** *Holds*: the downstream stage takes what the upstream
  stage handed it and builds on it. *Weakens*: it takes part of it, re-derives something it was
  handed, or adds a term the upstream never stated. *Breaks*: it contradicts or ignores what it
  was handed.
- **One verbatim quotation from each side.** One sentence from the upstream artefact stating what
  it hands on; one from the downstream artefact showing what was received. Emphasis is stripped;
  everything else is byte-exact. ⛔ **Each quotation is checked mechanically against its file** on
  the day it is written and again whenever the page is built, and the result is recorded.
- **A reading** of a few sentences saying why the two quotations earn the verdict.

## Around the handoffs, four parts

1. **The stage table**: each stage, where it lives, first and last commit that touched it. From git.
2. **Where the judgment sat**, one row per stage: *joint* · *the agent's, accepted as presented* ·
   *the person's*. On the first run this row found that the stage with the most scores in it was
   the one nobody had ruled individually.
3. **Value, followed through.** Value is not a stage. Name where it enters, where it is quantified,
   and where it drops out of the argument.
4. **The weakest link and its smallest repair.** One handoff, the cause located in the stage that
   owns it, the smallest change that would mend it. ⛔ **The repair is named, not made**, unless the
   person rules otherwise.

## Three rules, all from the first run

- ⛔ **Every verdict is confronted as a formal question with options.** Per handoff, two questions
  in one call: the verdict (confirm · enrich · correct to each other value) with both quotations in
  the question text, and whose decision the downstream stage was. Never prose asking the person to
  "confirm, correct or enrich". `references/confront-protocol.md`.
- ⛔ **A draft that survives untouched has not been tested.** When zero verdicts change, that count
  is itself put as a question, and the figure on the page is then the person's ruling, not a default.
- ⛔ **No sentence on the page about the data is a string literal.** The first page asserted a
  timing fact its own dates contradicted. Every count, date and comparison is computed from the
  record and the files that own it, or the build refuses. `references/page-spec.md`.

## Where the stages come from

**The arc map.** `arc-map.tsv` carries a `storyline` column naming the stage a row begins; rows with
no value sit inside the stage of the row before them; `-` belongs to none. Stages are ordered by
first appearance, and a stage's files are everything its rows' targets match. **So a new artefact
needs a map row, not a change here.** The review is invocable at any point with two or more stages
on file: handoffs between stages on file are judged, the rest are marked *not yet judgeable*, and a
complete run judges all. A stage the map does not name is not judged; the record says what the map
does not cover, and that gap is a finding about the map.

## What it is not

- **Not a deliverable.** The record carries no version and no marker, and the deliverables
  contract does not govern it. It lives in `storyline/`, never in `deliverables/`.
- **Not a critic pass.** The critic reviews one stage against its input and looks upstream. This
  reads the whole chain in one context and looks at the joins.
- **It confronts nothing itself.** The subagent drafts; the person rules, at the gate, per handoff.
- **It edits no artefact it reads.** A repair is a sentence in the record until it is ruled made.

## Who does what

| | |
|---|---|
| `storyline-reviewer` (agent) | Locates stages from the map, reads the chain, drafts every part, checks every quotation, writes the draft record and nothing else |
| `/review-storyline` (command) | Writes the stub, spawns the drafter, puts each verdict, the zero-changed count and the weakest link to the person, records the rulings, builds the page |
| `scripts/build_storyline.py` | Resolves stages from the map, checks the record, renders the page. Derived, never a record. `--stages` lists the stages; `--check` tests a draft without rendering |

`references/record-format.md` is the contract the three share.
