#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=resolve-demo-root.sh
. "$SCRIPT_DIR/resolve-demo-root.sh"
ROOT="$(resolve_demo_root "$SCRIPT_DIR")"
# shellcheck source=openclaw-env.sh
. "$SCRIPT_DIR/openclaw-env.sh"

PROFILE="${OPENCLAW_PROFILE:-openclaw-nasa-apod}"
MODEL_REF="${OPENCLAW_MODEL_REF:-ollama/${OPENCLAW_OLLAMA_MODEL:-qwen3.6:27b}}"
SESSION="${OPENCLAW_SMOKE_SESSION:-nasa-apod-smoke}"
LOG_FILE="$ROOT/logs/openclaw-smoke.json"

mkdir -p "$ROOT/logs"
openclaw_require_cli

openclaw --profile "$PROFILE" agent \
  --local \
  --session-id "$SESSION" \
  --model "$MODEL_REF" \
  --timeout "${OPENCLAW_AGENT_TIMEOUT:-300}" \
  --message "Use the NASA APOD skill to answer: What is the NASA Astronomy Picture of the Day today? Include the title, date, media type, and image or video URL." \
  --json > "$LOG_FILE"

python3 - "$LOG_FILE" <<'PY'
import json
import sys

path = sys.argv[1]
data = json.load(open(path, encoding="utf-8"))
texts = [p.get("text", "") for p in data.get("payloads", [])]
text = "\n".join(texts).strip()
print(text)

checks = ["title", "date", "media", "http"]
missing = [word for word in checks if word.lower() not in text.lower()]
if missing:
    raise SystemExit(f"OpenClaw APOD smoke response missing expected content: {', '.join(missing)}")
PY

