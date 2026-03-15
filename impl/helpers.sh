# Some helper utilities

OPT_FORCE=
OPT_SYMLINK=

get_user_consent() {
    local prompt=$1
    read -p "$prompt (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}

is_same_file() {
    local src="$1"
    local dst="$2"
    [ -n "$OPT_SYMLINK" ] \
        && [ -L "$dst" ] \
        && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ] \
        && return
    [ -z "$OPT_SYMLINK" ] \
        && [ -f "$dst" ] \
        && ! [ -L "$dst" ] \
        && diff -q "$src" "$dst" >/dev/null 2>&1 \
        && return
    return 1
}

install_file() {
    local src="$1"
    local dst="$2"

    if [ -z "$OPT_FORCE" ] && ! is_same_file "$src" "$dst" \
            && ! get_user_consent "Override existing file $dst?"; then
        echo "Installation interrupted"
        exit 1
    fi

    # $PWD is used as a workaround for realpath or readlink -f, because they
    # are not available on Mac OS by default
    src="$PWD/$src"
    mkdir -p "$(dirname "$dst")"
    if [ -z "$OPT_SYMLINK" ]; then # install by copy
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

# Exports $OPT_FORCE and $OPT_SYMLINK
parse_default_options() {
    local target=$1; shift

    while [ $# != 0 ]; do
        case "$1" in
        "-f" | "--force") OPT_FORCE=1 ;;
        "-s" | "--symlink") OPT_SYMLINK=1 ;;
        "-h" | "--help") print_default_usage "$target"; exit ;;
        *) echo "$0: unknown option '$1'"; exit 1 ;;
        esac
        shift
    done
}

# Install bash snippet into ~/.config/bash and source it from '~/.bashrc':
install_bash_config_snippet() {
    local snippet="$1"
    local snippet_name="$(basename "$1")"

    install_file "$snippet" "$HOME/.config/bash/$snippet_name"

    if ! grep -qF "source \"\$HOME/.config/bash/$snippet_name\"" ~/.bashrc; then
      echo "source \"\$HOME/.config/bash/$snippet_name\"" >> ~/.bashrc
      echo "Note: you might need to run 'source ~/.bashrc' to configure current shell"
    fi
}