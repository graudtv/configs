#!/usr/bin/env bash
set -euo pipefail && cd "$(dirname "$0")" && source ../impl/helpers.sh

if version="$(just --version 2>/dev/null)"; then
  echo "just already installed: $version ($(command -v just))"
elif ! [ -f "$HOME/.local/bin/just" ]; then
  mkdir -p "$HOME/.local/bin"
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$HOME/.local/bin/"
fi

install_bash_config_snippet "files-bash/just.sh"
