# Some helper utilities

get_user_consent() {
    local prompt=$1
    read -p "$prompt (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}

install_file() {
    local src=$1
    local dst=$2
    local force=$3
    local symlink=$4

    if [ -z "$force" ] && [ -f "$dst" ] && \
       ! get_user_consent "Override existing file $dst?"; then
        echo "Installation interrupted"
        exit 1
    fi
    # $PWD is used as a workaround for realpath or readlink -f, because they
    # are not available on Mac OS by default
    src="$PWD/$src"
    if [ -z $symlink ]; then # install by copy
        install "$src" "$dst"
    else
        ln -sf "$src" "$dst"
    fi
}

print_default_usage() {
    local target=$1
    echo "This script automatically installs some keybindings and plugins for $target"
    echo "Options: "
    echo "  -f, --force                 # override existing $target config"
    echo "  -s, --symlink               # install config files as symlinks to files in this repo"
    echo "  -h, --help                  # print this help message"
}

# exports $opt_force and $opt_symlink
parse_default_options() {
    local target=$1; shift
    while [ $# != 0 ]; do
        case "$1" in
        "-f" | "--force") opt_force=1 ;;
        "-s" | "--symlink") opt_symlink=1 ;;
        "-h" | "--help") print_default_usage $target; exit ;;
        *) echo "$0: unknown option '$1'"; exit 1 ;;
        esac
        shift
    done
}