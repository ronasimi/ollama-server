# Ollama Local Environment

This directory (`ollama_data`) serves as the persistent storage volume for the local Ollama Docker container, mapping to `/root/.ollama` inside the container. It retains downloaded model weights, manifests, and cache, ensuring models do not need to be redownloaded when the container restarts.

## Hardware Acceleration & Performance
The Docker Compose configuration is heavily optimized for integrated GPU (iGPU) inference[cite: 1]. Key container features include:
* **Vulkan Support:** Enabled via device passthrough (`/dev/dri:/dev/dri`) and the `OLLAMA_VULKAN=1` environment variable[cite: 1].
* **iGPU Optimization:** Explicitly enabled using `OLLAMA_IGPU_ENABLE=1`[cite: 1].
* **Memory & Performance Tweaks:** Utilizes 8-bit quantization for the KV cache (`OLLAMA_KV_CACHE_TYPE=q8_0`) and enables Flash Attention (`OLLAMA_FLASH_ATTENTION=1`) to optimize memory footprint and generation speed[cite: 1].

## Networking
The container exposes the Ollama API on port `11434`[cite: 1]. 
* **Host Binding:** `OLLAMA_HOST=0.0.0.0` allows the API to be accessed from any local network interface[cite: 1].
* **CORS Configuration:** `OLLAMA_ORIGINS="*"` is configured to prevent Cross-Origin Resource Sharing errors, allowing seamless connections from browser-based web applications[cite: 1].

## Custom Models
This environment runs custom local models, specifically tuned for coding tasks with modified context windows:
* **Qwen 2.5 Coder (1.5B):** Base model `qwen2.5-coder:1.5b` configured with a context window of 2,048 tokens (`PARAMETER num_ctx 2048`)[cite: 2].
* **Qwen 2.5 Coder (3B):** Base model `qwen2.5-coder:3b` configured with an extended context window of 8,192 tokens (`PARAMETER num_ctx 8192`)[cite: 3].
