########################################
## shell settings
########################################

# use: __ac_modpath PATH [append] to append/prepend to $PATH without dupes
function __ac_modpath() {
    local item=$1
    local where=$2
    #echo "Checking path '$item' @ $PATH"

    local found=0
    local parts=("${(@s/:/)PATH}")
    for elem in "${parts[@]}"; do
        if [ "$item" = "$elem" ]; then
            found=1
            break
        fi
    done
    if [ "$found" -eq 1 ]; then
        #echo "nope"
        return
    fi
    local retval=""
    local prefix=""
    local postfix=""
    if [ "$where" = "append" ]; then
        postfix=":${item}"
    else
        prefix="${item}:"
    fi

    for elem in "${parts[@]}"; do
        retval="${retval}${elem}:"
    done
    retval="${prefix}${retval:0:-1}${postfix}"

    export PATH="${retval}"
}

typeset -U fpath
fpath=($Z/ext_functions $fpath)

C=$(tput colors)

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1048576
export SAVEHIST=$HISTSIZE
export HISTTIMEFORMAT="%F %T"

export GIT_EDITOR=vim
export EDITOR=vim
export VISUAL=vim
export CVS_RSH=ssh
export RSYNC_RSH=ssh

export PAGER=less
export LESS="-rX" # --quit-at-eof --raw-control-chars --no-init
export GREP_COLORS='mt=01;32'

locale -a | grep 'en_US.utf8' >/dev/null 2>&1 && {
  export LANG='en_US.utf8'
  #export LC_TIME='en_US.utf8'
}

export TERM="xterm-256color"

if [ -d /opt/src/android/sdk ]; then
   export ANDROID_HOME=/opt/src/android/sdk
fi

__ac_modpath "${HOME}/code/dotfiles/bin"
__ac_modpath "${HOME}/bin"

if [ -d "${HOME}/.nix-profile" ] && [ -d "/nix/_node_modules" ]; then
  export NPM_PACKAGES="/nix/_node_modules"
  __ac_modpath "${NPM_PACKAGES}/bin" append
fi

if [ -d "${HOME}/.local/share/man" ]; then
    export MANPATH=${HOME}/.local/share/man:$(manpath -q)
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    export WORKON_HOME="${HOME}/.virtualenvs"
    source /usr/local/bin/virtualenvwrapper.sh
elif [ -f /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]; then
    export WORKON_HOME="${HOME}/.virtualenvs"
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi

export RUST_SRC_PATH=${RUST_SRC_PATH:-"/opt/src/rust/src"}

if [ -d "${HOME}/.cargo/bin" ]; then
  __ac_modpath "${HOME}/.cargo/bin" append
fi
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if [ -d /usr/local/go ]; then
  export GOROOT="/usr/local/go"
fi

if [ -d "${HOME}/code/go" ]; then
  export GOPATH="${HOME}/code/go"
  __ac_modpath "${GOPATH}/bin" append
fi

if [ -f "${HOME}/.nix-profile/share/chruby/chruby.sh" ]; then
    alias my-chruby="source ${HOME}/.nix-profile/share/chruby/chruby.sh; chruby ruby-2.3.0"
elif [ -f "/usr/local/share/chruby/chruby.sh" ]; then
    alias my-chruby="source /usr/local/share/chruby/chruby.sh; chruby ruby-2.3.0"
fi

if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

# https://github.com/taylor/kiex
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

# https://esbuild.github.io/
if [ -e "${HOME}/.local/share/node/node_modules/.bin/esbuild" ]; then
	export MIX_ESBUILD_PATH="$HOME/.local/share/node/node_modules/.bin/esbuild"
fi

# sdkman.io
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# node version manager - https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
