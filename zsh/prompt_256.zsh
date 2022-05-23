########################################
## the prompt code in grml isn't really
##  pretty, so copy and adapt
########################################

EXITCODE="%(?..%?%1v )"
PS2='\`%_> '      # secondary prompt, printed when the shell needs more information to complete a command.
PS3='?# '         # selection prompt used within a select loop.
PS4='+%N:%i:%_> ' # the execution trace prompt (setopt xtrace). default: '+%N:%i>'

# don't use colors on dumb terminals (like emacs):
if [[ "$TERM" == dumb ]] ; then
    PROMPT="${EXITCODE}%n@%m %40<...<%B%~%b%<< "
else
    if [[ "x$UC" == "x" ]] ; then
        UC=$WHITE
    fi
    if [[ "x$HC" == "x" ]] ; then
        HC=$CYAN
    fi
    # This assembles the primary prompt string
    if (( EUID != 0 )); then
        PPRE="[a]${RED}${EXITCODE}"
        PROMPT="[b]${UC}%n${WHITE}@${HC}%m %40<...<${YELLOW}%3~%<< "
        PPOST="[c]${BBLUE}$ ${NO_COLOUR}"
    else
        PPRE="[a]${BLUE}${EXITCODE}"
        PROMPT="[b]${UC}%n${WHITE}@${HC}%m %40<...<%B${BRED}%3~%b%<< "
        PPOST="[c]${BWHITE}# ${NO_COLOUR}"
    fi
fi

if [ -n "$ZSH_HOSTNAME" ]; then
  hostname="${ZSH_HOSTNAME}"
else
  hostname="%m"
fi
shortname=${HOSTNAME%%.*}

if [ -n "$HOSTCOLOR" ]; then
  hostcolor="$HOSTCOLOR";
else
  hostname_crc=$(echo $HOSTNAME | tr 'A-Z' 'a-z' | cksum)
  hostname_crc=${hostname_crc%% *}
  hostcolor=$(( 0x${hostname_crc} % 8 + 104 ))

  hostname_crc=$(echo $HOSTNAME | tr 'A-Z' 'a-z' | cksum | cut -c-10)
  hostcolor=$(($hostname_crc % 8))
fi
if [ -n "$USERCOLOR" ]; then
  usercolor="$USERCOLOR";
else
  usercolor="220"
fi

if [ -n "$ZSH_USERNAME" ]; then
  username="${ZSH_USERNAME}"
else
  username="%n"
fi

local px="%{$FX[reset]$FG[243]%}"
local name="%{$FX[reset]$FG[$usercolor]%}${username}"
local host="%{$FX[reset]$FG[$hostcolor]%}${hostname}"
local dir="%{$FX[reset]$FG[215]%}%3~"
local sign="%{$FX[reset]$FG[117]%}$"

# Use zshcontrib's vcs_info to get information about any current version control systems.
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%{$FX[reset]$FG[082]%}"
zstyle ':vcs_info:*' unstagedstr "%{$FX[reset]$FG[197]%}"
zstyle ':vcs_info:*' formats ":%{$FX[reset]$FG[222]%}%c%u%b"

#if [[ "$LC_PUTTY" -eq 1 ]]; then

setopt prompt_subst

PROMPT='$(check_last_exit_code λ)${px}(${name}${px}@${host}${px} ${dir}${px}${vcs_info_msg_0_}${px}) ${sign} %{$FX[reset]%}'
RPROMPT='$(check_last_exit_code)'
