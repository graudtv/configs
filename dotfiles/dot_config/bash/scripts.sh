hide() { mv "$1" "..$1"; }
unhide() { mv "$1" "${1#..}"; }

# rust run
rr() { rustc "$1" && "$(realpath ${1%.*})"; }

aider-chat() (
  TMPDIR=$(mktemp -d /tmp/randdir.XXXXXX)
  if [ $? -ne 0 ]; then
    echo "Failed to create temporary directory"
    return 1
  fi

  cd "$TMPDIR" || { echo "Failed to cd to $TMPDIR"; return 1; }

  aider --no-git --edit-format=ask "$@"
  rm -rf "$TMPDIR"
)

kilo-chat() (
  TMPDIR=$(mktemp -d /tmp/randdir.XXXXXX)
  if [ $? -ne 0 ]; then
    echo "Failed to create temporary directory"
    return 1
  fi

  cd "$TMPDIR" || { echo "Failed to cd to $TMPDIR"; return 1; }

  kilo
  rm -rf "$TMPDIR"
)

