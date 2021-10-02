target="tmux"
config_src=$(dirname "$0")/"tmux.conf"
config_dst="${HOME}/.tmux.conf"

source impl/install-target.sh

parse_options $@
install_target