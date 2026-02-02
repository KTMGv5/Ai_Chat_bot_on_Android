# Ollama on Android (Termux)

![Platform](https://img.shields.io/badge/platform-Android-green)
![Environment](https://img.shields.io/badge/environment-Termux-blue)
![CPU](https://img.shields.io/badge/CPU-ARM64%20%7C%20ARMv7-lightgrey)
![LLM](https://img.shields.io/badge/LLM-Ollama-purple)
![Status](https://img.shields.io/badge/status-experimental-orange)

Run **Ollama LLMs locally on Android** using **Termux**.

Minimal installer for mobile CPUs with optional automatic server startup.

---

## 🚀 Quick Install

    curl -fsSL https://raw.githubusercontent.com/KTMGv5/Ai_Chat_bot_on_Android/refs/heads/main/install_ollama.sh -o install_ollama.sh
    chmod +x install_ollama.sh
    ./install_ollama.sh

---

## ⚙️ Optional Configuration

Change behavior without editing the script:

    SMALL_MODEL=llama3.2:1b ./install_ollama.sh

    START_AT_END=0 ./install_ollama.sh

    LOG_FILE=$HOME/ollama.log ./install_ollama.sh

---

## 💡 Usage

If the server is running:

    ollama run gemma3:270m

Manual mode (two sessions):

Session 1:
    ollama serve

Session 2:
    ollama run gemma3:270m

---

## 📱 Device Compatibility

| Device / Class        | CPU Architecture | Android Version | Status        | Notes                              |
|-----------------------|------------------|-----------------|---------------|------------------------------------|
| Generic ARM64 Phones  | ARM64 (aarch64)  | Android 10+     | ✅ Works      | Recommended                         |
| Older ARMv7 Devices  | ARMv7            | Android 8–9     | ⚠️ Limited    | Smaller models only                |
| Low-RAM Devices      | ARM64 / ARMv7    | Android 9+      | ⚠️ Limited    | Expect slow inference              |
| x86 / x86_64         | x86              | Any             | ❌ Unsupported| Termux + Ollama not supported      |

---

## 📝 Notes

- Mobile devices are limited by RAM, thermals, and battery
- Smaller models are strongly recommended
- Close background apps for best performance

---

## 📜 License

Provided as-is for research and experimentation.

Ollama and downloaded models are subject to their respective licenses.
