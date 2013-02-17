# ~/.bashrc: executed by bash(1) for non-login shells.

##########################################
##                                      ##
##    .bashrc by fa[at]art-core.org     ##
##                                      ##
##########################################
##      2011-08-09
my_version='0.91'
##########################################
##                                      ##
##    many ideas by Moshe Jacobsen      ##
##    (http://runslinux.net)            ##
##    and Emmanuel Rouat                ##
##########################################

##########################################
## configuration
##
tabcomp=1

##########################################
## aliases
##
alias ls='ls -h --color=none';
alias l='ls -Fl --color=always';
alias ll='l -Al'
alias less='less -R'
alias mkdir='mkdir -p'
alias vi='my_vim'
alias ci='my_vim'
alias df='df -h'
alias du='du -h'
alias dum='du --max-depth=1'
alias grep='grep --color=always'
alias grepnc='grep --color=none'
alias px='ps aux|grep'
alias cp='cp -i -r'
alias rm='rm -i'
alias ..='cd ..'
alias die='kill -9'
alias su='su -'
alias sudo='sudo -i'
alias gp='git pull'
alias gpp='git pull && git push'
ack 2> /dev/null | alias ack='ack-grep'

export TERM='xterm'
my_uname=`which uname`

##########################################
## tab completion
##

if [ "$my_uname" = 'FreeBSD' ]; then
    my_file_comp='/usr/local/etc/bash_completion';
else
    my_file_comp='/etc/bash_completion';
fi

if [[ "$tabcomp" -eq "1" && -f `which pear > /dev/null 2>&1` ]]; then 
    complete -W "`pear 2>&1 | awk '{ORS=" "} /[a-zA-Z-]+ / {print $1}'`" -f pear
    #complete -W "`apt-get 2>&1 | awk '{ORS=" "} /(^   [a-z])([a-zA-Z-]*)( - )/ {print $1}'`" -f apt-get
fi
if [[ "$tabcomp" -eq "1" && -f "$my_file_comp" ]]; then 
    source $my_file_comp
fi
if [[ "$tabcomp" -eq "1" ]]; then 
    my_ssh_comp_config="a"
    my_ssh_comp_known="b"
    if [[ -f $HOME"/.ssh/config" ]]; then
        my_ssh_comp_config=`cat ~/.ssh/config | awk '/Host / { print $2 }'`
    fi
    if [[ -f $HOME"/.ssh/config" ]]; then
        my_ssh_comp_known=`cat ~/.ssh/known_hosts | awk '/ssh-/ { print $1 }' | cut -d ',' -f1 |  grep --color=none "^[a-z]" | uniq`
    fi
    if [[ "x${my_ssh_comp_config}${my_ssh_comp_known}" != "xab" ]]; then
        complete -W "$(echo ${my_ssh_comp_config}" "${my_ssh_comp_known})" ssh
    fi
fi

##########################################
## misc settings
##

# No beeping
set bell-style visible
# Tab once for complete
set show-all-if-ambiguous on
# Show file info in complete
set visible-stats on
# Do not attempt completion on an empty line
shopt -s no_empty_cmd_completion
# correct minor spelling errors in a cd command
shopt -s cdspell
# cause multi-line commands to be appended to your bash history as a single line command
shopt -s cmdhist
# history expansion (the !something) allows to edit the expanded line before executing
shopt -s histverify
# disables the use of Ctrl-D to exit the shell
set -o ignoreeof
# let screen be resumed with any key
`which tty` > /dev/null 2>&1 && `which stty` ixany


##########################################
## bash colors
##
black='\033[0;30m'
dark_gray='\033[1;30m'
red='\033[0;31m'
light_red='\033[1;31m'
green='\033[0;32m'
light_green='\033[1;32m'
brown='\033[0;33m'
yellow='\033[1;33m'
blue='\033[0;34m'
light_blue='\033[1;34m'
purple='\033[0;35m'
light_purple='\033[1;35m'
cyan='\033[0;36m'
light_cyan='\033[1;36m'
light_gray='\033[0;37m'
white='\033[1;37m'
nocolor='\033[0m'

##########################################
## Get hostnames
##
my_host_f=$(hostname -f 2>/dev/null || hostname)
my_host_s=$(hostname -s 2>/dev/null || hostname)

##########################################
## host- and user-specific actions
##
HOST=$my_host_f;
HC=$brown;

case $USER in
 root)  UC=$light_red;  PR="\[$light_blue\] # \[$nocolor\]"; ;;
 *)     UC=$white;      PR="\[$light_blue\] $ \[$nocolor\]"; ;;
esac

if [ -f ~/.ssh/.bashrc.hosts ]; then
    source ~/.ssh/.bashrc.hosts
fi


##########################################
##  functions
##
function greps() {
    grep -r "$1" "$2" | grep -v ".svn" | grep -v "lib/vendor/symfony" | grep -v "web/system/"
}

function settitle() {
    printf "\033]2;$*\a"
}

function my_vim() {
    vim "$@";
    settitle "${my_host_f}: `pwd`";
}

function my_vers() {
    echo -e ${yellow}".bashrc by fa, version "${light_red}${my_version}${nocolor} >&2;
}

# find something
function ff() {
    find . -type f -iname '*'$*'*' -ls;
}

# find and grep
function ffg() {
    find . -exec grep $* '{}' \; -print ;
}

function w500bat {
    bat="/sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/"
    full="energy_full"
    now="energy_now"

    _full=$( cat ${bat}${full} )
    _now=$( cat ${bat}${now} )
    fillint=`echo "scale=0; $_now*100/$_full" | bc`
    fillfloat=`echo "scale=2; $_now*100/$_full" | bc`

if [[ "$1" = '-v' ]]; then
echo $_full
echo $_now
fi

    if [[ "$fillint" -ge 75 ]]; then
        echo -n -e "${light_green}"
    elif [[ "$fillint" -ge 25 ]]; then
        echo -n -e "${yellow}"
    else
        echo -n -e "${light_red}"
    fi

    echo -e "Battery: $fillint % remaining ${nocolor}"
}

# get current host related info
function ii() {
    local O_LANG=$LANG
    local O_LC_ALL=$LC_ALL
    local MY_IF=$(/sbin/ifconfig | awk '/Link / { print $1 } ')

    LANG=C
    LC_ALL=C

    echo -e "\n${nocolor}You are logged in to ${light_red}${HOST}${nocolor} - $(date)"
    echo -e "\n${light_red}Kernel version:${nocolor} " ; uname -a
    echo -e "\n${light_red}Users logged on:${nocolor} " ; w -h
    echo -e "\n${light_red}Machine stats :${nocolor} " ; uptime
    echo -e "\n${light_red}Memory stats :${nocolor} " ; free -m
    for my_if in $MY_IF; do
        echo -e "\n${light_red}Interface $my_if :${nocolor}" ;
        /sbin/ifconfig $my_if | awk '/inet / { print $2 } ' | cut -d ":" -f 2
        /sbin/ifconfig $my_if | awk '/inet6 / { print $3 } '
        /sbin/ifconfig $my_if | awk '/TX b/ { print "TX " $3 $4 " RX " $7 $8 } '
    done
    echo
    LANG=$O_LANG
    LC_ALL=$O_LC_ALL
}

function my_colors() {
    local o="$white""("
    local c="$white"")"
    echo -e "$nocolor"
    echo -e "$o""$black"black_____"$c""$o""$dark_gray"dark_gray___"$c"
    echo -e "$o""$light_gray"light_gray"$c""$o""$white"white_______"$c"
    echo -e "$o""$red"red_______"$c""$o""$light_red"light_red___"$c"
    echo -e "$o""$green"green_____"$c""$o""$light_green"light_green_"$c"
    echo -e "$o""$blue"blue______"$c""$o""$light_blue"light_blue__"$c"
    echo -e "$o""$cyan"cyan______"$c""$o""$light_cyan"light_cyan__"$c"
    echo -e "$o""$purple"purple____"$c""$o""$light_purple"light_purple"$c"
    echo -e "$o""$brown"brown_____"$c""$o""$yellow"yellow______"$c"
    echo -e "$nocolor"
}

#function my_set_prompt() {
#    local PS_EMPTY="\h \$ "
#    local PS_STANDARD="\u@\h:\w\$ "
#    local PS_JOBS=${light_gray}"("${dark_gray}$(jobs > /dev/null 2>&1; jobs 2>&1)$(IFS=""; set -- $(jobs); echo $#)"j"${light_gray}")"
#    local PS_SMILE="\`if [ \$? = 0 ]; then echo -e \"${green}^_^${nocolor}\"; else echo -e \"${cyan}-_-${nocolor}\"; fi\`"

    PS_SMILE='$(if [[ $? -eq 0 ]]; then echo -e "\[\e[0;33m\]^_^\[\e[0m\]"; else echo -e "\[\e[0;36m\]-_-\[\e[0m\]"; fi;)'
    export PS1=${PS_SMILE}"\["${dark_gray}"\](\["$UC"\]"$USER"\["${light_gray}"\]@\["$HC"\]"${HOST}"\["${dark_gray}"\]):(\["$UC"\]\$(_chomp_path \$(pwd))\["${dark_gray}"\])"$PR

#    export PS1=${PS_FANCY}
#}


# posted by Cynyr in http://blog.jolexa.net/2010/08/16/linux-my-bash-prompt/
function _chomp_path() {
    local path=${1/${HOME}/\~}
    local last=${path} sedout= count=0 path2=

    #bash is dumb, "${#path//[^'/']/}" fails.
    #sedout="${path//[^'/']/}"
    sedout=`echo $path| sed 's,[^/],,g'`
    count=${#sedout}
    if ((count > 2)); then
#   if [ "x${path:0:1}" != 'x~' ]; then
            last="…"
        path2=${path%/*}
        path2=${path2%/*}
        last+=${path//${path2}}
    fi
    echo ${last}
}

##########################################
## os-specific stuff
##
if [ "$my_uname" = 'FreeBSD' ]; then
    export TERM='cons25';
    alias ls='ls -hFG';
    alias udb='/usr/libexec/locate.updatedb';
    function fports() { grep -i ^"$1" /usr/ports/INDEX-6; }
elif [ "$my_uname" = 'CYGWIN_NT-5.1' ]; then
    for i in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
        alias $i:='cd /cygdrive/'$i;
    done;
    bind 'set show-all-if-ambiguous off'             # Tab once for complete
fi

##########################################
## exports
##
#my_set_prompt

export PATH="~/bin:"$PATH

export GIT_EDITOR=vim
export EDITOR=vim
export CVS_RSH=ssh

export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoredups
export LESS="-erX"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PYTHONPATH=$PYTHONPATH:$HOME/code/topaz/pypy
