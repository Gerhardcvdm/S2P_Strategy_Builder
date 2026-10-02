# The confront — how each verdict is put to the person

The draft is the agent's. Nothing on the page is the person's until it has been put as a formal
question with options and answered. This file is the protocol the command follows at Gates GS1
and GS2. It presupposes the host has a question tool that takes a list of options and lets the
person type their own; in Claude Code that is `AskUserQuestion`. ⛔ **Where the host has none, the
same questions are put in the chat as numbered options, one handoff per message, and the person's
reply is recorded verbatim in the register's Answer column.** Never prose asking the person to
"confirm, correct or enrich" the draft as a whole.

## Why formal questions

On the first run the verdicts were drafted carefully and the person was invited, in prose, to
correct them. Nothing changed, and nothing could be said about that: an invitation to correct is
satisfied by silence. A formal question with options has an answer or it does not, the answer is
one of a known set, and the register records which mode it was taken in. The options are the test.

## Gate GS1 — one call per handoff, two questions in it

For each `H<n>` whose verdict is not `not yet judgeable`, in order, **one call** carrying:

**Question 1 — the verdict.** Header `H<n> verdict`. The question text carries the handoff name,
both quotations with their `path:line`, and the draft reading in one sentence:

> H2 · portfolio → prioritisation. Upstream, `portfolio/portfolio.md:61`: "…". Downstream,
> `portfolio/portfolio-ranking.md:12`: "…". Drafted *weakens*: the ranking adds a weighting term the
> portfolio never stated. Your ruling?

Four options, the draft first and marked recommended:

| Option | Description |
|---|---|
| **Confirm <draft>** | The verdict stands as drafted |
| **Enrich: <draft> stands, add to the reading** | The value is right; the reading is missing something you know. Say what in the note |
| **Correct to <other value 1>** | With that value's definition in the description |
| **Correct to <other value 2>** | With that value's definition in the description |

**Question 2 — whose decision.** Header `<downstream> judgment`:

> At the <downstream> stage, whose decision was the work? The register shows <evidence from §2>.

Three options, the draft first and marked recommended: **joint** · **the agent's, accepted as
presented** · **the person's**. Descriptions: *joint* — rulings on file name the choices this stage
made; *the agent's* — the stage's content was produced and accepted without a ruling naming it;
*the person's* — the person chose, and the record shows the choice as theirs.

**H1 carries a third question** for the upstream stage, since no handoff feeds it. The headers
differ so the two judgment questions cannot be confused.

**Recording.** Each answer is one row in `storyline/rulings.md`, mode `options`, in the order
asked. The record is updated in the same edit: the handoff's `Confronted` line; on *corrected*, the
`Verdict` line and a struck copy of the old value in the reading; on *enriched*, an `Enrichment`
line with the person's words; the stage's `Sat with` and `Ruled` cells in §2. Then commit.

**An answer typed in the Other box** is recorded verbatim as the answer. If it is not one of the
values, restate what was heard and ask again; do not pick a reading.

## The zero-changed question — after the last handoff, when it applies

If the count of `corrected` rows is zero, one more call before Gate GS1 closes. Header `Zero
changed`:

> 0 of <N> verdicts changed in the confront. Is that your ruling, or should a handoff be reopened?

| Option | Description |
|---|---|
| **0 of <N> stands as my ruling** | The count goes on the page as ruled, with this row's id |
| **Reopen one handoff** | Say which in the note; it is put again with the other two values offered first |
| **Reopen all** | Every handoff is put again, the draft value listed last |

Recorded as `GS1-R<n>`, and §6 `Ruled` carries it. ⛔ Until it does, the page does not show the
count. When the count is not zero, no question is put and §6 `Ruled` reads `by count · <date>`.

## Gate GS2 — the weakest link and its smallest repair, one call

Header `Weakest link`. The question text carries the handoff, the cause and the repair as §5
drafts them:

> The weakest link is H3 · prioritisation → choice. The cause sits in the prioritisation:
> `portfolio/portfolio-ranking.md` ranked everything and removed nothing, and handed on three orders
> that disagree. The smallest repair: a closing section in the ranking record stating what actually
> narrowed the field and why value was not a criterion. Your ruling?

| Option | Description |
|---|---|
| **Confirm the link and the repair; name it, do not make it** | §5 `Ruled` reads *confirmed, not made*. The owning artefact is untouched |
| **Confirm the link; a different repair** | Say what in the note. §5 is rewritten with your repair, the draft struck in place |
| **A different handoff is the weakest** | Say which. The drafter's §5 is struck and a new §5 drafted for it, then put again |
| **Make the repair now** | The command makes the named change in the owning artefact as a strike-and-add, never a rewrite, commits it, and §5 reads *made* with the commit |

Recorded as `GS2-R<n>`. A repair that is made is the one exception to *the review edits no artefact
it reads*, and it happens only on this row.

## Accounting, at the close of each gate

Per `derivation-orchestration` §3 rule 1 the gate report closes with an accounting computed from
the register: *N questions put, N answered, N confirmed, N enriched, N corrected, batch share 0%*.
The batch share is zero by construction and the report says so, because that is the point.
