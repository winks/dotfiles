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
export GREP_COLOR='1;32'

locale -a | grep 'en_US.utf8' >/dev/null 2>&1 && export LANG='en_US.utf8'

export GOROOT=/usr/local/go
export PATH=~/bin:~/code/dotfiles/bin:${PATH}:${GOROOT}/bin
export TERM="xterm-256color"

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME="~/.virtualenvs"
    source /usr/local/bin/virtualenvwrapper.sh
fi

if [ -f /usr/local/share/chruby/chruby.sh ]; then
    source /usr/local/share/chruby/chruby.sh
    chruby ruby-1.9
fi

if [ -d /opt/src/android/sdk ]; then
   export ANDROID_HOME=/opt/src/android/sdk
fi

if [ -f ~/.config/art-core/.profile_local ]; then
    source ~/.config/art-core/.profile_local
fi

export PATH=~/bin:~/code/dotfiles/bin:$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PYTHONPATH=$PYTHONPATH:$HOME/code/topaz/pypy
