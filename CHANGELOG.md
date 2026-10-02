# Changelog — S2P Strategy Builder (`s2p-strategy`)

Each version lists every command, skill and agent as **changed** or **unchanged**, because a run's
comparability across versions depends on whether the prompts moved, and a version number says
only that something did. It also names the observations the version closes, by number in the
authoring rig's observation log. `release.sh` refuses to release a version with no entry here and
copies the entry into the release's `RELEASE.md`.

## 0.7.0

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

## 0.6.0

*Source: the weekly review of 2026-09-22 — 49 observations from the three-arc test run (D#1–D#3),
observations 48–102 less those deferred; plus the ten recommendations recorded after D#3.*

**Changed — prompts**

- `commands/build-strategy.md` — the ruling register row owns the central proposition; an
  agent-drafted proposition is re-put in plain words at Gate 1; `IDENTIFIERS.md` and
  `RUN-TIMINGS.md` created at 0z; the resume is a register join and stops at any completed stage
  whose gate has no rows; plan mode on a resume fires on a context boundary only; a resume re-runs
  the guards and records the plugin version per stage; gate rules 4–6 (the mark is the ruler's,
  five modes, one answer per row, reserved questions in plain words); five-item close-out asserted
  before the next produce; the proxy writes its own agendas; the mandate is pasted, not retyped.
- `commands/build-portfolio.md` — gates renamed `GP1`–`GP5`, rulings `GP<gate>-R<n>` (the frame's
  positions are `P1`–`P6`); the unit of analysis governs both entry paths; the field-size test on
  the adopted path as a disclosure and a stop-check box; register, registry rows and timings row
  created at 0a; strictness stated and merge register; trigger/output derivation rule on the
  adopted path; filter set partitioned by what it gates; proposition-dependent filters marked
  conditional; Gate GP5 in plain words with registry-checked criteria; the proposition read from
  its register row; full-load costing cites upstream; **stage 8 is now the stop check, 8s the
  reviewed specification (`deliverables/SPEC-D2.md`), 9 the page**; `portfolio/demo/` stated once;
  the guard prints what it tested.
- `commands/build-recommendation.md` — the arc has `recommendation/` with `critic/`, `rulings.md`
  and `tools/`; gates `GR1`–`GR2`, rulings `GR<gate>-R<n>`; the entry guard tests
  `portfolio/demo/prototype-choice.md`; assumptions cite the frame's `A<n>`; the proxy writes the
  agenda to `recommendation/recommendation-agenda.md`; the ask states the authors' interest; the
  stage-5 verifier names two denominators, derives every count and ships its mutation list; the
  context harvest named as the worksheet's re-entry.
- `skills/derivation-orchestration` — §1 tool-existence guard, re-put rule, boundary-triggered plan
  mode; §2 gates invisible to a scan, the three entry artefacts, arc directories, registry at naming
  time, series continuation, guard re-run on resume; §3 rules 4–5 and the plain-words rule; §4 stub
  pass, two levers and the model row, flat findings, generated-artefact ratio, overlap; §5 no fourth
  marker; §6 pointer and truncation, the verification clause; §7 column-level inheritance, verbatim
  by bytes; §8 identifier grep, next-produce assertion; §9 cause split, entry gate un-timeable.
- `skills/use-case-portfolio-derivation` — the one-copy note enumerates every channel; field size on
  both paths; strictness and merge register; derived fields on the adopted path; filter partition and
  the published intersection; proposition-dependent filters; ownership dimension in Phase 3, cited by
  Phase 6; full-load costing cites upstream; adopted-path disclosure in the stop condition.
- `skills/analytical-document-build` — §2 cases from every population; §4 aggregation rule named on
  reconciled counts, two denominators, memberships in prose are derived figures; §7 truncation and
  pointing; pre-flight boxes.
- `skills/html-style` — an existing page keeps its tokens; width is `overflow-x`.
- `skills/arc-watcher` — map for the new names with the old accepted; `recommendation/` scanned;
  `fixtures/complete-run` and `scripts/make-fixture.sh`; the map test is the fixture.
- `agents/strategy-critic.md` — `Model:` and `Plugin:` rows; full-cell diff; cross-file byte
  comparison; backward grep; identifier-registry check; gate checks; mutation pass on verification
  stages.
- `agents/stakeholder-proxy.md` — `Write` tool, confined to the one agenda path; `Model:` and
  `Written to:` rows.

**Unchanged — prompts:** `skills/function-to-strategy-derivation`.

**Changed — packaging:** `templates/CLAUDE.md` (layout rows per arc, five-item close-out),
`templates/intake.md` (paste, do not retype), `adapters/release/release.sh` (requires and ships this
file), `hooks/` unchanged.

**Observations closed:** 48–76 (except 13, deferred), 83–102. Already applied before this version
and confirmed by reading: 74, 76, most of 75.

**Runs on earlier versions:** a repository produced on 0.5.0 or before renders on the 0.6.0 watcher
without change. Its D#2 rulings read `P<gate>-R<n>`, its D#3 rulings `R<gate>-R<n>` in
`portfolio/rulings.md`, its portfolio page is stage 8 and its stop check stage 9; the map accepts
each. A run resumed across the boundary carries the old names forward — do not rename identifiers
inside a run.

## 0.5.0

Released 2026-09-21 from source commit `bb73a64`. A rename and repackage: `method` on the authoring rig's own marketplace →
`s2p-strategy@s2p-strategy-builder`; licence changed to by-invitation; `html-style` bundled;
`reply-drafting` dropped; the stage-0a agent guard widened to the plugin cache path. **Every
command, skill and agent prompt-identical to 0.4.2** once the namespace is normalised (0–7 changed
lines per file, all rename or path). Closes no observations. *(Written after the fact, 2026-09-22 —
observation 93 is the reason this file exists.)*
