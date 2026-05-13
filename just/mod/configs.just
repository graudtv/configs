[group('configuration')]
configure-all: configure-vim configure-nvim configure-kitty

# Install and configure vim
[group('configuration')]
configure-vim: (_pm_install "vim")
    "{{justfile_directory()}}/configure" vim --symlink

# Install and configure nvim
[group('configuration')]
configure-nvim: install-nvim
    "{{justfile_directory()}}/configure" nvim --symlink

# Install and configure kitty
[group('configuration')]
configure-kitty: install-kitty
    "{{justfile_directory()}}/configure" kitty --symlink
