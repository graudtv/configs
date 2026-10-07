[ -f "$HOME/Documents/GitHub/econf/econf.sh" ] || return

source "$HOME/Documents/GitHub/econf/econf.sh"
alias ec=econf
complete -F __econf_complete ec
