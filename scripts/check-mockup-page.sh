#!/usr/bin/env bash
# Checks what the brainstorming skill's mockup server sends to the browser.
#
# Usage: scripts/check-mockup-page.sh [skill directory]
#
# Starts the server on a scratch project, fetches the waiting page and one screen, and prints the
# brand words, the page titles, and every address outside this machine that either page names.
# Exits 1 when a page holds a brand word or an outside address, and 2 when the server won't start.
set -uo pipefail
skill=${1:-plugins/standards/skills/brainstorming}
proj=$(mktemp -d)
trap 'rm -rf "$proj"' EXIT
if ! bash "$skill/scripts/start-server.sh" --project-dir "$proj" > "$proj/start.json"; then
  cat "$proj/start.json"
  exit 2
fi
state=$(ls -d "$proj"/.superpowers/brainstorm/*/state)
read -r url screens < <(python3 -I -c \
  'import json,sys; d=json.load(open(sys.argv[1])); print(d["url"], d["screen_dir"])' "$state/server-info")
# The first request trades the key in the address for a cookie; the second gets the page.
curl -s -c "$proj/jar" "$url" > /dev/null
curl -s -b "$proj/jar" "${url%%\?*}" > "$proj/waiting.html"
echo '<h2>Pick one</h2>' > "$screens/a.html"
sleep 1
curl -s -b "$proj/jar" "${url%%\?*}" > "$proj/screen.html"
bash "$skill/scripts/stop-server.sh" "$(dirname "$state")" > /dev/null

pages=("$proj/waiting.html" "$proj/screen.html")
shown=$(grep -c 'Pick one' "$proj/screen.html")
brand=$(cat "${pages[@]}" | grep -o -i -E 'primeradiant|prime radiant|superpowers|obra' | wc -l)
outside=$(cat "${pages[@]}" | grep -o -E 'https?://[^"'"'"' )<]+' | grep -v -E '//(localhost|127\.0\.0\.1)' | sort -u | tr '\n' ' ')
echo "screen shown: $shown"
echo "titles: $(cat "${pages[@]}" | grep -o -i '<title>[^<]*</title>' | sort -u | tr '\n' ' ')"
echo "brand words: $brand"
echo "outside addresses: ${outside:-none}"
[ "$shown" -ge 1 ] && [ "$brand" -eq 0 ] && [ -z "$outside" ]
