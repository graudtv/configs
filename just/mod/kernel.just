# packages required for building linux kernel
[group('kernel')]
install-kernel-dev-tools: (_pm_install """
  bison
  build-essential
  flex
  libelf-dev
  libncurses5-dev
  libssl-dev
  ncurses-dev
  pahole
  tar
  util-linux
  xz-utils
""")

# additional packages for working with kernel
[group('kernel')]
install-kernel-extra-dev-tools: (_pm_install f"""
  bc
  bpfcc-tools
  bsdextrautils
  clang
  cppcheck
  curl
  exuberant-ctags
  fakeroot
  flawfinder
  gnuplot
  hwloc
  indent
  libnuma-dev
  linux-headers-{{shell('uname -r')}}
  man-db
  net-tools
  numactl
  openssh-server
  perf-tools-unstable
  psmisc
  python3-distutils
  rt-tests
  smem
  sparse
  stress
  sysfsutils
  tldr-py
  trace-cmd
  tree
  tuna
  virt-what
""")
