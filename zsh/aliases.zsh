########################################
## aliases
##
alias cp='cp -i -r'
alias df='df -h'
alias du='du -h'
alias dum='du --max-depth=1'
alias gp='git pull'
alias gpp='git pull && git push'
alias ls="/bin/ls -b -CF --color=none"
alias l="ls -lF --color=auto"
alias ll="ls -lhAF --color=auto"
alias px='ps aux | grep -v "ps aux" | grep -v "grep --color" | grep'
alias rm='rm -i'
alias sudo="sudo -H -i"
alias ..="cd .."
alias ...="cd ../.."
which ack >/dev/null 2>&1 && alias ack='ack-grep'
which vim >/dev/null 2>&1 && alias vi='vim'
