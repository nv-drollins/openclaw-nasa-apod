# Agent Notes

This is an OpenClaw-only NASA APOD demo. It intentionally does not install or
use NemoClaw, OpenShell, Docker, vLLM, a browser automation stack, or any GPU
container runtime.

The local model path defaults to:

```text
ollama/qwen3.6:27b
```

The demo skill calls:

```text
https://api.nasa.gov/planetary/apod
```

Use live API calls through `curl`; do not answer from memory for APOD content.
The public `DEMO_KEY` is enough for normal demo use. If `NASA_API_KEY` is set,
use it instead.

