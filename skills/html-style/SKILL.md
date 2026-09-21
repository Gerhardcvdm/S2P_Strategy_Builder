---
name: html-style
description: >
  The house HTML style for Gerhard's documents — a dark, firm-branded, self-contained
  page style with a light print mode. Use this skill whenever producing a standalone HTML
  document, report, deliverable, one-pager, dashboard or working page for this user, and
  whenever they ask for "house style", "the usual style", "our template", or ask to
  restyle an existing HTML file. Supplies the palette, type scale, component set and the
  hard rules (self-contained, no external requests, print-safe, accessible contrast).
  Do NOT use for React/Next.js components or for pages that must match a different
  brand's identity.
tier: domain
---

# House HTML style

A single-file, dark-on-screen / light-on-paper document style in the firm's colours.
Start from `template.html` in this skill folder; it is the reference implementation, not
a suggestion.

## When this applies

Use it for **standalone HTML documents** — strategy papers, reports, one-pagers,
summaries, working pages, simple dashboards. Anything the user will open in a browser or
print.

Do **not** use it for React or Next.js component work, or when the user has asked for a
different visual identity.

## Hard rules

1. **Self-contained.** One file. Inline all CSS. No CDN scripts, no external stylesheets,
   no remote images, no web fonts. The page must render identically with no network.
   Embed images as `data:` URIs if genuinely needed.
2. **Print-safe.** Every document gets the print block below. A `#000000` background
   prints as a black block and wastes an entire toner cartridge — the print stylesheet
   inverts to light. Never ship a dark page without it.
3. **Contrast floors hold.** 4.5:1 for body text, 3:1 for large text and UI edges. The
   fixed values below already satisfy this. If you introduce a new colour, check it.
4. **No fabricated brand assets.** Firm *colours* are fine — they mark the document as
   internal. An invented logo, a fake approval mark, or styling passed off as
   brand-approved is not.
5. **Semantic HTML.** Real `<h1>`–`<h3>` in order, real `<table>` with `<thead>`, real
   `<a>`. The style rides on structure; it does not replace it.
6. **Class names are global — grep before you name.** One file means one CSS namespace,
   so a new class name is a write to shared state, not a local addition. Search the file
   for the name before you use it. A bare rule setting `display`, `position` or `margin`
   on a name already in use changes layout participation *wherever that name appears* —
   and the damage surfaces far from where you introduced it, which makes it hard to
   attribute. Prefer a component prefix, and scope new rules to a parent
   (`.toolbar .actions`, never `.actions`). Nothing else catches this: a syntax check, a
   test suite and a link checker all pass a CSS collision happily.

7. **Nothing else checks the structure — so check it yourself, every time.** A
   single self-contained file has no build step, no framework, no dev server and no
   linter. It buys portability by giving up every automatic guarantee, and a
   programmatic edit to a few hundred lines can leave a container unclosed without any
   visible signal. **After any edit that is not hand-typed in place, run three
   mechanical checks:** count opening against closing tags for `div`, `p`, `table`,
   `tr`, `td` and `section` across **both the edited region and the whole file** — the
   region is where a mismatch is cheap to attribute; assert **zero external references**
   (`src="http`, `href="http`, `@import`, `url(http`), because hard rule 1 is an
   assertion nobody enforces; and where a version or date appears in more than one place
   — a header block and a footer, typically — **check them against each other**. All
   three have caught real defects: a block opened as a `div` and closed as a `</p>`,
   swallowing the rest of a section; and a footer reading *Version 0.1* under a header
   reading *0.2*. **A value recorded in two places drifts, and the drift is silent.**

8. **The prose goes through `humanizer` before the document is called done.** Load the
   `humanizer` skill and run its process in file mode over every sentence the page shows a
   reader: hero subtitle, card paragraphs, table cells, captions, legends, footers, and
   the strings a generator script writes into a page. Code, paths, data and link targets
   stay as they are. The style is dark, dense and card based, and that surface makes
   staged prose (a contrast that names nothing, a one line closer, dashes as the only
   connector, a bold label on every item) read as a slide deck. Added 2026-09-12 after
   the run-progress page shipped reading that way. **A page whose structure passes rule 7
   and whose prose fails this one is not finished.**

## The palette

```css
:root {
  /* ground */
  --bg: #000000;
  --surface: #2c2e30;
  --surface-2: #3a3b3d;
  --border: #636466;

  /* text */
  --text: #ffffff;
  --text-muted: #a7a8aa;

  /* firm accents */
  --accent-1: #86bc25;   /* firm green — rules, marks, small elements */
  --accent-2: #0d8390;   /* petrol */
  --accent-3: #007cb0;   /* blue — light backgrounds only */

  /* corrected tones (see Corrections below) */
  --accent-1-deep: #4a7c15;  /* green that carries white text: 5.0:1 */
  --link: #5ab5e0;           /* link on dark: 9.0:1 on bg, 5.8:1 on surface */

  /* highlights — decorative, never load-bearing */
  --bright-green: #0df200;
  --bright-teal: #3efac5;

  --gradient-1: linear-gradient(135deg, var(--accent-1-deep), var(--accent-2));
  --gradient-2: linear-gradient(135deg, var(--accent-3), var(--accent-1));
  --shadow-glow: 0 0 40px rgba(13, 131, 144, 0.2);
}
```

### Corrections applied to the original template

Two values in the source template failed contrast and were changed. Keep the changes.

| Issue | Original | Measured | Fix |
|---|---|---|---|
| White text on the gradient | `#86bc25` start | **2.3:1** — fails even the 3:1 large-text floor | `--accent-1-deep: #4a7c15` → **5.0:1**. Still reads as firm green. The hero no longer sits on a gradient (2026-09-12); the fix still governs `.btn-primary`, and `--accent-1-deep` is the eyebrow's print colour |
| Link colour on dark grounds | `#007cb0` | **4.49:1** on `--bg`, lower on `--surface` | `--link: #5ab5e0` → **9.0:1** / **5.8:1** |

`#86bc25` is still the accent of record — use it for rules, borders, marks, `::marker`,
small icons and text on *dark* grounds, where it is comfortably legible. Just never put
white text on top of it.

## Typography

```css
font-family: 'Aptos', 'Aptos Display', Calibri, 'Segoe UI', system-ui,
             -apple-system, sans-serif;
line-height: 1.6;
```

Aptos is the firm's face and resolves locally on Windows; the stack degrades cleanly
elsewhere. **Never link Google Fonts** — it breaks rule 1.

| Element | Size | Weight |
|---|---|---|
| `header.hero .eyebrow` | 0.8rem, uppercase, `letter-spacing: .14em`, `--accent-1` | 600 |
| `header.hero h1` | 2.6rem, `line-height: 1.12`, `max-width: 30ch` | 700 |
| `.card h2` | 1.3rem | 600 |
| `.stat .value` | 1.8rem | 700 |
| `.stat .label`, `th` | 0.85–0.9rem, uppercase, `letter-spacing: .03–.04em` | 600 |
| body | 1rem | 400 |

Container: `max-width: 960px; margin: 0 auto`. Body padding `40px 24px`.

## Components

| Class | Use |
|---|---|
| `header.hero` | One per document. No panel: an eyebrow naming the document kind, the title on the ground, a one-line subtitle in `--text-muted`, closed by a 3px `--accent-1` rule. Screen and print are the same design. Chosen 2026-09-12 over the gradient panel, which read as a slide title and was the loudest thing on every page |
| `.card` | The workhorse. `--surface` ground, 1px `--border`, `border-radius: 14px`, `padding: 28px` |
| `.grid` | `repeat(auto-fit, minmax(220px, 1fr))`, `gap: 16px`. Wraps stat tiles |
| `.stat` | Figure tile: `.value` over `.label`. Three or four per row reads best |
| `.accent-text` | Gradient-clipped emphasis span. **Sparingly** — see the caution below |
| `.btn-primary` | Gradient pill. Only when something is genuinely clickable |
| `table` | `border-collapse: collapse`, uppercase muted `th`, hairline `--border` row rules |
| `footer` | Centred, muted, 0.85rem |

### Caution on `.accent-text`

It sets `color: transparent` and paints through `background-clip: text`. Where that fails
— some print paths, some reader modes — the text becomes **invisible**, not merely
unstyled. So:

- Never use it for body copy, headings that carry meaning, or anything a reader must have.
- Emphasis only, on short spans: a figure, a term, two or three words.
- Give it a fallback colour before the clip, so a failure degrades to visible text:

```css
.accent-text {
  color: var(--accent-1);              /* fallback: visible if clip fails */
  background: var(--gradient-2);
  -webkit-background-clip: text;
  background-clip: text;
  font-weight: 700;
}
@supports (background-clip: text) or (-webkit-background-clip: text) {
  .accent-text { color: transparent; }
}
```

## The print block — required

Append to every document:

```css
@media print {
  :root {
    --bg: #ffffff;
    --surface: #ffffff;
    --surface-2: #f4f5f6;
    --border: #c9ccce;
    --text: #000000;
    --text-muted: #4a4d50;
    --link: #005f8a;
  }
  body { padding: 0; font-size: 10.5pt; }
  header.hero { padding: 0 0 16px; margin-bottom: 24px; }
  header.hero h1 { font-size: 22pt; color: #000; }
  header.hero p { color: var(--text-muted); }
  header.hero .eyebrow { color: var(--accent-1-deep); }  /* #86bc25 on white is 2.3:1 */
  .card {
    border: 1px solid var(--border);
    box-shadow: none;
    break-inside: avoid;
    page-break-inside: avoid;
  }
  .btn-primary { display: none; }
  .accent-text {
    color: var(--accent-2);
    background: none;
    -webkit-text-fill-color: currentColor;
  }
  a { color: var(--link); text-decoration: underline; }
  a[href^="http"]::after { content: " (" attr(href) ")"; font-size: 8pt; color: #4a4d50; }
  table { break-inside: auto; }
  tr { break-inside: avoid; }
  thead { display: table-header-group; }
}
```

Note what it does beyond inverting: moves the eyebrow to the deep green that holds contrast on paper, kills the glow and gradients that pixelate,
prevents cards and rows splitting across pages, repeats table headers on every page, and
expands link URLs — because a printed link is otherwise dead.

## Composition — what happens when a second skill governs the same page

**This style *permits* its components; it does not require them.** Where a quality standard,
brand brief or accessibility rule forbids one, **the prohibition wins and nothing here is
violated.**

⛔ **What this style *requires* is the small set of hard rules above** — one self-contained file,
the palette, the print block, the contrast floors, semantic structure. **Only those override a
competing standard**, because only there is the conflict real.

**Read what each rule *does*, never which skill is more senior.** Observed: a craft standard in
force alongside this style forbade three components this style ships — gradient-clipped text, a
row of statistic tiles under the hero, and cards as the page structure. Both tempting resolutions
are wrong. Treating this style as senior *because it is mandatory* reproduces every pattern the
craft standard exists to prevent; treating the craft standard as senior *because it is about
quality* overrides a brand decision that was not the agent's to make. **A permission and a
prohibition do not conflict** — the prohibition simply wins.

⚠ **The glyph case resolves the same way.** Dense warning glyphs are a convention of *internal
working artefacts*, not of this style, and nothing here requires them in a deliverable.

> **The general form, and it belongs wherever skills are authored: a skill should mark each rule
> as a requirement or a permission.** The two behave completely differently once a second skill is
> loaded. **Most rules in most style skills are permissions written in the grammar of
> requirements**, and an agent reading them under load will treat every one as binding.

## Building a document

1. Copy `template.html` from this skill folder as the starting point.
2. Set a real `<title>` — it names the browser tab and any PDF export.
3. Replace the hero's eyebrow (the document kind: *strategy paper*, *working page*, *run progress*), title and subtitle. Keep the eyebrow to two or three words.
4. Build the body from `.card` sections, one per topic.
5. Keep the palette. Do not introduce new colours without checking contrast.
6. Grep every class name you introduced against the rest of the file — see hard rule 6.
   A collision with an existing name is silent and is not caught by anything else.
7. Confirm the print block is present, then check it in the browser's print preview
   before calling the document done.
8. Run the structural checks from hard rule 7 — tag balance over the edited region and
   the whole file, zero external references, and version consistency wherever a version
   appears twice. **Run them as part of the edit, not as a review step:** the edited
   region is the only place a mismatch is cheap to attribute, and the check costs one
   command.
9. Run `humanizer` over the prose (hard rule 8), in file mode, and read the result once
   in the browser. If the page is written by a script, humanise the strings in the
   script, then regenerate.
