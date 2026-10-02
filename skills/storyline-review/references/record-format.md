# The record — `storyline/storyline-review.md`

The one file the drafter writes, the command annotates at the gates, and the builder reads. Its
shape is a contract: `build_storyline.py --check` parses exactly this and refuses anything else, so a
field written differently is a build failure, not a style choice. Blockquotes carry the quotations
because a markdown table cell cannot hold a pipe, and quoted source lines often do.

Everything in `{braces}` is filled in. Lines beginning `**Key:**` are parsed by the key; the key is
case-sensitive and ends at the colon.

```markdown
# Storyline review — {Organisation} · {Function}

| | |
|---|---|
| **Stage** | storyline · the record (`/review-storyline` stage 1) |
| **Status** | {draft · running | draft · not yet confronted | confronted · N of N handoffs ruled} |
| **Input** | the bundled `arc-map.tsv` of s2p-strategy {version}, or `.claude/arc-map.tsv` · every stage artefact in §1 · `git log` |
| **Date** | {YYYY-MM-DD} |
| **Plugin** | s2p-strategy {version} |
| **Drafted by** | storyline-reviewer · model: {model} |
| **Organisation** | {from intake.md} |
| **Function** | {from intake.md} |
| **Deliverable** | no — a working record: no version, no marker, not governed by the deliverables contract |

## 1 · Stages

| # | Stage | Map rows | Lives in | On file | First commit | Last commit |
|---|---|---|---|---|---|---|
| 1 | strategy | D1 0–12 | `strategy/` · `client/` · `deliverables/` | 23 files | `0f2fe8a` 2026-09-05 | `e0dcabf` 2026-09-22 |
| 5 | specification | D3 0–5 | `recommendation/` · `deliverables/` | none | — | — |

## 2 · Where the judgment sat

| Stage | Sat with | Evidence | Ruled |
|---|---|---|---|
| strategy | joint | 28 ruling rows in `strategy/rulings.md` over 9 gates · 20 from options, 8 batch | not yet |
| portfolio | the agent's, accepted as presented | 260 scores in `portfolio/positioning-matrix.md`, accepted in one commit (`a5a2e57`); GP3 ruled the weighting, no ruling names a score | not yet |
| specification | not on file | — | — |

## 3 · Handoffs

### H1 · strategy → portfolio

**Verdict:** weakens
**Upstream:** `strategy/strategy-basis.md:112`
> {one sentence, verbatim, emphasis stripped}
**Downstream:** `portfolio/entry.md:9`
> {one sentence, verbatim, emphasis stripped}
**Check:** both found · 2026-10-02 · upstream exact · downstream exact after emphasis stripped
**Reading:** {a few sentences: why these two quotations earn the verdict. May run to several lines;
it ends at the next `**Key:**` line}
**Confronted:** not yet

### H4 · choice → specification

**Verdict:** not yet judgeable
**Why:** specification has no artefact on file

## 4 · Value, followed through

| Stage | Value | Where |
|---|---|---|
| strategy | enters | `strategy/cr-value-drivers.md:14` |
| portfolio | quantified | `portfolio/positioning-matrix.md:88` |
| prioritisation | drops out | `portfolio/portfolio-ranking.md:40` — the weighting omits V4 |
| choice | absent | — |
| specification | not on file | — |

## 5 · The weakest link and its smallest repair

**Handoff:** H3
**Cause in:** prioritisation · `portfolio/portfolio-ranking.md`
**Smallest repair:** {one or two sentences naming the change, in the owning artefact}
**Ruled:** not yet

## 6 · The confront

**Handoffs judged:** 3
**Changed:** 0
**Ruled:** not yet
```

## Field rules

**Header.** ⛔ `Input` names the map by which one it was (the bundled map and the plugin version, or the project's `.claude/arc-map.tsv`), never by an absolute path: a path carries the machine's user name and the authoring repository's name into a record that the fixture reduces and the release ships. `Status` has three forms and the builder reads the first word: `draft` or `confronted`.
`draft · running` is the stub the command writes before the drafter is spawned; a record still
carrying it was never finished, and the build refuses it.

**§1 Stages.** The drafter fills this from `build_storyline.py --stages`, which resolves the map's
`storyline` column, globs each stage's targets and reads git. The builder recomputes it at build
time and renders what git says; a difference from the record is printed as a note, because commits
made after the draft (the rulings, a strike in place) move the last-commit column and that is not
a defect. `On file` is a count of matched files or `none`. A stage with `none` is *not on file*.

**§2 Judgment.** One row per stage in §1. `Sat with` is one of exactly: `joint` · `the agent's,
accepted as presented` · `the person's` · `not on file`. `Evidence` names what the drafter read:
ruling rows, their modes, the commit that accepted a generated table. `Ruled` is `not yet` or
`GS1-R<n> · <date>`; when the gate corrects the value, the row reads `the person's (was joint)` and
the builder shows both.

**§3 Handoffs.** One `### H<n> · <upstream> → <downstream>` per consecutive pair of stages in §1
order, numbered from 1, with no pair missing: the builder derives the pairs from the map and
refuses a record whose set differs.

- `Verdict` is exactly one of `holds` · `weakens` · `breaks` · `not yet judgeable`. An empty verdict
  is a refusal.
- A handoff whose upstream or downstream stage is not on file **must** read `not yet judgeable`,
  with a `**Why:**` line naming the stage; quotations are not written. A verdict on such a handoff
  is a refusal. A `not yet judgeable` verdict on a handoff whose two stages are both on file is
  also a refusal: the drafter must judge what exists.
- `Upstream` and `Downstream` are `` `path:line` `` and the path must be a file some row of that
  stage claims. The line is where the drafter found it; the builder re-finds the sentence and uses
  the line it finds, noting a difference.
- The blockquote under each is **one line**: one sentence as it stands in the file, with `**`,
  `*` and `_` emphasis markers removed and nothing else changed. The check strips the same markers
  from the file and looks for the sentence as a substring of one line. Not found is a refusal.
- `Check` records what the drafter's own run of `--check` reported and the date. The builder
  reruns it and prints its own.
- `Reading` is prose. It may run over several lines.
- `Confronted` is `not yet`, or `GS1-R<n> · confirmed · <date>`, `GS1-R<n> · enriched · <date>`,
  or `GS1-R<n> · corrected from <old value> · <date>`. On *corrected* the `Verdict` line carries
  the new value. On *enriched* an `**Enrichment:**` line follows, carrying the person's words.
  The builder counts *changed* as the number of `corrected` rows.

**§4 Value.** One row per stage in §1. `Value` is one of `enters` · `quantified` · `carried` ·
`drops out` · `absent` · `not on file`. `Where` is `` `path:line` `` with an optional note after a
dash, or `—`.

**§5 Weakest link.** `Handoff` names an `H<n>` from §3 that is not `not yet judgeable`. `Cause in`
is a stage name from §1 and a file that stage claims. `Ruled` is `not yet`, or `GS2-R<n> ·
confirmed, not made · <date>`, `GS2-R<n> · made · <date>`, `GS2-R<n> · repair changed · <date>`,
or `GS2-R<n> · link changed to H<m> · <date>` (in which case §5 is rewritten for H<m> and the old
text struck in place).

**§6 The confront.** `Handoffs judged` is the count of §3 entries whose verdict is not `not yet
judgeable`. `Changed` is the count of `corrected` rows. `Ruled` is `not yet` or `GS1-R<n> · the count
stands · <date>`. ⛔ The builder computes both counts from §3 and refuses if §6 states different
figures: two sources for one number is the defect the page exists to refuse. When `Changed` is
zero, the figure is not on the page until `Ruled` carries a row: an untested zero is a draft.

## The register — `storyline/rulings.md`

The command creates it at stage 1 with a header only, and appends one row per ruling at the
gates. The arc map finds Gate GS1 by `\*\*GS1-R` and Gate GS2 by `\*\*GS2-R`. Same columns as the
other arcs' registers:

```markdown
# Storyline review — ruling register

| Id | Question | Answer | Mode | Who | Date |
|---|---|---|---|---|---|
| **GS1-R1** | H1 strategy → portfolio · verdict weakens? | confirmed | options | Gerhard | 2026-10-02 |
| **GS1-R2** | H1 · whose decision was the portfolio stage? | the agent's, accepted as presented | options | Gerhard | 2026-10-02 |
```

Every row is `options` by construction: the confront protocol puts nothing as prose. The `GS`
series is registered in `IDENTIFIERS.md` at stage 1, after a grep of the registry for `GS`.

## The calendar — `storyline/calendar.tsv`, optional

Dated events to lay beside the commit timeline: sessions, meetings, pauses. Tab-separated, `#`
comments allowed. Without this file the timeline exhibit is omitted, never faked.

```
# date	label	kind     (kind: session | meeting | pause | other)
2026-09-05	first session	session
2026-09-22	weekly review	other
```
