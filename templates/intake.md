# Intake

Fill this in **before** invoking `/build-strategy`. The command refuses to start without it, and
will not infer a field.

**How to use this file.** Replace each `[...]` bracket with your answer. Where a field lists
options, **delete the ones that do not apply and keep one** — the guard rejects any field still
holding a bracket, so an untouched option list fails the check rather than passing silently.

⚠ **Fields are addressed by name, never by number.** Earlier versions numbered them 1–8 and every
downstream reference used the number; a field inserted in the middle then changed what six other
documents meant. **Cite `Data boundary`, not "field 6".**

---

## ⛔ Two decisions are not on this form, and that is deliberate

**The single claim this work is making**, and **who the transformation is for**, are *decisions
between costed alternatives* rather than facts you hold. Posed as blank boxes they failed three
attempts in a row on the run this form comes from, while every factual field below was right by
the second pass.

**So the command takes them at Gate 0**, after reading everything below: it proposes three or four
candidate claims and both unit options, each with what it steers the derivation toward and what it
costs if it is wrong, and **you rule.** You still choose; you choose against named alternatives.

⭐ **Two tests you can run on your own sentence, if you want to arrive with one:**

1. **Check the grammatical subject.** *"AI should help us do [good things]"* has the technology as
   its subject — it describes an intent and cannot be contradicted. **A claim about where the firm
   loses time or money has the firm as its subject.**
2. **Could your sponsor answer *"no, that is not where our problem is"*?** If not, it is a heading,
   and a heading invites a nod rather than an argument.

⛔ **Who the transformation is for is irreversible.** Every stage takes its unit of analysis from
it and none can see past it, so discovering it wrong at stage 6 costs the whole chain.

---

## The eight fields

**Data boundary:** [**a permission rule, not a description.** Choose one and edit it, or write your
own in the same form — *"X and Y may; Z may never"*.
· `public record and sector material may enter; nothing supplied under NDA or held internally may`
· `public record only; no sector material, no internal material`
· `public, sector and named internal documents may; client-confidential material may never`
⚠ *"We don't have much data"* is a fact about the client and licenses nothing. This is the field
stages 2 and 5 defer to, and **a wrong answer here is not recoverable by any later gate.**]

**Client processing permission:** [**a different question with a different owner** — the boundary
above protects this repo; this asks what the *client* may lawfully feed a model. Choose one:
· `unknown` — the normal answer before the sponsor conversation. **It becomes the highest-ranked
  assumption in the pack and the first item on the stakeholder agenda**
· `unrestricted` — the function's material is the client's own, with no third-party terms over it
· `restricted: [name the constraint]` — e.g. sponsor consent required per contract
· `prohibited` — no third-party processing of the material this function handles
⛔ On the run this field comes from, it blocked five of ten recommended capabilities, **and the
entries that survived it were the ones the instrument ranked last** — the order inverted.]

**Engagement mode:** [choose one:
· `commissioned` — the sponsor is reachable throughout. The mandate is verbatim theirs, and Gate 1
  asks whether they would recognise the restatement as theirs
· `targeted` — no contact until the work is largely done. The mandate is **as inferred, with the
  evidence**, the proposition is openly your hypothesis, and Gate 1 asks whether it is defensible
  enough to put in front of them cold]

**Organisation:** [free text — the name as it should appear in the deliverable. A private company,
a subsidiary that files nothing or a partnership is in scope; **a thin public record changes what
the deliverable may claim, not whether the work can start.**]

**Function:** [free text — what is being transformed. Also used as the file slug, so keep it short:
"data-governance" → `dg-`, "clinical research" → `cr-`]

**Sponsor:** [role · `SOLE` or `SEVERAL` · what they are measured on.
⚠ **The expensive one.** Building for two sponsors and later collapsing to one forces every driver
to be re-tagged or dropped.]

**Mandate, verbatim:** [free text, and **verbatim matters** — exactly as given, untidied. **Paste
it; do not retype it** — a retyped sentence gets its capitals and its typos corrected on the way,
and every later file that quotes this one is byte-compared against it. Gate 1 asks whether the
sponsor would recognise the restatement as theirs, and that check is worthless against a mandate
already smoothed. In `targeted` mode: the mandate as inferred, with **the evidence it was inferred
from**, labelled as inferred.]

**Trigger:** [what caused this now — or the literal word `unknown`, which is a sanctioned answer
and better than a guess.]
