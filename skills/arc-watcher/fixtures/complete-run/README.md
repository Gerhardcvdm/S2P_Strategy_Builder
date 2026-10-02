# Fixture — a completed three-arc run, reduced to what the map reads

Built by `scripts/make-fixture.sh` from a real synthetic-organisation run (the `claude-plugin-test`
rig, D#1–D#3 complete on plugin 0.1.0–0.5.0, the storyline review on 0.7.0). Every file the commands wrote is here by name; each
markdown file holds its first two lines and the lines an `arc-map.tsv` regex matches; every other
file is empty. Nothing else from the run travels.

**Two files are synthesised, not reduced**, because the run's first arc ran on 0.1.0, before the
method had them: `strategy/frame-agenda.md` (stage 1p, added 0.2.0) and `strategy/rulings.md` (the
register, created at Gate 0 from 0.6.0; that run kept D#1's rulings in `handoff.md`). With them the
fixture is a complete run under the current method.

**The test:** `bash scripts/render-progress.sh --dir "$PWD/fixtures/complete-run" --summary` reports
*0 thing(s) to look at* when the tree is committed. Anything else is a finding about the map.

**Arc S, the storyline review, is in this fixture since 0.7.0**: `storyline/storyline-review.md`, `rulings.md`
(GS1-R1–R10, GS2-R1) and the page, reduced the same way. Rebuilt 2026-10-02 from the same rig after the
first run of `/review-storyline`.

⚠ **`make-fixture.sh` empties the fixture before it writes, so the two synthesised files above are deleted
by every rebuild.** Restore them with `git checkout -- fixtures/complete-run/strategy/frame-agenda.md
fixtures/complete-run/strategy/rulings.md` after each run, until the builder learns to keep them.
