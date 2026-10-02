---
description: Read a derivation backwards and judge whether its stages hang together — a drafted verdict on every handoff, each put to you as a formal question with options, then the weakest link and its smallest repair, then the page
argument-hint: [stage]
---

# Review Storyline

Run the **storyline review** on the derivation in this directory, following `storyline-review`.
Six stages, **two gates where a human decides**, and the second gate is one question per handoff.

⚠ **Load `derivation-orchestration` before anything else.** Guards (§1), state (§2), gates (§3), the
reviewer protocol (§4), markers and identifiers (§7), committing (§8). Then load `storyline-review`.
This file carries only the sequence.

## What this command does, and what drives each step

| # | Produces | Driver |
|---|---|---|
| 0 | guards · `storyline/`, its register, the `GS` series in `IDENTIFIERS.md`, the timings row | **Agent** (Bash) · `derivation-orchestration` §1–2 |
| 1 | `storyline/storyline-review.md` — the draft record | **Agent** writes the stub → **`storyline-reviewer`** writes the draft · `storyline-review` *record-format* |
| 2 | `storyline/rulings.md` rows `GS1-R<n>` · the record's `Confronted` and `Ruled` cells | **⚠ Gate GS1 — manual: one ruling per handoff, two questions per call** · `storyline-review` *confront-protocol* |
| 3 | one more `GS1-R` row, when zero verdicts changed | **⚠ Gate GS1, continued — manual: the count is yours or it is not on the page** |
| 4 | `GS2-R<n>` · §5 `Ruled` | **⚠ Gate GS2 — manual: the weakest link and its repair** · the repair is made only on your ruling |
| 5 | `storyline/storyline-review.html` | **Agent** · `scripts/build_storyline.py` · `html-style` hard rules |
| — | close-out | **Agent** · §8 |

**No critic pass runs here.** The drafter is itself a reviewer of the whole chain, and the critic's
contract is one stage against its input. **No proxy pass runs here**: nothing in the record is for the
sponsor. The record is not a deliverable and never goes to `deliverables/`.

## Usage

```bash
/review-storyline          # resume from wherever the artefacts stop
/review-storyline 1        # redraft deliberately; the register is kept and the confront re-put
```

Invocable at any point with **two or more storyline stages on file**. Handoffs between stages on
file are judged; the rest are *not yet judgeable*; a complete run judges all. Run it again later and
it drafts again: a second review after more stages exist is a new record, and the old one is kept
under `storyline/archive/<date>/`.

## Implementation steps

### 0 · Guards

```bash
[ -f intake.md ] || echo "STOP: no intake.md — this is not a run directory"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || echo "STOP: not a git repository; the stage table reads git"
cc="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
ls .claude/agents/storyline-reviewer.md "$cc"/agents/storyline-reviewer.md \
   "$cc"/plugins/cache/*/s2p-strategy/*/agents/storyline-reviewer.md 2>/dev/null | grep -q . \
  || echo "STOP: storyline-reviewer is not installed"
SL=$(ls -d .claude/skills/storyline-review "$cc"/skills/storyline-review \
   "$cc"/plugins/cache/*/s2p-strategy/*/skills/storyline-review 2>/dev/null | head -1)
[ -n "$SL" ] || echo "STOP: the storyline-review skill is not installed"
MAP=.claude/arc-map.tsv; [ -f "$MAP" ] || MAP="$SL/../arc-watcher/arc-map.tsv"
head -20 "$MAP" | grep -q $'\tstoryline$' || echo "STOP: $MAP has no storyline column — the map predates 0.7.0"
PY=$(command -v py || command -v python3 || command -v python); [ -n "$PY" ] || echo "STOP: no python"
"$PY" "$SL/scripts/build_storyline.py" --dir . --map "$MAP" --stages
```

The last line prints the stages the map yields and how many are on file. **Fewer than two on file
is a stop**: the message names which stages exist and which the map expects. Print what each guard
tested, never what it implies: *map has a storyline column*, not *map is valid*.

Then, before stage 1, the entry writes (`derivation-orchestration` §2): `mkdir -p storyline`;
`storyline/rulings.md` with its header only; the `GS1-R` and `GS2-R` series appended to
`IDENTIFIERS.md` **after** `grep -n 'GS' IDENTIFIERS.md` shows no collision (record the collision
and choose a free prefix if it does); the arc's header in `RUN-TIMINGS.md`. Commit: *storyline
review entry*.

### 1 · The draft

**Write the stub first** (`derivation-orchestration` §4): the record's header table with `Status`
reading `draft · running`, the date, the plugin version, and nothing else. Commit it. A drafter
killed by a rate limit then leaves a file that says it was started, not silence.

Then invoke `storyline-reviewer` with: the run directory, `MAP`, `$SL/scripts/build_storyline.py`,
the record path `storyline/storyline-review.md`, and the plugin version. It writes the record over
the stub; its contract confines its write tool to that path. ⛔ **Do not transcribe its report into
the record.** When it returns, run

```bash
"$PY" "$SL/scripts/build_storyline.py" --dir . --map "$MAP" --check
```

and treat a refusal as a defect in the draft: send the failures back to the drafter, once. A second
refusal goes to Gate GS1 as the first item. Commit the draft. Timings row from the two commits.

### 2 · Gate GS1 — the confront, one call per handoff

Follow `storyline-review/references/confront-protocol.md` exactly. For each handoff the record
judges, in order: **one call, two questions** (three for H1): the verdict with both quotations in
the question text, options *confirm · enrich · correct to each other value*; and whose decision the
downstream stage was. After each call, append the rows to `storyline/rulings.md` and update the
record's `Confronted`, `Verdict`, `Enrichment`, `Sat with` and `Ruled` cells in the same edit.

⛔ **The draft is first and marked recommended, and that is the only place the agent's view
appears.** An answer in the Other box is recorded verbatim; one that is not a value is restated and
asked again.

### 3 · The zero-changed question — when it applies

If no verdict was corrected, put the count: *0 of N changed — your ruling, or reopen?* Record the
answer as the next `GS1-R` row and write it into §6 `Ruled`. If a handoff is reopened, put it again
with the other two values first. **When at least one verdict changed, no question is put** and §6
`Ruled` reads `by count · <date>`. Commit, with the gate's accounting in the message: *N put, N
answered, N confirmed, N enriched, N corrected, batch share 0%*.

### 4 · Gate GS2 — the weakest link

One call: the handoff, the cause in its owning stage, the smallest repair, four options per the
protocol. On *confirm, not made* nothing else is touched. On *make the repair now*, make it in the
owning artefact as a strike-and-add (never a rewrite), note the commit in §5, and name the file in
the gate report; that is the one edit this command makes outside `storyline/`. Record `GS2-R<n>`.
Commit.

### 5 · The page

```bash
"$PY" "$SL/scripts/build_storyline.py" --dir . --map "$MAP"
```

It refuses or it writes `storyline/storyline-review.html`; there is no partial page. The refusal
list is a defect list for the record, not for the script. On success it has already run
`html-style` rule 7's three checks. Commit the page. **Never publish it via the Artifact tool.**

### Close-out

Per `derivation-orchestration` §8, in the last commit's message: the artefacts; the timings rows for
stages 1 and 5 from commit timestamps, the gates `not separable`; observations about the method or an
explicit `none for this review`; `handoff.md` updated with the weakest link and its repair as an open
item carrying the condition that closes it, when the repair was not made; the identifier grep for
`GS`, or `no new series` on a second review. **Never push.**

## Gates

| Gate | When | The rulings |
|---|---|---|
| **GS1** | Stage 2, then 3 | Per handoff: the verdict (confirm · enrich · correct) and whose decision the downstream stage was. Then, when nothing changed, whether that count is yours |
| **GS2** | Stage 4 | The weakest link, the cause, the smallest repair; named, or made on your word |

## Resume

Derived from the files, `derivation-orchestration` §2. The record's `Status` first word: `draft ·
running` → stage 1 is re-run from the stub; `draft` with every `Confronted` reading `not yet` →
stage 2; some confronted → stage 2 continues at the first `not yet`; all confronted and §6 `Ruled`
`not yet` with zero corrected → stage 3; §5 `Ruled` `not yet` → stage 4; page missing or older than
the record → stage 5. The register is the authority for what was ruled; the record's cells are
checked against it and a mismatch is a stop.

## Error handling

**Fewer than two stages on file** — name the stages the map expects and which exist. Stop.
**The map has no storyline column** — the plugin predates 0.7.0, or the project map was written
before it. Say which file and stop; do not fall back to guessing stages from directory names.
**A quotation fails the check** — the draft is wrong, not the file. Back to the drafter once, then
the gate.
**The drafter wrote outside its path** — report the files, `git checkout` them, and put it to the
gate as the first item.
**The person wants the repair made and it touches a closed arc's artefact** — strike in place, never
rewrite, and name the file in the commit; `derivation-orchestration` §4's corrections rule.

## Important notes

- **NEVER confirm a verdict on the agent's behalf.** Recommended is the strongest word the draft gets.
- **NEVER put the confront as prose.** One call per handoff, options, every time.
- **NEVER show the zero-changed count before it is ruled.**
- **NEVER edit a stage artefact except on a GS2 *make it now* ruling.**
- **NEVER push.** Commit locally after each stage.

## Example output

```
## /review-storyline — Gate GS1, handoff 3 of 4

Map: skills/arc-watcher/arc-map.tsv · 5 storyline stages · 4 on file (specification: no artefact)
Draft: 4 handoffs, 3 judged, 1 not yet judgeable · 6 quotations, 6 found
So far: H1 confirmed (GS1-R1) · portfolio judgment corrected to the agent's (GS1-R2) ·
        H2 enriched (GS1-R3) · prioritisation judgment confirmed (GS1-R4)

⚠ GATE GS1 — H3 · prioritisation → choice

  [one call, two questions — see the question box]

Then: the zero-changed question does not apply (0 corrected so far, 1 handoff to go).
Next: Gate GS2, the weakest link. Stage 1 committed as 4c1e9a2.
```
