# Clean Instance Prerequisites

This repo is intended to work on a fresh DGX Spark / Ubuntu host. The scripts
track and install host prerequisites where possible.

| Requirement | Why it is needed | Installed by |
|---|---|---|
| Ubuntu with `sudo` | First-time package and service setup | Manual host requirement |
| `git`, `curl`, `ca-certificates`, `lsof`, `python3`, `zstd` | Repo checkout, APOD API calls, HTTP checks, service management, Ollama tar extraction | `scripts/install-host-prereqs.sh` |
| Node.js 22+ and npm | Native OpenClaw CLI runtime | `scripts/install-host-prereqs.sh` via `nvm` if needed |
| OpenClaw CLI | Native agent, gateway, dashboard, model config, and skills | `scripts/install-host-prereqs.sh` via pinned `openclaw@2026.5.12`; override with `OPENCLAW_CLI_VERSION` |
| Ollama 0.22.1 | Local model runtime on DGX Spark / GB10 | `scripts/install-ollama.sh` |
| `qwen3.6:27b` Ollama model | Default local model for this OpenClaw APOD template | `scripts/ensure-model.sh` |
| Internet access to `api.nasa.gov` | Fetches NASA APOD data | Manual network requirement |
| Browser or SSH tunnel | To open the OpenClaw dashboard from another machine | Manual |

Optional:

- `NASA_API_KEY` if the public NASA `DEMO_KEY` is rate-limited.

Not required for this OpenClaw-only version:

- NemoClaw
- OpenShell
- Docker
- NVIDIA Container Toolkit
- vLLM
- Hugging Face token
- Attached display
