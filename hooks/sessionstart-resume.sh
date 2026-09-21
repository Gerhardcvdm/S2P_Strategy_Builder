#!/usr/bin/env bash
# SessionStart recovery — the half of the context boundary the PreCompact hook cannot reach.
#
# PreCompact fires BEFORE a compaction and can only warn the person; its output never reaches
# the agent, and it does not fire on /clear at all. This hook fires AFTER the context is gone
# (matcher: clear | compact | resume) and its stdout IS read into the agent's context. So it
# re-injects the resume document, which is the one file written to carry what the artefacts
# cannot: why each gate was ruled the way it was, and what is still open.
#
# Safe in any project: prints nothing unless the working directory holds a handoff.md.
# Bounded: a resume document longer than the cap is cut, and says so, rather than flooding
# the fresh context with the thing the compaction was trying to shed.
#
# Idempotent per session: the plugin's hooks.json and a junction install's user-settings entry
# both point here, and both fire. The second within ten seconds exits silently — this hook's
# output goes into the agent's context, and injecting the resume document twice costs the
# whole budget the cap exists to protect.

set -uo pipefail

# read the hook's stdin JSON first, before any child could consume it
payload=""; [ -t 0 ] || { IFS= read -r -t 1 -d '' payload || true; }
if [[ "$payload" =~ \"session_id\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
  mark="${TMPDIR:-${TEMP:-/tmp}}/method-hook-SessionStart-${BASH_REMATCH[1]}"
  if [ -f "$mark" ]; then
    now_s=$(date +%s); then_s=$(stat -c %Y "$mark" 2>/dev/null || echo 0)
    [ $((now_s - then_s)) -lt 10 ] && exit 0
  fi
  : > "$mark" 2>/dev/null || true
fi

d="${CLAUDE_PROJECT_DIR:-$PWD}"
f="$d/handoff.md"
[ -f "$f" ] || exit 0

cap=240
total=$(wc -l < "$f" | tr -d ' ')

echo "RESUME DOCUMENT re-injected after a context boundary — handoff.md ($total lines). Read it before"
echo "acting; the artefacts survived the boundary, the reasoning behind them did not. Then derive the"
echo "resume point from the filesystem as the command instructs — this file is context, not state."
# the watcher, if it ships alongside: one line of position derived from the files, not from memory
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
w="$here/../skills/arc-watcher/scripts/render-progress.sh"
[ -f "$w" ] && bash "$w" --dir "$d" --summary 2>/dev/null </dev/null
echo "----- handoff.md -----"
if [ "$total" -le "$cap" ]; then
  cat "$f"
else
  head -n "$cap" "$f"
  echo "----- cut at $cap of $total lines: open handoff.md for the rest -----"
fi
