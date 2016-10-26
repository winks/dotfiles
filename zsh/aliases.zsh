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
which ack >/dev/null 2>&1 && alias ack='ack-grep'
which vim >/dev/null 2>&1 && alias vi='vim'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias weather="curl -4 wttr.in/muc"

# laptop
alias tpdisable="synclient TouchPadOff=1; xset m 1/8 40"
alias tpenable="synclient TouchPadOff=0; xset m 1/8 40"

alias touchpadoff="echo Use tpdisable && tpdisable"
alias touchpadon="echo Use tpenable && tpenable"

# gui
alias acxm="ac xm"
alias actr="ac tr"
alias acb="ac b"

# dev
alias gp='git pull'
alias gpp='git pull && git push'
alias gps='git stash && git pull && git push && git stash apply'
alias puppet_u='vagrant up puppet --provision-with shell,puppet'
alias puppet_p='vagrant provision puppet --provision-with shell,puppet'
