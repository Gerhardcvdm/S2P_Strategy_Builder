#!/usr/bin/env bash
# PreCompact close-out check.
#
# Fires BEFORE the context is compacted, while the reasoning still exists.
# The artefacts survive a compaction; WHY a gate was ruled the way it was does not,
# and handoff.md is what is supposed to carry it.
#
# Safe in any project: exits silently unless the working directory is a git repo,
# and only mentions handoff.md if that file exists.
# Never blocks — it warns and gets out of the way.
# Idempotent per session: two registrations (the plugin's hooks.json and a junction install's
# user-settings entry) produce one warning, not two.

set -uo pipefail

payload=""; [ -t 0 ] || { IFS= read -r -t 1 -d '' payload || true; }
if [[ "$payload" =~ \"session_id\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
  mark="${TMPDIR:-${TEMP:-/tmp}}/method-hook-PreCompact-${BASH_REMATCH[1]}"
  if [ -f "$mark" ]; then
    now_s=$(date +%s); then_s=$(stat -c %Y "$mark" 2>/dev/null || echo 0)
    [ $((now_s - then_s)) -lt 10 ] && exit 0
  fi
  : > "$mark" 2>/dev/null || true
fi

d="${CLAUDE_PROJECT_DIR:-$PWD}"
git -C "$d" rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

warn=""

# 1 — uncommitted work
n=$(git -C "$d" status --porcelain 2>/dev/null | grep -c . || true)
if [ "${n:-0}" -gt 0 ]; then
  warn="${warn}${n} uncommitted change(s). "
fi

# 2 — resume document behind the repo
if [ -f "$d/handoff.md" ]; then
  h=$(git -C "$d" log -1 --format=%H -- handoff.md 2>/dev/null || true)
  if [ -n "$h" ]; then
    behind=$(git -C "$d" rev-list --count "${h}..HEAD" 2>/dev/null || echo 0)
    if [ "${behind:-0}" -gt 0 ]; then
      warn="${warn}handoff.md is ${behind} commit(s) behind HEAD. "
    fi
  else
    warn="${warn}handoff.md has never been committed. "
  fi
fi

warn="${warn% }"
[ -z "$warn" ] && exit 0

printf '{"systemMessage":"CLOSE-OUT before compaction: %s Commit and update the resume document now — after the compaction the reasoning behind it is gone, and only the artefacts remain."}\n' "$warn"
