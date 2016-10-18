if [[ $TERM != "screen" ]]; then
    if which tmux > /dev/null 2>&1; then
        test -z ${TMUX} && (tmux -2 attach || tmux -2) && exit
    fi
fi
which zsh > /dev/null 2>&1 && exec zsh -l

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [ -e /home/florian/.nix-profile/etc/profile.d/nix.sh ]; then . /home/florian/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
