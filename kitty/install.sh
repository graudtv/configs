#!/usr/bin/env bash
set -euo pipefail && cd "$(dirname "$0")" && source ../impl/helpers.sh

CONFDIR="${HOME}/.config/kitty"

parse_default_options nvim "$@"
install_file "files-kitty/kitty.conf" "${CONFDIR}/kitty.conf"
install_file "files-kitty/default.conf" "${CONFDIR}/default.conf"
install_file "files-kitty/current-theme.conf" "${CONFDIR}/current-theme.conf"