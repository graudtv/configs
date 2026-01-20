cd "$(dirname "$0")"
source ../impl/helpers.sh

CONFDIR="${HOME}/.config/nvim"

find_neovim() {
  type nvim >&/dev/null && { echo "nvim"; return; }
  type nv >&/dev/null && { echo "nv"; return; }
  echo "Failed to find neovim. Is it installed?"
}


parse_default_options nvim $@
install_file init.lua "${CONFDIR}/init.lua" "$opt_force" "$opt_symlink"
install_file lua/nvutils.lua "${CONFDIR}/lua/nvutils.lua" "$opt_force" "$opt_symlink"
install_file nvim-pack-lock.json "${CONFDIR}/nvim-pack-lock.json" "$opt_force" "$opt_symlink"
"$(find_neovim)" -c "qall"

echo "Configuration installed. Now you can run nvim"