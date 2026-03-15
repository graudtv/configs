# vim, git, ...
[group('packages')]
install-essential-tools: (_pm_install """
  vim
  git
  wget
""")

# gcc, make, cmake, ...
[group('packages')]
install-build-tools: (_pm_install """
  gcc
  make
  cmake
  ninja-build
""")

# nmon, ncdu, ack, ...
[group('packages')]
install-extra-tools: (_pm_install """
  clang-format
  tmux
  git-lfs
  nmon
  ncdu
  curl
  ack
""") install-autojump install-mosh

[group('packages')]
install-fuse:
  {{distro_is_debian}} && install fuse3 || true

[group('update-packages')]
update-nvim: (_pm_install "wget") install-fuse
  {{sudo}} wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage -O /usr/local/bin/nvim
  {{sudo}} chmod +x /usr/local/bin/nvim

[group('packages')]
install-nvim:
  #!/bin/bash -eu
  if [ -f /usr/local/bin/nvim ]; then
    echo "{{style("command")}}nvim already installed{{NORMAL}}"
  else
    just update-nvim
  fi

[group('packages')]
install-autojump: (_pm_install "autojump")
  #!/bin/bash -eu
  if ! grep -qe '/usr/share/autojump/autojump.sh' ~/.bashrc; then
    echo 'source /usr/share/autojump/autojump.sh' >> ~/.bashrc
  fi

_install_locales locales:
  #!/bin/bash
  set -euo pipefail
  for locale in {{locales}}; do
    if ! locale -a | grep -qe "$locale"; then
      {{sudo}} locale-gen "$locale"
    fi
  done

[group('packages')]
install-mosh: (_pm_install "mosh") (_install_locales "ru_RU.utf8 en_US.utf8")

[group('packages')]
install-all: install-essential-tools install-build-tools install-extra-tools install-nvim
