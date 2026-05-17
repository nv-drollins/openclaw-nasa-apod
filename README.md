# OpenClaw NASA APOD Demo

OpenClaw-only version of the NASA Astronomy Picture of the Day demo. It lets a
local agent fetch live APOD data from `api.nasa.gov`, summarize it, and answer
date-based astronomy image questions without the NemoClaw/OpenShell sandbox
layer.

The default local model is:

```text
ollama/qwen3.6:27b
```

See [PREREQUISITES.md](PREREQUISITES.md) for the clean-instance requirements
ledger.

## Quick Start

Run these commands on the Spark or Ubuntu host:

```bash
git clone https://github.com/nv-drollins/openclaw-nasa-apod.git
cd openclaw-nasa-apod
chmod +x install.sh scripts/*.sh
./install.sh
```

This demo was created and tested with OpenClaw CLI `2026.5.12`. The installer
uses that version by default. To intentionally test a different OpenClaw
release, pass it through the install command:

```bash
OPENCLAW_CLI_VERSION=2026.5.12 ./install.sh
```

Use `OPENCLAW_CLI_VERSION=latest ./install.sh` only when validating the latest
OpenClaw release.

`install.sh` installs missing host prerequisites, ensures Ollama and
`qwen3.6:27b` are available, creates a native OpenClaw profile, checks NASA
APOD API access, starts the OpenClaw gateway, and prints the dashboard URL and
token.

Try this prompt in the dashboard:

```text
What is the NASA Astronomy Picture of the Day today? Include the title, date, media type, and image or video URL.
```

Other good prompts:

```text
Show me NASA's Astronomy Picture of the Day from July 20, 2019 and explain why that date matters.
```

```text
Find three random APOD entries and compare what kind of astronomy each one shows.
```

```text
Show me APOD entries from the first week of January 2026 as a numbered list with URLs.
```

## What You Get

- A native OpenClaw workspace restricted to the `nasa-apod` skill
- Live read-only APOD API access through `curl`
- NASA's public `DEMO_KEY` path by default
- Optional `NASA_API_KEY` support for higher rate limits
- A local Ollama/Qwen model path
- Start, stop, dashboard, prerequisite, and smoke-test scripts

## Day-2 Commands

Start or repair the full demo:

```bash
./scripts/start-demo.sh
```

Stop the OpenClaw gateway:

```bash
./scripts/stop-demo.sh
```

Run direct NASA API checks:

```bash
./scripts/run-apod-smoke.sh
```

Run a native OpenClaw agent smoke test:

```bash
./scripts/run-openclaw-smoke.sh
```

Show the dashboard URL and token:

```bash
./scripts/show-dashboard.sh
```

## Configuration

| Variable | Default | Purpose |
|---|---:|---|
| `OPENCLAW_CLI_VERSION` | `2026.5.12` | OpenClaw CLI npm package version installed by the prereq script |
| `OPENCLAW_PROFILE` | `openclaw-nasa-apod` | Native OpenClaw profile name |
| `OPENCLAW_OLLAMA_MODEL` | `qwen3.6:27b` | Ollama model to pull and use |
| `OPENCLAW_MODEL_REF` | `ollama/${OPENCLAW_OLLAMA_MODEL}` | OpenClaw model id |
| `OPENCLAW_GATEWAY_PORT` | `18791` | Dashboard/gateway port |
| `OPENCLAW_GATEWAY_BIND` | `loopback` | Gateway bind mode; use `lan` only on trusted networks |
| `NASA_API_KEY` | `DEMO_KEY` fallback | Optional NASA API key |

## Notes

This project deliberately does not install or use NemoClaw, OpenShell, Docker,
or vLLM. Native OpenClaw runs on the host and calls NASA's public APOD API
directly.

The setup script sets `agents.defaults.skills` to `["nasa-apod"]` so unrelated
skills are not exposed to this agent.

NASA's public `DEMO_KEY` allows enough calls for a normal demo, but it can be
rate-limited. If the smoke test reports a NASA API rate-limit error, set your
own key before starting:

```bash
export NASA_API_KEY="your-key"
./scripts/start-demo.sh
```
