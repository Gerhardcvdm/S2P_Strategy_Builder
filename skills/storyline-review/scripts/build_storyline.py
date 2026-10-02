#!/usr/bin/env python3
"""build_storyline.py — resolve the storyline stages from the arc map, check the review record, and
render storyline/storyline-review.html. Derived, never a record.

  build_storyline.py --dir RUN [--map TSV] --stages     print the stages the map yields (for the drafter)
  build_storyline.py --dir RUN [--map TSV] --check      parse and check the record; write nothing
  build_storyline.py --dir RUN [--map TSV]              check, then build the page, or refuse

Every figure on the page is computed here from the record, the map, git and the optional calendar.
There is no sentence about the data in a string literal in this file. Where a figure cannot be
computed the exhibit is omitted and the page says so. Where the record contradicts the files, or
itself, the build refuses and writes nothing. See references/page-spec.md for the refusal list and
references/record-format.md for what is parsed.

Run with python3 or the Windows launcher: PYTHONUTF8=1 py build_storyline.py --dir .
"""
import argparse
import datetime as dt
import glob
import html
import io
import os
import re
import subprocess
import sys

VERDICTS = ("holds", "weakens", "breaks")
NYJ = "not yet judgeable"
SAT = ("joint", "the agent's, accepted as presented", "the person's")
VALUE = ("enters", "quantified", "carried", "drops out", "absent", "not on file")


# ----------------------------------------------------------------------------------------------
# helpers
# ----------------------------------------------------------------------------------------------
def read(path):
    return io.open(path, encoding="utf-8").read()


def norm_path(p):
    return p.replace(os.sep, "/")


def strip_emphasis(s):
    """Remove markdown emphasis markers: every * and any _ not inside a word. Nothing else moves."""
    s = s.replace("*", "")
    s = re.sub(r"(?<!\w)_|_(?!\w)", "", s)
    return s


def git(run, *args):
    try:
        out = subprocess.run(["git", *args], cwd=run, capture_output=True, text=True, encoding="utf-8")
    except FileNotFoundError:
        return None
    if out.returncode != 0:
        return None
    return out.stdout


def md_inline(s):
    """Minimal markdown to HTML for prose cells: code, strike, bold, italic. Escaped first."""
    s = html.escape(s, quote=False)
    s = re.sub(r"~~(.+?)~~", r"<s>\1</s>", s)
    s = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", s)
    s = re.sub(r"(?<![\w*])\*(?!\s)(.+?)(?<!\s)\*(?![\w*])", r"<em>\1</em>", s)
    s = re.sub(r"`([^`]+)`", r"<code>\1</code>", s)
    return s


def esc(s):
    return html.escape(str(s), quote=True)


# ----------------------------------------------------------------------------------------------
# the map
# ----------------------------------------------------------------------------------------------
class Stage:
    def __init__(self, name):
        self.name = name
        self.rows = []          # (arc, id)
        self.items = []         # (glob_or_file, exclude_regex)
        self.files = []         # resolved, sorted, run-relative, forward slashes
        self.first = None       # (sha, date)
        self.last = None

    @property
    def on_file(self):
        return bool(self.files)

    def rows_label(self):
        out = []
        arc = None
        for a, i in self.rows:
            if a != arc:
                out.append([a, i, i])
                arc = a
            else:
                out[-1][2] = i
        return " · ".join(f"{a} {lo}" if lo == hi else f"{a} {lo}–{hi}" for a, lo, hi in out)

    def lives_in(self):
        dirs = set()
        for f in self.files:
            dirs.add(f.split("/")[0] + "/" if "/" in f else f)
        if not dirs:   # nothing on file: name the directories the targets would be in, skipping glob heads
            for it, _ in self.items:
                it = it.split("::", 1)[0]
                parts = [q for q in it.split("/") if not any(ch in q for ch in "*?[")]
                if not parts:
                    continue
                dirs.add(parts[0] + "/" if "/" in it and parts[0] != it else parts[0])
        return " · ".join(f"`{d}`" for d in sorted(dirs))


def load_map(path):
    text = read(path)
    col = None
    stages = []
    by_name = {}
    current = None
    for line in text.split("\n"):
        if line.startswith("# arc\t"):
            heads = line[2:].split("\t")
            if "storyline" in heads:
                col = heads.index("storyline")
            continue
        if not line.strip() or line.startswith("#"):
            continue
        if col is None:
            return None, "the map's column header names no storyline column"
        f = line.split("\t")
        val = f[col].strip() if len(f) > col else ""
        if val == "-":
            continue
        if val:
            if val not in by_name:
                by_name[val] = Stage(val)
                stages.append(by_name[val])
            current = by_name[val]
        if current is None:
            continue
        current.rows.append((f[0], f[1]))
        targets, exclude = f[4], (f[5] if len(f) > 5 else "-")
        if targets == "-" or f[2] == "check":
            continue   # a check row's targets are the guards' inputs (intake.md), not the stage's artefacts
        for it in targets.split("|"):
            it = it[1:] if it.startswith("?") else it
            current.items.append((it, exclude))   # a file::regex item is kept whole: the file counts only when the regex matches
    if col is None:
        return None, "the map has no storyline column"
    return stages, None


def resolve_files(run, stages):
    for st in stages:
        found = set()
        for it, exclude in st.items:
            if "::" in it:
                # the ruling record: as the renderer does, the file belongs to the stage only when a line matches
                f, rx = it.split("::", 1)
                p = os.path.join(run, f)
                if os.path.isfile(p) and any(re.search(rx, line) for line in read(p).split("\n")):
                    found.add(norm_path(f))
                continue
            if any(ch in it for ch in "*?["):
                hits = glob.glob(os.path.join(run, it), recursive=True)
            else:
                p = os.path.join(run, it)
                hits = [p] if os.path.isfile(p) else []
            for h in hits:
                if not os.path.isfile(h):
                    continue
                rel = norm_path(os.path.relpath(h, run))
                if rel.endswith("/README.md"):
                    continue
                if exclude != "-" and re.search(exclude, rel):
                    continue
                found.add(rel)
        st.files = sorted(found)
        if st.files:
            first = git(run, "log", "--reverse", "--format=%h\t%as", "--", *st.files)
            last = git(run, "log", "-1", "--format=%h\t%as", "--", *st.files)
            st.first = tuple(first.strip().split("\n")[0].split("\t")) if first and first.strip() else None
            st.last = tuple(last.strip().split("\t")) if last and last.strip() else None


def stages_table(stages):
    rows = ["| # | Stage | Map rows | Lives in | On file | First commit | Last commit |",
            "|---|---|---|---|---|---|---|"]
    for n, st in enumerate(stages, 1):
        onf = f"{len(st.files)} files" if st.on_file else "none"
        fc = f"`{st.first[0]}` {st.first[1]}" if st.first else "—"
        lc = f"`{st.last[0]}` {st.last[1]}" if st.last else "—"
        rows.append(f"| {n} | {st.name} | {st.rows_label()} | {st.lives_in()} | {onf} | {fc} | {lc} |")
    return "\n".join(rows)


# ----------------------------------------------------------------------------------------------
# the record
# ----------------------------------------------------------------------------------------------
KEY_RE = re.compile(r"^\*\*([A-Za-z][A-Za-z ]*?):\*\*\s*(.*)$")


def parse_table(block):
    rows = []
    heads = None
    for line in block.split("\n"):
        if not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if heads is None:
            heads = cells
            continue
        if all(re.fullmatch(r":?-+:?", c) for c in cells):
            continue
        rows.append(dict(zip(heads, cells)))
    return rows


def parse_keys(block):
    """**Key:** value lines; a value runs on until the next key line or a blockquote. Blockquotes
    after Upstream/Downstream are collected as the quotation."""
    out = {}
    key = None
    for line in block.split("\n"):
        m = KEY_RE.match(line)
        if m:
            key = m.group(1)
            out[key] = m.group(2).strip()
            continue
        if line.startswith(">"):
            if key in ("Upstream", "Downstream"):
                q = line[1:].strip()
                out.setdefault(key + " quotation", []).append(q)
            continue
        if key and line.strip() and not line.startswith("#"):
            out[key] = (out[key] + "\n" + line.rstrip()).strip()
    return out


def parse_record(text):
    rec = {"header": {}, "stages": [], "judgment": [], "handoffs": [], "value": [], "weakest": {}, "confront": {}}
    parts = re.split(r"^## (\d) · ", text, flags=re.M)
    head = parts[0]
    for line in head.split("\n"):
        m = re.match(r"^\|\s*\*\*(.+?)\*\*\s*\|\s*(.*?)\s*\|\s*$", line)
        if m:
            rec["header"][m.group(1)] = m.group(2)
    m = re.match(r"^# Storyline review — (.+?) · (.+)$", head, flags=re.M)
    rec["title"] = (m.group(1), m.group(2)) if m else None
    secs = {}
    for i in range(1, len(parts), 2):
        secs[parts[i]] = parts[i + 1]
    rec["stages"] = parse_table(secs.get("1", ""))
    rec["judgment"] = parse_table(secs.get("2", ""))
    hs = re.split(r"^### H(\d+) · (.+?) → (.+?)\s*$", secs.get("3", ""), flags=re.M)
    for i in range(1, len(hs), 4):
        d = parse_keys(hs[i + 3])
        d["n"] = int(hs[i])
        d["up"] = hs[i + 1].strip()
        d["down"] = hs[i + 2].strip()
        rec["handoffs"].append(d)
    rec["value"] = parse_table(secs.get("4", ""))
    rec["weakest"] = parse_keys(secs.get("5", ""))
    rec["confront"] = parse_keys(secs.get("6", ""))
    return rec


# ----------------------------------------------------------------------------------------------
# the checks
# ----------------------------------------------------------------------------------------------
def find_quotation(run, path, quote):
    """Return (line_no, exact) or (None, None). exact is True when the raw line holds the raw quote."""
    full = os.path.join(run, path)
    if not os.path.isfile(full):
        return None, None
    q = strip_emphasis(quote).strip()
    if not q:
        return None, None
    for n, line in enumerate(read(full).split("\n"), 1):
        if q in strip_emphasis(line):
            return n, (quote in line)
    return None, None


def check(run, stages, rec):
    fails, notes = [], []
    by_name = {s.name: s for s in stages}
    on_file = [s for s in stages if s.on_file]
    if len(on_file) < 2:
        fails.append(f"only {len(on_file)} storyline stage(s) on file; two are needed: "
                     + ", ".join(f"{s.name} ({'on file' if s.on_file else 'none'})" for s in stages))
    status = rec["header"].get("Status", "")
    if status.startswith("draft · running"):
        fails.append("the record's Status is still `draft · running`: the drafter never finished it")
    if not rec["title"]:
        fails.append("the record has no `# Storyline review — Organisation · Function` title line")

    # §1: one row per stage, in order
    names = [r.get("Stage") for r in rec["stages"]]
    if names != [s.name for s in stages]:
        fails.append(f"§1 lists stages {names}; the map yields {[s.name for s in stages]}")
    for r in rec["stages"]:
        st = by_name.get(r.get("Stage"))
        if st and (r.get("On file", "") == "none") == st.on_file:
            notes.append(f"§1 {st.name}: the record says `{r.get('On file')}`, the files say "
                         f"{len(st.files)} on file; the page shows the files")
        if st and st.last and r.get("Last commit") and st.last[0] not in r.get("Last commit"):
            notes.append(f"§1 {st.name}: last commit is now `{st.last[0]}` {st.last[1]} (record: {r.get('Last commit')})")

    # §2
    jnames = [r.get("Stage") for r in rec["judgment"]]
    if jnames != [s.name for s in stages]:
        fails.append(f"§2 has rows for {jnames}; one row per stage is required, in map order")
    for r in rec["judgment"]:
        st = by_name.get(r.get("Stage"))
        sat = re.sub(r"\s*\(was .*\)$", "", r.get("Sat with", "")).strip()
        if st is None:
            continue
        if st.on_file and sat not in SAT:
            fails.append(f"§2 {st.name}: `Sat with` is `{r.get('Sat with')}`; it must be one of {SAT}")
        if not st.on_file and sat != "not on file":
            fails.append(f"§2 {st.name}: the stage has no artefact, so `Sat with` must read `not on file`")
        if st.on_file and sat == "not on file":
            fails.append(f"§2 {st.name}: the stage is on file ({len(st.files)} files) but `Sat with` reads `not on file`")

    # §3: the handoffs the map yields
    expected = [(n, stages[n - 1].name, stages[n].name) for n in range(1, len(stages))]
    got = [(h["n"], h["up"], h["down"]) for h in rec["handoffs"]]
    if got != expected:
        fails.append(f"§3 handoffs are {got}; the map yields {expected}")
    for h in rec["handoffs"]:
        tag = f"H{h['n']} {h['up']} → {h['down']}"
        up, down = by_name.get(h["up"]), by_name.get(h["down"])
        v = h.get("Verdict", "").strip()
        h["verdict"] = v
        if not v:
            fails.append(f"{tag}: empty verdict")
            continue
        if v not in VERDICTS + (NYJ,):
            fails.append(f"{tag}: verdict `{v}` is not one of {VERDICTS + (NYJ,)}")
            continue
        judgeable = bool(up and down and up.on_file and down.on_file)
        if judgeable and v == NYJ:
            fails.append(f"{tag}: both stages are on file, so a verdict is required, not `{NYJ}`")
        if not judgeable and v != NYJ:
            missing = [s.name for s in (up, down) if s and not s.on_file]
            fails.append(f"{tag}: {missing} not on file, so the record may not carry a verdict (`{v}`)")
        if v == NYJ:
            if not h.get("Why"):
                fails.append(f"{tag}: `{NYJ}` needs a `**Why:**` line")
            continue
        for side, st in (("Upstream", up), ("Downstream", down)):
            ref = h.get(side, "")
            m = re.match(r"^`([^`:]+)(?::(\d+))?`\s*$", ref)
            if not m:
                fails.append(f"{tag}: `{side}` must be `path:line` in backticks, got `{ref}`")
                continue
            path, line_said = m.group(1), m.group(2)
            qs = h.get(side + " quotation", [])
            if len(qs) != 1:
                fails.append(f"{tag}: {side.lower()} quotation must be exactly one blockquote line, found {len(qs)}")
                continue
            if st and path not in st.files:
                fails.append(f"{tag}: {side.lower()} file `{path}` is not one the {st.name} stage claims")
            n, exact = find_quotation(run, path, qs[0])
            if n is None:
                fails.append(f"{tag}: {side.lower()} quotation not found in `{path}` after emphasis is stripped:\n      > {qs[0]}")
            else:
                h[side + " found"] = (path, n, exact)
                if line_said and int(line_said) != n:
                    notes.append(f"{tag}: {side.lower()} quotation is at `{path}:{n}` now (record says :{line_said})")
        if not h.get("Reading"):
            fails.append(f"{tag}: no `**Reading:**`")
        c = h.get("Confronted", "not yet")
        if not (c == "not yet" or re.match(r"^GS1-R\d+ · (confirmed|enriched|corrected from (holds|weakens|breaks)) · \d{4}-\d{2}-\d{2}$", c)):
            fails.append(f"{tag}: `Confronted` reads `{c}`; see record-format.md")

    # §4
    vnames = [r.get("Stage") for r in rec["value"]]
    if vnames != [s.name for s in stages]:
        fails.append(f"§4 has rows for {vnames}; one row per stage is required, in map order")
    for r in rec["value"]:
        if r.get("Value") not in VALUE:
            fails.append(f"§4 {r.get('Stage')}: `Value` is `{r.get('Value')}`; it must be one of {VALUE}")

    # §5
    w = rec["weakest"]
    hid = w.get("Handoff", "")
    hmap = {f"H{h['n']}": h for h in rec["handoffs"]}
    if hid not in hmap:
        fails.append(f"§5 names handoff `{hid}`, which §3 does not have")
    elif hmap[hid].get("verdict") == NYJ:
        fails.append(f"§5 names {hid}, which is not yet judgeable")
    if not w.get("Cause in"):
        fails.append("§5 has no `**Cause in:**`")
    if not w.get("Smallest repair"):
        fails.append("§5 has no `**Smallest repair:**`")
    wr = w.get("Ruled", "not yet")
    if not (wr == "not yet" or re.match(r"^GS2-R\d+ · (confirmed, not made|made|repair changed|link changed to H\d+) · \d{4}-\d{2}-\d{2}", wr)):
        fails.append(f"§5 `Ruled` reads `{wr}`; see record-format.md")

    # §6 against §3
    judged = sum(1 for h in rec["handoffs"] if h.get("verdict") in VERDICTS)
    changed = sum(1 for h in rec["handoffs"] if "corrected" in h.get("Confronted", ""))
    confronted = sum(1 for h in rec["handoffs"] if h.get("Confronted", "not yet") != "not yet")
    c6 = rec["confront"]
    for key, val in (("Handoffs judged", judged), ("Changed", changed)):
        said = c6.get(key, "")
        if not said.isdigit():
            fails.append(f"§6 `{key}` is `{said}`; a count is required")
        elif int(said) != val:
            fails.append(f"§6 says {key} = {said}; §3 yields {val}")
    cr = c6.get("Ruled", "not yet")
    if not (cr == "not yet" or re.match(r"^(GS1-R\d+ · the count stands|by count) · \d{4}-\d{2}-\d{2}$", cr)):
        fails.append(f"§6 `Ruled` reads `{cr}`; see record-format.md")
    if changed > 0 and cr.startswith("GS1-R"):
        fails.append("§6 carries a zero-changed ruling but §3 has corrected verdicts; the question did not apply")

    rec["derived"] = {"judged": judged, "changed": changed, "confronted": confronted,
                      "confirmed": sum(1 for h in rec["handoffs"] if "confirmed" in h.get("Confronted", "")),
                      "enriched": sum(1 for h in rec["handoffs"] if "enriched" in h.get("Confronted", "")),
                      "quotations": sum(1 for h in rec["handoffs"] for s in ("Upstream", "Downstream") if h.get(s + " found")),
                      "on_file": len(on_file), "stages": len(stages), "possible": len(stages) - 1}
    return fails, notes


# ----------------------------------------------------------------------------------------------
# the calendar
# ----------------------------------------------------------------------------------------------
def load_calendar(path):
    if not path or not os.path.isfile(path):
        return None
    events = []
    for line in read(path).split("\n"):
        if not line.strip() or line.startswith("#"):
            continue
        f = line.split("\t")
        if len(f) < 2:
            continue
        try:
            d = dt.date.fromisoformat(f[0].strip())
        except ValueError:
            continue
        events.append((d, f[1].strip(), f[2].strip() if len(f) > 2 else "other"))
    return events


# ----------------------------------------------------------------------------------------------
# the page
# ----------------------------------------------------------------------------------------------
CSS = """
  :root {
    --bg: #000000; --surface: #2c2e30; --surface-2: #3a3b3d; --border: #636466;
    --text: #ffffff; --text-muted: #a7a8aa;
    --accent-1: #86bc25; --accent-2: #0d8390; --accent-3: #007cb0;
    --accent-1-deep: #4a7c15; --link: #5ab5e0;
    --sl-holds: #86bc25; --sl-weakens: #e8b84a; --sl-breaks: #ef6b6b; --sl-nyj: #a7a8aa;
    --sl-joint: #3efac5; --sl-agent: #e8b84a; --sl-person: #86bc25;
  }
  * { box-sizing: border-box; }
  body { margin: 0; padding: 40px 24px; background: var(--bg); color: var(--text);
    font-family: 'Aptos', 'Aptos Display', Calibri, 'Segoe UI', system-ui, -apple-system, sans-serif; line-height: 1.6; }
  .container { max-width: 1040px; margin: 0 auto; }
  header.hero { padding: 8px 0 24px; border-bottom: 3px solid var(--accent-1); margin-bottom: 32px; }
  header.hero .eyebrow { margin: 0 0 10px; font-size: .8rem; font-weight: 600; letter-spacing: .14em; text-transform: uppercase; color: var(--accent-1); }
  header.hero h1 { margin: 0 0 10px; max-width: 34ch; font-size: 2.4rem; font-weight: 700; line-height: 1.12; letter-spacing: -.01em; }
  header.hero p { margin: 0; color: var(--text-muted); font-size: 1.05rem; }
  .card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 28px; margin-bottom: 20px; }
  .card h2 { margin-top: 0; font-size: 1.3rem; font-weight: 600; }
  .card h3 { font-size: 1.05rem; font-weight: 600; margin: 0 0 8px; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; }
  .stat { background: var(--surface-2); border-radius: 12px; padding: 18px; border: 1px solid var(--border); }
  .stat .value { font-size: 1.7rem; font-weight: 700; }
  .stat .label { color: var(--text-muted); font-size: .85rem; text-transform: uppercase; letter-spacing: .04em; }
  .table-wrap { overflow-x: auto; }
  table { width: 100%; border-collapse: collapse; }
  th, td { text-align: left; padding: 10px 14px; border-bottom: 1px solid var(--border); vertical-align: top; }
  th { color: var(--text-muted); font-weight: 600; font-size: .85rem; text-transform: uppercase; letter-spacing: .03em; }
  code { font-family: Consolas, 'Cascadia Mono', Menlo, monospace; font-size: .9em; color: var(--sl-joint); }
  a { color: var(--link); }
  blockquote { margin: 8px 0; padding: 10px 16px; border-left: 3px solid var(--border); background: var(--surface-2); border-radius: 0 8px 8px 0; }
  blockquote p { margin: 0; }
  .muted { color: var(--text-muted); }
  footer { text-align: center; color: var(--text-muted); font-size: .85rem; margin-top: 40px; }

  .sl-strip { display: flex; flex-wrap: nowrap; overflow-x: auto; align-items: stretch; gap: 0; margin: 12px 0 4px; padding-bottom: 6px; }
  .sl-stage { flex: 1 1 140px; min-width: 140px; border: 1px solid var(--border); border-radius: 10px; padding: 12px 14px; background: var(--surface-2); }
  .sl-stage.sl-off { border-style: dashed; color: var(--text-muted); background: transparent; }
  .sl-stage .sl-name { font-weight: 600; }
  .sl-stage .sl-dates { font-size: .8rem; color: var(--text-muted); }
  .sl-join { flex: 0 0 96px; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 0 4px; }
  .sl-join .sl-line { width: 100%; height: 2px; background: var(--border); position: relative; }
  .sl-join .sl-line::after { content: ""; position: absolute; right: -1px; top: -4px; border: 5px solid transparent; border-left-color: var(--border); }
  .sl-badge { display: inline-block; font-size: .75rem; font-weight: 700; letter-spacing: .04em; text-transform: uppercase; padding: 2px 10px; border-radius: 999px; border: 1px solid currentColor; }
  .sl-holds { color: var(--sl-holds); }
  .sl-weakens { color: var(--sl-weakens); }
  .sl-breaks { color: var(--sl-breaks); }
  .sl-nyj { color: var(--sl-nyj); border-style: dashed; }
  .sl-join .sl-badge { margin-top: 6px; background: var(--surface); }
  .sl-join .sl-h { font-size: .75rem; color: var(--text-muted); margin-bottom: 4px; }

  .sl-sat { display: grid; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr)); gap: 12px; margin-top: 12px; }
  .sl-cell { border: 1px solid var(--border); border-top-width: 5px; border-radius: 10px; padding: 12px 14px; background: var(--surface-2); }
  .sl-cell.sl-joint { border-top-color: var(--sl-joint); }
  .sl-cell.sl-agent { border-top-color: var(--sl-agent); }
  .sl-cell.sl-person { border-top-color: var(--sl-person); }
  .sl-cell.sl-off { border-style: dashed; background: transparent; color: var(--text-muted); }
  .sl-cell .sl-who { font-weight: 600; }
  .sl-cell .sl-ev { font-size: .85rem; color: var(--text-muted); margin-top: 6px; }
  .sl-cell s { color: var(--text-muted); }

  .sl-card .sl-head { display: flex; justify-content: space-between; align-items: baseline; gap: 12px; flex-wrap: wrap; }
  .sl-ref { font-size: .85rem; color: var(--text-muted); }
  .sl-check { font-size: .8rem; color: var(--text-muted); }
  .sl-row { display: grid; grid-template-columns: 11em 1fr; gap: 6px 14px; margin-top: 10px; }
  .sl-row .sl-k { color: var(--text-muted); font-size: .85rem; text-transform: uppercase; letter-spacing: .03em; }
  .sl-tl { width: 100%; height: auto; display: block; }
  .sl-tl text { font-family: inherit; fill: var(--text-muted); font-size: 11px; }
  .sl-tl .sl-tl-bar { fill: var(--accent-2); }
  .sl-tl .sl-tl-ev { stroke: var(--sl-agent); }
  .sl-tl .sl-tl-ev-t { fill: var(--sl-agent); }
  .sl-tl .sl-tl-axis { stroke: var(--border); }

  @media print {
    :root { --bg: #fff; --surface: #fff; --surface-2: #f4f5f6; --border: #c9ccce; --text: #000; --text-muted: #4a4d50; --link: #005f8a;
      --sl-holds: #4a7c15; --sl-weakens: #8a6400; --sl-breaks: #a03030; --sl-nyj: #4a4d50; --sl-joint: #0a6a74; --sl-agent: #8a6400; --sl-person: #4a7c15; }
    body { padding: 0; font-size: 10.5pt; }
    header.hero h1 { font-size: 22pt; color: #000; }
    header.hero .eyebrow { color: var(--accent-1-deep); }
    .card { break-inside: avoid; page-break-inside: avoid; box-shadow: none; }
    code { color: #0a6a74; }
    a { color: var(--link); text-decoration: underline; }
    table { break-inside: auto; } tr { break-inside: avoid; } thead { display: table-header-group; }
  }
"""


def badge(v):
    cls = {"holds": "sl-holds", "weakens": "sl-weakens", "breaks": "sl-breaks"}.get(v, "sl-nyj")
    return f'<span class="sl-badge {cls}">{esc(v)}</span>'


def sat_class(sat):
    s = re.sub(r"\s*\(was .*\)$", "", sat).strip()
    return {"joint": "sl-joint", "the agent's, accepted as presented": "sl-agent", "the person's": "sl-person"}.get(s, "sl-off")


def timeline_svg(stages, events):
    dates = [dt.date.fromisoformat(s.first[1]) for s in stages if s.first] + \
            [dt.date.fromisoformat(s.last[1]) for s in stages if s.last] + [e[0] for e in events]
    if not dates:
        return None
    lo, hi = min(dates), max(dates)
    span = max((hi - lo).days, 1)
    W, left, right = 1000, 150, 30
    row_h, top = 28, 30
    rows = [s for s in stages if s.first]
    H = top + row_h * len(rows) + 70
    inner = W - left - right

    def x(d):
        return left + inner * (d - lo).days / span

    out = [f'<svg class="sl-tl" viewBox="0 0 {W} {H}" xmlns="http://www.w3.org/2000/svg" role="img" '
           f'aria-label="commit spans per stage with calendar events">']
    for i, st in enumerate(rows):
        y = top + i * row_h
        a, b = dt.date.fromisoformat(st.first[1]), dt.date.fromisoformat(st.last[1])
        w = max(x(b) - x(a), 3)
        out.append(f'<text x="{left - 10}" y="{y + 14}" text-anchor="end">{esc(st.name)}</text>')
        out.append(f'<rect class="sl-tl-bar" x="{x(a):.1f}" y="{y + 4}" width="{w:.1f}" height="14" rx="3"/>')
    ay = top + row_h * len(rows) + 8
    out.append(f'<line class="sl-tl-axis" x1="{left}" y1="{ay}" x2="{W - right}" y2="{ay}"/>')
    out.append(f'<text x="{left}" y="{ay + 16}">{lo.isoformat()}</text>')
    out.append(f'<text x="{W - right}" y="{ay + 16}" text-anchor="end">{hi.isoformat()}</text>')
    for n, (d, label, kind) in enumerate(sorted(events)):
        xx = x(d)
        out.append(f'<line class="sl-tl-ev" x1="{xx:.1f}" y1="{top - 8}" x2="{xx:.1f}" y2="{ay}" stroke-dasharray="3 3"/>')
        ty = ay + 32 + (n % 2) * 14
        out.append(f'<text class="sl-tl-ev-t" x="{xx:.1f}" y="{ty}" text-anchor="middle">{esc(label)} · {d.isoformat()}</text>')
    out.append("</svg>")
    return "\n".join(out)


def render(run, stages, rec, notes, events, record_path, map_path):
    d = rec["derived"]
    today = dt.date.today().isoformat()
    sha = (git(run, "rev-parse", "--short", "HEAD") or "").strip() or "no commit"
    org, fn = rec["title"]
    by_name = {s.name: s for s in stages}
    H = []
    H.append(f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Storyline review — {esc(org)} · {esc(fn)}</title>
<style>{CSS}</style>
</head>
<body>
<div class="container">
<header class="hero">
  <p class="eyebrow">Storyline review</p>
  <h1>{esc(org)} · {esc(fn)}</h1>
  <p>{d['stages']} stages on the map, {d['on_file']} on file · {d['judged']} of {d['possible']} handoffs judged · built {today} from <code>{esc(norm_path(record_path))}</code> at <code>{esc(sha)}</code></p>
</header>""")

    # figures
    changed_cell = (f"{d['changed']}" if (rec["confront"].get("Ruled", "not yet") != "not yet") else "not yet ruled")
    H.append(f"""<div class="card">
  <h2>Figures</h2>
  <div class="grid">
    <div class="stat"><div class="value">{d['on_file']} / {d['stages']}</div><div class="label">stages on file</div></div>
    <div class="stat"><div class="value">{d['judged']} / {d['possible']}</div><div class="label">handoffs judged</div></div>
    <div class="stat"><div class="value">{d['quotations']}</div><div class="label">quotations checked, all found</div></div>
    <div class="stat"><div class="value">{d['confronted']} / {d['judged']}</div><div class="label">verdicts confronted</div></div>
    <div class="stat"><div class="value">{d['confirmed']} · {d['enriched']} · {d['changed']}</div><div class="label">confirmed · enriched · corrected</div></div>
    <div class="stat"><div class="value">{esc(changed_cell)}</div><div class="label">changed, as ruled</div></div>
  </div>
</div>""")

    # strip
    hs = {h["n"]: h for h in rec["handoffs"]}
    strip = ['<div class="sl-strip">']
    for i, st in enumerate(stages, 1):
        cls = "sl-stage" + ("" if st.on_file else " sl-off")
        dates = f"{st.first[1]} → {st.last[1]}" if st.first and st.last else "not on file"
        strip.append(f'<div class="{cls}"><div class="sl-name">{i} · {esc(st.name)}</div><div class="sl-dates">{esc(dates)}</div></div>')
        if i < len(stages):
            h = hs.get(i)
            v = h.get("verdict", NYJ) if h else NYJ
            strip.append(f'<div class="sl-join"><div class="sl-h">H{i}</div><div class="sl-line"></div>{badge(v)}</div>')
    strip.append("</div>")
    H.append(f"""<div class="card">
  <h2>The stage strip</h2>
  {''.join(strip)}
</div>""")

    # judgment
    cells = []
    for r in rec["judgment"]:
        st = by_name.get(r.get("Stage"))
        sat = r.get("Sat with", "")
        m = re.match(r"^(.*?)\s*\(was (.*)\)$", sat)
        who = f"{esc(m.group(1))} <s>{esc(m.group(2))}</s>" if m else esc(sat)
        cells.append(f'<div class="sl-cell {sat_class(sat)}"><div class="sl-who">{esc(r.get("Stage",""))}</div>'
                     f'<div>{who}</div><div class="sl-ev">{md_inline(r.get("Evidence",""))}</div>'
                     f'<div class="sl-ev">{md_inline(r.get("Ruled","not yet"))}</div></div>')
    H.append(f"""<div class="card">
  <h2>Where the judgment sat</h2>
  <div class="sl-sat">{''.join(cells)}</div>
</div>""")

    # handoffs
    H.append('<div class="card"><h2>The handoffs</h2>')
    for h in rec["handoffs"]:
        v = h.get("verdict", "")
        H.append(f'<div class="sl-card"><div class="sl-head"><h3>H{h["n"]} · {esc(h["up"])} → {esc(h["down"])}</h3>{badge(v)}</div>')
        if v == NYJ:
            H.append(f'<p class="muted">{md_inline(h.get("Why",""))}</p></div>')
            continue
        for side in ("Upstream", "Downstream"):
            path, n, exact = h[side + " found"]
            q = h[side + " quotation"][0]
            how = "found as written" if exact else "found after emphasis stripped"
            H.append(f'<div class="sl-ref">{side} · <code>{esc(path)}:{n}</code> · <span class="sl-check">{how}, {today}</span></div>'
                     f'<blockquote><p>{esc(q)}</p></blockquote>')
        rows = [("Reading", h.get("Reading", ""))]
        if h.get("Enrichment"):
            rows.append(("Enrichment", h["Enrichment"]))
        rows.append(("Confronted", h.get("Confronted", "not yet")))
        rows.append(("Drafter's check", h.get("Check", "")))
        H.append('<div class="sl-row">' + "".join(f'<div class="sl-k">{esc(k)}</div><div>{md_inline(val)}</div>' for k, val in rows) + "</div></div>")
    H.append("</div>")

    # value
    vrows = "".join(f'<tr><td>{esc(r.get("Stage",""))}</td><td>{esc(r.get("Value",""))}</td><td>{md_inline(r.get("Where",""))}</td></tr>' for r in rec["value"])
    H.append(f"""<div class="card">
  <h2>Value, followed through</h2>
  <div class="table-wrap"><table><thead><tr><th>Stage</th><th>Value</th><th>Where</th></tr></thead><tbody>{vrows}</tbody></table></div>
</div>""")

    # weakest
    w = rec["weakest"]
    wrows = "".join(f'<div class="sl-k">{esc(k)}</div><div>{md_inline(w.get(k, ""))}</div>' for k in ("Handoff", "Cause in", "Smallest repair", "Ruled"))
    H.append(f"""<div class="card">
  <h2>The weakest link and its smallest repair</h2>
  <div class="sl-row">{wrows}</div>
</div>""")

    # timeline
    if events is None:
        H.append('<div class="card"><h2>The commit timeline</h2><p class="muted">Omitted: no <code>storyline/calendar.tsv</code> was given, and the exhibit is not drawn without one.</p></div>')
    else:
        svg = timeline_svg(stages, events)
        H.append(f'<div class="card"><h2>The commit timeline</h2><p class="muted">{len([s for s in stages if s.first])} stage spans from git, {len(events)} calendar events.</p>{svg or ""}</div>')

    # stage table
    trows = []
    for n, st in enumerate(stages, 1):
        trows.append(f'<tr><td>{n}</td><td>{esc(st.name)}</td><td>{esc(st.rows_label())}</td><td>{md_inline(st.lives_in())}</td>'
                     f'<td>{len(st.files) if st.on_file else "none"}</td>'
                     f'<td>{(esc(st.first[0]) + " " + esc(st.first[1])) if st.first else "—"}</td>'
                     f'<td>{(esc(st.last[0]) + " " + esc(st.last[1])) if st.last else "—"}</td></tr>')
    nl = "".join(f"<li>{esc(n)}</li>" for n in notes)
    H.append(f"""<div class="card">
  <h2>The stages, as git reports them</h2>
  <div class="table-wrap"><table><thead><tr><th>#</th><th>Stage</th><th>Map rows</th><th>Lives in</th><th>Files</th><th>First commit</th><th>Last commit</th></tr></thead><tbody>{''.join(trows)}</tbody></table></div>
  {('<ul class="muted">' + nl + '</ul>') if nl else ''}
</div>""")

    H.append(f"""<footer>Derived by build_storyline.py on {today} from <code>{esc(norm_path(record_path))}</code> and <code>{esc(norm_path(map_path))}</code> at <code>{esc(sha)}</code>. Not a record.</footer>
</div>
</body>
</html>
""")
    return "\n".join(H), today


def rule7(page, today):
    fails = []
    for t in ["div", "p", "table", "thead", "tbody", "tr", "td", "th", "blockquote", "ul", "li", "header", "footer", "svg", "span", "h1", "h2", "h3"]:
        o = len(re.findall(r"<%s[ >]" % t, page))
        c = len(re.findall(r"</%s>" % t, page))
        if o != c:
            fails.append(f"tag balance: <{t}> {o} opened, {c} closed")
    ext = len(re.findall(r'src="http|href="http|@import|url\(http', page))
    if ext:
        fails.append(f"{ext} external reference(s)")
    if page.count(today) < 2:
        fails.append("the build date does not appear in both header and footer")
    return fails


# ----------------------------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dir", default=".", help="the run directory")
    ap.add_argument("--map", help="arc-map.tsv; default .claude/arc-map.tsv in the run, else arc-watcher's")
    ap.add_argument("--record", help="default storyline/storyline-review.md")
    ap.add_argument("--out", help="default storyline/storyline-review.html")
    ap.add_argument("--calendar", help="default storyline/calendar.tsv, optional")
    ap.add_argument("--stages", action="store_true", help="print the stages the map yields and stop")
    ap.add_argument("--check", action="store_true", help="check the record and stop; write nothing")
    a = ap.parse_args()

    run = os.path.abspath(a.dir)
    here = os.path.dirname(os.path.abspath(__file__))
    map_path = a.map or (os.path.join(run, ".claude", "arc-map.tsv") if os.path.isfile(os.path.join(run, ".claude", "arc-map.tsv"))
                         else os.path.join(here, "..", "..", "arc-watcher", "arc-map.tsv"))
    map_path = os.path.normpath(map_path)
    record_path = a.record or os.path.join(run, "storyline", "storyline-review.md")
    out_path = a.out or os.path.join(run, "storyline", "storyline-review.html")
    cal_path = a.calendar or os.path.join(run, "storyline", "calendar.tsv")

    fails = []
    if not os.path.isfile(map_path):
        fails.append(f"no map at {map_path}")
    if git(run, "rev-parse", "--is-inside-work-tree") is None:
        fails.append(f"{run} is not a git repository; the stage table reads git")
    if fails:
        print("REFUSED\n  " + "\n  ".join(fails)); sys.exit(2)

    stages, err = load_map(map_path)
    if err:
        print(f"REFUSED\n  {err}: {map_path}"); sys.exit(2)
    resolve_files(run, stages)

    if a.stages:
        print(f"map: {norm_path(map_path)}")
        print(f"{len(stages)} storyline stages, {sum(1 for s in stages if s.on_file)} on file\n")
        print(stages_table(stages))
        for st in stages:
            print(f"\n{st.name}: {len(st.files)} file(s)" + ("" if st.files else " — not on file"))
            for f in st.files:
                print(f"  {f}")
        sys.exit(0)

    if not os.path.isfile(record_path):
        print(f"REFUSED\n  no record at {record_path}"); sys.exit(2)
    rec = parse_record(read(record_path))
    fails, notes = check(run, stages, rec)
    if fails:
        print(f"REFUSED — {len(fails)} failure(s) in {norm_path(os.path.relpath(record_path, run))}")
        for f in fails:
            print("  - " + f)
        sys.exit(2)
    d = rec["derived"]
    print(f"record ok: {d['stages']} stages ({d['on_file']} on file), {d['judged']} handoffs judged, "
          f"{d['quotations']} quotations found, {d['confronted']} confronted, {d['changed']} corrected")
    for n in notes:
        print("  note: " + n)
    if a.check:
        sys.exit(0)

    events = load_calendar(cal_path)
    page, today = render(run, stages, rec, notes, events, os.path.relpath(record_path, run), os.path.relpath(map_path, run) if map_path.startswith(run) else map_path)
    r7 = rule7(page, today)
    if r7:
        print("REFUSED — the rendered page fails html-style rule 7:\n  - " + "\n  - ".join(r7)); sys.exit(2)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    io.open(out_path, "w", encoding="utf-8", newline="\n").write(page)
    print(f"written: {norm_path(os.path.relpath(out_path, run))} ({len(page.encode('utf-8'))} bytes); "
          f"timeline {'drawn from ' + str(len(events)) + ' events' if events is not None else 'omitted, no calendar'}")


if __name__ == "__main__":
    main()
