#!/bin/bash

SCRIPT_VERSION="1.0.0" UPDATE_URL="https://raw.githubusercontent.com/KTMGv5/LLM-On-Android-beta-/main/install_ollama.sh"

check_for_updates() { echo "Checking for script updates..." remote_version=$(curl -fsSL "$UPDATE_URL" | grep 'SCRIPT_VERSION="' | head -n1 | cut -d'"' -f2)

if [ -z "$remote_version" ]; then
    echo "Could not fetch version info. Skipping update check."
    return
fi

if [ "$remote_version" != "$SCRIPT_VERSION" ]; then
    echo "A new version ($remote_version) is available. Updating..."
    curl -fsSL "$UPDATE_URL" -o "$0"
    chmod +x "$0"
    echo "Update complete. Restarting script..."
    exec "$0"
    exit 0
else
    echo "Running latest version ($SCRIPT_VERSION)."
fi

}

check_for_updates

echo "Installing Termux dependencies and the officially patched Ollama package..." pkg update pkg install -y curl ollama

if [ $? -ne 0 ]; then echo "Ollama package installation failed. Check network or Termux connectivity." exit 1 fi

echo "Ollama installed successfully."

echo "Starting Ollama server for model pull..." ollama serve & > /dev/null 2>&1 OLLAMA_PID=$! sleep 5

SMALL_MODEL="gemma3:270m" echo "Downloading model: $SMALL_MODEL (~292MB)..." ollama pull ${SMALL_MODEL}

if [ $? -ne 0 ]; then echo "Failed to download model ${SMALL_MODEL}." kill $OLLAMA_PID 2>/dev/null exit 1 fi

echo "Model downloaded successfully." kill $OLLAMA_PID 2>/dev/null

echo "Installation complete." echo "---" echo "Usage:" echo "1. Start server: ollama serve" echo "2. Run model: ollama run ${SMALL_MODEL}"
