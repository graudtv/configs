[group('configuration')]
configure-all: configure-vim configure-nvim

# Install and configure vim
[group('configuration')]
configure-vim: (_pm_install "vim")
    "{{justfile_directory()}}/configure" vim --symlink

# Install and configure nvim
[group('configuration')]
configure-nvim: install-nvim
    "{{justfile_directory()}}/configure" nvim --symlink

