# Inference operations

## Start, inspect and restart

```bash
docker compose up -d
docker compose ps
docker compose logs --tail=100 ollama
docker compose restart ollama
```

Inspect the API:

```bash
curl -fsS http://127.0.0.1:11434/api/version
curl -fsS http://127.0.0.1:11434/api/tags
curl -fsS http://127.0.0.1:11434/api/ps
```

`/api/tags` reports installed models; `/api/ps` reports loaded models. Container health alone does not prove model readiness. Inspect logs and loaded-model details to verify the actual backend and context allocation.

## Image selection

The source preserves the original `latest` image default. Set `OLLAMA_IMAGE` in `.env` to an exact deployed tag or digest when reproducibility is needed. Updating the image is separate from installing this clean source:

```bash
docker compose pull ollama
docker compose up -d ollama
```

## Pi integration

Pi's Compose adds `host.docker.internal:host-gateway` and uses the host-published API. If Pi cannot connect, check the API from the host and from inside Pi:

```bash
cd ~/Projects/pi-docker
docker compose exec -T pi curl -fsS http://host.docker.internal:11434/api/tags
bash scripts/sync-models.sh
```

The Ollama project does not need the MCP network because Pi reaches it through the host port. Keep only one service listening on host port 11434.

## Context and hardware

The supplied defaults enable Vulkan/iGPU settings, flash attention and q8_0 cache, with one parallel request and one loaded model. `/dev/dri` must exist and the container must be able to use it. No throughput or GPU-use claim follows from environment settings alone.

32K is a limit, not a prefill target. Larger prompts still consume time and shared RAM. Pi controls prompt/retrieval budgets and compaction; Ollama owns model execution. Changing server defaults does not rewrite existing model manifests.

## Source lineage

This clean snapshot combines the uploaded Ollama project with its routing-v2 model definition, updates the optional prompt for r24 and aligns concurrency/context defaults with the Pi stack. Models and local image versions may have changed on the host since those source archives were uploaded; their runtime state is preserved by the installer.
