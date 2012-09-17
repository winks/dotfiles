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
        PPRE="${RED}${EXITCODE}"
        PROMPT="${UC}%n${WHITE}@${HC}%m %40<...<${YELLOW}%3~%<< "
        PPOST="${BBLUE}$ ${NO_COLOUR}"
    else
        PPRE="${BLUE}${EXITCODE}"
        PROMPT="${UC}%n${WHITE}@${HC}%m %40<...<%B${BRED}%3~%b%<< "
        PPOST="${BWHITE}# ${NO_COLOUR}"
    fi
fi

local p="%{$FX[reset]$FG[243]%}"
local name="%{$FX[reset]$FG[114]%}%n"
local host="%{$FX[reset]$FG[117]%}%m"
local jobs="%1(j.(%{$FX[reset]$FG[197]%}%j job%2(j.s.)${p})-.)"
local time="%{$FX[reset]$FG[215]%}%*"
local dir="%{$FX[reset]$FG[105]%}%~"

local last="%(?..%{$FX[reset]$FG[203]%}%??${p}:)"
local hist="%{$FX[reset]$FG[220]%}%!!"
local priv="%{$FX[reset]$FG[245]%}%#"

# Use zshcontrib's vcs_info to get information about any current version control systems.
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%{$FX[reset]$FG[082]%}"
zstyle ':vcs_info:*' unstagedstr "%{$FX[reset]$FG[160]%}"
zstyle ':vcs_info:*' formats ":%{$FX[reset]$FG[222]%}%c%u%b"

local vcsi='${vcs_info_msg_0_}'

setopt prompt_subst
PROMPT="${p}(${name}${p}@${host}${p})-${jobs}(${time}${p})-(${dir}${p}${vcsi}${p})
(${last}${p}${hist}${p}:${priv}${p})- %{$FX[reset]%}"

#PROMPT="${PPRE}${PROMPT}${PPOST}"
#RPROMPT='${vcs_info_msg_0_}'
