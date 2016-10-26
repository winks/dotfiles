autoload -Uz compinit && compinit

#zstyle ':completion:*' special-dirs true

# autocomplete ssh
local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts


