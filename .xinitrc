xsetroot -cursor_name left_ptr
setxkbmap -layout gb

if [ -f $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi

if which pm-suspend >>/dev/null; then
    xautolock -time 10 -locker "sudo systemctrl start suspend.target" &
fi

emacsclient -c &

exec qtile
