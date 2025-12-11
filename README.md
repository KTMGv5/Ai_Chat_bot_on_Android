# Ollama Installation Script for Termux (Android)

This script automates the installation of **Ollama** and a lightweight Language Model (LLM) on Android devices via the Termux environment.

This is ideal for running efficient large language models directly on mobile CPUs.

## ✨ Features

* **One-Step Setup:** Downloads and installs the patched version of Ollama available in the Termux package repository.
* **Minimal Model Download:** Automatically pulls the specific, efficient model **`gemma3:270m`**, which is optimized for mobile CPU usage.
* **Clean Operation:** The script manages the server startup, model download, and clean shutdown of the temporary background service.

## 🚀 Installation

Follow these steps to quickly get Ollama running on your Android device using Termux.

### Prerequisites

You must have the [Termux application](https://termux.dev/) installed on your Android device.

### Execution

1.  **Download the script:**
    ```bash
    curl -fsSL https://raw.githubusercontent.com/KTMGv5/LLM-On-Android-beta-/refs/heads/main/install_ollama.sh -o install_ollama.sh
    ```

2.  **Make it executable:**
    ```bash
    chmod +x install_ollama.sh
    ```

3.  **Run the installation:**
    ```bash
    ./install_ollama.sh
    ```

The script will update packages, install dependencies, and download the `gemma3:270m` model.

> **Note on Model:** The included model, `gemma3:270m`, is specific to this project's configuration. If you encounter errors, you may need to substitute it for a publicly available model like `gemma:2b` or `phi3:3.8b-mini-128k-instruct-q4_0`.

## 💡 Usage

Running Ollama requires two steps, which you will typically perform in two separate Termux sessions:

### 1. Start the Ollama Server (Session 1)

Ollama runs as a server process. Open your first Termux session and run the following command. You must keep this session running in the background.
```bash
ollama serve
```
Open a new Termux session (swipe from the left edge of the screen to open the session menu) and use the run command to start interacting with the model.
```bash
ollama run gemma3:270m
