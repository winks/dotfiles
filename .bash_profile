if [[ $TERM != "screen" ]]; then
    if which tmux > /dev/null 2>&1; then
        test -z ${TMUX} && (tmux attach || tmux) && exit
    fi
fi
which zsh >/dev/null 2>&1 && exec zsh -l
