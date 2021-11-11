#!/usr/bin/sh

userresources=$XDG_CONFIG_HOME/X11/.Xresources
usermodmap=$XDG_CONFIG_HOME/X11/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap


#merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi


if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi


if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi


if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi


# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi



# Ivan's config

xset b off
xset -cursor_name left_ptr
setxkbmap -layout us,ru -option grp:caps_toggle #-option grp_led:caps

export RXVT_SOCKET="XDR_RUNTIME_DIR/rxvt-socket-$XSESSION"
urxvtd -q -o -f

redshift -x
redshift -O 5000 &
xbacklight -set 20

# keychain --confhost
# [ -f ~/.keychain/$HOSTNAME-sh ] && . ~/.keychain/$HOSTNAME-sh 2>/dev/null
# [ -f ~/.keychain/$HOSTNAME-sh-gpg ] && . ~/.keychain/$HOSTNAME-sh-gpg 2>/dev/null

sxhkd &
exec bspwm 



# Default config

# twm &
# xclock -geometry 50x50-1+1 &
# xterm -geometry 80x50+494+51 &
# xterm -geometry 80x20+494-0 &
# exec xterm -geometry 80x66+0+0 -name login
