#!/usr/bin/env bash
# Build fixtures/complete-run from a real run: every file name the commands wrote, each markdown
# file reduced to what the map reads — its first two lines (the header a critic pass is found by)
# and every line that any regex in arc-map.tsv would match (ruling rows, gate-taken lines, the
# entry path, a Part heading) — and every other file emptied. No engagement content travels:
# a fixture is file names and identifiers. The regex list is read from the map, so a map that
# gains a pattern rebuilds a fixture that carries the lines it needs.
#
#   bash scripts/make-fixture.sh <run-dir> [<fixture-dir>]
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
run="${1:?run directory}"; out="${2:-$here/../fixtures/complete-run}"
map="$here/../arc-map.tsv"
# every file::regex in targets (col 5, |-separated) and skipif (col 7)
pats=$(awk -F'\t' '!/^#/ && NF>6 { n=split($5,t,"|"); for(i=1;i<=n;i++) if (t[i] ~ /::/) { sub(/^[^:]*::/,"",t[i]); print t[i] }
                                       if ($7 ~ /::/) { s=$7; sub(/^[^:]*::/,"",s); print s } }' "$map" | sort -u)
mkdir -p "$out"; find "$out" -mindepth 1 -maxdepth 1 ! -name README.md -exec rm -rf {} +
( cd "$run" && find intake.md handoff.md RUN-TIMINGS.md IDENTIFIERS.md strategy client portfolio recommendation deliverables storyline \
    -type f 2>/dev/null | grep -v -e '/\.' -e '__pycache__' -e 'RUN-PROGRESS' ) | while IFS= read -r f; do
  mkdir -p "$out/$(dirname "$f")"
  case "$f" in
    *.md)
      { head -2 "$run/$f"
        while IFS= read -r l; do
          while IFS= read -r p; do [[ "$l" =~ $p ]] && { printf '%s\n' "$l"; break; }; done <<< "$pats" || true
        done < "$run/$f"
      } > "$out/$f" ;;
    *) : > "$out/$f" ;;
  esac
done
echo "fixture written to $out: $(find "$out" -type f | wc -l) files, $(printf '%s\n' "$pats" | wc -l) map regexes kept"
