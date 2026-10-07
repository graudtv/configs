#!/usr/bin/env bash
set -euo pipefail && cd "$(dirname "$0")" && source ../impl/helpers.sh

CONFDIR="${HOME}/.config/nvim"

find_neovim() {
  type nvim >&/dev/null && { echo "nvim"; return; }
  type nv >&/dev/null && { echo "nv"; return; }
  echo "Failed to find neovim. Is it installed?"
  exit 1
}

parse_default_options nvim "$@"
install_files_recursive "../dotfiles/dot_config/nvim" "$CONFDIR"
install_bash_config_snippet "../dotfiles/dot_config/bash/editor-is-nvim.sh"
"$(find_neovim)" -c "qall"

echo "Configuration installed. Now you can run nvim"