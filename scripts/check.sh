#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
docker compose config --quiet
printf 'Ollama Compose configuration passed. Live API and inference checks are separate.\n'
