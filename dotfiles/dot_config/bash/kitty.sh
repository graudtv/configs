[ "$TERM" = "xterm-kitty" ] || return

alias set-window-title="kitten @ set-window-title"
alias tabname=$HOME/scripts/kitty/tabname
alias lssh="$(which ssh)"
alias ssh="kitten ssh"

alias ksession="$HOME/.config/kitty/scripts/ksession"
alias ks=ksession
eval "$(ksession --completion-bash)"
