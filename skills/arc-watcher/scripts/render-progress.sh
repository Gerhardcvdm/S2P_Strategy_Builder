#!/usr/bin/env bash
# render-progress.sh — derive where a method run stands from the files on disk, and render it.
#
# Holds no state and creates none. Reads intake.md, the artefact directories, the critic
# directories, git, handoff.md, RUN-TIMINGS.md and the ruling register; writes RUN-PROGRESS.html,
# which is git-ignored and regenerated on every agent turn by the plugin's Stop hook. Exits 0
# always — a Stop hook that exits non-zero would stop the agent from stopping.
#
#   render-progress.sh [--dir D] [--out FILE] [--map FILE] [--summary] [--force]
#   A project may carry its own map at .claude/arc-map.tsv: it is used when --map is not given, and its
#   presence is permission to render without an intake.md — a run that predates the intake form.
#   Lines in a map beginning "#=" are directives: "#= Organisation: X" (also Function, Sponsor,
#   Engagement mode) name the engagement when there is no intake.md; "#= arc P: name" names an arc.
#   --summary  print a one-line position to stdout as well (used by the SessionStart hook)
#   --force    render even when there is no intake.md in the directory
#
# Written to spawn as few processes as possible: on Windows each fork costs tens of
# milliseconds, and a Stop hook runs on every turn. Escaping and counting are pure bash.
#
# Idempotent per session and event: when two registrations fire it (the plugin's hooks.json and
# a junction install's user-settings entry), the second within ten seconds exits without work.

set -uo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
d="${CLAUDE_PROJECT_DIR:-$PWD}"; map="$here/../arc-map.tsv"; map_given=0; out=""; force=0; summary=0
while [ $# -gt 0 ]; do
  case "$1" in
    --dir) d="$2"; shift ;;  --map) map="$2"; map_given=1; shift ;;  --out) out="$2"; shift ;;
    --force) force=1 ;;      --summary) summary=1 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "render-progress: unknown argument $1" >&2; exit 0 ;;
  esac; shift
done

# ---- one fire per session and event, however many registrations point here -----------------
if [ ! -t 0 ]; then
  payload=""; IFS= read -r -t 1 -d '' payload || true
  if [[ "$payload" =~ \"session_id\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
    sid="${BASH_REMATCH[1]}"; ev="hook"
    [[ "$payload" =~ \"hook_event_name\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]] && ev="${BASH_REMATCH[1]}"
    mark="${TMPDIR:-${TEMP:-/tmp}}/method-hook-${ev}-${sid}"
    if [ -f "$mark" ]; then
      now_s=$(date +%s); then_s=$(stat -c %Y "$mark" 2>/dev/null || echo 0)
      [ $((now_s - then_s)) -lt 10 ] && exit 0
    fi
    : > "$mark" 2>/dev/null || true
  fi
fi

# a project map beside the project's CLAUDE.md wins over the bundled one, and licenses a render without intake.md
[ "$map_given" = 1 ] || { [ -f "$d/.claude/arc-map.tsv" ] && { map="$d/.claude/arc-map.tsv"; force=1; }; }
[ -f "$d/intake.md" ] || [ "$force" = 1 ] || exit 0
[ -f "$map" ] || { echo "render-progress: no map at $map" >&2; exit 0; }
cd "$d" 2>/dev/null || exit 0
out="${out:-$d/RUN-PROGRESS.html}"
shopt -s nullglob globstar

# e VALUE  -> sets E to the HTML-escaped value, with no subprocess
e() { E="$1"; E="${E//&/&amp;}"; E="${E//</&lt;}"; E="${E//>/&gt;}"; }
now="$(date '+%Y-%m-%d %H:%M %Z')"

# ---- the engagement, from the intake ------------------------------------------------------
org=""; fn=""; sponsor=""; mode=""; unfilled=0
if [ -f intake.md ]; then
  while IFS= read -r line; do
    [[ "$line" == \*\*[!*]*:\*\** ]] || continue
    key="${line#\*\*}"; key="${key%%:\*\**}"; val="${line#*:\*\*}"; val="${val#"${val%%[! ]*}"}"
    [ -z "$val" ] || [[ "$val" == \[* ]] && unfilled=$((unfilled+1))
    case "$key" in
      Organisation) e "$val"; org="$E" ;;  Function) e "$val"; fn="$E" ;;
      Sponsor) e "$val"; sponsor="$E" ;;    'Engagement mode') e "$val"; mode="$E" ;;
    esac
  done < intake.md
fi

# ---- git, the resume document, the instruments ----------------------------------------------
ingit=0; branch="—"; headline="not a git repository"; dirty=0; ncommit=0
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ingit=1
  e "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"; branch="$E"
  e "$(git log -1 --format='%h · %ci · %s' 2>/dev/null)"; headline="$E"
  dirty=0; while IFS= read -r l; do [ -n "$l" ] && dirty=$((dirty+1)); done < <(git status --porcelain 2>/dev/null)
  ncommit=$(git rev-list --count HEAD 2>/dev/null || echo 0)
fi
# the resume document may be spelt handoff.md or HANDOFF.md; on a case-insensitive disk -f finds either, git only the spelling it holds
hf=""; for c in handoff.md HANDOFF.md Handoff.md; do [ -f "$c" ] && { hf="$c"; break; }; done
if [ -n "$hf" ] && [ "$ingit" = 1 ]; then g=$(git ls-files handoff.md HANDOFF.md Handoff.md 2>/dev/null); g="${g%%$'\n'*}"; [ -n "$g" ] && hf="$g"; fi
handoff="no handoff.md"; handoff_bad=1
if [ -n "$hf" ]; then
  handoff_bad=0
  if [ "$ingit" = 1 ]; then
    h=$(git log -1 --format=%H -- "$hf" 2>/dev/null || true)
    if [ -z "$h" ]; then handoff="$hf never committed"; handoff_bad=1
    else b=$(git rev-list --count "${h}..HEAD" 2>/dev/null || echo 0)
      if [ "${b:-0}" -gt 0 ]; then handoff="$hf is $b commit(s) behind HEAD"; handoff_bad=1; else handoff="$hf current"; fi
    fi
  else handoff="$hf present"; fi
fi
tablerows() { # $1 file -> ROWS = body rows of the first markdown table (pipe lines, minus header and rule)
  local n=0 l; while IFS= read -r l; do [[ "$l" == "|"* ]] && [[ "$l" != "|-"* ]] && [[ "$l" != "| -"* ]] && n=$((n+1)); done < "$1"
  ROWS=$(( n > 0 ? n - 1 : 0 )); }
timings="no RUN-TIMINGS.md"; [ -f RUN-TIMINGS.md ] && { tablerows RUN-TIMINGS.md; timings="RUN-TIMINGS.md · $ROWS rows"; }
reg=""; for f in ruling*.md RULINGS.md rulings*.md strategy/ruling*.md strategy/RULINGS.md portfolio/ruling*.md; do [ -f "$f" ] && { reg="$f"; break; }; done
register="no ruling register found"; [ -n "$reg" ] && { tablerows "$reg"; e "$reg"; register="$E · $ROWS rows"; }

# grepcount FILE REGEX -> GC = number of matching lines, no subprocess
grepcount() { GC=0; local l; [ -f "$1" ] || return 0; while IFS= read -r l; do [[ "$l" =~ $2 ]] && GC=$((GC+1)); done < "$1"; }

# ---- the first lines of every reviewer pass, read once, so a pass can be found by the artefact it names ----
declare -A CHEAD=()
for cf in strategy/critic/*.md portfolio/critic/*.md deliverables/critic/*.md critic/*.md; do
  [[ "$cf" == */README.md ]] && continue
  n=0; s=""; while IFS= read -r l && [ $n -lt 2 ]; do s="$s$l"$'\n'; n=$((n+1)); done < "$cf"; CHEAD[$cf]="$s"
done

# ---- read the map into arrays -----------------------------------------------------------------
declare -A arcname=([D1]="D#1 · /build-strategy" [D2]="D#2 · /build-portfolio" [D3]="D#3 · /build-recommendation")
declare -a M_arc=() M_id=() M_kind=() M_label=() M_targets=() M_exclude=() M_skipif=() M_critic=() M_note=() M_since=() M_waits=()
while IFS= read -r line; do
  [ -z "$line" ] && continue
  if [[ "$line" == "#="* ]]; then  # a directive: "#= Key: value"
    dv="${line#\#=}"; dv="${dv#"${dv%%[! ]*}"}"; dk="${dv%%:*}"; dv="${dv#*:}"; dv="${dv#"${dv%%[! ]*}"}"; e "$dv"
    case "$dk" in
      Organisation) [ -n "$org" ] || org="$E" ;;  Function) [ -n "$fn" ] || fn="$E" ;;
      Sponsor) [ -n "$sponsor" ] || sponsor="$E" ;;  "Engagement mode") [ -n "$mode" ] || mode="$E" ;;
      arc\ *) arcname["${dk#arc }"]="$E" ;;
    esac; continue
  fi
  [[ "$line" == \#* ]] && continue
  # tabs are IFS whitespace, so a run of them would collapse and shift every field after an empty one
  line="${line//$'\t'/$'\x1f'}"; IFS=$'\x1f' read -r arc id kind label targets exclude skipif critic note since waits <<< "$line"
  M_arc+=("$arc"); M_id+=("$id"); M_kind+=("$kind"); M_label+=("$label"); M_targets+=("$targets")
  M_exclude+=("$exclude"); M_skipif+=("$skipif"); M_critic+=("$critic"); M_note+=("$note"); M_since+=("${since:--}"); M_waits+=("${waits:--}")
done < "$map"
N=${#M_arc[@]}

# ---- detect: FOUND[i] matched paths (newline-joined), CNT[i] how many required matched, SKIP[i], REC[i] ruling-record lines ----
declare -a FOUND=() CNT=() SKIP=() STATE=() CRIT=() DETAIL=() REC=() RECF=()
declare -A matched=()
for ((i=0;i<N;i++)); do
  FOUND[$i]=""; CNT[$i]=0; SKIP[$i]=0; STATE[$i]=""; CRIT[$i]=""; DETAIL[$i]=""; REC[$i]=0; RECF[$i]=""
  t="${M_targets[$i]}"; x="${M_exclude[$i]}"
  [ "$t" = "-" ] && continue
  IFS='|' read -ra items <<< "$t"
  for it in "${items[@]}"; do
    req=1; [[ "$it" == \?* ]] && { req=0; it="${it#?}"; }
    if [[ "$it" == *"::"* ]]; then
      f="${it%%::*}"; [ -f "$f" ] || continue
      grepcount "$f" "${it#*::}"
      if [ "$GC" -gt 0 ]; then
        matched[$f]=1
        if [ "${M_kind[$i]}" = gate ]; then REC[$i]=$GC; RECF[$i]="$f"
        else FOUND[$i]="${FOUND[$i]}${FOUND[$i]:+$'\n'}$f"; [ "$req" = 1 ] && CNT[$i]=$(( ${CNT[$i]} + 1 )); fi
      fi
      continue
    fi
    for f in $it; do
      [ -e "$f" ] || continue
      [ "$x" != "-" ] && [[ "$f" =~ $x ]] && continue
      matched[$f]=1
      [ "$req" = 1 ] || continue
      [[ $'\n'"${FOUND[$i]}"$'\n' == *$'\n'"$f"$'\n'* ]] && continue
      FOUND[$i]="${FOUND[$i]}${FOUND[$i]:+$'\n'}$f"; CNT[$i]=$(( ${CNT[$i]} + 1 ))
    done
  done
  if [ "${CNT[$i]}" = 0 ] && [ "${REC[$i]}" = 0 ] && [ "${M_skipif[$i]}" != "-" ]; then
    sf="${M_skipif[$i]%%::*}"; [ -f "$sf" ] && { grepcount "$sf" "${M_skipif[$i]#*::}"; [ "$GC" -gt 0 ] && SKIP[$i]=1; }
  fi
done

# ---- walk each arc ------------------------------------------------------------------------------
anom=""; n_anom=0
anomaly() { anom="$anom<li>$1</li>"; n_anom=$((n_anom+1)); }
declare -a arcs=()
declare -A arc_pos=() arc_done=() arc_total=() arc_gates=() arc_gpass=() arc_ch=() arc_cn=() arc_state=() arc_first=() arc_last=() arc_gaps=() arc_pct=() arc_waits=()
for ((i=0;i<N;i++)); do
  a="${M_arc[$i]}"
  if [ -z "${arc_first[$a]:-}" ]; then arcs+=("$a"); arc_first[$a]=$i; arc_done[$a]=0; arc_total[$a]=0; arc_gates[$a]=0; arc_gpass[$a]=0; arc_ch[$a]=0; arc_cn[$a]=0; arc_pos[$a]=""; arc_state[$a]="pending"; arc_gaps[$a]=0; arc_pct[$a]=0; arc_waits[$a]=""; fi
  arc_last[$a]=$i
done
declare -A idx=()   # "ARC:ID" -> row index, for waits
for ((i=0;i<N;i++)); do idx["${M_arc[$i]}:${M_id[$i]}"]=$i; done
isdone() { [ "${CNT[$1]}" -gt 0 ] || [ "${SKIP[$1]}" = 1 ]; }

for a in "${arcs[@]}"; do
  lo=${arc_first[$a]}; hi=${arc_last[$a]}
  # the frontier: the first stage without an artefact AFTER the last stage that has one. Stages missing
  # before the last done one are gaps — skipped, or younger than the run — and do not move the position.
  last_done=-1; frontier=-1
  for ((i=lo;i<=hi;i++)); do [ "${M_kind[$i]}" = stage ] || continue; arc_total[$a]=$(( ${arc_total[$a]} + 1 )); isdone $i && last_done=$i; done
  for ((i=lo;i<=hi;i++)); do [ "${M_kind[$i]}" = stage ] || continue
    if isdone $i; then arc_done[$a]=$(( ${arc_done[$a]} + 1 ))
    elif [ "$i" -gt "$last_done" ] && [ "$frontier" -lt 0 ]; then frontier=$i; fi
  done
  # an arc whose input from another arc is not on file has not started: nothing in it is open or next
  blocked=0
  for ((i=lo;i<=hi;i++)); do w="${M_waits[$i]}"; [ "$w" != "-" ] && [ -n "${idx[$w]:-}" ] && ! isdone "${idx[$w]}" && blocked=1; done
  # the item immediately before the frontier (ignoring checks) decides whether a gate is open
  open_gate=-1
  if [ "$frontier" -ge 0 ] && [ "$blocked" = 0 ]; then
    for ((j=frontier-1;j>=lo;j--)); do
      [ "${M_kind[$j]}" = check ] && continue
      [ "${M_kind[$j]}" = gate ] && [ "${REC[$j]}" = 0 ] && [ "${SKIP[$j]}" = 0 ] && open_gate=$j
      break
    done
  fi
  gapnames=""; ngap=0; gap_after=""; inferred=""; noreg=""
  for ((i=lo;i<=hi;i++)); do
    k="${M_kind[$i]}"; id="${M_id[$i]}"
    nxt=""; for ((j=i+1;j<=hi;j++)); do [ "${M_kind[$j]}" = stage ] && { nxt="stage ${M_id[$j]} · ${M_label[$j]}"; break; }; done
    prv=-1; for ((j=i-1;j>=lo;j--)); do [ "${M_kind[$j]}" = check ] && continue; prv=$j; break; done
    case "$k" in
      check)
        STATE[$i]="check"; e "${M_note[$i]}"; DETAIL[$i]="runs every invocation${E:+ · $E}"
        w="${M_waits[$i]}"
        if [ "$w" != "-" ] && [ -n "${idx[$w]:-}" ]; then wi=${idx[$w]}; wa="${arcname[${M_arc[$wi]}]}"; wa="${wa%% *}"
          if isdone $wi; then DETAIL[$i]="${DETAIL[$i]} · input from $wa stage ${M_id[$wi]} is on file"
          else arc_waits[$a]="$wa stage ${M_id[$wi]} · ${M_label[$wi]}"; DETAIL[$i]="${DETAIL[$i]} · <b>waits on ${arc_waits[$a]}</b>"; fi
        fi ;;
      gate)
        e "${RECF[$i]}"; rf="$E"
        if [ "${SKIP[$i]}" = 1 ]; then STATE[$i]="n/a"; e "${M_skipif[$i]%%::*}"; DETAIL[$i]="not applicable on this run: <code>${M_skipif[$i]#*::}</code> in <code>$E</code>"
          [ -n "${M_note[$i]}" ] && { e "${M_note[$i]}"; DETAIL[$i]="${DETAIL[$i]} <span class=\"nt\">$E</span>"; }; continue; fi
        arc_gates[$a]=$(( ${arc_gates[$a]} + 1 ))
        if [ "$blocked" = 1 ] && [ "${REC[$i]}" = 0 ]; then STATE[$i]="pending"; DETAIL[$i]="waits on ${arc_waits[$a]:-another arc}"
        elif [ "$i" = "$open_gate" ]; then STATE[$i]="open"
          DETAIL[$i]="<b>waiting for a ruling.</b> ${nxt:-The next stage} cannot start until it is recorded, and no ruling rows were found in the register"
        elif [ "${REC[$i]}" -gt 0 ]; then
          STATE[$i]="ruled"; arc_gpass[$a]=$(( ${arc_gpass[$a]} + 1 ))
          DETAIL[$i]="${REC[$i]} ruling row(s) in <code>$rf</code>"
        elif [ "$frontier" -lt 0 ] || [ "$i" -lt "$frontier" ]; then
          STATE[$i]="passed"; arc_gpass[$a]=$(( ${arc_gpass[$a]} + 1 ))
          if [ "${M_targets[$i]}" = "-" ]; then DETAIL[$i]="the run went on: ${nxt:-a later stage} has an artefact. The map names no ruling record for this gate, so this is inference"
          else DETAIL[$i]="<span class=\"bad\">inferred, not ruled.</span> ${nxt:-A later stage} has an artefact and no ruling rows were found in the register"
            inferred="$inferred${inferred:+, }$id"; regf="${M_targets[$i]%%::*}"; regf="${regf%%|*}"; [ -f "$regf" ] || { e "$regf"; noreg="$E"; }; fi
        else STATE[$i]="pending"
          if [ "$prv" -ge 0 ]; then DETAIL[$i]="waits on stage ${M_id[$prv]} · ${M_label[$prv]}"; else DETAIL[$i]="waits on the stages before it"; fi
        fi
        [ -n "${M_note[$i]}" ] && { e "${M_note[$i]}"; DETAIL[$i]="${DETAIL[$i]} <span class=\"nt\">$E</span>"; } ;;
      stage)
        if isdone $i; then
          STATE[$i]="done"; [ "${SKIP[$i]}" = 1 ] && STATE[$i]="skipped"
          if [ "${SKIP[$i]}" = 1 ] || [ "${M_critic[$i]}" = "n/a" ]; then CRIT[$i]=""
          elif [ "${M_critic[$i]}" != "-" ]; then
            arc_cn[$a]=$(( ${arc_cn[$a]} + 1 )); hit=""
            IFS='|' read -ra cps <<< "${M_critic[$i]}"
            for cp in "${cps[@]}"; do
              if [[ "$cp" == *"::{file}" ]]; then
                cg="${cp%%::*}"
                for cf in $cg; do [[ "$cf" == */README.md ]] && continue; [ -n "${CHEAD[$cf]:-}" ] || continue
                  while IFS= read -r p; do [ -z "$p" ] && continue; b="${p##*/}"; [[ "${CHEAD[$cf]}" == *"$b"* ]] && { hit="$cf"; break; }; done <<< "${FOUND[$i]}"
                  [ -n "$hit" ] && break; done
              else cf="${cp//\{id\}/$id}"; [ -f "$cf" ] && hit="$cf"; fi
              [ -n "$hit" ] && break
            done
            if [ -n "$hit" ]; then CRIT[$i]="✓ $hit"; arc_ch[$a]=$(( ${arc_ch[$a]} + 1 )); matched[$hit]=1
            else CRIT[$i]="missing"; e "${M_critic[$i]}"; anomaly "<b>$a stage $id</b> has an artefact and no reviewer pass on file (looked for <code>$E</code>). Put it to the next gate as a question rather than re-running the pass."; fi
          else CRIT[$i]="unspecified"; fi
          if [ "${SKIP[$i]}" = 1 ]; then e "${M_skipif[$i]%%::*}"; DETAIL[$i]="skipped by design: <code>${M_skipif[$i]#*::}</code> in <code>$E</code>"
          else
            det=""; n=0
            while IFS= read -r p; do [ -z "$p" ] && continue; n=$((n+1)); [ "$n" -le 3 ] && { e "$p"; det="$det<code>$E</code> "; }; done <<< "${FOUND[$i]}"
            [ "$n" -gt 3 ] && det="$det… $n files"
            DETAIL[$i]="$det"
          fi
          [ -n "${M_note[$i]}" ] && { e "${M_note[$i]}"; DETAIL[$i]="${DETAIL[$i]} <span class=\"nt\">$E</span>"; }
        elif [ "$i" -lt "$last_done" ]; then
          STATE[$i]="gap"; ngap=$((ngap+1)); gapnames="$gapnames${gapnames:+, }$id"
          DETAIL[$i]="no artefact, though later stages have one. Either it was skipped or it entered the method after this arc ran"
          [ "${M_since[$i]}" != "-" ] && DETAIL[$i]="${DETAIL[$i]} (added in ${M_since[$i]})"
          [ -n "${M_note[$i]}" ] && { e "${M_note[$i]}"; DETAIL[$i]="${DETAIL[$i]} <span class=\"nt\">$E</span>"; }
          for ((j=i+1;j<=hi;j++)); do [ "${M_kind[$j]}" = stage ] && isdone $j && { gap_after="${M_id[$j]}"; break; }; done
          if [ "${M_critic[$i]}" != "-" ] && [ "${M_critic[$i]}" != "n/a" ]; then cf="${M_critic[$i]//\{id\}/$id}"; cf="${cf%%|*}"; [[ "$cf" == *"::"* ]] || { [ -f "$cf" ] && { matched[$cf]=1; anomaly "<b>$a stage $id</b> has a reviewer pass and no artefact: a pass ran on something the map cannot see."; }; }; fi
        else
          if [ "$i" = "$frontier" ] && [ "$open_gate" -lt 0 ] && [ "$blocked" = 0 ]; then STATE[$i]="next"
            if [ "$prv" -ge 0 ] && [ "${M_kind[$prv]}" = gate ] && [ "${REC[$prv]}" -gt 0 ]; then DETAIL[$i]="next to run · ${M_id[$prv]} is ruled"
            elif [ -n "${arc_waits[$a]}" ]; then DETAIL[$i]="next to run once ${arc_waits[$a]} is on file"
            else DETAIL[$i]="next to run"; fi
          else STATE[$i]="pending"
            if [ "$open_gate" -ge 0 ] && [ "$i" = "$frontier" ]; then DETAIL[$i]="<b>waits on ${M_id[$open_gate]}</b> · ${M_label[$open_gate]}"
            elif [ "$prv" -ge 0 ] && [ "${M_kind[$prv]}" = gate ]; then DETAIL[$i]="waits on ${M_id[$prv]} · ${M_label[$prv]}"
            elif [ "$prv" -ge 0 ]; then DETAIL[$i]="waits on stage ${M_id[$prv]} · ${M_label[$prv]}"
            else DETAIL[$i]="waits on the stages before it"; fi
            [ -n "${arc_waits[$a]}" ] && [ "$i" = "$frontier" ] && DETAIL[$i]="${DETAIL[$i]} · and on ${arc_waits[$a]}"
          fi
          [ -n "${M_note[$i]}" ] && { e "${M_note[$i]}"; DETAIL[$i]="${DETAIL[$i]} <span class=\"nt\">$E</span>"; }
        fi ;;
    esac
  done
  arc_gaps[$a]=$ngap
  [ -n "$inferred" ] && anomaly "<b>$a</b>: gates <b>$inferred</b> are passed by inference only. The stage after each exists and no ruling row was found${noreg:+ (there is no register at <code>$noreg</code>)}. Either a resume walked past them or the rulings live somewhere the map does not read. The next gate report should say which."
  [ "$ngap" -gt 0 ] && anomaly "<b>$a</b>: stage <b>$gapnames</b> has no artefact, and the run continued to stage $gap_after. Either it was skipped or it entered the method after this arc ran (the map's <i>since</i> column says when). The position ignores the gap. The gate report should say which it was."
  units=$(( ${arc_total[$a]} + ${arc_gates[$a]} )); dn=$(( ${arc_done[$a]} + ${arc_gpass[$a]} ))
  [ "$units" -gt 0 ] && arc_pct[$a]=$(( (dn*100 + units/2) / units ))
  if [ "$frontier" -lt 0 ]; then arc_state[$a]="complete"; arc_pos[$a]="every stage has an artefact"; [ "$ngap" -gt 0 ] && arc_pos[$a]="the run reached the last stage · $ngap stage(s) not on file: $gapnames"
  elif [ "$open_gate" -ge 0 ]; then arc_state[$a]="at a gate"; arc_pos[$a]="${M_id[$open_gate]} · ${M_label[$open_gate]} · awaiting a ruling"
  elif [ "${arc_done[$a]}" = 0 ]; then arc_state[$a]="pending"; arc_pos[$a]="not started"; [ -n "${arc_waits[$a]}" ] && arc_pos[$a]="not started · waits on ${arc_waits[$a]}"
  else arc_state[$a]="in progress"; arc_pos[$a]="stage ${M_id[$frontier]} · ${M_label[$frontier]} · next to run"; fi
done

# ---- the unmapped-files sweep ---------------------------------------------------------------
unmapped=""
for f in strategy/* client/* portfolio/* portfolio/demo/* demo/* deliverables/*; do
  [ -f "$f" ] || continue; [[ "$f" == */README.md ]] && continue
  [ -n "${matched[$f]:-}" ] || { e "$f"; unmapped="$unmapped<li><code>$E</code></li>"; }
done
[ -n "$unmapped" ] && anomaly "Files in the scanned directories that no map row claims. Either a stage wrote outside the map or the map is behind the command:<ul>$unmapped</ul>"
[ "$unfilled" -gt 0 ] && anomaly "<code>intake.md</code> has $unfilled unfilled field(s), so the entry guard will stop."
[ "$handoff_bad" = 1 ] && anomaly "Resume document: $handoff."
[ "$ingit" = 0 ] && anomaly "Not a git repository. Every commit the commands order will silently not happen."

# ---- headline: the arc the run is in — at a gate or in progress first, then the first not started ----
head_arc=""
for a in "${arcs[@]}"; do case "${arc_state[$a]}" in "at a gate"|"in progress") head_arc="$a"; break;; esac; done
[ -z "$head_arc" ] && for a in "${arcs[@]}"; do [ "${arc_state[$a]}" = pending ] && { head_arc="$a"; break; }; done
[ -z "$head_arc" ] && head_arc="${arcs[${#arcs[@]}-1]}"
position="${arcname[$head_arc]:-$head_arc} · ${arc_pos[$head_arc]}"
tot_done=0; tot_all=0; g_pass=0; g_all=0; c_on=0; c_all=0
for a in "${arcs[@]}"; do tot_done=$((tot_done+${arc_done[$a]})); tot_all=$((tot_all+${arc_total[$a]})); g_pass=$((g_pass+${arc_gpass[$a]})); g_all=$((g_all+${arc_gates[$a]})); c_on=$((c_on+${arc_ch[$a]})); c_all=$((c_all+${arc_cn[$a]})); done
units=$((tot_all+g_all)); pct=0; [ "$units" -gt 0 ] && pct=$(( ((tot_done+g_pass)*100 + units/2) / units ))

# ---- render -----------------------------------------------------------------------------------
arcs_html=""
for a in "${arcs[@]}"; do
  strip=""; table=""
  for ((i=${arc_first[$a]};i<=${arc_last[$a]};i++)); do
    k="${M_kind[$i]}"; s="${STATE[$i]}"; e "${M_id[$i]}"; id="$E"; e "${M_label[$i]}"; lab="$E"
    sl="$s"; [ "$s" = gap ] && sl="not on file"; sc="$s"; [ "$s" = "n/a" ] && sc="na"
    strip="$strip<li class=\"nd nd-$k st-$sc\" title=\"$lab · $sl\"><span class=\"nid\">$id</span></li>"
    case "${CRIT[$i]}" in
      "✓ "*) cp="${CRIT[$i]#✓ }"; e "$cp"; ct="$E"; e "${cp#*/}"; cc="<span class=\"ok\">✓</span> <code title=\"$ct\">$E</code>" ;;
      missing) cc="<span class=\"bad\">missing</span>" ;;
      unspecified) cc="<span class=\"mu\">path not specified by the command</span>" ;;
      *) cc="—" ;;
    esac
    table="$table<tr class=\"r-$k r-$sc\"><td class=\"mono\">$id</td><td>$lab</td><td><span class=\"pill p-$sc\">$sl</span></td><td class=\"det\">$cc</td><td class=\"det\">${DETAIL[$i]}</td></tr>"
  done
  critline=""; [ "${arc_cn[$a]}" -gt 0 ] && critline=" · reviewer passes ${arc_ch[$a]} of ${arc_cn[$a]}"
  gapline=""; [ "${arc_gaps[$a]}" -gt 0 ] && gapline=" · ${arc_gaps[$a]} not on file"
  st="${arc_state[$a]}"; stc="${st// /-}"
  arcs_html="$arcs_html
<section class=\"card arc\">
  <div class=\"arc-head\">
    <div class=\"arc-row\"><h2>${arcname[$a]:-$a}</h2><span class=\"pct\">≈ ${arc_pct[$a]}%</span></div>
    <p class=\"arc-pos\"><span class=\"pill p-$stc\">$st</span> ${arc_pos[$a]}</p>
    <p class=\"arc-nums\">${arc_done[$a]} of ${arc_total[$a]} stages with artefacts${gapline} · ${arc_gpass[$a]} of ${arc_gates[$a]} gates ruled or passed${critline}</p>
  </div>
  <ol class=\"strip\" aria-label=\"Stages and gates in order\">$strip</ol>
  <div class=\"tw\"><table>
    <thead><tr><th>#</th><th>Stage or gate</th><th>State</th><th>Reviewer pass</th><th>Why, and what it is waiting for</th></tr></thead>
    <tbody>$table</tbody>
  </table></div>
</section>"
done

warn_dirty=""; [ "$dirty" -gt 0 ] && warn_dirty=" warn"
warn_anom=""; [ "$n_anom" -gt 0 ] && warn_anom=" warn"
anom_html="<p class=\"mu\">Nothing. Every artefact is mapped, every stage with an artefact has its reviewer pass, every passed gate has a ruling record, and the resume document is current.</p>"
[ -n "$anom" ] && anom_html="<ul>$anom</ul>"

tmp="$out.tmp.$$"
cat > "$tmp" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Run progress · ${org:-engagement} · ${fn:-function}</title>
<style>
:root{--bg:#000;--surface:#2c2e30;--surface-2:#3a3b3d;--border:#636466;--text:#fff;--text-muted:#a7a8aa;
--accent-1:#86bc25;--accent-2:#0d8390;--accent-3:#007cb0;--accent-1-deep:#4a7c15;--link:#5ab5e0;--bright-green:#0df200;--bright-teal:#3efac5;
--gradient-1:linear-gradient(135deg,var(--accent-1-deep),var(--accent-2));--shadow-glow:0 0 40px rgba(13,131,144,.2)}
*{box-sizing:border-box}
body{margin:0;padding:40px 24px;background:var(--bg);color:var(--text);font:1rem/1.6 'Aptos','Aptos Display',Calibri,'Segoe UI',system-ui,-apple-system,sans-serif}
.wrap{max-width:960px;margin:0 auto}
header.hero{padding:8px 0 24px;border-bottom:3px solid var(--accent-1);margin-bottom:24px;display:grid;grid-template-columns:1fr auto;gap:12px 32px;align-items:end}
header.hero .eyebrow{margin:0 0 10px;font-size:.8rem;font-weight:600;letter-spacing:.14em;text-transform:uppercase;color:var(--accent-1)}
header.hero h1{margin:0 0 10px;max-width:30ch;font-size:2.6rem;font-weight:700;line-height:1.12;letter-spacing:-.01em;color:var(--text)}
header.hero p{margin:0;color:var(--text-muted);font-size:1.05rem}
.hero-pct{text-align:right;min-width:160px}
.hero-pct .v{font-size:2.6rem;font-weight:700;line-height:1;color:var(--text)}
.hero-pct .l{font-size:.78rem;text-transform:uppercase;letter-spacing:.06em;color:var(--text-muted);margin-top:4px}
.bar{height:6px;background:var(--surface-2);border-radius:3px;overflow:hidden;margin-top:10px}
.bar i{display:block;height:100%;background:var(--accent-1);border-radius:3px}
.card{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:28px;margin-bottom:20px}
.card h2{margin:0 0 6px;font-size:1.3rem;font-weight:600}
.arc-row{display:flex;justify-content:space-between;align-items:baseline;gap:16px;flex-wrap:wrap}
.pct{font-size:1.1rem;font-weight:700;color:var(--text-muted)}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:16px;margin-bottom:20px}
.stat{background:var(--surface);border:1px solid var(--border);border-radius:14px;padding:20px 22px}
.stat .value{font-size:1.8rem;font-weight:700;line-height:1.1}
.stat .label{font-size:.85rem;text-transform:uppercase;letter-spacing:.04em;color:var(--text-muted);font-weight:600;margin-top:6px}
.stat.warn .value{color:var(--bright-teal)}
.mono,code{font-family:Consolas,'Cascadia Mono',ui-monospace,monospace;font-size:.92em}
code{background:var(--surface-2);padding:1px 6px;border-radius:5px}
.arc-head{margin-bottom:14px}.arc-pos{margin:4px 0}.arc-nums{margin:0;color:var(--text-muted);font-size:.92rem}
.strip{list-style:none;display:flex;flex-wrap:wrap;gap:6px;padding:14px 0 6px;margin:0 0 14px;border-bottom:1px solid var(--border)}
.strip .nd{width:44px;height:44px;display:flex;align-items:center;justify-content:center;font-size:.8rem;font-weight:700;border:2px solid var(--border);background:var(--surface-2);color:var(--text-muted)}
.strip .nd-stage{border-radius:50%}
.strip .nd-check{border-radius:8px;border-style:dashed}
.strip .nd-gate{border-radius:6px;transform:rotate(45deg);width:36px;height:36px;margin:4px}
.strip .nd-gate .nid{transform:rotate(-45deg);font-size:.66rem}
.strip .st-done,.strip .st-ruled{background:var(--accent-1-deep);border-color:var(--accent-1);color:#fff}
.strip .st-passed{background:var(--surface-2);border-color:var(--accent-1);border-style:dashed;color:var(--accent-1)}
.strip .st-skipped{background:var(--surface-2);border-color:var(--accent-1);color:var(--accent-1)}
.strip .st-gap{background:var(--surface-2);border-style:dotted;color:var(--text-muted)}
.strip .st-next,.strip .st-open{background:#fff;border-color:var(--bright-teal);color:#000;box-shadow:0 0 0 4px rgba(62,250,197,.25)}
.strip .st-check{opacity:.75}
.strip .st-na{opacity:.4;border-style:dashed}
.pill{display:inline-block;padding:1px 10px;border-radius:999px;font-size:.78rem;font-weight:600;text-transform:uppercase;letter-spacing:.03em;border:1px solid var(--border);color:var(--text-muted);white-space:nowrap}
.p-done,.p-passed,.p-ruled,.p-complete,.p-skipped{border-color:var(--accent-1);color:var(--accent-1)}
.p-passed{border-style:dashed}
.p-next,.p-open,.p-in-progress,.p-at-a-gate{border-color:var(--bright-teal);color:var(--bright-teal)}
.p-gap{border-style:dotted}.p-na{opacity:.6}
.tw{overflow-x:auto}
table{width:100%;border-collapse:collapse;font-size:.95rem}
th{text-align:left;font-size:.8rem;text-transform:uppercase;letter-spacing:.04em;color:var(--text-muted);font-weight:600;padding:8px 10px;border-bottom:1px solid var(--border)}
td{padding:8px 10px;border-bottom:1px solid var(--border);vertical-align:top}
tr.r-gate td{background:rgba(13,131,144,.10)}
tr.r-pending td{color:var(--text-muted)}
tr.r-open td,tr.r-next td{background:rgba(62,250,197,.08)}
.det{font-size:.88rem;word-break:break-word}.nt{color:var(--text-muted);font-style:italic}
.ok{color:var(--accent-1)}.bad{color:var(--bright-teal);font-weight:600}.mu{color:var(--text-muted)}
.anom li{margin:6px 0}.anom ul{margin:4px 0 0}
.kv{display:grid;grid-template-columns:max-content 1fr;gap:6px 18px;margin:0}.kv dt{color:var(--text-muted)}.kv dd{margin:0}
.legend{color:var(--text-muted);font-size:.85rem;margin:0 0 20px}
footer{text-align:center;color:var(--text-muted);font-size:.85rem;margin-top:28px}
a{color:var(--link)}
@media (max-width:640px){header.hero{grid-template-columns:1fr}.hero-pct{text-align:left}}
@media print{:root{--bg:#fff;--surface:#fff;--surface-2:#f4f5f6;--border:#c9ccce;--text:#000;--text-muted:#4a4d50;--link:#005f8a}
body{padding:0;font-size:10.5pt}header.hero{padding:0 0 16px}
header.hero h1{font-size:22pt;color:#000}header.hero .eyebrow{color:var(--accent-1-deep)}.hero-pct .v{color:#000}.bar{background:#ddd}.bar i{background:#000}.card{border:1px solid var(--border);box-shadow:none;break-inside:avoid;page-break-inside:avoid}
.strip .st-next,.strip .st-open{box-shadow:none}.strip .st-done,.strip .st-ruled{color:#fff}
a{color:var(--link);text-decoration:underline}table{break-inside:auto}tr{break-inside:avoid}thead{display:table-header-group}}
</style>
</head>
<body>
<div class="wrap">
<header class="hero">
  <div>
    <p class="eyebrow">Run progress</p>
    <h1>${position}</h1>
    <p>${org:-not named} · ${fn:-no function stated} · sponsor ${sponsor:-not named} · ${mode:-mode not stated}</p>
  </div>
  <div class="hero-pct" title="Stages with artefacts plus gates ruled or passed, over all stages and gates of the three arcs. It counts what exists, not whether it is right.">
    <div class="v">≈ ${pct}%</div>
    <div class="l">of the run, approximate</div>
    <div class="bar"><i style="width:${pct}%"></i></div>
  </div>
</header>

<div class="grid">
  <div class="stat"><div class="value">${tot_done} / ${tot_all}</div><div class="label">stages with artefacts</div></div>
  <div class="stat"><div class="value">${g_pass} / ${g_all}</div><div class="label">gates ruled or passed</div></div>
  <div class="stat"><div class="value">${c_on} / ${c_all}</div><div class="label">reviewer passes on file</div></div>
  <div class="stat${warn_dirty}"><div class="value">${dirty}</div><div class="label">uncommitted changes</div></div>
  <div class="stat${warn_anom}"><div class="value">${n_anom}</div><div class="label">things to look at</div></div>
</div>
<p class="legend">The percentage is stages with an artefact plus gates with a ruling record or a stage after them, over every stage and gate of the three arcs. It counts what exists and says nothing about whether it is right. A gate reads ruled when a ruling row was found, passed when the run merely went on, and n/a when this run did not need it. A stage reads not on file when it has no artefact but later stages do.</p>
${arcs_html}

<section class="card anom">
  <h2>Things to look at</h2>
  ${anom_html}
</section>

<section class="card">
  <h2>Close-out state</h2>
  <dl class="kv">
    <dt>Branch</dt><dd>${branch} · ${ncommit} commits</dd>
    <dt>Last commit</dt><dd>${headline}</dd>
    <dt>Working tree</dt><dd>${dirty} uncommitted change(s)</dd>
    <dt>Resume document</dt><dd>${handoff}</dd>
    <dt>Timings</dt><dd>${timings}</dd>
    <dt>Ruling register</dt><dd>${register}</dd>
  </dl>
</section>

<footer>
  Derived from the files on disk at ${now}. Holds no state and is not a deliverable. Regenerate with
  <code>bash render-progress.sh</code> from the <code>arc-watcher</code> skill, or let the Stop hook do it.
</footer>
</div>
</body>
</html>
HTML
mv -f "$tmp" "$out"

if [ "$summary" = 1 ]; then
  echo "RUN POSITION: ${position} · ≈${pct}% · ${tot_done}/${tot_all} stages · ${g_pass}/${g_all} gates · ${dirty} uncommitted · ${n_anom} thing(s) to look at · ${handoff} · page: RUN-PROGRESS.html"
fi
exit 0
