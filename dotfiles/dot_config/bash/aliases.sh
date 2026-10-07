alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

alias activate="source .venv/bin/activate"
alias cdc="cd && clear"
alias py="python3"
alias vimr="vim -R"
alias ssh-dev="sshpass -p root ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ServerAliveInterval=30 -o User=root"
alias rp="realpath"
alias hl="grep -C999999 --color=always"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

maybe_alias "$HOME/scripts/vsel"
maybe_alias "$HOME/Documents/GitHub/dvm/dvm"

[ -d "$HOME/.config/kickstart-nvim" ] && alias kickstart-nvim='NVIM_APPNAME=kickstart-nvim nvim'
