#!/usr/bin/env bash
set -euo pipefail && cd "$(dirname "$0")" && source ../impl/helpers.sh

parse_default_options tmux "$@"
install_file tmux.conf "${HOME}/.tmux.conf"