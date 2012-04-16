[[ $TERM != "screen" ]] && which tmux >/dev/null 2>&1 && exec tmux && exit
which zsh >/dev/null 2>&1 && exec zsh -l
