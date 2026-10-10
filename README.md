<div align="center">

# 🦙 Ollama Server

**Local inference for the Pi stack.**

`Vulkan iGPU` · `32K default context` · `One loaded model` · `One parallel request`

[Quick start](#quick-start) · [Models](#models) · [Operations](docs/OPERATIONS.md)

</div>

This repo runs the Ollama service independently from Pi and the MCP gateway. It retains model weights in the existing `ollama_data` bind mount and supplies an optional WhiteRabbitNeo model definition.

## Quick start

```bash
cd ~/Projects/ollama-server
docker compose up -d
curl -fsS http://127.0.0.1:11434/api/version
docker compose exec -T ollama ollama list
```

Pi reaches this service through the host-published port **11434**. The existing port mapping publishes on host interfaces; the API listens on `0.0.0.0` inside the container.

## Configuration

| Setting | Supplied value | Purpose |
| :--- | :--- | :--- |
| Vulkan/iGPU | enabled | `/dev/dri` device access |
| Flash attention | enabled | Attention configuration |
| KV cache | `q8_0` | Quantized KV storage |
| Default context | 32,768 | Align with Pi's model cap |
| Parallel requests | 1 | Bound concurrent context allocation |
| Loaded models | 1 | Bound model residency |
| Keep alive | `-1` | Retain the loaded model |

These are configured settings; actual acceleration and performance must be checked in Ollama logs on the host. Pi also caps generated model profiles at 32K. An existing model's parameters or a request can differ from the server default.

The Compose image defaults to `ollama/ollama:latest`, matching the recovered project source. To retain an exact deployment image, set `OLLAMA_IMAGE` in `.env` to its tag or digest. Routine `up -d` does not explicitly pull an update.

## Models

Use the models already stored in `ollama_data`. Model preparation and Qwen probes are maintained in `pi-docker` rather than duplicated here.

Optional WhiteRabbitNeo alias:

```bash
docker compose cp Modelfile.whiterabbitneo ollama:/tmp/Modelfile.whiterabbitneo
docker compose exec -T ollama ollama create security-agent:7b -f /tmp/Modelfile.whiterabbitneo
```

Creation can download the configured GGUF source. The definition uses 32K context and a short evidence-oriented system prompt. Pi's current tool contract supplies discovery and invocation details; the obsolete `mcp_search`/`mcp_call` workflow is removed. Recreate the alias only if you use it.

## State and checks

`ollama_data` contains downloaded weights, manifests and cache. Source replacement preserves it. The clean package contains configuration and model definitions, not weights.

```bash
bash scripts/check.sh
docker compose logs --tail=100 ollama
curl -fsS http://127.0.0.1:11434/api/ps
```

The check validates Compose with Docker's parser. API availability, GPU use, model residency and generation remain deployment checks. See [operations](docs/OPERATIONS.md).
