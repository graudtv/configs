cd "$(dirname "$0")"
source ../impl/helpers.sh

parse_options tmux $@
install_target tmux.conf "${HOME}/.tmux.conf" $opt_force $opt_symlink