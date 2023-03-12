cd "$(dirname "$0")"
source ../impl/helpers.sh

install_plugins() {
    if ! [ -e "${HOME}/.vim/autoload/plug.vim" ]; then
      # installing https://github.com/junegunn/vim-plug according to instruction
      echo "Installing vim-plug plugin..."
      curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    echo
    echo "Now please open vim and print :PlugInstall to finish installation"
    echo "Note. Some errors will be displayed during first vim opening, it's ok! Just ignore them and press Enter, as vim suggests, then run command above"
}

parse_default_options vim $@
install_file vimrc "${HOME}/.vimrc" "$opt_force" "$opt_symlink"
install_file config.vim "${HOME}/.vim/config.vim" "$opt_force" "$opt_symlink"
install_plugins