########################################
## shell settings
########################################

typeset -U fpath
fpath=($Z/functions $fpath)

C=$(tput colors)

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1048576
export SAVEHIST=$HISTSIZE
export HISTTIMEFORMAT="%F %T"

export GIT_EDITOR=vim
export EDITOR=vim
export CVS_RSH=ssh
export RSYNC_RSH=ssh

export PAGER=less
export LESS="-rX" # --quit-at-eof --raw-control-chars --no-init

locale -a | grep 'en_US.utf8' >/dev/null 2>&1 && export LANG='en_US.utf8'

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME="~/.virtualenvs"
    source /usr/local/bin/virtualenvwrapper.sh
fi

export PATH=~/bin:~/code/dotfiles/bin:${PATH}

source /usr/local/share/chruby/chruby.sh
chruby ruby-1.9

export ANDROID_HOME=/opt/src/android/sdk
export TERM="xterm-256color"
