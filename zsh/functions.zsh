########################################
## functions
########################################

if (( C == 256 )); then
    autoload spectrum && spectrum
fi
if (( C == 8 )); then
    autoload spectrum && spectrum
fi

autoload -Uz vcs_info
precmd() {
    vcs_info
}

function my_vers() {
    echo -e ".zshrc.local by fa, version ${my_version}"
}

# battery level information
function w500bat {
    # system-specific stuff
    bat="/sys/class/power_supply/BAT0/"
    full="energy_full"
    now="energy_now"

    # calculate level
    _full=$( cat ${bat}${full} )
    _now=$( cat ${bat}${now} )
    fillint=`echo "scale=0; $_now*100/$_full" | bc`
    fillfloat=`echo "scale=2; $_now*100/$_full" | bc`

    # verbose version
    if [[ "$1" = '-v' ]]; then
        echo $_full
        echo $_now
    fi

    # colorized output
    if [[ "$fillint" -ge 75 ]]; then
        echo -n -e "${fg_bold[green]}"
    elif [[ "$fillint" -ge 25 ]]; then
        echo -n -e "${fg_bold[yellow]}"
    else
        echo -n -e "${fg_bold[red]}"
    fi

    echo -e "Battery: $fillint % remaining ${reset_color}"
}

# some system information
function ii() {
    local O_LANG=$LANG
    local O_LC_ALL=$LC_ALL
    local FQDN=`hostname -f`
    local MY_II_IF="$(/sbin/ifconfig | awk '/Link / { print $1 } ')"

    LANG=C
    LC_ALL=C

    echo -n -e "\n${reset_color}You are logged in to "
    echo -e "${fg_bold[red]}${HOST} ${fg_bold[yellow]}(${FQDN})${reset_color} - $(date)"
    echo -e "\n${fg_bold[red]}Kernel version:${reset_color} " ; uname -a
    echo -e "\n${fg_bold[red]}Users logged on:${reset_color} " ; w -h
    echo -e "\n${fg_bold[red]}Machine stats :${reset_color} " ; uptime
    echo -e "\n${fg_bold[red]}Memory stats :${reset_color} " ; free -m

    for my_if in ${=MY_II_IF}; do
        echo -e "\n${fg_bold[red]}Interface $my_if :${reset_color}" ;
        /sbin/ifconfig $my_if | awk '/inet / { print $2 } ' | cut -d ":" -f 2
        /sbin/ifconfig $my_if | awk '/inet6 / { print $3 } '
        /sbin/ifconfig $my_if | awk '/TX b/ { print "TX " $3 $4 " RX " $7 $8 } '
    done

    echo
    LANG=$O_LANG
    LC_ALL=$O_LC_ALL
}

########################################
## os-specific stuff
##

isfreebsd(){
    [[ $OSTYPE == freebsd* ]] && return 0
    return 1
}

iscygwin(){
    [[ $OSTYPE == cygwin* ]] && return 0
    return 1
}

if [ isfreebsd ]; then
#    export TERM='cons25';
    alias ls='ls -hFG';
elif [ iscygwin ]; then
    for i in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
        alias $i:='cd /cygdrive/'$i;
    done;
    zstyle :compinstall filename '/cygdrive/c/Users/Florian/.zshrc'
#    bind 'set show-all-if-ambiguous off'             # Tab once for complete
fi

