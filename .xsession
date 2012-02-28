#!/bin/bash

#xcompmgr &
#xrdb -load $HOME/.Xdefaults &

xset dpms force on &
#xset s off
xset b off &

#synclient TapButton1=1 TapButton2=2 TapButton3=3 &

# caps lock ist doof
xmodmap -e "remove Lock = Caps_Lock" &
xmodmap -e "keysym Caps_Lock = Control_L" &
xmodmap -e "add Control = Control_L" &

xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1 &
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2 &

fbsetbg -l &

# systray
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --widthtype percent --width 10 --transparent true \
 --tint 0x202020 --height 12 &

#x-terminal-emulator &

if [ -e /etc/debian_version ] ; then
	exec xmonad
else
	export WINDOW_MANAGER=xmonad
	exec gnome-session
fi
