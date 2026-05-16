#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RUN_INSTALL=1
RUN_AGENT_SMOKE="${OPENCLAW_RUN_AGENT_SMOKE:-0}"

usage() {
  cat <<EOF
Usage: $0 [--no-install] [--agent-smoke]

Starts the OpenClaw-only NASA APOD demo:
  - installs clean-instance prerequisites when needed
  - ensures Ollama and qwen3.6:27b are available
  - configures native OpenClaw
  - checks direct NASA APOD API access
  - starts the OpenClaw gateway and prints dashboard access

Options:
  --no-install   Skip prerequisite installation checks.
  --agent-smoke  Run a native OpenClaw prompt against the APOD skill.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-install) RUN_INSTALL=0 ;;
    --agent-smoke) RUN_AGENT_SMOKE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

echo "[1/5] Checking host prerequisites"
if [ "$RUN_INSTALL" -eq 1 ]; then
  "$SCRIPT_DIR/install-host-prereqs.sh"
else
  echo "Skipping install step"
fi

echo "[2/5] Ensuring local Ollama model"
"$SCRIPT_DIR/ensure-model.sh"

echo "[3/5] Configuring native OpenClaw"
"$SCRIPT_DIR/setup-openclaw.sh"

echo "[4/5] Smoke checks"
"$SCRIPT_DIR/run-apod-smoke.sh"
if [ "$RUN_AGENT_SMOKE" = "1" ]; then
  "$SCRIPT_DIR/run-openclaw-smoke.sh"
fi

echo "[5/5] OpenClaw dashboard"
"$SCRIPT_DIR/start-openclaw-gateway.sh"
"$SCRIPT_DIR/show-dashboard.sh"

cat <<EOF

Try this prompt:
  What is the NASA Astronomy Picture of the Day today? Include the title, date, media type, and image or video URL.

Stop the demo with:
  ./scripts/stop-demo.sh
EOF

