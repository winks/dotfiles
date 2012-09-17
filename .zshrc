########################################
##  .zshrc.local to complement
##    grml's .zshrc
##    by fa[at]art-core.org
## ported from .bashrc 0.91, 2011-08-09
########################################
## 2012-09-17
my_version='1.2'
########################################
#set -x

Z=~/code/dotfiles/zsh

## grml defaults
#source ${Z}/zshrc.base
## environment
source $Z/environment.zsh
## aliases
source $Z/aliases.zsh
## options
source $Z/options.zsh
source $Z/functions.zsh

my_uname=`which uname`
## host-specific stuff, purely optional
if [ -f ~/.ssh/.profile.host ]; then
#    source ~/.ssh/.profile.host
fi

## prompt
if (( C == 256 )); then
    source $Z/prompt_256.zsh
else
    source $Z/prompt_256.zsh
fi
