# The page — `storyline/storyline-review.html`

Built by `scripts/build_storyline.py` from the record, the arc map, git and an optional calendar.
**Derived, never a record.** Deleting it loses nothing; editing it changes nothing; the record and
the register are the sources. It is committed, unlike `RUN-PROGRESS.html`, because it is built once
at stage 5 and read afterwards, not regenerated every turn.

## The one rule

⛔ **No sentence on the page about the data is a string literal.** Every count, date, name and
comparison the page shows is computed from the record, the map, git or the calendar at build time.
Where a figure cannot be computed, the exhibit that needs it is omitted and the omission is stated
on the page; nothing is filled in by hand and nothing is defaulted. The first page of this kind
asserted a timing fact in a template string that the stage dates on the same page contradicted.

## Refusals

The build stops, prints every failure it found, and writes nothing when:

- the record, the map or the git repository is missing, or the map has no `storyline` column;
- fewer than two storyline stages have an artefact on file;
- the record's set of handoffs differs from the consecutive pairs the map yields;
- a verdict cell is empty or not one of the four values;
- a handoff whose stages are both on file reads `not yet judgeable`, or a handoff with a stage not
  on file carries a verdict;
- a quotation is not found in its file after emphasis is stripped from both;
- a quotation's file is not one the named stage claims;
- §6's counts differ from what §3 yields;
- the record's `Status` still reads `draft · running`.

A missing calendar is not a refusal: the timeline exhibit is omitted and the page says so.

## Sections, in order

1. **Hero.** Eyebrow *storyline review*. Title from the record's `Organisation` and `Function`.
   Subtitle computed: *N stages on the map, M on file · K handoffs judged · built <date> from <record>
   at <short sha>*.
2. **Figures.** Stat tiles, each computed: stages on file / on the map; handoffs judged / possible;
   quotations checked (all found, or the build would have refused); verdicts confirmed · enriched ·
   corrected; the changed count, shown only once §6 `Ruled` carries a row, else *not yet ruled*.
3. **The stage strip.** One box per stage in map order, named, with its first and last commit
   dates; between consecutive boxes a verdict badge: *holds* green, *weakens* amber, *breaks* red,
   *not yet judgeable* dashed grey. A stage not on file is a dashed box.
4. **Where the judgment sat.** One cell per stage coloured by `Sat with`: joint, the agent's, the
   person's; not on file dashed. Under each cell the evidence sentence and the ruling id or *not
   yet*. A corrected value shows the struck draft beside it.
5. **Handoff cards.** One per handoff: title, verdict badge, the two quotations each as a
   blockquote with `path:line` as found at build time and the check result, the reading, the
   confronted row, the enrichment where there is one. A not-yet-judgeable handoff is a short card
   with its `Why`.
6. **Value, followed through.** The §4 table, with the stage strip's colours.
7. **The weakest link.** The §5 fields and the ruling.
8. **The commit timeline** — *only when `storyline/calendar.tsv` exists.* An inline SVG: one bar per
   stage from first to last commit, calendar events as ticks with their labels, the axis spanning
   the earliest and latest date in either source. Without the calendar this section is one
   sentence saying the exhibit is omitted because no calendar file was given.
9. **The stage table.** §1 as git reports it at build time, with any difference from the record
   noted under the table.
10. **Footer.** *Derived by build_storyline.py on <date> from storyline/storyline-review.md at <sha>.
    Not a record.*

## Style

`html-style` governs: one self-contained file, the palette, the print block, semantic structure.
New colours for the verdict badges are the only additions and are checked for contrast on the dark
surface and inverted to deeper tones in print. Component classes are prefixed `sl-` and scoped.
Rule 7's three checks run inside the build and a failure is a refusal. The strings the script writes
into the page are labels; the prose is the record's, so the humanizer pass belongs to the record.

## Invocation

```bash
PY=$(command -v py || command -v python3 || command -v python)
"$PY" "$SL/scripts/build_storyline.py" --dir . --stages            # the stage table, for the drafter
"$PY" "$SL/scripts/build_storyline.py" --dir . --check             # test a draft; writes nothing
"$PY" "$SL/scripts/build_storyline.py" --dir .                     # build storyline/storyline-review.html
```

`--map` overrides the map; otherwise `.claude/arc-map.tsv` in the run directory is used when present,
else the `arc-watcher` map beside this skill. `--record`, `--out` and `--calendar` override the
default paths under `storyline/`.
