# S2P Strategy Builder v0.7.0

Released 2026-10-02 from source commit `3428f13`. This repository is generated;
do not edit it. Changes are made at the source and released again.

## What changed in v0.7.0

*Source: `briefs/storyline-review.md` — eight rulings of 2026-10-02 from the first end-to-end run of the
review, and four build-session rulings taken the same day: the review's record is a fourth arc `S` on
the map; the command is `review-storyline`; the stage column is a twelfth map column with the reader
extended; this ships as 0.7.0 after the test run. The fifth open item, whether the record is a
deliverable, was taken as the brief states it: it is not.*

**Added**

- `commands/review-storyline.md` — reads a derivation backwards. Six stages, two gates: the guards and
  the entry writes; the stub, then the drafter; Gate GS1, one call per handoff with the two quotations
  in the question and the options *confirm · enrich · correct*, plus whose decision the downstream
  stage was; the zero-changed question when it applies; Gate GS2, the weakest link and its smallest
  repair, named and not made unless ruled; the page. No critic pass, no proxy pass; the record is not a
  deliverable and lives in `storyline/`. Invocable at any point with two or more stages on file.
- `skills/storyline-review` — the method, in its own words, 5,839 characters: the handoff as the unit,
  the three-value verdict, the verbatim-quotation rule and its mechanical check, the four parts around
  the handoffs, the three rules the first run produced. `references/record-format.md` is the contract
  the drafter, the command and the builder share; `references/confront-protocol.md` the gate
  questions; `references/page-spec.md` the page and its refusals. `scripts/build_storyline.py`
  resolves stages from the map's `storyline` column, globs their files, reads git, checks every
  quotation, computes every figure, and refuses rather than fakes; `--stages` and `--check` serve the
  drafter.
- `agents/storyline-reviewer.md` — the drafter. Reads the whole chain in its own context, drafts every
  part, checks every quotation, writes the draft record and nothing else. Never confronts, never
  reports a verdict as ruled, never edits an artefact it reads.

**Changed — prompts**

- `skills/arc-watcher` — a `storyline` column, twelfth on every row, naming the storyline stage a row
  begins (`strategy`, `portfolio`, `prioritisation`, `choice`, `specification`); blank inherits, `-`
  is none. Arc `S` with five rows for the review's record, waiting on D#2 stage 0a. The reader binds
  the new column and a trailing `rest`, and reports any row wider than it knows instead of folding the
  remainder into `waits` — a 12-column map on the 0.6.0 reader rendered without error and silently
  dropped every cross-arc wait. `storyline/` is scanned; `make-fixture.sh` carries it; the percentage
  is over every arc on the map, so a finished three-arc run now reads *Storyline · not started*.
- `templates/CLAUDE.md` — the arc table and the layout name the review and `storyline/`.
- `wiring-the-method.html` — the review in the primitives, the inventory, the setup steps and the
  stages tab; the diagram is unchanged and the page says why.

**Unchanged — prompts:** `commands/build-strategy.md`, `commands/build-portfolio.md`,
`commands/build-recommendation.md`, `skills/function-to-strategy-derivation`,
`skills/use-case-portfolio-derivation`, `skills/derivation-orchestration`,
`skills/analytical-document-build`, `skills/html-style`, `agents/strategy-critic.md`,
`agents/stakeholder-proxy.md`, `hooks/`.

**Observations closed:** 24 in the authoring rig's log (the positional reader; closed in part — the reader reports a
wide row, and the fixture still cannot show a dropped wait).

**Tested, 2026-10-02, on the plugin-test rig (D#1–D#3 complete, demo built outside the repo):** five
storyline stages resolved from the map, all on file; the drafter read the chain in one context (45 tool
uses, about 9 minutes) and wrote a record that passed `--check` first time: four handoffs, four *weakens*,
eight quotations found. Gate GS1 put ten questions from options and took ten answers: every verdict
confirmed, the portfolio stage ruled *the agent's, accepted as presented*, the other four *joint*; the
zero-changed count put and ruled (GS1-R10). Gate GS2 confirmed H1 as the weakest link with the repair named
and not made. The page built on the first run; the timeline exhibit was omitted for want of a calendar
file, as specified. The builder was also run on a synthetic two-stage repository with nine single-defect
mutations of the record, each refused for the stated reason, and one benign change that passed. Not yet
exercised on a real run: a *not yet judgeable* handoff (the rig has every stage), a corrected verdict, an
enrichment, a *make it now* ruling, and the calendar exhibit beyond the synthetic run. The record
surfaced one map gap the run already knew (observation 104: no arc owns the demo build) and one it did
not: `client/README.md`, the record grade, is not surfaced by the `client/*` target.

The full history is in `CHANGELOG.md`.
