#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

# =========================
# Termux Ollama Setup Script
# =========================

# ---- defaults / config ----
SMALL_MODEL="${SMALL_MODEL:-gemma3:270m}"

# Ollama clients typically expect scheme included
OLLAMA_HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"

START_AT_END="${START_AT_END:-1}"   # 1 = keep server running at end, 0 = stop it
LOG_FILE="${LOG_FILE:-$HOME/ollama-serve.log}"

# ---------- helpers ----------
log()  { printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[x]\033[0m %s\n" "$*" >&2; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "Missing command: $1"; exit 1; }
}

is_termux() {
  [[ -n "${PREFIX:-}" && "${PREFIX}" == */com.termux/* ]]
}

# Real health check: ping the daemon HTTP API
server_running() {
  curl -fsS "${OLLAMA_HOST}/api/version" >/dev/null 2>&1
}

start_server_bg() {
  log "Starting Ollama server (background) on ${OLLAMA_HOST} ..."
  export OLLAMA_HOST

  # Start in background, log output for debugging
  # (nohup is okay, but plain background is often simpler in Termux)
  nohup ollama serve >"$LOG_FILE" 2>&1 &
  OLLAMA_PID=$!

  # Wait for server to be responsive (up to ~30s)
  for i in {1..30}; do
    if server_running; then
      log "Ollama server is up. (pid=${OLLAMA_PID})"
      return 0
    fi
    sleep 1
  done

  err "Ollama server did not become ready. Check logs: $LOG_FILE"
  return 1
}

stop_server_bg() {
  if [[ -n "${OLLAMA_PID:-}" ]] && kill -0 "$OLLAMA_PID" 2>/dev/null; then
    log "Stopping background Ollama server (pid=${OLLAMA_PID}) ..."
    kill "$OLLAMA_PID" 2>/dev/null || true
  fi
}

cleanup() {
  # If START_AT_END=0, stop what we started.
  if [[ "${START_AT_END}" == "0" ]]; then
    stop_server_bg
  fi
}
trap cleanup EXIT
trap 'err "Interrupted."; exit 130' INT

# ---------- sanity checks ----------
if ! is_termux; then
  warn "This script is intended for Termux. Continuing anyway..."
fi

need_cmd pkg

# ---------- 1) Install packages ----------
log "Updating packages..."
pkg update -y

log "Installing dependencies..."
pkg install -y curl

log "Installing ollama (if available in your repo)..."
if ! pkg install -y ollama; then
  err "Failed to install 'ollama' via pkg."
  err "If your repo doesn't provide it, you may need a different install method/build."
  exit 1
fi

need_cmd ollama
need_cmd curl
log "Ollama installed."

# ---------- 2) Ensure server is running (for pulling) ----------
export OLLAMA_HOST

if server_running; then
  log "Ollama server already running; won't start a duplicate server."
  OLLAMA_PID=""
else
  start_server_bg
fi

# ---------- 3) Pull model ----------
log "Pulling model: ${SMALL_MODEL}"
if ! ollama pull "${SMALL_MODEL}"; then
  err "Failed to pull model '${SMALL_MODEL}'."
  err "Check server logs: ${LOG_FILE}"
  exit 1
fi

log "Model '${SMALL_MODEL}' downloaded successfully."

# ---------- 4) Finish ----------
echo
log "Setup complete."
echo "----------------------------------------"
echo "Model:          ${SMALL_MODEL}"
echo "Host:           ${OLLAMA_HOST}"
echo "Server log:     ${LOG_FILE}"
echo "----------------------------------------"
echo

if [[ "${START_AT_END}" == "1" ]]; then
  if server_running; then
    log "Leaving Ollama server running."
  else
    start_server_bg
    log "Leaving Ollama server running."
  fi

  echo "Try it now:"
  echo "  ollama run ${SMALL_MODEL}"
else
  log "Server will be stopped (START_AT_END=0)."
  echo "To start later:"
  echo "  ollama serve"
  echo "To run:"
  echo "  ollama run ${SMALL_MODEL}"
fi
