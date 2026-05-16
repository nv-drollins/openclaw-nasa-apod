#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-demo-root.sh
. "$SCRIPT_DIR/resolve-demo-root.sh"
ROOT="$(resolve_demo_root "$SCRIPT_DIR")"

API_KEY="${NASA_API_KEY:-DEMO_KEY}"
OUT="$ROOT/logs/apod-smoke.json"

mkdir -p "$ROOT/logs"

if ! command -v curl >/dev/null 2>&1; then
  echo "Missing curl. Run ./scripts/install-host-prereqs.sh first." >&2
  exit 1
fi

if [ -n "${NASA_API_KEY:-}" ]; then
  echo "Fetching NASA APOD with NASA_API_KEY"
else
  echo "Fetching NASA APOD with public DEMO_KEY"
fi
curl -fsS "https://api.nasa.gov/planetary/apod?api_key=${API_KEY}&thumbs=true" -o "$OUT"

python3 - "$OUT" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    data = json.load(f)

if "error" in data:
    raise SystemExit(f"NASA APOD API returned an error: {data['error']}")

required = ["title", "date", "media_type", "url", "explanation"]
missing = [key for key in required if not data.get(key)]
if missing:
    raise SystemExit(f"NASA APOD response missing required fields: {', '.join(missing)}")

print("NASA APOD API reachable")
print(f"Title: {data['title']}")
print(f"Date: {data['date']}")
print(f"Media type: {data['media_type']}")
print(f"URL: {data.get('hdurl') or data['url']}")
PY
