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
function show_bat {
    # system-specific stuff
    bat=$1
    full=$2
    now=$3

    # calculate level
    _full=$( cat ${bat}${full} )
    _now=$( cat ${bat}${now} )
    fillint=`echo "scale=0; $_now*100/$_full" | bc`
    fillfloat=`echo "scale=2; $_now*100/$_full" | bc`

    # verbose version
    if [[ "$4" = '-v' ]]; then
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

# battery level information
function nx7010bat {
    # system-specific stuff
    show_bat "/sys/class/power_supply/C11F/" "charge_full" "charge_now" $1
}

# battery level information
function w500bat {
    # system-specific stuff
    show_bat "/sys/class/power_supply/BAT0/" "energy_full" "energy_now" $1
}

function s710bat {
    # system-specific stuff
    show_bat "/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/CMB1/" "charge_full" "charge_now" $1
}

function s710bat2 {
    # system-specific stuff
    bat="/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/CMB1/"
    full="charge_full"
    now="charge_now"

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

function prefixlambda() {
    echo "%(?,%{$fg_bold[grey]%}λ%{$reset_color%},%{$fg_bold[yellow]%}λ%{$reset_color%})"
}
function prefixthunder() {
    echo "%(?,%{$fg_bold[grey]%}⚡%{$reset_color%},%{$fg_bold[yellow]%}⚡%{$reset_color%})"
}
function prefixsym() {
    echo "%(?,%{$fg_bold[grey]%}😏%{$reset_color%},%{$fg_bold[yellow]%}😏%{$reset_color%})"
}

# Pretty print JSON
function cjson () {
  local url=$(echo $1)
  if [[ "http" == $url[0,4] ]] ; then
    curl --silent $url | python -mjson.tool | pygmentize -O style=monokai -f console256 -g
  else
    cat $url | python -mjson.tool | pygmentize -O style=monokai -f console256 -g
  fi
}

function dige() {
    echo -en "; such resolv\n;\n;   so dns\n;\n;     wow\n;";
    dig $@;
}

function vms_running () {
    ps ux | grep '[V]BoxHeadless' | sed -e 's/.*comment \([a-zA-Z0-9_-]\+\) .*/\1/' | sort | while read v; do
        echo -n $v
        len=${#v}
        diff=$((30 - $len))
        for i in `seq 1 $diff`; do
            echo -n " "
        done
        match=""
        find ~/code -name Vagrantfile | xargs grep $v | cut -d':' -f 1 | sort | uniq | while read f; do
            match="$match $(dirname $f | xargs basename)"
        done
        echo "| $match" | sed -e 's/\n/ /'
    done
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

function px() {
    local arg=$1
    local len=${#arg}
    local x=${arg:0:1}
    local xs=${arg:1:$len}
    /bin/ps aux | grep "[${x}]${xs}"
}

