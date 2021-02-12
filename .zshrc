########################################
##  .zshrc.local to complement
##    grml's .zshrc
##    by fa[at]art-core.org
## ported from .bashrc 0.91, 2011-08-09
########################################
## 2021-02-03
my_version='1.5'
########################################
#set -x

Z=~/code/dotfiles/zsh

## host-specific stuff, purely optional
if [ -f ~/.config/art-core/.profile.pre ]; then
    source ~/.config/art-core/.profile.pre
fi

## grml defaults
#source ${Z}/zshrc.base
## environment
source $Z/environment.zsh
## aliases
source $Z/aliases.zsh
## options
source $Z/options.zsh
## functions
source $Z/functions.zsh
## completion
source $Z/completion.zsh

## prompt
source $Z/prompt_256.zsh

## host-specific stuff, purely optional
if [ -f ~/.config/art-core/.profile.post ]; then
    source ~/.config/art-core/.profile.post
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
