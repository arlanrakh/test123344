#!/bin/bash

echo "Downloading Qwen3 600M model for offline translation..."
echo "This may take a few minutes depending on your internet speed."

# Create a models directory
mkdir -p models

# Download the model
curl -L -o models/qwen3-600m.gguf \
  "https://huggingface.co/Cactus-Compute/Qwen3-600m-Instruct-GGUF/resolve/main/Qwen3-0.6B-Q8_0.gguf"

if [ $? -eq 0 ]; then
    echo "✅ Model downloaded successfully to models/qwen3-600m.gguf"
    echo "File size: $(ls -lh models/qwen3-600m.gguf | awk '{print $5}')"
else
    echo "❌ Failed to download model. Please check your internet connection."
    exit 1
fi