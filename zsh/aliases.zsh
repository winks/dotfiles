########################################
## aliases
##

# general
alias cp='cp -i -r'
alias df='df -h'
alias du='du -h'
alias dum='du --max-depth=1'
alias grep='grep --color'
alias ls="/bin/ls -b -CF --color=none"
alias l="ls -lF --color=auto"
alias ll="ls -lhAF --color=auto"
alias rm='rm -i'
alias today='cal | sed "s/.*/ & /;s/ $(date +%e) / [] /"'
alias ..="cd .."
alias ...="cd ../.."
alias hexfind='grep --color="auto" -P -n "[\x80-\xFF]"'
which vim >/dev/null 2>&1 && alias vi='vim'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias weather="curl -4 wttr.in/muc"
alias psthread='ps -e -T -eo pcpu,pid,tid,args,comm'

[ -f "$HOME/code/dotfiles/multitail.conf" ] && {
  alias multitail="multitail --config $HOME/code/dotfiles/multitail.conf"
}

# laptop
alias tpdisable="synclient TouchPadOff=1; xset m 1/8 40"
alias tpenable="synclient TouchPadOff=0; xset m 1/8 40"

[ -f "$HOME/.config/i3/config" ] && {
  alias i3cheatsheet="egrep ^bind $HOME/.config/i3/config | cut -d ' ' -f 2- | sed 's/ /\t/' | column -ts $'\t' | pr -2 -w 145 -t | less"
}
