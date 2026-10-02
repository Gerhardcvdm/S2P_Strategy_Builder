---
name: arc-watcher
description: Render where a method run stands from the artefacts on disk — every stage and gate of every arc on the map, what is done, what is next, which gate is open and what waits on it, which gates were ruled and which merely passed, which reviewer passes are missing, an approximate percentage complete, and the close-out state — as one self-contained HTML page, regenerated on every agent turn. Use when asked "where are we", "what is left", "how far along are we", "did the critic run on stage 5", "show me the progress", before writing a gate report, at the start of a resumed session, or whenever a run's position is about to be asserted from memory. It derives; it never records.
tier: domain
---

# Arc watcher

**Created by Gerhard van der Merwe.** Licence: by invitation only, see `LICENSE`; do not share or redistribute.

The commands keep no state file: every artefact declares its stage, and the resume point
is derived from a directory listing. This skill renders that derivation so a person can see it.
**`RUN-PROGRESS.html` is a view of the files, never a record of anything.** Deleting it loses
nothing; editing it changes nothing; citing it as a source is citing a screenshot.

## How it runs

| When | Driver | What you get |
|---|---|---|
| End of every agent turn | **`Stop` hook**, shipped in the plugin's `hooks/hooks.json` | `RUN-PROGRESS.html` rewritten in the project root. Silent. Exits without writing in a folder with no `intake.md` |
| After a clear, compaction or resume | **`SessionStart` hook** calls the script with `--summary` | One line of position in the agent's context, derived from files rather than remembered |
| On demand | `bash scripts/render-progress.sh [--dir D] [--summary]` | The same page, and the line |

The page is **git-ignored**; step 0z of `/build-strategy` adds the ignore line. A derived file
that is committed becomes something to keep in step, which is what the design avoids.

**A project may carry its own map.** `.claude/arc-map.tsv` beside the project's `CLAUDE.md` is used
in place of the bundled map when `--map` is not given, and its presence is permission to render without
an `intake.md` — the case of a run that predates the intake form and whose files carry the names the
sessions gave them rather than the names the commands would have. Such a map may open with directive
lines: `#= Organisation: …`, `#= Function: …`, `#= Sponsor: …` and `#= Engagement mode: …` name the
engagement on the page when there is no intake to read them from, and `#= arc P: name` names an arc the
bundled map does not have. The resume document may be spelt `handoff.md` or `HANDOFF.md`; reviewer
passes are also looked for under `deliverables/critic/`.

The script is idempotent per session and event: when two registrations fire it (the plugin's and a
development install's), the second within ten seconds exits without work.

## Reading the page

- **The headline** is the arc the run is in — the first one *at a gate* or *in progress*, else the
  first not started — and where it stands: *GP5 · awaiting a ruling*, *stage 7 · next to run*, or
  *not started · waits on D#2 stage 7*. A complete arc with a stage missing says so: *the run
  reached the last stage · 1 stage not on file: 1p*.
- **The percentage** is stages with an artefact plus gates ruled or passed, over every stage and
  gate of every arc on the map, the storyline review's own rows included. It is approximate by construction and measures presence, never quality.
  Each arc carries its own.
- **The strip**: a circle is a stage, a diamond a gate, a dashed square a check that leaves no
  artefact. Solid green is done or ruled; a dashed green ring is a gate passed by inference only;
  the white ring with the teal halo is where the run is; dotted grey is a stage not on file; faded
  is a gate this run did not need.
- **Every row says why.** A gate is **`ruled`** when a ruling row is found where the map looks
  (the row's target is a `file::regex` over the register), **`passed`** when only a later stage
  exists — *inferred, not ruled* — and **`open`** when the stage before it is done, the stage after
  it is not, and no ruling is on file. Pending rows name what they wait on: the open gate, the
  stage before them, or the other arc's stage that has to exist first (the map's `waits` column).
- **Not on file** is a stage with no artefact while later stages have one. It does not move the
  position: the run went past it, so either it was skipped or it entered the method after this arc
  ran (the row's `since` says when). Reported once per arc, not once per later stage.
- **Reviewer pass** is found by the artefact the pass names in its first lines (`{file}`), falling
  back to the stage id (`{id}`), because a run's critic files may carry the skill's step numbers
  rather than the command's stage numbers.
- **Things to look at** is the list that matters: gates passed by inference where a register
  should hold rows; stages not on file; a stage with an artefact and no reviewer pass; a reviewer
  pass with no artefact; files in the scanned directories that no map row claims; an unfilled
  intake; a resume document behind `HEAD`; no repository. ⛔ **Every item in it goes into the
  next gate report.** The page finds them; it does not resolve them.
- **Close-out state** mirrors the four-item close-out list: working tree, resume document,
  timings, ruling register.

## What it cannot know

Presence is not quality — an artefact exists, not that it is right. A gate ruled is a row that
matched a pattern, not a ruling read. A gate passed is not a gate ruled. It cannot tell a skipped
stage from one added to the method after the arc ran; it can only say the run went past it.
A critic path the command never states cannot be checked. ⚠ **Where the page and the resume
document disagree, the files win and the disagreement is a finding.**

## Extending the map

`arc-map.tsv` is the single list of what each stage leaves behind, one row per stage, gate or
check: arc · id · kind · label · targets · exclude · skip-if · critic · note · since · waits ·
storyline.

- **targets**: items separated by `|`, each a glob or `file::regex`. A glob prefixed `?` is
  *claimed, not required*: the unmapped sweep stops naming the file and the stage is not done by
  it. On a gate row a `file::regex` is the **ruling record**; a match makes the gate *ruled*.
  ⚠ A regex may not contain `|` — it is the item separator.
- **skip-if** (`file::regex`): a stage skipped by design, or a gate not applicable, when it matches.
- **critic**: patterns separated by `|`, tried in order. `dir/*.md::{file}` finds the pass whose
  first two lines name one of the stage's artefacts; `dir/{id}.md` is the stage id. `n/a` for a
  proxy pass; `-` when the command does not say where the pass is filed.
- **since**: the plugin version the row entered the method — shown when the stage is not on file.
- **waits**: `ARC:ID`, the other arc's stage that must exist first. Inside an arc, order is the
  dependency.
- **storyline** *(added 0.7.0)*: the storyline stage this row begins — `strategy`, `portfolio`,
  `prioritisation`, `choice`, `specification`. Blank means the row sits inside the stage of the row
  before it; `-` means it belongs to none (the review's own arc `S`). The renderer does not read it;
  `storyline-review` does, so a new artefact needs a row here and nothing in that skill.
- ⚠ **A target means something different per kind.** On a stage row it is an artefact the stage leaves;
  on a gate row the ruling record; on a check row an input the guard reads, `intake.md`, which no stage
  produces. The renderer only asks whether a row is done, so it never needed the distinction; a reader
  that attributes files to stages must skip check rows, or the intake joins every arc and sets a false
  first commit (observed 2026-10-02, the storyline builder's first run).
- ⛔ **Adding a column means extending the reader in the same edit.** The script binds columns by
  position into a fixed list of names, and bash gives the last name the rest of the line, so a column
  the reader does not know lands inside `waits` and the cross-arc dependency is dropped with no error.
  The reader now binds a trailing `rest` and reports any row wider than it knows under *Things to look
  at*; the fixture cannot show the dropped wait, so the report is the test.

⛔ **A stage that adds an artefact adds a row here, a line to the command's resume map, and a
directory to the command's scan — the same edit.** The page's unmapped-files sweep is what catches
the row that was forgotten. ⛔ **After editing the map, run the script against the fixture and
read *Things to look at* before committing:**

```bash
bash scripts/render-progress.sh --dir fixtures/complete-run --summary
```

`fixtures/complete-run/` is the file tree of a completed three-arc run — every file name the
commands wrote, each reduced to its header lines and its ruling rows, which is all the map reads.
`scripts/make-fixture.sh <run-dir>` rebuilds it from a real run. **The map is correct when the
fixture renders with zero things to look at**, and a change to the map that raises that number is
a change to test, not to ship. A map written from the command's prose is a claim about the command;
only a run's files can confirm it. The first version of this map met a real run and produced
eighteen warnings about the tool, one about the run.

**Arc `S` is the storyline review**, five rows: the guards, the draft record, Gates GS1 and GS2, the
page. It waits on D#2 stage 0a, the second stage's first artefact, and it is why a finished three-arc
run reads *Storyline · not started* rather than complete.

**Two naming schemes are live.** Runs before 0.6.0 filed D#2's rulings as `P<gate>-R<n>`, D#3's as
`R<gate>-R<n>` in `portfolio/rulings.md`, the portfolio page at stage 8 and the stop check at 9;
0.6.0 renamed the series to `GP`/`GR`, gave D#3 `recommendation/` and swapped the last two portfolio
stages. The map's regexes accept both, its stage rows find the artefact by file name, and a row's
note says which scheme applied when.

## Pre-flight, before a gate report cites the page

- [ ] The page was regenerated this turn, not read from an earlier one
- [ ] Every item under *Things to look at* appears in the report
- [ ] No number in the report was typed from memory when the page had it
- [ ] The report says *the files show*, never *the page confirms*
- [ ] A *ruled* gate is cited as *a ruling row is on file*, never as *the gate was ruled correctly*
