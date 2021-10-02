target="tmux"
config_src=$(dirname "$0")/"tmux"
config_dst="${HOME}/.tmux"

source impl/install-target.sh

parse-options $@
install-target