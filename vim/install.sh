target="vim"
config_src=$(dirname "$0")/"vimrc"
config_dst="${HOME}/.vimrc"

source impl/install-target.sh

install_vimplug() {
	[ -e "${HOME}/.vim/autoload/plug.vim" ] && return

	# installing https://github.com/junegunn/vim-plug according to instruction
	echo "Installing vim-plug plugin..."
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "Now please open vim and print :PlugInstall to finish installation"
    echo "Note. Some errors should be displayed during first vim opening, it's ok! Just ignore them and press Enter, as vim suggests, then run command above"
}

parse_options $@
install_target
install_vimplug